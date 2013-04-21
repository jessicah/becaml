open Unix;;

open Glue;;

open Archivable;;
open Blist;;
open Message;;
open MessageQueue;;
open Messenger;;
open Os;;
open Semaphores;;
open SupportDefs;;
open Threads;;


external b_handler_handler			  : 'a					  -> c_pointer          = "b_handler_handler"
external b_handler_handler_name       : 'a -> string		  -> c_pointer          = "b_handler_handler_name"
external b_handler_handler_message    : 'a -> c_pointer              -> c_pointer          = "b_handler_handler_message"
external b_handler_                   : c_pointer                    -> unit        = "b_handler_"   
external b_handler_archive            : c_pointer -> c_pointer -> bool      -> status_t = "b_handler_archive"
external b_handler_instantiate        : c_pointer                    -> c_pointer          = "b_handler_instantiate"
external b_handler_getSupportedSuites : c_pointer -> c_pointer              -> status_t = "b_handler_getSupportedSuites"
external b_handler_lockLooper         : c_pointer                    -> bool        = "b_handler_lockLooper"
external b_handler_lockLooperWithTimeout : c_pointer -> bigtime_t -> status_t = "b_handler_lockLooperWithTimeout"
external b_handler_unlockLooper          : c_pointer -> unit  = "b_handler_unlockLooper"
external b_handler_looper                : c_pointer -> c_pointer    = "b_handler_looper"
external b_handler_messageReceived  : c_pointer -> c_pointer -> unit = "b_handler_messageReceived"
external b_handler_resolveSpecifier : c_pointer -> c_pointer -> int32 -> c_pointer -> int32 -> string -> c_pointer = "b_handler_resolveSpecifier_bytecode" "b_handler_resolveSpecifier_native"
external b_handler_setFilterList    : c_pointer -> c_pointer -> unit = "b_handler_setFilterList"
external b_handler_filterList       : c_pointer -> unit -> c_pointer = "b_handler_filterList"
external b_handler_addFilter        : c_pointer -> c_pointer -> unit = "b_handler_addFilter"
external b_handler_removeFilter     : c_pointer -> c_pointer -> bool = "b_handler_removeFilter"
external b_handler_setName      : c_pointer -> string -> unit = "b_handler_setName"
external b_handler_name         : c_pointer -> unit -> string = "b_handler_name"
external b_handler_setNextHandler                     : c_pointer -> c_pointer -> unit = "b_handler_setNextHandler"
external b_handler_nextHandler                        : c_pointer -> unit -> c_pointer = "b_handler_nextHandler"
external b_handler_startWatching_handler  : c_pointer -> c_pointer -> int32 -> status_t= "b_handler_startWatching_handler"
external b_handler_startWatching_messenger: c_pointer -> c_pointer -> int32 -> status_t= "b_handler_startWatching_messenger"
external b_handler_startWatchingAll_handler  : c_pointer -> c_pointer -> status_t= "b_handler_startWatchingAll_handler"
external b_handler_startWatchingAll_messenger: c_pointer -> c_pointer -> status_t= "b_handler_startWatchingAll_messenger"
external b_handler_stopWatching_handler  : c_pointer -> c_pointer -> int32 -> status_t= "b_handler_stopWatching_handler"
external b_handler_stopWatching_messenger: c_pointer -> c_pointer -> int32 -> status_t= "b_handler_stopWatching_messenger"
external b_handler_stopWatchingAll_handler  : c_pointer -> c_pointer -> status_t= "b_handler_stopWatchingAll_handler"
external b_handler_stopWatchingAll_messenger: c_pointer -> c_pointer -> status_t= "b_handler_stopWatchingAll_messenger"

