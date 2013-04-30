#ifndef BEOS
	#define BEOS
#endif

#include <Invoker.h>
#include <stdio.h>
#include <Handler.h>
#include <Looper.h>

#include "glue.h"

#include "alloc.h"
#include "callback.h"
#include "mlvalues.h"
#include "memory.h"
#include "signals.h"
#include "threads.h"



extern "C" 
{
	value b_invoker_invoker(value unit);
	value b_invoker_invoker_handler(/*value invoker,*/ value message, value handler);
	value b_invoker_invoker_handler_looper(/*value self,*/ value message, value handler, value looper);
	value b_invoker_invoker_messenger(value invoker, value message, value messenger);
	value b_invoker_setTarget_handler(value invoker, value handler);
	value b_invoker_setTarget_looper(value invoker, value handler, value looper);
	value b_invoker_setTarget_messenger(value invoker, value messenger);
	/*
	value b_invoker_timeout();
	value b_invoker_setTimeout();
	value b_invoker_messenger();
	value b_invoker_isTargetLocal();
	value b_invoker_target_looper();
	value b_invoker_target();
	value b_invoker_setTarget_messenger();
	value b_invoker_setTarget_looper();
	value b_invoker_setTarget_handler();
	value b_invoker_command();
*/	value b_invoker_message(value invoker);
/*	value b_invoker_setMessage();
	value b_invoker_handlerForReply();
	value b_invoker_setHandlerForReply();
	value b_invoker_invokeKind_notify();
	value b_invoker_invokeKind();
	value b_control_invoked();
	value b_invoker_invokeNotify();*/
	value b_invoker_invoke_message(value invoker, value message);
	value b_invoker_invoke(value invoker);
/*	value b_invoker_endInvokeNotify();
	value b_invoker_beginInvokeNotify();
	value b_invoker_();
	value b_invoker_invoker_messenger();
	value b_invoker_handler_looper();
	value b_invoker_handler();
	value b_invoker();        
	*/
	extern sem_id callback_sem;
	extern sem_id ocaml_sem;
}


class OInvoker : public BInvoker//, public Glue 
{
	public :		
		OInvoker(/*value self,*/ BMessage *message, BHandler *handler, BLooper *looper) : 
			BInvoker(message, handler, looper)//, Glue(/*self*/)
		{}
		
		OInvoker(/*value self,*/ BMessage *message, BHandler *handler) : 
			BInvoker(message, handler)//, Glue(/*self*/)
		{	}

 		status_t SetTarget(const BHandler *h, const BLooper *loop = NULL); 
		status_t SetTarget(BMessenger messenger); 
};

status_t OInvoker::SetTarget(const BHandler *hand, const BLooper *loop = NULL){
	CAMLparam0();
	CAMLlocal3(h, l, res);
		caml_leave_blocking_section();
		h = caml_copy_int32((int32)hand);
		l = caml_copy_int32((int32)loop);
		
			////**acquire_sem(callback_sem);		
				res = caml_c_thread_register();caml_callback2(*caml_named_value("OInvoker#setTarget_handler_looper"), h, l);
			////**release_sem(callback_sem);
		caml_enter_blocking_section();

	CAMLreturn(res);
}

status_t OInvoker::SetTarget(BMessenger messenger){
	CAMLparam0();
	status_t res;
	BMessenger *m = new BMessenger(messenger);

	caml_leave_blocking_section();
		////**acquire_sem(callback_sem);
			res = caml_c_thread_register();caml_callback(*caml_named_value("OInvoker#setTarget_messenger"), 
							copy_int32((int32)m));
		////**release_sem(callback_sem);
	caml_enter_blocking_section();

	CAMLreturn(res);
}

//**********************
value b_invoker_invoker(value unit) {
	printf("b_invoker_invoker non implémenté\n");
	
}

//***********************
value b_invoker_invoker_messenger(value invoker, value message, value messenger){
	printf("b_invoker_invoker_messenger non implémenté\n");
}
	
//***********************
value b_invoker_invoker_handler(/*value invoker,*/ value message, value handler){
	CAMLparam2(/*invoker,*/ message, handler);
	
	OInvoker *i;
	
	i = new OInvoker(//invoker,
					 (BMessage *)Int32_val(message),
					 (BHandler *)Int32_val(handler));
	printf("C 0x%lx : %lx\n", i, sizeof(OInvoker));
	CAMLreturn(caml_copy_int32((uint32)i));
}

//********************		
value b_invoker_invoker_handler_looper(/*value self,*/ value message, value handler, value looper){
	CAMLparam3(/*self,*/ message, handler, looper);
	
	OInvoker *i;
	
	i = new OInvoker(//self,
					(BMessage *)Int32_val(message),
									 (BHandler *)Int32_val(handler),
									 (BLooper  *)Int32_val(looper));
	printf("C 0x%lx : %lx\n", i, sizeof(OInvoker));

	CAMLreturn(caml_copy_int32((uint32)i));
}

//*****************
value b_invoker_invoke_message (value invoker, value message) {
	CAMLparam2(invoker, message);
	status_t res;
	BInvoker * i = (BInvoker *)Int32_val(invoker);
	BMessage * m = (BMessage *)Int32_val(message);
	if (m==NULL) res = i->BInvoker::Invoke();
	else		 res = i->BInvoker::Invoke(m);

	CAMLreturn(caml_copy_int32(res));
}

//**********************
value b_invoker_invoke(value invoker){
	CAMLparam1(invoker);

	CAMLreturn(caml_copy_int32(((BInvoker*)Int32_val(invoker))->Invoke()));

}

//******************
value b_invoker_message(value invoker){
	CAMLparam1(invoker);
	
	CAMLreturn(caml_copy_int32((value)((BInvoker*)Int32_val(invoker))->Message()));
}

//**********************
value b_invoker_setTarget_handler(value invoker, value handler){
	CAMLparam2(invoker, handler);
	
	BInvoker *i = (BInvoker*)Int32_val(invoker);
	BHandler *h = (BHandler*)Int32_val(handler);

	CAMLreturn(caml_copy_int32(i->BInvoker::SetTarget(h)));
}

//************************
value b_invoker_setTarget_looper(value invoker, value handler, value looper){
	CAMLparam3(invoker, handler, looper);
	BInvoker *i = (BInvoker*)Int32_val(invoker);
	BHandler *h = ((BHandler*)Int32_val(handler));
	BLooper *l = ((BLooper*)Int32_val(looper));

	CAMLreturn(caml_copy_int32(i->BInvoker::SetTarget(h, l)));
}
	
//**********************
value b_invoker_setTarget_messenger(value invoker, value messenger){
	CAMLparam2(invoker, messenger);

	CAMLreturn(caml_copy_int32(((BInvoker*)Int32_val(invoker))->BInvoker::SetTarget(*(BMessenger*)Int32_val(messenger))));
}

