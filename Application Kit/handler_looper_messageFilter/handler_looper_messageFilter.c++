#include <Handler.h>
#include <Looper.h>
#include <MessageFilter.h>
#include <Messenger.h>

#include <stdio.h>

#include "alloc.h"
#include "callback.h"
#include "memory.h"
#include "mlvalues.h"
#include "signals.h"
#include "threads.h"


#include "handler.h"

extern "C" 
{
  extern sem_id ocaml_sem;
  filter_result decode_filter_result(value result);
  value encode_filter_result(filter_result val);
  
  value b_handler_handler(value self, value unit);
  value b_handler_handler_name(value self, value name);
  value b_handler_handler_message(value self, value message);
  value b_handler_(value handler);
  value b_handler_archive(value handler, value archive, value deep);
  value b_handler_instantiate(value archive_message);
  value b_handler_addFilter(value handler,value filter);
  value b_handler_getSupportedSuites(value handler, value message);
  value b_handler_lockLooper(value handler);
  value b_handler_lockLooperWithTimeout(value handler, value timeout);
  value b_handler_unlockLooper(value handler);
  value b_handler_looper(value handler);
  value b_handler_messageReceived(value handler, value message);
  value b_handler_resolveSpecifier_native(value handler, value message, value index, 
										  value specifier, value what, value property);
  value b_handler_resolveSpecifier_bytecode(value *argv, int argc);
  value b_handler_setFilterList(value handler, value list);      
  value b_handler_filterList(value handler);                                
  value b_handler_removeFilter(value handler,value filter);
  value b_handler_setName(value handler, value name);
  value b_handler_name(value handler, value unit);
  value b_handler_setNextHandler(value handler, value nextHandler);
  value b_handler_nextHandler(value handler, value unit);
  value b_handler_startWatching_handler(value handler, value watcher, value what);
  value b_handler_startWatching_messenger(value handler, value watcher, value what);
  value b_handler_startWatchingAll_handler(value handler, value watcher);  
  value b_handler_startWatchingAll_messenger(value handler, value watcher);  
  value b_handler_stopWatching_handler(value handler, value watcher, value what);
  value b_handler_stopWatching_messenger(value handler, value watcher, value what);
  value b_handler_stopWatchingAll_handler(value handler, value watcher);  
  value b_handler_stopWatchingAll_messenger(value handler, value watcher);  

  value b_looper_looper_name(value name, value priority, value portCapacity);
  value b_looper_port_default_capacity(value unit);
  value b_looper_looper_archive(value archive, value deep);
  value b_looper_ (value looper);
  value b_looperForThread ();
  value b_looper_addCommonFilter();
  value b_looper_countLocks();
  value b_looper_isLocked();
  value b_looper_lockingThread();
  value b_looper_unlock();
  value b_looper_lockWithTimeout();
  value b_looper_lock(value looper);
  value b_looper_dispatchMessage();
  value b_looper_detachCurrentMessage();
  value b_looper_currentMessage(value looper);
  value b_looper_commonFilterList();
  value b_looper_indexOf();
  value b_looper_countHandlers();
  value b_looper_handlerAt();
  value b_looper_removeHandler();
  value b_looper_addHandler();
  value b_looper_setCommonFilterList();
  value b_looper_removeCommonFilter();
  value b_looper_run();
  value b_looper_quitRequested();
  value b_looper_quit();
  value b_looper_postMessage_handler_message_reply (value looper, value handler, value message, value replyHandler);
  value b_looper_postMessage_handler_message	   (value looper, value handler, value message);
  value b_looper_postMessage_handler_command_reply();
  value b_looper_postMessage_handler_command();
  value b_looper_postMessage_message(value looper, value message);
  value b_looper_postMessage_command();
  value b_looper_messageQueue();
  value b_looper_messageReceived();
  value b_looper_sem();
  value b_looper_countLockRequests();
  value b_looper_team();
  value b_looper_thread();
  value b_looper_preferredHandler();
  value b_looper_setPreferredHandler();                                                         

	value b_MessageFilter_MessageFilter_command(value self, value command);
	value b_MessageFilter_filter(value self, value message, value target);
	value b_MessageFilter_looper(value messageFilter);
}


OHandler::OHandler(value handler_ocaml, BHandler *handler) :
		Glue(handler_ocaml)
{
	BMessage *archive = new BMessage();
        handler->Archive(archive);
	Instantiate(archive);
}

