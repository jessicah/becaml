open Blist
open Box
open Button
open CheckBox
open Glue
open List
open Message
open Point
open Rect
open View
open SupportDefs
open TextControl

(*open algobase assert stdio*)

type corner = 
| CORNER_TOPLEFT
| CORNER_BOTTOMLEFT
| CORNER_TOPRIGHT
| CORNER_BOTTOMRIGHT 
;;

type rect_dim =
| RECT_WIDTH
| RECT_HEIGHT
| RECT_WIDTH_AND_HEIGHT
;;

type align_side =
| ALIGN_LEFT
| ALIGN_TOP
| ALIGN_RIGHT
| ALIGN_BOTTOM
| ALIGN_HCENTER
| ALIGN_VCENTER 
;;

let average x y =
	(x +. y) /. 2.
;;

class viewLayoutFactory =
	object(self)
	
	method makeButton ~name ~label ~msgID ~pos ?(posRef = CORNER_TOPLEFT) () =
		let dummyFrame = new be_rect 
		in
		dummyFrame#be_rect ();
		dummyFrame#be_rect ~left:0. ~top:0. ~right:0. ~bottom:0. ();
		let pButton = new be_button
		in
		pButton#be_button ~frame:dummyFrame
						  ~name 
						  ~label 
						  ~message:(let m = new be_message 
									in m#be_message ~command:msgID ();
									m)
						  ();
		pButton#resizeToPreferred ();
		self#moveViewCorner ~view:(pButton :> be_view) ~pos ~posRef ();
		pButton;
		
	method makeCheckBox ~name ~label ~msgID ~pos ?(posRef = CORNER_TOPLEFT) () =
		let dummyFrame = new be_rect 
		in
		dummyFrame#be_rect();
		dummyFrame#be_rect ~left:0. ~top:0. ~right:0. ~bottom:0. ();
		let pCheckBox = new be_checkBox
		in
		pCheckBox#be_checkBox ~frame:dummyFrame 
							  ~name 
							  ~label 
							  ~message:(let m = new be_message 
							  			in 
							  			m#be_message ~command:msgID ();
										m)
							  ();
		pCheckBox#resizeToPreferred ();
		self#moveViewCorner ~view:(pCheckBox :> be_view) ~pos ~posRef ();
		pCheckBox;

	method makeTextControl ~name ~label ~text ~pos ~controlWidth ?(posRef = CORNER_TOPLEFT) () =
		let dummyFrame = new be_rect 
		in
		dummyFrame#be_rect();
		dummyFrame#be_rect ~left:0. ~top:0. ~right:0. ~bottom:0. ();
		let pCtrl = new be_textControl
		in
		pCtrl#be_textControl ~frame:dummyFrame ~name ~label ~text 
							 ~message:(let m = new be_message 
									   in 
									   m#be_message();
									   m#set_interne null; 
									   m)
							 ();
		self#layoutTextControl ~control:pCtrl ~pos ~controlWidth ~posRef ();
		pCtrl;

	method layoutTextControl ~control ~pos ~controlWidth ?(posRef = CORNER_TOPLEFT) () =
		control#resizeToPreferred ();
		let pTextView = control#textView ()
		and widthExpand = ref controlWidth
		in
		widthExpand := !widthExpand -. ((control#bounds ())#width ());
		if (!widthExpand > 0.)
		then begin
				control#resizeBy ~horizontal:!widthExpand ~vertical:0.;
				pTextView#resizeBy ~horizontal:!widthExpand ~vertical:0.;
			 end;
		self#moveViewCorner ~view:(control :> be_view) ~pos ~posRef ();

	method moveViewCorner ~view ~(pos : be_point) ?(posRef = CORNER_TOPLEFT) () =
		let frame = view#frame ()
		and topLeft = ref pos
		in
		(match posRef with
		| CORNER_TOPLEFT -> topLeft := pos;
		| CORNER_BOTTOMLEFT -> !topLeft#set ~x:pos#x 
											~y:(pos#y -. (frame#height ()))
											();
		| CORNER_TOPRIGHT -> !topLeft#set ~x:(pos#x -. (frame#width ())) 
										  ~y:pos#y
										  ();
		| CORNER_BOTTOMRIGHT ->  !topLeft#set ~x:(pos#x -. (frame#width ())) 
											  ~y:(pos#y -. (frame#height ()))
											  ();
		);
		view#moveTo ~where:!topLeft ();
		
	method align ~(viewList : be_list) ~side ~(alignLen:float) =
		let len = viewList#countItems ()
		in
		try
			if (len <= Int32.one) 
			then raise Break;

			if (  (side != ALIGN_LEFT)		&& (side != ALIGN_TOP)
				&& (side != ALIGN_RIGHT)	&& (side != ALIGN_BOTTOM)
				&& (side != ALIGN_HCENTER)	&& (side != ALIGN_VCENTER))
			then raise Break;
			
			let viewLoc = new be_point
			in
			viewLoc#be_point();
			let pView = new be_view
			in
			pView#set_interne (viewList#itemAt Int32.zero);
			if (pView#get_interne() = null)
			then raise Break;
			
			let frame = pView#frame ()
			in
			(match side 
			with 
			| ALIGN_LEFT 
			| ALIGN_TOP 	-> viewLoc#set ~x:frame#left ~y:frame#top ();
			| ALIGN_RIGHT	-> viewLoc#set ~x:frame#right ~y:frame#top ();
			| ALIGN_BOTTOM	-> viewLoc#set ~x:frame#left ~y:frame#bottom ();
			| ALIGN_HCENTER	-> viewLoc#set ~x:frame#left ~y:(average frame#top frame#bottom) ();
			| ALIGN_VCENTER	-> viewLoc#set ~x:(average frame#left frame#right) ~y:frame#top ();
							   print_string "Aligning along vcenter\nInitial position: ";
							   flush stdout;
							   viewLoc#printToStream ();
			);
			
			for i = 1 to (Int32.to_int len) - 1 do
				let pView = new be_view
				in
				pView#set_interne (viewList#itemAt (Int32.of_int i));
				if (pView#get_interne() != null)
				then begin
						match side with
						| ALIGN_LEFT	->	viewLoc#set ~y:(viewLoc#y +. alignLen) ();
											self#moveViewCorner ~view:pView ~pos:viewLoc ~posRef:CORNER_TOPLEFT ();
						
						| ALIGN_TOP		->	viewLoc#set ~x:(viewLoc#x +. alignLen) ();
											self#moveViewCorner ~view:pView ~pos:viewLoc ~posRef:CORNER_TOPLEFT ();
						
						| ALIGN_RIGHT	->	viewLoc#set ~y:(viewLoc#y +. alignLen) ();
											self#moveViewCorner ~view:pView ~pos:viewLoc ~posRef:CORNER_TOPRIGHT ();
						
						| ALIGN_BOTTOM	->	viewLoc#set ~x:(viewLoc#x +. alignLen) ();
											self#moveViewCorner ~view:pView ~pos:viewLoc ~posRef:CORNER_BOTTOMLEFT ();
						
						| ALIGN_HCENTER	->	viewLoc#set ~x:(viewLoc#x +. alignLen) ();
											let moveLoc = viewLoc
											and r = pView#frame ()
											in
											moveLoc#set ~y:(moveLoc#y -. ((r#bottom -. r#top) /. 2.)) ();
											self#moveViewCorner ~view:pView ~pos:moveLoc ~posRef:CORNER_TOPLEFT ();
						
						| ALIGN_VCENTER	->	viewLoc#set ~y:(viewLoc#y +. alignLen) ();
											let moveLoc = viewLoc
											and r = pView#frame ()
											in
											moveLoc#set ~x:(moveLoc#x -. ((r#right -. r#left) /. 2.)) ();
											self#moveViewCorner ~view:pView ~pos:moveLoc ~posRef:CORNER_TOPLEFT ();
					 end
			done;
							   
			
		with Break -> () 
	
	method resizeToListMax ~(viewList:be_list) ~resizeDim ?(anchor = CORNER_TOPLEFT) () =
		let len = viewList#countItems ()
		and	maxWidth  = ref 0.0 
		and maxHeight = ref 0.0
		and curWidth  = ref 0.0
		and curHeight = ref 0.0
		in

		for i = 0 to (Int32.to_int len) - 1 do
			let pView = new be_view
			in
			pView#set_interne (viewList#itemAt (Int32.of_int i));
			if (pView#get_interne() != null) 
			then begin
					let frame = pView#frame ()
					in
					curWidth := frame#width ();
					curHeight := frame#height ();
					if (!curWidth > !maxWidth) 
					then maxWidth := !curWidth;
					if (!curHeight > !maxHeight) 
					then maxHeight := !curHeight;
			
				 end
		done;

		for i = 0 to (Int32.to_int len) - 1 do
			let pView = new be_view
			in
			pView#set_interne (viewList#itemAt (Int32.of_int i));
			if (pView#get_interne() != null) 
			then begin
					let newWidth = ref 0.0
					and newHeight = ref 0.0
					and frame = pView#frame ()
					in
					newWidth := if (resizeDim = RECT_WIDTH)
								then !maxWidth 
								else frame#width ();
					newHeight := if (resizeDim = RECT_HEIGHT)
								 then !maxHeight 
								 else frame#height ();
					pView#resizeTo !newWidth !newHeight;
				 end
		done;

	method resizeAroundChildren ~(view:be_view) ~(margin:be_point) =
		let fMax_x = ref 0.0
		and fMax_y = ref 0.0
		and numChild = view#countChildren ()
		in
		for i = 0 to (Int32.to_int numChild) - 1 do
			let childView = view#childAt (Int32.of_int i)
			in
			if (childView#get_interne() != null) 
			then begin
					let r = childView#frame ()
					in
					fMax_x := max !fMax_x r#right;
					fMax_y := max !fMax_y r#bottom;
				 end
		done;
	
		fMax_x := !fMax_x +. margin#x;
		fMax_y := !fMax_y +. margin#y;
		view#resizeTo !fMax_x !fMax_y;

end	
