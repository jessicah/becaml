open Rect;;
open Window;;
open Button;;
open Message;;

open Application;;
open AppDefs;;

let kBUTTON_MSG = Int32.of_string "0x50524553" ;; (* 'PRES' *)

let kWindowFrame = let r = new be_rect in r#be_rect ~left:100. ~top:100. ~right:300. ~bottom:300. () ; r ;;
let kButtonFrame = let r = new be_rect in r#be_rect ~left:80. ~top:90. ~right:120. ~bottom:110. () ; r;;
let kWindowName = "ButtonWindow";;
let kButtonName = "Press";;
let numPresses = ref 0 ;;


class btsButtonWindow = 
	object(self)
	inherit be_window as win

	val fButton = new be_button
	
	method btsButtonWindow () =
	win#be_window ~frame:kWindowFrame ~title:kWindowName ~window_type:B_TITLED_WINDOW 
				  ~flags:kB_WILL_DRAW ();
	fButton#be_button ~frame:kButtonFrame ~name:kButtonName ~label:kButtonName 
					  ~message:(let m = new be_message in m#be_message ~command:kBUTTON_MSG (); m) () ;
	self#addChild ~aView:(fButton :> be_view) ()
	
	method quitRequested () =
		Printf.printf "[OCaml]btsButtonWindow : appel de be_app#postMessage\n"; flush stdout;
		ignore(be_app#postMessage ~command:kB_QUIT_REQUESTED ());
		win#quitRequested ()
		
	method messageReceived ~message =
		if (message#what = kBUTTON_MSG)
		then begin
			incr numPresses;
			self#setTitle (Format.sprintf "Presses : %d" !numPresses)
			end
		else begin
			 Printf.printf "[OCaml]btsButtonWindow#messageReceived(0x%lx) transfert a be_win\n" message#what;flush stdout;
			 win#messageReceived message
			 end
		

end;;


