OHandler::OHandler(value handler_ocaml, char *name) :
 	BHandler(name), Glue(handler_ocaml)
{
}

OHandler::OHandler(value handler_ocaml, BMessage *message) :
 	BHandler(message) ,Glue(handler_ocaml)
{
}

//******************************************************************************
class OMessageFilter : public BMessageFilter, public Glue 
{
	public :
			OMessageFilter(value self, uint32 command);
			filter_result Filter(BMessage *message, BHandler **target);
};

OMessageFilter::OMessageFilter(value self, uint32 command) :
	BMessageFilter(command), Glue(self)
{
}

filter_result OMessageFilter::Filter(BMessage *message, BHandler **target) {
//	CAMLparam1(((value)(*interne)));
	CAMLparam0();
	CAMLlocal3(caml_filter_res, caml_mess, caml_target);
	BHandler *t;
	filter_result result;
	
	t =*target;
	printf("appel de MessageFilter#Filter\n");

	caml_leave_blocking_section();
	
		caml_mess = caml_copy_int32((int32)message);
		caml_target = caml_copy_int32((int32)t);
	
		caml_filter_res = caml_callback2(*caml_named_value("MessageFilter#Filter"), 
									//*interne, 
									caml_mess, 
									caml_target);
	caml_enter_blocking_section();
	result = decode_filter_result(caml_filter_res);
	
	CAMLreturnT(enum filter_result, result);
}

/******************************************************************************/
filter_result decode_filter_result(value result){
	CAMLparam1(result);
	filter_result res;
	
	switch(Int_val(result)) {
		case 0 : res = B_SKIP_MESSAGE;
		case 1 : res = B_DISPATCH_MESSAGE;
	};
	
	CAMLreturnT(enum filter_result, res);
}

//**********************************
value encode_filter_result(filter_result val){
	CAMLparam0();
	CAMLlocal1(res);
	
	caml_leave_blocking_section();
	switch(val) {
		case B_SKIP_MESSAGE : res = Atom(0);
		case B_DISPATCH_MESSAGE : res = Atom(1);
	};

	caml_enter_blocking_section();
	
	CAMLreturn(res);
}

//--------
value b_handler_handler(value self, value unit) {
	CAMLparam2(self, unit);
	CAMLlocal1(handler);
  
	OHandler *ohandler_c;
	
       	caml_release_runtime_system(); 
	  	ohandler_c = new OHandler(self, (char *)NULL);
  	caml_acquire_runtime_system();
	printf("C 0x%lx : %lx\n", ohandler_c, sizeof(OHandler));
		
	handler = caml_copy_int32((int32)ohandler_c);
	
	CAMLreturn(handler);
}


//--------
value b_handler_handler_name(value self, value name) {

  CAMLparam2(self, name);
  CAMLlocal1(handler);
 
  OHandler *ohandler_c;
  caml_release_runtime_system();
	  ohandler_c = new OHandler(self, String_val(name));
  caml_acquire_runtime_system();
  printf("C 0x%lx : %lx\n", ohandler_c, sizeof(OHandler));
  
  handler = caml_copy_int32((value)ohandler_c);
  CAMLreturn(handler);

}

//--------
value b_handler_handler_message(value self, value message) {
	CAMLparam2(self, message);
	CAMLlocal1(handler);
	
	OHandler *ohandler_c;
	caml_release_runtime_system();
		ohandler_c = new OHandler(self, (BMessage *)Int32_val(message));
  	caml_acquire_runtime_system();
	printf("C 0x%lx : %lx\n", ohandler_c, sizeof(OHandler));
  
	handler = caml_copy_int32((value)ohandler_c);
	
	CAMLreturn(handler);
}

//-------  
value b_handler_(value handler) {
  CAMLparam1(handler);
  
  caml_leave_blocking_section();
	  ((OHandler *)Int32_val(handler))->BHandler::~BHandler();
  caml_enter_blocking_section();
  
  CAMLreturn(Val_unit);
}

//-----
value b_handler_archive(value handler, value archive, value deep){
  CAMLparam3(handler,archive,deep);
	CAMLlocal1(caml_archive);	  

  caml_leave_blocking_section();
	  caml_archive = caml_copy_int32(((OHandler *)Int32_val(handler))->
						  BHandler::Archive((BMessage *)Int32_val(archive), 
								  			Bool_val(deep)));
  caml_enter_blocking_section();
  CAMLreturn(caml_archive);
}

