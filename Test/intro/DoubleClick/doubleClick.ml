open Application;;
open AppDefs;;
open Message;;
open Bstring;;
open Point;;
open Printf;;
open Rect;;
open View;;
open Window;;

class doubleClickView =
	object(self)
	inherit be_view as view
	
	val mLastButton = ref (Int32.zero)
	val mClickCount = ref (Int32.zero)
	val mText = new be_string

	method doubleClickView ~frame ~name ~resizeMask ~flags =
		view#be_view ~frame ~name ~resizingMode:resizeMask ~flags;
		mLastButton := Int32.zero;
		mClickCount := Int32.zero;
		mText#be_string ~string:"No clicks so far"
	
	method draw ~updateRect =
		print_string "[OCaml]doubleClickView#draw\n";flush stdout;
		let p = new be_point in
		p#be_point ~x:20. ~y:30. ();
		self#drawString (mText#string()) p;
		
	method mouseDown ~point =
		print_string "[OCAML]doubleClickView#mouseDown\n";flush stdout;
		let msg = new be_message 
		in msg#be_message ~message:((self#window())#currentMessage()) ();
		let clicks = ref Int32.zero 
		in ignore (msg#findInt32 "clicks" clicks ());
		let button = ref Int32.zero 
		in ignore (msg#findInt32 "buttons" button ());
		if ((!button = !mLastButton) && ((Int32.to_int !clicks) > 1))
		then begin 
		print_string "[OCAML]doubleClickView#mouseDown incrment de mclickCount\n";flush stdout;
			mClickCount := Int32.add !mClickCount Int32.one;
			end
		else
			mClickCount := Int32.one;
		mLastButton := !button;
		let buttonName = ref "Primary button"
		in
		if ((!button) = kB_SECONDARY_MOUSE_BUTTON)
		then 
			buttonName := "Secondary button"
		else if ((!button) = kB_TERTIARY_MOUSE_BUTTON)
			 then
			 	 buttonName := "Tertiary button";
		Printf.printf "[OCAML]doubleClickView#mouseDown buttonName = %s\n" !buttonName;flush stdout;
		let clickName = ref ""
		in
		begin
			match (Int32.to_int !mClickCount)
			with | 1 -> clickName := "single click"
				 | 2 -> clickName := "double click" 
				 | 3 -> clickName := "triple click"
				 | _ -> clickName := "many clicks"
		end;
		let str = Format.sprintf "%s; %s" !buttonName !clickName
		in
		mText#be_string str;
		self#invalidate();

end;;

class doubleClickWin =
	object(self)
	inherit be_window as win

	method doubleClickWin () =
		print_string "[OCaml]doubleClickWin#doubleClickWin\n";flush stdout;	
		let r = new be_rect
		in r#be_rect ~left:50. ~top:50. ~right:250. ~bottom:100. () ;
		win#be_window	~frame:r 
						~title:"DoubleClick" 
						~window_type:B_TITLED_WINDOW 
						~flags:(List.fold_left	Int32.logor 
												Int32.zero [kB_NOT_ZOOMABLE ; 
															kB_NOT_MINIMIZABLE ; 
															kB_NOT_RESIZABLE ; 
															kB_ASYNCHRONOUS_CONTROLS]) ();
		print_string "[OCaml]doubleClickWin#doubleClickWin : be_rect cree\n";flush stdout;	
		let v = new doubleClickView
		in 
		v#doubleClickView	~frame:(self#bounds()) 
							~name:"DoubleClickView" 
							~resizeMask:kB_FOLLOW_NONE 
							~flags:kB_WILL_DRAW ;
							
		self#addChild ~aView:(v :> be_view) ();

	method quit () =
		printf "doubleClickWin#quit 1\n";flush stdout;
		ignore (be_app#postMessage ~command:kB_QUIT_REQUESTED ());
		printf "doubleClickWin#quit 2\n";flush stdout;
		win#quit();
		printf "doubleClickWin#quit 3\n";flush stdout;

end;;

class doubleClickApp =
	object(self)
	inherit be_application as app
	
	method doubleClickApp signature =
		app#be_application ~signature ()

	method readyToRun () =
		let win = new doubleClickWin
		in
		win#doubleClickWin();
		win#show();
end;;

let app = new doubleClickApp
in
app#doubleClickApp "application/x-vnd.Be.DoubleClick";
app#run();

		
		
