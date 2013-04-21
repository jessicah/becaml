open Int32;;

open Glue;;
open Handler;;
open Looper;;
open Message;;
open Messenger;;
open SupportDefs;;

external b_invoker_invoker : unit -> c_pointer = "b_invoker_invoker"
external b_invoker_invoker_messenger : c_pointer -> c_pointer -> c_pointer = "b_invoker_invoker_messenger"
external b_invoker_invoker_handler : c_pointer -> c_pointer -> c_pointer = "b_invoker_invoker_handler"
external b_invoker_invoker_handler_looper : c_pointer -> c_pointer -> c_pointer -> c_pointer = "b_invoker_invoker_handler_looper"
(*
external b_invoker_ : c_pointer -> unit = "b_invoker_"
external b_invoker_beginInvokeNotify : c_pointer -> int32 -> unit = "b_invoker_beginInvokeNotify"
external b_control_invoked : unit -> int32 = "b_control_invoked" (* A REVOIR*)
external b_invoker_endInvokeNotify : c_pointer -> unit = "b_invoker_endInvokeNotify"*)
external b_invoker_invoke_message : c_pointer -> c_pointer -> status_t = "b_invoker_invoke_message"
external b_invoker_invoke : c_pointer -> status_t = "b_invoker_invoke"
(*external b_invoker_invokeNotify : c_pointer -> c_pointer -> int32 -> status_t = "b_invoker_invokeNotify"
external b_invoker_invokeKind_notify : c_pointer -> bool -> int32= "b_invoker_invokeKind_notify"
external b_invoker_invokeKind : c_pointer -> int32 = "b_invoker_invokeKind"
external b_invoker_setHandlerForReply : c_pointer -> c_pointer -> status_t = "b_invoker_setHandlerForReply"
external b_invoker_handlerForReply : c_pointer -> c_pointer = "b_invoker_handlerForReply"
external b_invoker_setMessage : c_pointer -> c_pointer -> status_t = "b_invoker_setMessage"
*)
external b_invoker_message :  c_pointer -> c_pointer = "b_invoker_message"
(*
external b_invoker_command : c_pointer -> int32 = "b_invoker_command"
*)
external b_invoker_setTarget_messenger : c_pointer -> c_pointer -> status_t = "b_invoker_setTarget_messenger"
external b_invoker_setTarget_handler : c_pointer -> c_pointer -> status_t = "b_invoker_setTarget_handler"
external b_invoker_setTarget_looper : c_pointer -> c_pointer -> c_pointer -> status_t = "b_invoker_setTarget_looper"
(*external b_invoker_target_looper : c_pointer -> c_pointer -> c_pointer = "b_invoker_target_looper"
external b_invoker_target : c_pointer -> c_pointer = "b_invoker_target"
external b_invoker_isTargetLocal : c_pointer -> bool = "b_invoker_isTargetLocal" 
external b_invoker_messenger : c_pointer -> c_pointer = "b_invoker_messenger"
external b_invoker_setTimeout : c_pointer -> bigtime_t -> status_t = "b_invoker_setTimeout"
external b_invoker_timeout : c_pointer -> bigtime_t = "b_invoker_timeout"
*)
class be_Invoker =
	object(self)
	inherit be_interne

	method be_Invoker ?message ?handler ?messenger ?looper () =
		match message,messenger,handler,looper with
		| None, None, None, None -> self#set_interne(b_invoker_invoker ())
		| Some m, Some mess, None, None -> self#set_interne(b_invoker_invoker_messenger ((m : be_message)#get_interne()) ((mess : be_messenger)#get_interne()))
		| Some m, None, Some h, None -> self#set_interne(b_invoker_invoker_handler ((m : be_message)#get_interne()) ((h : be_Handler)#get_interne()))
		| Some m, None, Some h, Some l -> 
			self#set_interne(b_invoker_invoker_handler_looper ((m : be_message)#get_interne()) 
															  ((h : be_Handler)#get_interne()) 
															  ((l : be_Looper )#get_interne()))
		| _ -> failwith "be_invoker#be_invoker : paramètres incorrects"
(*		
	method be_invoker_ () = b_invoker_(self#get_interne)
	method beginInvokeNotify ?(kind = b_control_invoked ()) () = 
		b_invoker_beginInvokeNotify self#get_interne kind
	method endInvokeNotify () = b_invoker_endInvokeNotify self#get_interne *)
	method invoke : 'a. ?message:(#be_message as 'a) -> unit -> status_t= 
		fun ?message () -> match message with 
	 					   | Some m -> print_string "[OCaml] b_invoker_invoke_message\n"; flush stdout; b_invoker_invoke_message (self#get_interne()) (m#get_interne())
						   | None   -> print_string "[OCaml] b_invoker_invoke\n"        ; flush stdout; b_invoker_invoke (self#get_interne())
(*	method invokeNotify ~message ?(kind = b_control_invoked ()) ()=
		b_invoker_invokeNotify self#get_interne ((message : be_message)#get_interne) kind
	method invokeKind ?notify () = match notify with
								   | Some b -> b_invoker_invokeKind_notify self#get_interne b
								   | None -> b_invoker_invokeKind self#get_interne
	method setHandlerForReply ~replyHandler = b_invoker_setHandlerForReply self#get_interne	((replyHandler : be_Handler)#get_interne)
	method handlerForReply () = let handler = new be_Handler
								in
								begin
									handler#set_interne(b_invoker_handlerForReply self#get_interne);
									handler
								end
	method setMessage ~message = b_invoker_setMessage self#get_interne ((message : be_Handler)#get_interne)
*)	method message () = let message = new be_message
						in
							message#set_interne(b_invoker_message (self#get_interne()));
							message
(*	method command () = b_invoker_command self#get_interne
*)
	method setTarget : 'a 'b 'c.
		?messenger:(#be_messenger as 'a) ->
		?handler:(#be_Handler as 'b) ->
		?looper:(#be_Looper as 'c) -> 
		unit ->
		status_t =
		fun	?messenger ?handler ?looper () ->
		match messenger,handler,looper with
		| Some m, None, None -> b_invoker_setTarget_messenger	(self#get_interne()) (m#get_interne())
		| None, Some h, None -> print_string "[OCaml] be_invoker#setTarget (handler)\n";flush stdout; 
					b_invoker_setTarget_handler		(self#get_interne()) (h#get_interne())
		| None, Some h, Some l -> b_invoker_setTarget_looper	(self#get_interne()) (h#get_interne()) 
																				 (l#get_interne())
		| _ -> failwith "be_invoker#setTarget : paramètres incorrects"
	
(*		
	method target ?looper () = let handler = new be_Handler
							   in
							   begin
									match looper with
									| Some l -> (handler#set_interne(b_invoker_target_looper self#get_interne ((l : be_Looper)#get_interne) );
												 handler
												)
									| None ->  (handler#set_interne(b_invoker_target self#get_interne);
												handler
											   )
							   end
	method isTargetLocal () = b_invoker_isTargetLocal self#get_interne							   
	method messenger () = let messenger = new be_messenger
						  in
						  begin
						  	messenger#set_interne(b_invoker_messenger self#get_interne);
							messenger
						  end
	method setTimeout ~timeout = b_invoker_setTimeout self#get_interne timeout
	method timeout () = b_invoker_timeout self#get_interne
	*)
end;;
