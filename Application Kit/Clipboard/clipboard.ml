open Glue;;
open Int32;;
open Message;;
open Messenger;;
open Supportdefs;;

external b_clipboard : be -> string -> bool -> be = "b_clipboard"
external b_clipboard_ : be -> unit = "b_clipboard_"
external b_clipboard_clear : be -> unit = "b_clipboard_clear"
external b_clipboard_commit : be -> unit = "b_clipboard_commit"
external b_clipboard_revert : be -> unit = "b_clipboard_revert"
external b_clipboard_data : be -> be = "b_clipboard_data"
external b_clipboard_dataSource : be -> be = "b_clipboard_dataSource"
external b_clipboard_localCount : be -> int32 = "b_clipboard_localCount"
external b_clipboard_systemCount : be -> int32 = "b_clipboard_systemCount"
external b_clipboard_lock : be -> bool = "b_clipboard_lock"
external b_clipboard_unlock : be -> unit = "b_clipboard_unlock"
external b_clipboard_isLocked : be -> bool = "b_clipboard_isLocked"
external b_clipboard_name : be -> string = "b_clipboard_name"
external b_clipboard_startWatching : be -> be -> status_t = "b_clipboard_startWatching"
external b_clipboard_stopWatching : be -> be -> status_t = "b_clipboard_stopWatching"



class be_clipboard =
	object(self)
	inherit be_interne

	method be_clipboard ~name ?(discard = false) () = self#_BE_set_interne(b_clipboard self#_BE_interne name discard)
	method be_clipboard_ () = b_clipboard_ self#_BE_interne
	method clear () = b_clipboard_clear self#_BE_interne 
	method commit () = b_clipboard_commit self#_BE_interne
	method revert () = b_clipboard_revert self#_BE_interne
	method data () = let message = new be_message
	                 in
					 begin
					 	message#_BE_set_interne (b_clipboard_data self#_BE_interne);
						message
					 end
	method dataSource () = let messenger = new be_messenger
	                 in
					 begin
					 	messenger#_BE_set_interne (b_clipboard_dataSource self#_BE_interne);
						messenger
					 end
	method localCount () = b_clipboard_localCount self#_BE_interne
	method systemCount () = b_clipboard_systemCount self#_BE_interne
	method lock () = b_clipboard_lock self#_BE_interne
	method unlock () = b_clipboard_unlock self#_BE_interne
	method isLocked () = b_clipboard_isLocked self#_BE_interne
	method name () = b_clipboard_name self#_BE_interne
	method startWatching ~target = b_clipboard_startWatching self#_BE_interne ((target : be_messenger)#_BE_interne)
	method stopWatching ~target = b_clipboard_stopWatching self#_BE_interne ((target : be_messenger)#_BE_interne)

end;;
