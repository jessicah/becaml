open AppDefs
open Application
open Bitmap
open Blist
open Bstring
open Errors
open Font
open Glue
open Picture
open Point
open Rect
open Shape
open TranslatorRoster
open TranslationUtils
open View
open Window

let kTEXT = "BeOS"

class glyphPt =
	object
	inherit be_interne

	val pt =  ref (new be_point)
	val mutable offset = new be_point

	method glyphPt p o =
		pt := p;
		offset <- o

	method pt = pt
	method offset = offset

end

class iterView  =
	object(self)
	inherit be_view as view
	inherit be_shapeIterator as shapeIterator
	
	val mutable shapePts = ([||] :  be_list array);

	val delta = { nonspace = 0.0 ; space = 0.0 };
	val mutable fontSize = 0.0;
	
	val shapes = ( ref [| |] : be_shape array ref);
	val esc    = ( ref [| |] : be_point array ref);
	val offset = let p = new be_point in p#be_point();p

	val text = new be_string;
	val mutable textLen = 0
	val initialPoint = let p = new be_point in p#be_point();p
	
	val mutable dragPoint = new glyphPt
	
	val mutable currentPoint = new be_point	
	
	val mutable curShape = 0

	val mutable firstPass = true
	val mutable isTracking = true
	
	method iterView r =
