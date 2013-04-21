open Glue;;
open Font;;
open Int32;;
open Looper;;
open Message;;
open SupportDefs;;
open Threads;;

external b_application_signature : string -> c_pointer = "b_application_signature"
external b_application_messageReceived : c_pointer -> c_pointer -> unit = "b_application_messageReceived"
external b_application_readyToRun : c_pointer -> unit = "b_application_readyToRun"
external b_application_postmessage : c_pointer -> int32 -> status_t = "b_application_postMessage"
external b_application_run : c_pointer -> thread_id = "b_application_run"
external b_application_quitRequested : c_pointer -> bool = "b_application_quitRequested"
external b_app : unit -> c_pointer = "b_app"

class be_application =
	object (self)
	inherit be_Looper

	method be_application ?signature ?error ?archive () =
	     self#set_interne (match signature,error,archive with
							   | Some s, None, None -> b_application_signature s
							   | Some s, Some (e : unit), None -> (self#get_interne())(*b_application_error*)
							   | None, None, Some (m : unit) ->   (self#get_interne())(*b_application_archive *)
							   | _ -> failwith "be_application#be_application : parametres incorrects"
							  );
		be_plain_font#set_interne(b_plain_font());
		be_bold_font#set_interne (b_bold_font());

(*	method be_application_messageReceived : 'a. message:(#be_message as 'a) -> unit  =
		fun ~message ->
		b_application_messageReceived (self#get_interne()) (message#get_interne())
*)
	method postMessage ?message ?command ?handler ?reply_handler () =
		match command with
		| None -> failwith "arguments manquants dans be_application#postMessage\n" (*a ameliorer*)
		| Some command -> Printf.printf "[OCaml] be_application#postMessage ~command:0x%lx\n" command;
						  flush stdout;
						  b_application_postmessage (self#get_interne()) command
(*	method be_application_ () = b_application_ self#get_interne()
	method appResources () = b_application_appResources self#get_interne()
    method aboutRequested : unit -> unit(* b_application_aboutRequested self#get_interne()*)
	method appActivated ~active = b_application_appActivated self#get_interne() active
	method argvReceived ~argc ~argv = b_application_argvReceived self#get_interne() argc argv
    method getAppInfo ~theInfo = b_application_getAppInfo self#get_interne() theInfo
	method isLaunching () = b_application_isLaunching self#get_interne()
	method pulse () = b_application_pulse self#get_interne()
	method setPulseRate ~rate = b_application_setPulseRate self#get_interne() rate
*)	method quitRequested ()= b_application_quitRequested (self#get_interne())
	method readyToRun ()= b_application_readyToRun (self#get_interne())
	(*method refsReceived ~message = b_application_refsReceived self#get_interne() message
	*)
	method run () = 
		b_application_run (self#get_interne())
	(*
	method quit () = b_application_quit self#get_interne()
	method setCursor ?(sync = true) cursor =
	              match sync with
				  | None -> b_application_setCursor_cursor self#get_interne() cursor
				  | Some s -> b_application_setCursor_sync self#get_interne() cursor sync
	method hideCursor = b_application_hideCursor self#get_interne()
	method showCursor = b_application_showCursor self#get_interne()
	method obscureCursor = b_application_obscureCursor self#get_interne()
	method isCursorHidden = b_application_isCursorHidden self#get_interne()
	method windowAt ~index = b_application_windowAt self#get_interne() index
	method countWindows () = b_application_countWindows self#get_interne() 
*)
end;;


let be_app = new be_application;;
(*let be_app_messenger = be_application_be_app_messenger ();;
*)

let set_be_app a = be_app#set_interne a;;

Callback.register "OApplication::Set_be_app" set_be_app;;

Callback.register "OApplication::AboutRequested" (fun a_c -> 
(*launch*) (find a_c : #be_application)#aboutRequested ());;

Callback.register "OApplication::MessageReceived" (fun a_c -> fun m_c -> 
		(*print_string "OApplication::MessageReceived\n";flush stdout;*)
		let a = try find a_c 
				with Not_found -> 
(*				print_string "[OCaml register]OApplication::MessageReceived : a_c not found\n";flush stdout;*)
				let a' = new be_application 
								  in
								  a'#set_interne a_c;
								  a'
		and m = try find m_c 
				with Not_found -> let m' = new be_message 
								  in
								  m'#set_interne m_c;
								  m'
		in 
		(*launch (fun () ->*) a#messageReceived m(*)*);
		);;
Callback.register "OApplication::Ready_to_run"  (fun a_c -> (find a_c : #be_application)#readyToRun());;
Callback.register "OApplication::QuitRequested" (fun a_c -> (find a_c : #be_application)#quitRequested());;
