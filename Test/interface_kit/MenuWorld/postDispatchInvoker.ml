open Message
open MessageFilter
open Invoker

class postDispatchInvoker =
	object(self)
	inherit be_MessageFilter as messageFilter
	val invoker = new be_Invoker

	method postDispatchInvoker ~cmdFilter 
							   ~(invokeMsg : be_message)
							   ~(invokeHandler : be_Handler)
							   ?(invokeLooper = let il = new Looper.be_Looper 
												in 
												il#set_interne Glue.null;
												il) 
							   ()=
		self#be_MessageFilter ~command:cmdFilter ();
		invoker#be_Invoker ~message:invokeMsg ~handler:invokeHandler ~looper:invokeLooper ()

	method filter ~message ~target =
	(*	(self#looper ())#dispatchMessage message target;
		let pInvMsg = invoker#message ()
		in
		ignore (pInvMsg#addMessage "Dispatched Message" message);
		ignore (pInvMsg#addPointer "Dispatch Target" (target :> Glue.be_interne));
		ignore (invoker#invoke ());
	*)	B_SKIP_MESSAGE
	
end	