(*		shapeIterator#be_shapeIterator ();*)
		view#be_view ~frame:r ~name:"iterview" ~resizingMode:kB_FOLLOW_ALL ~flags:kB_WILL_DRAW;
		
		text#be_string ~string:kTEXT;
		textLen <- Int32.to_int (text#length ());

		curShape <- 0;
		shapePts <- Array.init textLen (fun _ -> new be_list);

		fontSize <- 350.0;
		initialPoint#set ~x:10.0 ~y:350.0 ();

		firstPass <- true;
		isTracking <- false;

		esc := Array.init (textLen * 2) (fun _ ->
										 let p = new be_point
										 in
										 p#be_point();
										 p);
		
		
		shapes := Array.init textLen (fun _ ->
									  let s = new be_shape 
									  in 
									  s#be_shape();
									  s);

		self#initializeShapes ();
		self#setViewColor ~red:255 ~green:255 ~blue:255 ()
		
	method iterView_ () =
		for i = 0 to textLen - 1
		do
			delete (!shapes.(i)#get_interne());
			let c = shapePts.(i)#countItems ()
			in
			for j= 0 to pred (Int32.to_int c)
			do
				ignore (shapePts.(i)#removeItem ~index:Int32.zero ());
			done;
		done;

	(* Vive le GC !!!
		delete []shapePts;
		delete []esc;
		
		free(shapes);
	*)
	method initializeShapes () =
		let font = ref (new be_font)
		in
		!font#be_font();
		self#getFont ~font;
		!font#setSize fontSize;
		
	(*delta initialisé à la déclaration en OCaml	
		delta <- {	nonspace = 0.0; 
					space = 0.0
				 };
	*)
		let s = text#string () in
		let ls = String.length s in 
		let ca = Array.make ls '\000' in
		for i=0 to pred ls
		do	ca.(i) <- String.get s i;
		done;

		!font#getGlyphShapes ~charArray:ca ~numChars:(Int32.of_int textLen) ~glyphShapeArray:shapes;
		!font#getEscapements ~charArray:ca(*text#string ()*) ~numChars:(Int32.of_int textLen) 
							 ~delta 
							 ~be_point_escapementArray:esc 
							 ~offsetArray: (ref (Array.sub !esc textLen textLen)) 
							 ();
	
	method private mouseUp pt =
		isTracking <- false;

	method private mouseMoved pt code msg =
		if (isTracking = false)
		then ()
		else begin	
				dragPoint#pt := (pt#minus dragPoint#offset);
				self#invalidate ();
			 end

	method private mouseDown ~point:pt =

		let buttons = Int32.one
		and diff = ref (new be_point)
		and g = ref(new glyphPt)
		and  foundPt = ref false
		in
		try
			for j = 0 to (textLen - 1)
			do
				let tmp = !shapes.(j)#bounds()
				in
				tmp#insetBy ~x:(-3.0) ~y:(-3.0) ();
				tmp#offsetBy ~point:(Obj.magic (shapePts.(j)#itemAt Int32.zero) : glyphPt)#offset ();
				if tmp#contains ~point:pt ()
				then
					try 
						for i=0 to (Int32.to_int (shapePts.(j)#countItems()))
						do
							g := Obj.magic ((* glyphPt* *)shapePts.(j)#itemAt (Int32.of_int i));
							(*diff := !g#pt + !g#offset - pt;*)
							failwith "(diff)";
							if (!diff#x > -3.0 && !diff#x < 3.0 && !diff#y > -3.0 && !diff#y < 3.0)
							then
								foundPt := true;
							raise Break;
						done;
					with Break -> ();
					if !foundPt
					then raise Break;
			done;
		with Break -> ();
		if (not !foundPt)
		then ();

		dragPoint <- !g;
		isTracking <- true;
		self#setMouseEventMask ~mask:B_POINTER_EVENTS ~options:[B_LOCK_WINDOW_FOCUS;B_NO_POINTER_HISTORY] ()

	method private draw ~updateRect:r =
		let where = new be_point 
		in
		where#be_point ~point:initialPoint ();
	
		let curShape = ref 0
		in
		for i=0  to (textLen - 1)
		do
			offset#set ~x:(floor(where#x +. !esc.(i + textLen)#x +. 0.5))
					   ~y:(floor(where#y +. !esc.(i + textLen)#y +. 0.5) -. 1.0)
					   ();
			self#movePenTo ~pt:offset ();
			self#setHighColor ~red:0 ~green:0 ~blue:0 ();
			self#setPenSize ~size:2.0;
			self#strokeShape ~shape:!shapes.(i) ();
			self#setPenSize ~size:1.0;
		
			self#iterate !shapes.(i);
			incr curShape;

			where#set ~x:(where#x +. !esc.(i)#x *. fontSize)
					  ~y:(where#x +. !esc.(i)#y *. fontSize)
					  ();
		done;

		if (firstPass)
		then firstPass <- false;

	method private iterateMoveTo point =
		self#setHighColor ~red:0 ~green:255 ~blue:0 ();
		self#fillEllipse (failwith "point+offset")(*(!point + offset) 2 2*);
		if (firstPass)
		then ignore (shapePts.(curShape)#addItem (let g = new glyphPt 
												  in
												  g#glyphPt point offset;
												  g :> be_interne));
	
		currentPoint <- (failwith "point+offset")(*!point + offset*);
		kB_OK;
	
	method private iterateLineTo lineCount linePts =
		self#setHighColor ~red:255 ~green:0 ~blue:0 ();
		for i=0 to (lineCount - 1) do
	
			failwith "self#fillEllipse (!linePts+offset) 2 2";
			if (firstPass)
			then ignore (shapePts.(curShape)#addItem (let g = new glyphPt 
													  in
													  g#glyphPt !linePts offset;
													  g:> be_interne));
		
			failwith "incr linePts";
		done;

		currentPoint <- failwith "(!linePts - 1) + offset";
		kB_OK;	
		
	method private iterateBezierTo bezierCount bezierPts =

		let tmp = new be_point
		in
		tmp#be_point ~x:2.5 ~y:2.5 ();
	
		for i=0 to pred bezierCount
		do
			self#setHighColor ~red:140 ~green:140 ~blue:140 ();
				
			self#strokeRect ~rect:(let r = new be_rect
								   in
								   failwith "r#be_rect ~leftTop:(bezierPts + offset - tmp) 
													   ~rightBottom:(bezierPts+offset+tmp)
									  		 ()";
								   r) 
							();
			failwith "self#strokeRect(new be_rect(( !(bezierPts+1) + offset - tmp)
												  ( !(bezierPts+1) + offset + tmp)));

			self#strokeLine currentPoint *bezierPts+offset;
			self#strokeLine ( !(bezierPts+1) + offset !(bezierPts+2)+offset)";

			self#setHighColor ~red:0 ~green:0 ~blue:255 ();
			failwith "self#fillEllipse( !(bezierPts+2) + offset 2 2)";
				
			if(firstPass)
			then begin
					ignore (shapePts.(curShape)#addItem(let g = new glyphPt in g#glyphPt  bezierPts		 offset ; g:>be_interne));
					ignore (shapePts.(curShape)#addItem(let g = new glyphPt in g#glyphPt (failwith "bezierPts + 1") offset ; g:>be_interne));
					ignore (shapePts.(curShape)#addItem(let g = new glyphPt in g#glyphPt (failwith "bezierPts + 2") offset ; g:>be_interne));
			end;

			failwith "currentPoint <- !(bezierPts+2) + offset";				
			failwith "bezierPts := !bezierPts + 3";
		done;
		kB_OK;
	
	method private iterateClose () =
		kB_OK;	
end
and tWin =
	object(self)
	inherit be_window as window
	
	val view = new iterView;
	
	method tWin () =
		self#be_window ~frame:(let r = new be_rect
						  		 in
								 r#be_rect ~left:10.0 ~top:50.0 ~right:950.0 ~bottom:500.0 ();
								 r)
						  ~title:"BShapeIterator" 
						  ~window_type:B_TITLED_WINDOW 
						  ~flags:Int32.zero
						  ();
		view#iterView (self#bounds());
		self#addChild ~aView:view ();
		self#show ();
		
	method tWin_ () =
		()
		
	method quitRequested () =
		ignore(be_app#postMessage ~command:kB_QUIT_REQUESTED ());
		true;
	
end;;

class tApp =
	object(self)
	inherit be_application as application
	
	val win = new tWin
	
	method tApp () =
		application#be_application ~signature:"application/x-vnd.Be-clip" ();
		win#tWin ();
		self#run ();
		
	method tApp_ () = 
		()
end;;
(*
Gc.set { (Gc.get()) with Gc.verbose = 0xffff; Gc.minor_heap_size = 512*1024;
Gc.space_overhead = 100; Gc.max_overhead = 0};;
*)
let a = new tApp 
in
a#tApp ();;
