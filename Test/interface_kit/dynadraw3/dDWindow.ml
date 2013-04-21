open Glue;;
open Application;;
open AppDefs;;
open Errors;;
open Handler;;
open Message;;
open Menu;;
open MenuBar;;
open MenuItem;;
open Alert;;
open PrintJob;;
open Point
open Rect;;
open Window;;

open FilterView;;
open MsgVals;;

let rect = new be_rect;;
rect#be_rect ~left:50. ~top:50. ~right:600. ~bottom:600. ();;

class dDWindow =
	object(self)
	inherit be_window as window

	val fv = new filterView
	val printSettings = new be_message
	val scaleItem = new be_menuItem
	
	method dDWindow () =
		window#be_window ~frame:rect ~title:"Dynadraw!" ~window_type:B_TITLED_WINDOW ~flags:Int32.zero ();
		printSettings#set_interne null;
		
		let mb = new be_menuBar
		in
		mb#be_menuBar ~frame:(let r = new be_rect in 
							  r#be_rect ~left:0. 
							  			~top:0. 
										~right:rect#right 
										~bottom:15. ();
										r
							 ) 
					   ~name:"menubar" ();
		let menu = new be_menu
		in 
		menu#be_menu ~name:"File" ();
		ignore(menu#addItem ~item: (let mi = new be_menuItem 
									in 
									print_string "[OCaml] dDWindow constructeur : creation de l'item 'About'\n";flush stdout;
									mi#be_menuItem ~label:"About" 
													  ~message:(let m = new be_message 
													  			in m#be_message ~command:kB_ABOUT_REQUESTED 
																				(); 
																m) 
													   (); 
									mi) 
							 ());
		ignore(menu#addItem ~item:(let mi = new be_menuItem 
								   in 
								   mi#be_menuItem ~label:"Quit" 
								   				  ~message:(let m = new be_message 
												  			in 
															m#be_message ~command:kB_QUIT_REQUESTED 
																		 (); 
															m) 
												  (); 
								   mi) 
							 ());
		
		ignore(print_string "[OCaml] dDWindow#DDWindow setTargetForItems\n";flush stdout;
				menu#setTargetForItems (be_app :> be_Handler));
		ignore(mb#addItem ~submenu:menu ());

		menu#be_menu ~name:"Controls" ();
		let tmpItem = new be_menuItem
		in 
		tmpItem#be_menuItem ~label:"Tweakables" 
							~message:(let m = new be_message in 
									  m#be_message ~command:kTWEAK_REQ (); 
									  m) 
							();
		ignore(tmpItem#setTarget ~handler:(be_app :> be_Handler) ());
		ignore(menu#addItem ~item:tmpItem ());
		
		let tmpItem = new be_menuItem
		in 
		tmpItem#be_menuItem ~label:"Color" 
							~message:(let m = new be_message 
									  in 
									  m#be_message ~command:kCOLOR_REQ (); 
									  m) 
							();
		ignore(tmpItem#setTarget ~handler:(be_app :> be_Handler) ());
		ignore(menu#addItem ~item:tmpItem ());
		ignore(menu#addSeparatorItem());
		ignore(menu#addItem ~item:(let _mi = new be_menuItem 
								   in 
								   _mi#be_menuItem ~label:"Clear Screen" 
								   				   ~message:(let _m = new be_message 
												   			 in 
															 _m#be_message ~command:kCLEAR_SCREEN (); 
															 _m) ();
								   _mi) ());
		ignore(mb#addItem ~submenu:menu ());
		menu#be_menu ~name:"Printing" ();
		scaleItem#be_menuItem ~label:"Scale To Page" 
							  ~message:(let m = new be_message in 
							  			m#be_message ~command:kSCALE_PAGE (); 
										m) 
							   ();
		ignore(menu#addItem ~item:scaleItem ());
		ignore(menu#addItem ~item:(let mi = new be_menuItem 
								   in mi#be_menuItem ~label:"Print" 
								   					 ~message:(let m = new be_message 
													 		   in m#be_message ~command:kPRINT_REQ 
															   				   (); 
															   m) 
													 (); 
								   mi) 
							());
		scaleItem#setMarked true;
		ignore(mb#addItem ~submenu:menu ());
		self#addChild ~aView:(mb :> be_view) ();
		let mb_height = (mb#bounds())#height()
		in
		fv#filterView ~r:(let _r = new be_rect in _r#be_rect ~left:0. ~top:mb_height ~right:rect#right ~bottom:(rect#bottom -. mb_height) (); _r);
		self#addChild ~aView:(fv :> be_view) ();
		print_string "[OCaml] dDWindow XXXX\n";flush stdout;
		self#show();
	
	method messageReceived ~message:msg =
		match msg#what with
		| m when m = kCOLOR_CHG -> ignore (self#postMessage ~message:msg ~handler:(fv :> be_Handler) ())
		| m when m = kMASS_CHG -> print_string "dDWindow#messageReceived : MASS\n";flush stdout;ignore (self#postMessage ~message:msg ~handler:(fv :> be_Handler) ())
		| m when m = kDRAG_CHG -> ignore (self#postMessage ~message:msg ~handler:(fv :> be_Handler) ())
		| m when m = kWIDTH_CHG -> ignore (self#postMessage ~message:msg ~handler:(fv :> be_Handler) ())
		| m when m = kFILL_CHG -> 
		Printf.printf "dDwindow envoie FILL_CHG a filterview\n";flush stdout;
			ignore (self#postMessage ~message:msg ~handler:(fv :> be_Handler) ())
		| m when m = kANGLE_CHG -> ignore (self#postMessage ~message:msg ~handler:(fv :> be_Handler) ())
		| m when m = kSLEEPAGE_CHG -> ignore (self#postMessage ~message:msg ~handler:(fv :> be_Handler) ())
		| m when m = kCLEAR_SCREEN -> ignore (self#postMessage ~message:msg ~handler:(fv :> be_Handler) ())
		| m when m = kPRINT_REQ -> ignore (self#doPrint ())
		| m when m = kSCALE_PAGE -> let tmp = not (scaleItem#isMarked()) 
								   in
								   scaleItem#setMarked tmp;
								   fv#setScaleToPage ~flag:tmp
		| _ -> window#messageReceived msg

	method doPrint() =
		let job = new be_printJob 
		in 
		job#be_printJob "dynadraw";
		if (self#setUpPage() != kB_NO_ERROR)
		then
		(let alert = new be_alert in 
		 alert#be_alert ~title:"Cancel" 
		 				~text:"Print cancelled" 
						~button0Label:"OK" 
						(); 
		 ignore(alert#go()));

		job#setSettings ~configuration:(let _message = new be_message in 
											_message#be_message ~message:printSettings ();
											_message);
		
		let pageRect = new be_rect
		in pageRect#be_rect ~rect:(job#printableRect()) ();
		let curPageRect = pageRect
		in
		let vWidth = ref 0.0
		and vHeight = ref 0.0
		in
		fv#getExtremities vWidth vHeight;
		let pHeight = pageRect#height()
		and pWidth = pageRect#width()
		in
		let xPages,yPages = ref 1,ref 1
		in
		if (not (scaleItem#isMarked()))
		then begin
				xPages := int_of_float (ceil( !vWidth  /. pWidth ));
				yPages := int_of_float (ceil( !vHeight /. pHeight));
				
			 end;
		job#beginJob();
		for x = 0 to !xPages
		do
			for y = 0 to !yPages 
			do
				curPageRect#offsetTo ~x:(float_of_int (x * (int_of_float pWidth ))) 
									 ~y:(float_of_int (y * (int_of_float pHeight))) ();
				job#drawView fv curPageRect (let point = new be_point in point#be_point ~x:0.0 ~y:0.0 (); point);
				job#spoolPage();
				if (not (job#canContinue()))
				then begin
						let alert = new be_alert 
					 	in alert#be_alert ~title:"Cancel" ~text:"Print job cancelled" ~button0Label:"OK" ();
						   ignore (alert#go())
					 end
			done;
			job#commitJob();
		done;

	method quitRequested() =
		ignore(be_app#postMessage ~command:kB_QUIT_REQUESTED ());
		true
	
	method setUpPage () =
		let job = new be_printJob
		in
		job#be_printJob "dynadraw";
		let rv = job#configPage ()
		in
		printSettings#set_interne ((job#settings ())#get_interne());
		rv
	
	method mass () =
		fv#mass ()

	method drag () =
		fv#drag ()
	
	method width () =
		fv#width ()

	method sleep () =
		fv#sleep ()

	method color () =
	self#lock();
		let color = fv#highColor ()
		in
		self#unlock();color

end;;	