external b_looper_looper_name    : string -> int32 -> int32 -> c_pointer = "b_looper_looper_name"
external b_looper_looper_archive : c_pointer -> c_pointer = "b_looper_looper_archive"
external b_looper_ : c_pointer -> unit = "b_looper_"
external b_looperForThread : c_pointer -> thread_id -> c_pointer = "b_looperForThread"
external b_looper_addCommonFilter : c_pointer -> c_pointer -> unit = "b_looper_addCommonFilter"
external b_looper_removeCommonFilter : c_pointer -> c_pointer -> bool = "b_looper_removeCommonFilter"
external b_looper_setCommonFilterList : c_pointer -> c_pointer -> unit = "b_looper_setCommonFilterList"
external b_looper_addHandler : c_pointer -> c_pointer -> unit = "b_looper_addHandler"
external b_looper_removeHandler : c_pointer -> c_pointer -> bool = "b_looper_removeHandler"
external b_looper_handlerAt : c_pointer -> int32 -> c_pointer = "b_looper_handlerAt"
external b_looper_countHandlers : c_pointer -> unit -> int32 = "b_looper_countHandlers"
external b_looper_indexOf : c_pointer -> c_pointer -> int32 = "b_looper_indexOf"
external b_looper_commonFilterList : c_pointer -> c_pointer = "b_looper_commonFilterList"
external b_looper_currentMessage : c_pointer -> c_pointer = "b_looper_currentMessage"
external b_looper_detachCurrentMessage : c_pointer -> c_pointer = "b_looper_detachCurrentMessage"
external b_looper_dispatchMessage : c_pointer -> c_pointer -> c_pointer -> unit = "b_looper_dispatchMessage"
external b_looper_lock : c_pointer -> bool = "b_looper_lock"
external b_looper_lockWithTimeout : c_pointer -> bigtime_t -> unit = "b_looper_lockWithTimeout"
external b_looper_unlock : c_pointer -> unit = "b_looper_unlock"
external b_looper_lockingThread : c_pointer -> thread_id = "b_looper_lockingThread"
external b_looper_isLocked : c_pointer -> bool = "b_looper_isLocked"
external b_looper_countLocks : c_pointer -> int32 = "b_looper_countLocks"
external b_looper_countLockRequests : c_pointer -> int32 = "b_looper_countLockRequests"
external b_looper_sem : c_pointer -> sem_id = "b_looper_sem"
external b_looper_messageReceived : c_pointer -> c_pointer -> unit = "b_looper_messageReceived"
external b_looper_messageQueue : c_pointer -> c_pointer = "b_looper_messageQueue"
external b_looper_postMessage_message : c_pointer -> c_pointer -> status_t = "b_looper_postMessage_message"
external b_looper_postMessage_command : c_pointer -> int32 -> status_t = "b_looper_postMessage_command"
external b_looper_postMessage_handler_message : c_pointer -> c_pointer -> c_pointer -> status_t = "b_looper_postMessage_handler_message"
external b_looper_postMessage_handler_message_reply : c_pointer -> c_pointer -> c_pointer -> c_pointer -> status_t = "b_looper_postMessage_handler_message_reply"
external b_looper_postMessage_handler_command : c_pointer -> c_pointer -> int32 -> status_t = "b_looper_postMessage_handler_command"
external b_looper_postMessage_handler_command_reply : c_pointer -> c_pointer -> int32 -> c_pointer -> status_t = "b_looper_postMessage_handler_command_reply"
external b_looper_quit : c_pointer -> unit = "b_looper_quit"
external b_looper_quitRequested : c_pointer -> bool = "b_looper_quitRequested"
external b_looper_run : c_pointer -> thread_id = "b_looper_run"
external b_looper_setPreferredHandler : c_pointer -> c_pointer -> unit = "b_looper_setPreferredHandler"
external b_looper_preferredHandler : c_pointer -> c_pointer = "b_looper_preferredHandler"
external b_looper_thread : c_pointer -> thread_id = "b_looper_thread"
external b_looper_team : c_pointer -> team_id = "b_looper_team"
external b_looper_port_default_capacity : unit -> int32 = "b_looper_port_default_capacity"

type filter_result = 
| B_SKIP_MESSAGE
| B_DISPATCH_MESSAGE 
;;

external b_MessageFilter_MessageFilter_command : 'a -> int32 -> c_pointer = "b_MessageFilter_MessageFilter_command"
external b_MessageFilter_filter : c_pointer -> c_pointer -> c_pointer -> filter_result = "b_MessageFilter_filter"
external b_MessageFilter_looper : c_pointer -> c_pointer  = "b_MessageFilter_looper"



type ('a,'b) filter_hook = be_message -> 'b (*be_Handler*) -> 'a (*be_MessageFilter*) -> filter_result

type message_delivery =
| B_ANY_DELIVERY
| B_DROPPED_DELIVERY
| B_PROGRAMMED_DELIVERY
;;

