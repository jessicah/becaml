open AppDefs;;
open Application
open HelloView
open Rect
open View;;
open Window;;

class helloWindow = 
	object(self)
	inherit be_window

	val aRect = new be_rect
	val aView = new helloView
	
	method hellowindow frame =
		self#be_window ~frame:frame 
						~title:"Charlotte" 
						~window_type:B_TITLED_WINDOW 
						~flags:(Int32.logor kB_NOT_RESIZABLE kB_NOT_ZOOMABLE) ();

		aRect#be_rect ~rect:(self#bounds()) ();
		print_string "appel de helloView\n";flush stdout;aView#helloView aRect "HelloView" "CHARLOTTE";
		self#addChild ~aView:(aView :> be_view) ();
		Printf.printf "[OCaml]fin du constructeur helloWindow (apres addchild)\n";flush stdout;
	
	method quitRequested () =
		ignore (be_app#postMessage ~command:kB_QUIT_REQUESTED ());
		true;
end
	;;
