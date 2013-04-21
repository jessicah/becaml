open Application;;
open BtsButtonWindow;;

let kBUTTON_APP_SIG = "application/x-vnd.Be-BasicButton";;

class btsButtonApp =
	object(self)
	inherit be_application as app

	val fWindow = new btsButtonWindow

	method btsButtonApp () =
		app#be_application ~signature:kBUTTON_APP_SIG ()

	method readyToRun () =
	fWindow#btsButtonWindow ();
	fWindow#show ()


end;;

let app = new btsButtonApp 
in
	app#btsButtonApp ();
	app#run ();
	Printf.printf "[OCaml]fin de btsButtonApp\n";flush stdout
;;
