open Glue
open Handler
open Invoker
open Message
open MessageFilter
open SupportDefs

class postDispatchInvoker =
	object(self)
	inherit be_MessageFilter as messageFilter
	val invoker = new be_Invoker

	method postDispatchInvoker ~cmdFilter 
							   ~(invokeMsg : be_message)
							   ~(invokeHandler : be_Handler)
							   ?invokeLooper 
							   ()=
							   
		self#be_MessageFilter ~command:cmdFilter ();
		match invokeLooper 
		with 
		| Some invokeLooper -> 
			invoker#be_Invoker ~message:invokeMsg 
							   ~handler:invokeHandler 
							   ~looper:invokeLooper ()
		| None -> 
			invoker#be_Invoker ~message:invokeMsg 
							   ~handler:invokeHandler 
							   ()

	method filter ~message ~target =
	Printf.printf "appel de postdispatchinvoker#filter.\n";flush stdout;
		((self#looper ())(* : <dispatchMessage : 'a. message:(#be_message as 'a) -> 
												   target:be_Handler -> 
												   unit ; 
							  ..>
						 *)
		)#dispatchMessage message target;
		let (pInvMsg : <addMessage : 'a. name:string -> message:(#be_interne as 'a) -> status_t;
					    ..
					   >) = 
		invoker#message ()
		in
		ignore (pInvMsg#addMessage "Dispatched Message" (message :> be_interne));
		ignore (pInvMsg#addPointer "Dispatch Target" (target :> be_interne));
		pInvMsg#printToStream();
		ignore (invoker#invoke ());
		B_SKIP_MESSAGE
end	

