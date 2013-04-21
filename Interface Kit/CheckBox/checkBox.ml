open Control
open Glue
open Handler
open Looper
open Message
open Messenger
open Rect
open SupportDefs
open View

external b_checkBox_checkBox : c_pointer -> string -> string -> c_pointer -> int32 -> int32 -> c_pointer = "b_checkBox_checkBox_bytecode" "b_checkBox_checkBox_native"
external b_checkBox_resizeToPreferred : c_pointer -> unit = "b_checkBox_resizeToPreferred"
external b_checkBox_invoke : c_pointer -> status_t = "b_checkBox_invoke"
external b_checkBox_invoke_message : c_pointer -> c_pointer -> status_t = "b_checkBox_invoke_message"
external b_checkBox_setTarget_handler : c_pointer -> c_pointer -> status_t = "b_checkBox_setTarget_handler"
external b_checkBox_setTarget_view : c_pointer -> c_pointer -> unit = "b_checkBox_setTarget_view"
external b_checkBox_setTarget_name : c_pointer -> string -> unit = "b_checkBox_setTarget_name"
external b_checkBox_setValue : c_pointer -> int32 -> unit = "b_checkBox_setValue"
external b_checkBox_value : c_pointer -> int32 = "b_checkBox_value"

class be_checkBox =
	object(self)
	inherit be_control as control

	method be_checkBox ~(frame : be_rect) ~name ~label ~(message : be_message)  
					 ?(resizingMode = Int32.logor kB_FOLLOW_LEFT 
					 							  kB_FOLLOW_TOP)
					 ?(flags = Int32.logor kB_WILL_DRAW 
					 					   kB_NAVIGABLE) () =
		 self#set_interne(b_checkBox_checkBox (frame#get_interne()) name label (message#get_interne()) resizingMode flags)
	method invoke : 'a. ?message:(#be_message as 'a) -> unit -> status_t =
	 fun ?message () ->
	 	match message with 
		| None -> b_checkBox_invoke (self#get_interne())
		| Some m -> b_checkBox_invoke_message (self#get_interne()) (m#get_interne())

	method resizeToPreferred () =
		b_checkBox_resizeToPreferred (self#get_interne())

	method setTarget : 'a 'b 'c.
		?messenger	:	(#be_messenger	as 'a) ->
		?handler	:	(#be_Handler	as 'b) ->
		?looper		:	(#be_Looper		as 'c) ->
		unit ->
		status_t =
		fun ?messenger ?handler ?looper () ->
		match messenger,handler,looper with
		| None, Some handler, None -> print_string "[OCaml] be_checkBox#setTarget (handler)\n";flush stdout;
					b_checkBox_setTarget_handler (self#get_interne()) (handler#get_interne())
		| _ -> failwith "be_checkBox#setTarget implémenté juste avec handler"
	
	method setValue ~value =
		b_checkBox_setValue (self#get_interne()) value
	
	method value () =
		b_checkBox_value (self#get_interne())
end;;

Callback.register "OCheckBox#Invoke" (fun c_c -> fun m_c -> ((find c_c): #be_checkBox)#invoke(find m_c));;
