open Application;;
open Alert;;
open Glue
open Message
open Window
open AppDefs;;

open MsgVals;;
open TweakWin;;
open ColorWin;;
open DDWindow

class ddApp = 
	object(self)
	inherit be_application as application
	
	val ddWin = new dDWindow
	val colorWin = new colorWin
	val tweakWin = new tweakWin
	val bt = ref false
	val bc = ref false
	
	method ddApp() =
		self#be_application ~signature:"application/x-vnd.Be-dynadraw" ();
		ddWin#dDWindow();

			
	method messageReceived ~message:msg =
		print_string "[OCaml]dDAPP#MessageReceived\n";flush stdout;
		let m = msg#what
		in
		if (m = kTWEAK_REQ) 
		then begin
				if (!bt = false)
				then begin
		print_string "[OCaml]dDAPP#MessageReceived avant twkwin\n";flush stdout;
				
					 tweakWin#tweakWin (ddWin :> be_window)
						  			   (ddWin#mass())
									   (ddWin#drag())
									   (ddWin#width())
									   (ddWin#sleep());
		print_string "[OCaml]dDAPP#MessageReceived apres twkwin\n";flush stdout;
					 bt := true
					 end
			 end
		else if (m = kCOLOR_REQ)
			 then begin
			 		if (!bc = false)
					then begin
						Printf.printf "[Ocaml] dDAPP->messageReceived, avant colorwin#colorwin, ddWin = 0x%lx, colorWin = 0x%lx\n" (Obj.magic ddWin) (Obj.magic colorWin);flush stdout;
						Printf.printf "[Ocaml] dDAPP->messageReceived, avant colorwin#colorwin\n";flush stdout;
						 colorWin#colorWin (ddWin :> be_window) 
										   (ddWin#color()) 
										   ();
						Printf.printf "[Ocaml] dDAPP->messageReceived, apres colorwin#colorwin\n";flush stdout;
						 bc := true
						 end
				  end
			 else if (m = kTWEAK_QUIT) 
			 	  then (bt := false;print_string "twkwin remis a zero\n";flush stdout;
				  		(*let m = new be_message in 
						m#be_message ~command:kTWEAK_REQ ();
						self#messageReceived ~message:m*))
				  else if (m = kCOLOR_QUIT) 
				  	   then bc := false
					   else application#messageReceived msg


	method aboutRequested() =
		let alert = new be_alert
		in
		alert#be_alert ~title:"About..." 
		~text:"DynaDraw\n\nOriginal SGI Version, Paul Haeberli 1989\nBe Version, Michael Morrissey" 
		~button0Label:"Cool!" ();
		alert#go();

	method run () =
		application#run();

	method quitRequested() =
		if !bt then (tweakWin#quit());
		if !bc then (colorWin#quit());
		true
initializer
Printf.printf "[OCaml] DDApp initializer : colorwin= 0x%lx\n" (Obj.magic colorWin);flush stdout;
end;;