type message_source =
| B_ANY_SOURCE
| B_REMOTE_SOURCE
| B_LOCAL_SOURCE 
;;

(******************************************************************************)

let looper_port_default_capacity = b_looper_port_default_capacity ();;


class 
(******************************************************************************)
be_MessageFilter =
	object(self : <filter : 'a. message:(#be_message as 'a) -> target:be_Handler -> filter_result; ..>)
	inherit be_interne

	method be_MessageFilter ?(delivery : message_delivery option) 
							?(source : message_source option) 
							?(command : int32 option) 
							?(filter : ( (be_MessageFilter,unit) filter_hook) option) 
							?(bobject : be_MessageFilter option) 
							() =
		match command with 
		| Some command -> self#set_interne (b_MessageFilter_MessageFilter_command self command)
		| None ->  failwith "be_MessageFilter#be_MessageFilter non implemente avec d'autres arguments que command seul.\n"

	method filter  : 'a.
		(message:(#be_message as 'a) ->
		target:(be_Handler) ->
		filter_result) =
		fun ~message ~target ->
			Printf.printf "be_MessageFilter#filter : typage trop fort sur target, impose par la definition mutuellement recursive de be_Handler et de be_MessageFilter. \n";flush Pervasives.stdout;
			message#printToStream();flush Pervasives.stdout;
			b_MessageFilter_filter (self#get_interne()) (message#get_interne()) (target#get_interne())
			
	method looper () = 
		let bl = new be_Looper
		in
		bl#set_interne (b_MessageFilter_looper (self#get_interne()));
		bl
end

and be_Handler =
object(self)
	
	(*val mutable forked = false;*)
	
	inherit be_Archivable as arc 
	
	method be_Handler : 'a.
		?archive:(#be_message as 'a) ->
		?name:string ->
		unit ->
		unit =
		fun	?archive ?name () ->
			(*if (not forked) then*)
			begin
				(*forked <- true;
				let pid = Unix.fork()
				in
				if (pid != 0) then ()(*pere*)
				else*) 
					match archive,name
					with 
					| None, None -> self#set_interne (b_handler_handler self)
					| None, Some name -> self#set_interne (b_handler_handler_name self name)
					| Some message, None -> self#set_interne (b_handler_handler_message self (message#get_interne()))
					| Some _, _  -> failwith "be_Handler : trop de parametres pour le constructeur" 
			end
						
	method be_Handler_ = 
		b_handler_ (self#get_interne())

   method archive ~archive  ?(deep = true) () = (*surchargee*)
             b_handler_archive (self#get_interne()) ((archive: be_message)#get_interne()) deep


   method instantiate ~archive = (* surchargee*)
		         let archive = new be_Archivable
		         in 
				 begin archive#set_interne (b_handler_instantiate (archive#get_interne())) ;
				       archive  
			     end


   method getSupportedSuites ~message =
              b_handler_getSupportedSuites (self#get_interne()) ((message : be_message)#get_interne())


   method lockLooper ()                  = b_handler_lockLooper            (self#get_interne())
   method lockLooperWithTimeout ~timeout = b_handler_lockLooperWithTimeout (self#get_interne()) timeout
   method unlockLooper                   = b_handler_unlockLooper          (self#get_interne())
   method looper () = 
             let looper = new be_Looper
			 in 
			 begin looper#set_interne (b_handler_looper (self#get_interne()));
			       looper
			 end
   
   method messageReceived ~message =
              b_handler_messageReceived (self#get_interne()) ((message : be_message)#get_interne())
   
   method resolveSpecifier ~message ~index ~specifier ~what ~property =
             let handler = new be_Handler 
			 in
			 begin handler#set_interne (b_handler_resolveSpecifier (self#get_interne()) 
			                               ((message : be_message)#get_interne()) 
										   index 
										   ((specifier : be_message)#get_interne()) what property);
			       handler
			 end
			 
   method setFilterList ~list = b_handler_setFilterList (self#get_interne()) ((list : be_list)#get_interne())
   method filterList () = 
          let list = new be_list 
		  in 
		  begin list#set_interne (b_handler_filterList (self#get_interne()) ()) ;
		        list
		  end
		  
	method addFilter : 'a. filter:(#be_interne as 'a) -> unit =
  		fun ~filter ->
		b_handler_addFilter (self#get_interne()) (filter#get_interne())

   method removeFilter ~filter = b_handler_removeFilter (self#get_interne()) 
   														((filter : be_MessageFilter)#get_interne())

   method setName ~string = b_handler_setName (self#get_interne()) string
   method name () =  b_handler_name (self#get_interne()) ()
   method setNextHandler ~handler = b_handler_setNextHandler (self#get_interne()) ((handler : be_Handler)#get_interne())
   method nextHandler () = 
              let handler = new be_Handler
			  in
			  begin handler#set_interne(b_handler_nextHandler (self#get_interne()) ()) ;
			        handler
			  end

   method startWatching ?watcher_messenger ?watcher_handler ~what ()=
            match watcher_messenger, watcher_handler 
			with
			| None, None -> failwith "be_Handler#startWatching : parametre manquant"
			| None, Some h -> b_handler_startWatching_handler (self#get_interne()) ((h : be_Handler)#get_interne()) what  
			| Some m, None -> b_handler_startWatching_messenger (self#get_interne()) ((m : be_messenger)#get_interne()) what 
			| _ ->  failwith "be_Handler#startWatching : parametre en trop"
			
   method startWatchingAll ?watcher_messenger ?watcher_handler ()=
            match watcher_messenger, watcher_handler 
			with
			| None, None -> failwith "be_Handler#startWatching : parametre manquant"
			| None, Some h -> b_handler_startWatchingAll_handler (self#get_interne()) ((h : be_Handler)#get_interne()) 
			| Some m, None -> b_handler_startWatchingAll_messenger (self#get_interne()) ((m : be_messenger)#get_interne()) 
			| _ ->  failwith "be_Handler#startWatchingAll : parametre en trop"

   method stopWatching ?watcher_messenger ?watcher_handler ~what ()=
            match watcher_messenger, watcher_handler 
			with
			| None, None -> failwith "be_Handler#stopWatching : parametre manquant"
			| None, Some h -> b_handler_stopWatching_handler   (self#get_interne()) ((h : be_Handler)#get_interne()) what
			| Some m, None -> b_handler_stopWatching_messenger (self#get_interne()) ((m : be_messenger)#get_interne()) what
			| _ ->  failwith "be_Handler#stopWatching : parametre en trop"
			
   
   method stopWatchingAll ?watcher_messenger ?watcher_handler ()=
            match watcher_messenger, watcher_handler 
			with
			| None, None -> failwith "be_Handler#stopWatchingAll : parametre manquant"
			| None, Some h -> b_handler_stopWatchingAll_handler   (self#get_interne()) ((h : be_Handler)#get_interne())
			| Some m, None -> b_handler_stopWatchingAll_messenger (self#get_interne()) ((m : be_messenger)#get_interne())
			| _ ->  failwith "be_Handler#stopWatching : parametre en trop"

   
end 
and be_Looper =
	object(self)
	inherit(be_Handler)
    
	method be_Looper ?archive ?(name = "") ?(priority = b_normal_priority) ?(portCapacity = looper_port_default_capacity) ()=
	         self#set_interne(match archive with | None -> b_looper_looper_name name priority portCapacity
			 		         						 | Some m -> b_looper_looper_archive ((m : be_message)#get_interne())
								 )
								
	method be_Looper_ = b_looper_ (self#get_interne())
	method looperForThread thread = let looper = new be_Looper
	                         		in 
							 		begin
										looper#set_interne (b_looperForThread (self#get_interne()) thread);
										looper
									end
									
	method addCommonFilter ~filter      = b_looper_addCommonFilter     (self#get_interne()) ((filter  : be_MessageFilter)#get_interne())
    method removeCommonFilter ~filter   = b_looper_removeCommonFilter  (self#get_interne()) ((filter  : be_MessageFilter)#get_interne())
	method setCommonFilterList ~filters = b_looper_setCommonFilterList (self#get_interne()) ((filters : be_list)#get_interne()) 
	method addHandler ~handler = b_looper_addHandler (self#get_interne()) ((handler : be_Handler)#get_interne())
	method removeHandler ~handler = b_looper_removeHandler (self#get_interne()) ((handler : be_Handler)#get_interne())

	method handlerAt ~index = let handler = new be_Handler 
	                          in
							  begin
							  	  handler#set_interne (b_looper_handlerAt (self#get_interne()) index);
							  	  handler
							  end
	method countHandlers () = b_looper_countHandlers (self#get_interne())
	method indexOf ~handler = b_looper_indexOf (self#get_interne()) ((handler : be_Handler)#get_interne())
	method commonFilterList () = let liste = new be_list 
	 							 in
								 begin
								 	liste#set_interne (b_looper_commonFilterList (self#get_interne()));
								 	liste
								 end
    method currentMessage () = 
		let mess = new be_message 
	    in
		begin
			mess#set_interne (b_looper_currentMessage (self#get_interne()));
			mess
		end
							
	method detachCurrentMessage () = let mess = new be_message 
	                           		 in
							   		 begin
										mess#set_interne (b_looper_detachCurrentMessage (self#get_interne()));
							   			mess
							   		 end

	method dispatchMessage : 'a .
		message:(#be_message as 'a) ->
		target:(be_Handler) ->
		unit = 
		fun ~message ~target ->
			b_looper_dispatchMessage (self#get_interne()) (message#get_interne()) 
													  (target#get_interne())
			
	method lock () = b_looper_lock (self#get_interne()) 
	method lockWithTimeout ~timeout = b_looper_lockWithTimeout (self#get_interne()) timeout
	method unlock () =  b_looper_unlock (self#get_interne()) 
	method lockingThread () = b_looper_lockingThread (self#get_interne())
	method isLocked () = b_looper_isLocked (self#get_interne())
	method countLocks () = b_looper_countLocks (self#get_interne())
	method countLockRequests =  b_looper_countLockRequests (self#get_interne())
	method sem () = b_looper_sem (self#get_interne())
	method messageReceived ~message = b_looper_messageReceived (self#get_interne()) ((message : be_message)#get_interne())
 	method messageQeue () = let message_queue = new be_MessageQueue
	                        in
							begin
								message_queue#set_interne(b_looper_messageQueue (self#get_interne()));
								message_queue
							end
	method postMessage : 'a.
		?message:(#be_message as 'a) ->
		?command:int32 ->
		?handler:be_Handler ->
		?reply_handler : be_Handler ->
		unit ->
		status_t =
	fun ?message ?command ?handler ?reply_handler () ->
		match handler,message,command,reply_handler with
		| None, Some m, None, None -> b_looper_postMessage_message (self#get_interne()) (m#get_interne())
		| None, None, Some c, None -> b_looper_postMessage_command (self#get_interne()) c
		| Some h, Some m, None, None -> b_looper_postMessage_handler_message (self#get_interne()) ((h : be_Handler)#get_interne()) (m#get_interne())
		| Some h, Some m, None, Some r -> b_looper_postMessage_handler_message_reply (self#get_interne()) ((h : be_Handler)#get_interne()) (m#get_interne()) ((r : be_Handler)#get_interne())
		| Some h, None, Some c, None -> b_looper_postMessage_handler_command (self#get_interne()) ((h : be_Handler)#get_interne()) c
		| Some h, None, Some c, Some r -> b_looper_postMessage_handler_command_reply (self#get_interne()) ((h : be_Handler)#get_interne()) c ((r : be_Handler)#get_interne())
		| _ -> failwith "be_Looper#postMessage : mauvais nombre d'arguments"

	method quit () = 
		b_looper_quit (self#get_interne())
		
	method quitRequested () = 
		b_looper_quitRequested (self#get_interne())

	method run () =  b_looper_run (self#get_interne())
	method setPreferredHandler ~handler = b_looper_setPreferredHandler (self#get_interne()) ((handler : be_Handler)#get_interne())
	method preferredHandler () = b_looper_preferredHandler (self#get_interne())
	method thread () = b_looper_thread (self#get_interne())
	method team () = b_looper_team (self#get_interne())
	
end

;;

(******************************************************************************)

Callback.register "postMessage_message_handler" (
	fun o -> 
	fun message -> let m = new be_message in m#set_interne message;
	fun handler -> let h = new be_Handler in h#set_interne handler;
	fun replyHandler -> let r = new be_Handler in r#set_interne replyHandler;
	o#postMessage ~message:m ~handler:h ~replyHandler r
);;


Callback.register "MessageFilter#Filter" (
	fun messageFilter -> 
	fun message_c -> let message = new be_message in message#set_interne message_c;
	fun target_c -> let target = new be_Handler in target#set_interne target_c;
	messageFilter#filter ~message ~target
);;