//------
value b_handler_instantiate(value archive_message) {
  CAMLparam1(archive_message);
  CAMLlocal1(caml_archivable);  
  
  caml_leave_blocking_section();
  	caml_archivable =caml_copy_int32((value)BHandler::Instantiate((BMessage *)Int32_val(archive_message)));
  caml_enter_blocking_section();

  CAMLreturn(caml_archivable);
}
//-------
value b_handler_getSupportedSuites(value handler, value message) {
  
  CAMLparam2(handler,message);
  CAMLlocal1(caml_status);

  caml_leave_blocking_section();
	  caml_status = caml_copy_int32(((OHandler *)Int32_val(handler))->BHandler::GetSupportedSuites((BMessage *)Int32_val(message)));
  caml_enter_blocking_section();
  
  CAMLreturn(caml_status);
}
//------
value b_handler_lockLooper(value handler) {

  CAMLparam1(handler);
  CAMLlocal1(resultat);
  
 CAMLreturn(Val_bool(((OHandler *)Int32_val(handler))->BHandler::LockLooper()));
}
//--------
value b_handler_lockLooperWithTimeout(value handler, value timeout){
  
  CAMLparam2(handler,timeout);
 
  CAMLreturn(Int32_val(((OHandler *)Int32_val(handler))->BHandler::LockLooperWithTimeout(Int64_val(timeout)))); 
}
//------
value b_handler_unlockLooper(value handler) {

  CAMLparam1(handler);
  
  ((OHandler *)Int32_val(handler))->BHandler::UnlockLooper();
  
  CAMLreturn(Val_unit);
}
//------
value b_handler_looper(value handler) {
  CAMLparam1(handler);
	CAMLlocal1(caml_looper);

	caml_leave_blocking_section();
		caml_looper = caml_copy_int32((int32)((OHandler *)Int32_val(handler))->BHandler::Looper());
	caml_enter_blocking_section();
	
  CAMLreturn(caml_looper);
}
//----
value b_handler_messageReceived(value handler, value message) {
 
  CAMLparam2(handler,message);
  
  ((OHandler *)Int32_val(handler))->BHandler::MessageReceived((BMessage *)Int32_val(message));

  CAMLreturn(Val_unit);
}


//------
value b_handler_resolveSpecifier_native(value handler, value message, value index, 
                                   		value specifier, value what, value property) {

CAMLparam5(handler,message,index,specifier,what);
CAMLxparam1(property);
CAMLlocal1(caml_specifier);

	caml_leave_blocking_section();
		caml_specifier = caml_copy_int32((value)((OHandler *)Int32_val(handler))->ResolveSpecifier(
     			  (BMessage *)(Int32_val(message)), 
                  Int32_val(index), 
     			  (BMessage *)(Int32_val(specifier)), 
                  Int32_val(what), 
                  String_val(property)));
	caml_enter_blocking_section();

	CAMLreturn(caml_specifier);

}


//*************************
value b_handler_resolveSpecifier_bytecode(value *argv, int argc) {

	return b_handler_resolveSpecifier_native(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]);
}

//------
value b_handler_setFilterList(value handler, value list){

	CAMLparam2(handler,list);

	((OHandler *)Int32_val(handler))->BHandler::SetFilterList((BList *)Int32_val(list));

	CAMLreturn(Val_unit);
}

//------
value b_handler_filterList(value handler) {
	CAMLparam1(handler);
	CAMLlocal1(caml_filter);

	caml_leave_blocking_section();
		caml_filter = caml_copy_int32((value)((OHandler *)Int32_val(handler))->BHandler::FilterList());
	caml_enter_blocking_section();
	
	CAMLreturn(caml_filter);
}

