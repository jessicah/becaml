open Glue;;
open Blist;;
open Polygon;;
open Message;;
open Point;;
open Rect;;
open SupportDefs;;
open Threads;;
open View;;

open MsgVals;;
open TweakWin;;

let epsilon = 0.01;;

class filterView =
	object(self)
	inherit be_view as view

	val curmass = ref 0.
	val curdrag = ref 0.
	val width = ref 0.
	val fillmode = ref true
	val fixed_angle = ref true
	val m = new be_point
	val odel = new be_point
	val cur = new be_point
	val last = new be_point
	val zzz = ref (Int32.of_int 10000)
	val bigX = ref 0.
	val bigY = ref 0.
	val scaleToPage = ref true
	val polyList = new be_list
	val velx = ref 0.
	val vely = ref 0.
	val vel = ref 0.
	val accx = ref 0.
	val accy = ref 0.
	val acc = ref 0.
	val angx = ref 0.
	val angy = ref 0.
	
        method filterView : 'a.r:(#be_rect as 'a) -> unit = 
                fun ~r ->
		view#be_view ~frame:r ~name:"filter" ~resizingMode:kB_FOLLOW_ALL ~flags:kB_WILL_DRAW;
		
		curmass := 0.5;
		curdrag := 0.46;
		width := 0.5;
		fillmode := true;
		fixed_angle := true;
		zzz:= (Int32.of_int 10000);
		bigX := r#width();
		bigY:= r#height();
		scaleToPage := true;
		polyList#be_list();
		m#be_point();
		odel#be_point();
		cur#be_point();
		last#be_point();

	method messageReceived ~message:msg =
		print_string "[OCaml]filterView#messageReceived\n";flush stdout;
		let val32 = ref Int32.zero
		in
		match msg#what
		with 
		| m when m = kMASS_CHG -> 
							ignore(msg#findInt32 ~name:"Mass" ~anInt32:val32 ());
			 				curmass := (Int32.to_float !val32) /. 100.0;
		| m when m = kDRAG_CHG -> 
							ignore(msg#findInt32 ~name:"Drag" ~anInt32:val32 ());
							curdrag := (Int32.to_float !val32) /. 100.0;
		| m when m = kWIDTH_CHG -> 
							ignore(msg#findInt32 ~name:"Width" ~anInt32:val32 ());
							width := (Int32.to_float !val32) /. 100.0;
		| m when m = kSLEEPAGE_CHG -> 
							ignore(msg#findInt32 ~name:"Sleepage" ~anInt32:val32 ());
							val32 := Int32.add kMIN_SLEEP (Int32.sub kMAX_SLEEP !val32);
							zzz := !val32;
		| m when m = kFILL_CHG -> self#toggle(fillmode);
		| m when m = kANGLE_CHG -> self#toggle(fixed_angle);
		| m when m = kCOLOR_CHG -> let red = ref 0 
								  and green = ref 0
								  and blue = ref 0
								  in
								  ignore(msg#findInt16 ~name:"red" ~anInt16:red ());
								  ignore(msg#findInt16 ~name:"green" ~anInt16:green ());
								  ignore(msg#findInt16 ~name:"blue" ~anInt16:blue ());
								  self#setHighColor ~red:!red ~green:!green ~blue:!blue ();
		| m when m = kCLEAR_SCREEN -> Printf.printf "clearScreen de filterview appele.\n";flush stdout;
									  self#clearScreen();
		| _ -> view#messageReceived msg
								  
	
	method mouseDown ~point =
		let buttons = ref Int32.zero
		and mx = ref 0.
		and my = ref 0.
		and b = new be_rect
		in
		b#be_rect ~rect:(self#bounds()) ();
		self#getMouse ~location:(ref point) ~buttons ~checkMessageQueue:true ();
		if (!buttons = kB_PRIMARY_MOUSE_BUTTON)
		then begin
			 	 mx := point#x /. b#right;
				 my := point#y /. b#bottom;
				 m#set ~x:!mx ~y:!my ();
				 self#setpos m;
				 odel#set ~x:0. ~y:0. ();
				 try 
				 	while true do
				 		self#getMouse ~location:(ref point) ~buttons ~checkMessageQueue:true ();
					 	
						if (!buttons <> kB_PRIMARY_MOUSE_BUTTON)
					 	then raise Break;
							
				 		mx := point#x /. b#right;
					 	my := point#y /. b#bottom;
					 	m#set ~x:!mx ~y:!my ();
				 		
						if self#apply m curmass curdrag
				 		then 
			 			  (
						  self#drawSegment();
						  );
					 	ignore(snooze( Int64.of_int32 !zzz));
				 done
				with Break -> ();
			 end
			 else if (!buttons = kB_SECONDARY_MOUSE_BUTTON)
			 	  then 
				  	self#clearScreen()

	method clearScreen() =
		Printf.printf "debut de clearScreen.\n";flush stdout;
		let count = polyList#countItems()
		in
		for i=0 to ((Int32.to_int count)-1)
		do
			delete (polyList#firstItem());
			ignore (polyList#removeItem ~index:Int32.zero ())
		done;
		self#invalidate()
	
	method apply m curmass curdrag =
		let mass = self#flerp 1.0 160.0 !curmass
		and drag = self#flerp 0.0 0.5 (!curdrag *. !curdrag)
		and fx = m#x -. cur#x
		and fy = m#y -. cur#y
		in 
		let acc = sqrt (fx *. fx +. fy *. fy)
		in
		if acc < 0.000001
		then 
			false
		else 
			begin
			 accx := fx /. mass;
			 accy := fy /. mass;
			
			 velx := (!accx +. !velx);
			 vely := (!accy +. !vely);
			 vel  := sqrt(!velx *. !velx +. !vely *. !vely);
			 
			 angx := -. !vely;
			 angy := !velx;
			 
			 if (!vel < 0.000001)
			 then false
			 else begin
			 	  angx := !angx /. !vel;
				  angy := !angy /. !vel;
				  if !fixed_angle
				  then begin
				  	   angx := 0.6;
					   angy := 0.2
					   end;
				  velx := !velx *. (1.0 -. drag);
				  vely := !vely *. (1.0 -. drag);
				  last#be_point ~point:cur ();
				  cur#set ~x:(cur#x +. !velx) ~y:(cur#y +. !vely) ();
				  true
			 	  end
			 end
	
	method drawSegment() =
		let del = new be_point in
		del#be_point ();
		let polypoints = Array.init 4 (fun i -> let p = new be_point in p#be_point(); p)
		and wid = ref 0.0
		and px = ref 0.0
		and py = ref 0.0
		and nx = ref 0.0
		and ny = ref 0.0
		and b = new be_rect
		in 
		b#be_rect ~rect:(self#bounds()) ();
		wid := (0.04 -. !vel);
		wid := !wid *. !width;
		if !wid < 0.00001
		then wid := 0.00001;
		del#set ~x:(!angx *. !wid) ~y:(!angy *. !wid) ();
		px := last#x;
		py := last#y;
		nx := cur#x;
		ny := cur#y;

		if ceil(!nx *. b#right) > !bigX
		then bigX := ceil (!nx *. b#right);
		if ceil(!ny *. b#bottom) > !bigY
		then bigY := ceil (!ny *. b#bottom);
		
		polypoints.(0)#set ~x:(b#right *. (!px +. odel#x)) ~y:(b#bottom *. (!py +. odel#y)) ();
		polypoints.(1)#set ~x:(b#right *. (!nx +. del#x)) ~y:(b#bottom *. (!ny +. del#y)) ();
		polypoints.(2)#set ~x:(b#right *. (!nx -. del#x)) ~y:(b#bottom *. (!ny -. del#y)) ();
		polypoints.(3)#set ~x:(b#right *. (!px -. odel#x)) ~y:(b#bottom *. (!py -. odel#y)) ();
		let poly = new be_polygon 
		in 
		poly#be_polygon polypoints (Int32.of_int 4); 	
		ignore (polyList#addItem ~item:(poly :> be_interne));
		
		if (!fillmode)
		then 
			self#fillPolygon ~pointList:polypoints ~numPoints:(Int32.of_int 4) ();
		self#strokePolygon ~pointList:polypoints ~numPoints:(Int32.of_int 4) ();
		odel#be_point ~point:del ()
		
	method draw ~updateRect =
		print_string "[OCaml]filterview#draw\n"; flush stdout;
		let poly = new be_polygon
		in
		if ((self#isPrinting()) && !scaleToPage)
		then begin
				let xscale = (self#bounds())#width() /. !bigX
				and yscale = (self#bounds())#height() /. !bigY
				in
				let scale = min xscale yscale
				in
				self#setScale (scale -. epsilon)
			 end;
		let numItems = ref (polyList#countItems())
		in
		Printf.printf "[OCaml] filterview#draw(numItems=%ld)\n" !numItems; flush stdout;
		if (!fillmode)
		then begin
				for i = 0 to (Int32.to_int !numItems)-1
				do
					poly#set_interne (polyList#itemAt ~index:(Int32.of_int i));
					self#fillPolygon ~aPolygon:poly ();
					self#strokePolygon ~polygon:poly ()
				done
			 end
		else
			for i = 0 to (Int32.to_int !numItems)-1
				do
					poly#set_interne (polyList#itemAt ~index:(Int32.of_int i));
					self#strokePolygon ~polygon:poly ()
				done

	method setpos point =
		cur#be_point ~point ();
		last#be_point ~point ();
		velx := 0.;
		vely := 0.;
		accx := 0.;
		accy := 0.;

	method toggle ref_bool =
		ref_bool := not !ref_bool

	method flerp f0 f1 p =
		f0 *. (1.0 -. p) +. f1 *. p

	method setScaleToPage ~flag =
		scaleToPage := flag

	method getExtremities maxx maxy =
		maxx := !bigX;
		maxy := !bigY
		
	method mass () =
		Int32.of_float (!curmass *. 100.)
	
	method drag () =
		Int32.of_float (!curdrag *. 100.)
	
	method width () =
		Int32.of_float (!width *. 100.)

	method sleep () =
		Int32.sub kMAX_SLEEP !zzz

end;;
