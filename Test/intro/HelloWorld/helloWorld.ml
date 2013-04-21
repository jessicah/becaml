open Font;;
open Rect
open Application
open HelloWindow

class helloApplication = 
	object(self)
	inherit be_application

	val aRect = new be_rect
	val aWindow = new helloWindow
	
	method helloApplication() =
		self#be_application ~signature:"application/x-vnd.Be-HelloWorldSample" ();
		aRect#be_rect();
		aRect#set ~left:100. ~top:80. ~right:360. ~bottom:120. ();
		aWindow#hellowindow aRect;
		aWindow#show();
end;;

let _ =
let myApplication = new helloApplication 
in
	myApplication#helloApplication();
	myApplication#run();
	
;;	