//---------
value b_handler_addFilter(value handler, value filter) {
  
  CAMLparam2(handler,filter);
  
  ((OHandler *)Int32_val(handler))->BHandler::AddFilter((BMessageFilter *)Int32_val(filter));
  
  CAMLreturn(Val_unit);
}
//---------
value b_handler_removeFilter(value handler, value filter) {
  
  CAMLparam2(handler,filter);
 
  CAMLreturn(Val_bool(((OHandler *)(handler))->BHandler::RemoveFilter((BMessageFilter *)Int32_val(filter))));
}
//--------
value b_handler_setName(value handler, value name){

  CAMLparam2(handler,name);
  
  ((OHandler *)Int32_val(handler))->BHandler::SetName(String_val(name));

  CAMLreturn(Val_unit);
}  
//--------
value b_handler_name(value handler, value unit){
  CAMLparam2(handler,unit);
  CAMLlocal1(caml_name);
	
 	caml_leave_blocking_section();
		caml_name = caml_copy_string((char *)((OHandler *)Int32_val(handler))->BHandler::Name());
	caml_enter_blocking_section();

	CAMLreturn(caml_name);
}
//---------
value b_handler_setNextHandler(value handler, value nextHandler){
  
  CAMLparam2(handler,nextHandler);

  ((OHandler *)Int32_val(handler))->BHandler::SetNextHandler((BHandler *)Int32_val(nextHandler));
  
  CAMLreturn(Val_unit);
}

//------
value b_handler_nextHandler(value handler, value unit){
  CAMLparam2(handler,unit);
   
  CAMLreturn(copy_int32((value)((OHandler *)Int32_val(handler))->BHandler::NextHandler()));
}

//-------
value b_handler_startWatching_handler(value handler, value watcher, value what) {
 
  CAMLparam3(handler,watcher,what);
  
  CAMLreturn(copy_int32(((OHandler *)Int32_val(handler))->BHandler::StartWatching((BHandler *)Int32_val(watcher), Int32_val(what))));
}

//-------
value b_handler_startWatching_messenger(value handler, value watcher, value what) {
 
  CAMLparam3(handler,watcher,what);
  
  CAMLreturn(copy_int32(((OHandler *)Int32_val(handler))->BHandler::StartWatching(*(BMessenger *)Int32_val(watcher), Int32_val(what))));
}

//-------
value b_handler_startWatchingAll_handler(value handler, value watcher) {
  
  CAMLparam2(handler,watcher);
  
  CAMLreturn(copy_int32(((OHandler *)Int32_val(handler))->BHandler::StartWatchingAll((BHandler *)Int32_val(watcher))));
}

//-------
value b_handler_startWatchingAll_messenger(value handler, value watcher) {
  CAMLparam2(handler,watcher);
  
  CAMLreturn(copy_int32(((OHandler *)Int32_val(handler))->BHandler::StartWatchingAll(*(BMessenger *)Int32_val(watcher))));
}

//-------
value b_handler_stopWatching_handler(value handler, value watcher, value what) {
  CAMLparam3(handler,watcher,what);
  
  CAMLreturn(copy_int32(((OHandler *)Int32_val(handler))->BHandler::StopWatching((BHandler *)Int32_val(watcher), Int32_val(what))));
}

//-------
value b_handler_stopWatching_messenger(value handler, value watcher, value what) {
  CAMLparam3(handler,watcher,what);
  
  CAMLreturn(copy_int32(((OHandler *)Int32_val(handler))->BHandler::StopWatching(*(BMessenger *)Int32_val(watcher), Int32_val(what))));
}

//-------
value b_handler_stopWatchingAll_handler(value handler, value watcher) {
  CAMLparam2(handler,watcher);
  
  CAMLreturn(copy_int32(((OHandler *)Int32_val(handler))->BHandler::StopWatchingAll((BHandler *)Int32_val(watcher))));
}

//-------
value b_handler_stopWatchingAll_messenger(value handler, value watcher) {
  CAMLparam2(handler,watcher);
  
  CAMLreturn(copy_int32(((OHandler *)Int32_val(handler))->BHandler::StopWatchingAll(*(BMessenger *)Int32_val(watcher))));
}

//-------
value b_looper_looper_name(value name, value priority, value portCapacity) {
printf("b_looper_looper_name non implemente.\n");
}

//-------
value b_looper_port_default_capacity(value unit){
	CAMLparam1(unit);

	CAMLreturn(copy_int32(B_LOOPER_PORT_DEFAULT_CAPACITY));
}

//-------
value b_looper_looper_archive(value archive, value deep){
printf("b_looper_looper_archive non implemente.\n");
}

//-------
value b_looper_ (value looper) {
printf("b_looper_ non implemente.\n");
}
//-------
value b_looperForThread () {
printf("b_looperForThread non implemente.\n");
}

value b_looper_addCommonFilter() {
printf("b_looper_addCommonFilter non implemente.\n");
}

