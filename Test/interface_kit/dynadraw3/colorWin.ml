open Message;;
open ColorControl;;
open Application;;
open Rect;;
open Window;;
open Point;;
open GraphicsDefs;;
open MsgVals;;


class colorWin =
	object(self)
	inherit be_window as window


	val handler = ref (new be_window)
	val cc = new be_colorControl
	val swatch = new be_view
	
	method colorWin hand initialColor =
	Printf.printf "[OCaml]colorWin avant be_window\n";flush stdout;
		self#be_window ~frame:(let r = new be_rect in 
		r#be_rect ~left:610.0 ~top:550.0 ~right:620.0 ~bottom:560.0 (); r) 
						~title:"Pen Color" ~window_type:B_FLOATING_WINDOW
						 ~flags:kB_NOT_RESIZABLE ();
	Printf.printf "[OCaml]colorWin apres be_window\n";flush stdout;
		let w = ref 0.0 and h = ref 0.0
		in
		handler := hand;
		cc#be_colorControl ~leftTop:(let _point = new be_point 
									 in _point#be_point ~x:50. ~y:1. (); _point) 
						   ~matrix:B_CELLS_32x8 
						   ~cellSide:5. 
						   ~name:"colorcntl"
						   ~message:(let _message = new be_message 
						  			 in _message#be_message ~command:kCOLOR_CHG (); _message) 
							  ();
		cc#setValue initialColor;
		cc#getPreferredSize w h;
	        Printf.printf "[OCaml]ccc#getPreferredSize -> w=%f h=%f\n" !w !h;flush stdout;
		self#resizeTo (!w +. 50.) !h;
		self#addChild ~aView:(cc :> be_view) ();

		swatch#be_view ~frame:(let _rect = new be_rect in 
		_rect#be_rect ~left:5. ~top:5. ~right:45.
		 ~bottom:((self#bounds())#height() -. 5.) (); _rect)
					   ~name:"swatch"
					   ~resizingMode:kB_FOLLOW_ALL
					   ~flags:kB_WILL_DRAW ;
		swatch#setViewColor ~rgb_color:(cc#valueAsColor()) ();
		self#addChild ~aView:(swatch :> be_view) ();
		self#show

	method messageReceived ~message:msg =
		match msg#what with
		| m when m = kCOLOR_CHG -> let clr = cc#valueAsColor() 
								   in
								   swatch#setViewColor ~rgb_color:clr ();
								   swatch#invalidate();
								   ignore(msg#addInt16 "red" (clr.red));
								   ignore(msg#addInt16 "green" (clr.green));
								   ignore(msg#addInt16 "blue" (clr.blue));
								   ignore(!handler#postMessage ~message:msg ())
		| _ -> window#messageReceived ~message:msg
	
	method quit() =
		ignore(be_app#postMessage ~command:kCOLOR_QUIT ());
		window#quit()
end;;
