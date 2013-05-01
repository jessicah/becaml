open Control
open Glue
open Handler
open Looper
open Message
open Messenger
open Rect
open SupportDefs
open View

external b_button_button : pointer -> string -> string -> pointer -> int32 -> int32 -> pointer = "b_button_button_bytecode" "b_button_button_native"
external b_button_makeDefault : pointer -> bool -> unit = "b_button_makeDefault"
external b_button_setEnabled : pointer -> bool -> unit = "b_button_setEnabled"
external b_button_setLabel : pointer -> string -> unit = "b_button_setLabel"
external b_button_setTarget_handler : pointer -> pointer -> status_t = "b_button_setTarget_handler"

class be_button =
	object(self)
	inherit be_control

	method be_button ~frame ~name ~label ~message
					 ?(resizingMode = Int32.logor kB_FOLLOW_LEFT 
					 							  kB_FOLLOW_TOP) 
					 ?(flags= Int32.logor kB_WILL_DRAW 
					 					  kB_NAVIGABLE) () =
		self#set_interne (b_button_button ((frame : be_rect)#get_interne()) name label 
										  ((message : be_message)#get_interne()) resizingMode flags)

	method makeDefault ~(state : bool) =
		b_button_makeDefault (self#get_interne()) state
		
	method setEnabled ~(enabled : bool) =
		b_button_setEnabled (self#get_interne()) enabled
	
	method setLabel ~(string : string) =
		b_button_setLabel (self#get_interne()) string

	method setTarget : 'a 'b 'c. 
		?messenger:(#be_messenger as 'a) ->
		?handler:(#be_Handler as 'b) ->
		?looper:(#be_Looper as 'c) -> 
		unit -> 
		SupportDefs.status_t =
		
		fun ?messenger ?handler ?looper () ->
		match handler,looper with 
		| Some handler, None -> b_button_setTarget_handler (self#get_interne()) (handler#get_interne())
		| _ -> failwith "be_button#setTarget implemente seulement avec un handler en parametres."
		
end;;