value b_looper_countLocks(){
printf("b_looper_countLocks non implemente.\n");
}

value b_looper_isLocked(){
printf("b_looper_isLocked non implemente.\n");
}

value b_looper_lockingThread(){
printf("b_looper_lockingThread non implemente.\n");
}

//******************
value b_looper_unlock(value looper){
	CAMLparam1(looper);

	((BLooper *)Int32_val(looper))->Unlock();

	CAMLreturn(Val_unit);
}

//***************
value b_looper_lockWithTimeout(){
}

//************************
value b_looper_lock(value looper){
	CAMLparam1(looper);
	CAMLlocal1(res_caml);

	//**acquire_sem(ocaml_sem);
		res_caml = Val_bool(((BLooper *)Int32_val(looper))->Lock());
	//**release_sem(ocaml_sem);
	
	CAMLreturn(res_caml);
}

value b_looper_dispatchMessage(){}
value b_looper_detachCurrentMessage(){}

//********************************
value b_looper_currentMessage(value looper){
	CAMLparam1(looper);
	CAMLlocal1(message);

	message = alloc(1, Abstract_tag);

	Store_field(message, 1, (value)((BLooper *)Int32_val(looper))->CurrentMessage());

	CAMLreturn(message);
	
}


value b_looper_commonFilterList(){}
value b_looper_indexOf(){}
value b_looper_countHandlers(){}
value b_looper_handlerAt(){}
value b_looper_removeHandler(){}
value b_looper_addHandler(){}
value b_looper_setCommonFilterList(){}
value b_looper_removeCommonFilter(){}
value b_looper_run(){}
value b_looper_quitRequested(){}
value b_looper_quit(){}

//***********************************
value b_looper_postMessage_handler_message_reply(value looper, value handler, value message, value replyHandler){	
	CAMLparam4(looper, handler, message, replyHandler);

	CAMLreturn(copy_int32(
	((BLooper *)Int32_val(looper))->BLooper::PostMessage((BMessage *)Int32_val(message),
														 (OHandler *)Int32_val(handler),
														 (OHandler *)Int32_val(replyHandler)								
											   )
	));
}

//*********************************
value b_looper_postMessage_handler_message(value looper, value handler, value message){
	CAMLparam3(looper, handler, message);

	CAMLreturn(copy_int32(
	((BLooper *)Int32_val(looper))->BLooper::PostMessage((BMessage *)Int32_val(message),								
														 (BHandler *)Int32_val(handler))
	));
}

value b_looper_postMessage_handler_command_reply(){}
value b_looper_postMessage_handler_command(){}

//*******************
value b_looper_postMessage_message(value looper, value message){
	CAMLparam2(looper, message);

	CAMLreturn(copy_int32(
		((BLooper *)Int32_val(looper))->PostMessage((BMessage *)Int32_val(message))
	));

}

value b_looper_postMessage_command(){}
value b_looper_messageQueue(){}
value b_looper_messageReceived(){}
value b_looper_sem(){}
value b_looper_countLockRequests(){}
value b_looper_team(){}
value b_looper_thread(){}
value b_looper_preferredHandler(){}
value b_looper_setPreferredHandler(){}

//***************************
value b_MessageFilter_MessageFilter_command(value self, value command){
	CAMLparam2(self, command);
	
	OMessageFilter *mf;
	caml_release_runtime_system();
		mf = new OMessageFilter(self, Int32_val(command));
	caml_acquire_runtime_system();
	printf("C 0x%lx : %lx\n", mf, sizeof(OMessageFilter));
	
	CAMLreturn(copy_int32((int32)mf));
}

//***************************************
value b_MessageFilter_filter(value messageFilter, value message, value target){
	CAMLparam3(messageFilter, message, target);
	filter_result res ;
	BMessageFilter *mf = (BMessageFilter *)Int32_val(messageFilter);
	BMessage *mes = (BMessage *)Int32_val(message);
	
	BHandler *cible;
	cible = ((BHandler *)Int32_val(target));
	
	res = mf->BMessageFilter::Filter(mes, &cible);
	CAMLreturn(encode_filter_result(res));
}

//**************************************
value b_MessageFilter_looper(value messageFilter) {
	CAMLparam1(messageFilter);

	CAMLreturn(copy_int32((int32)
							((BMessageFilter *)Int32_val(messageFilter))->BMessageFilter::Looper()
							
							));
}
