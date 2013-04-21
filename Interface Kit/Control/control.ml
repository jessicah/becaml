open View;;
open Invoker;;

let kB_CONTROL_ON = Int32.one
let kB_CONTROL_OFF = Int32.zero


class be_control =
	object(self)
	inherit be_view as view
	inherit be_Invoker as invoker
	
	method value () =
		Printf.printf "be_control#value non implemente.\n"; flush stdout;
		Int32.zero		

(*ERREUR	method setTarget : 'a.
		?view:(#be_view as 'a) ->
		?name:string ->
		unit ->
		unit =
		fun ?view ?name () ->
		Printf.printf "be_control#setTarget non implemente.\n"; flush stdout
		*)
end;;
