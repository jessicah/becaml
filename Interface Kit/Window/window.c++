
#include <stdio.h>
#include <string.h>

#ifndef BEOS
#define BEOS
#endif

#include "mlvalues.h"
#include "memory.h"
#include "alloc.h"
#include "callback.h"
#include "signals.h"
#include "threads.h"

#include <ClassInfo.h>
#include <Message.h>
#include <Window.h>

#include "glue.h"
#include "handler.h"
#include "message.h"
#include "point_rect.h"
#include "view.h"

//extern sem_id callback_sem;
extern sem_id ocaml_sem;
extern thread_id beos_thread;

class OWindow :public BWindow , public Glue{
	public:

		OWindow(value objet, BRect frame, const char *title, window_type type, uint32 flags, 
				int32 workspaces):
			BWindow(frame, title, type, flags, workspaces), 
			Glue(objet){}
		~OWindow(){
			printf("[C++] destruction de OWindow 0x%lx\n", this);fflush(stdout);

		}
//		void AddChild(BView *aView, BView *sibling = NULL);
		BView *CurrentFocus();
		
//		virtual void DispatchMessage(BMessage *message, BHandler *target);

		void MenusBeginning(); 		

		void MessageReceived(BMessage *message); 		
		status_t PostMessage(BMessage *message, BHandler *handler, BHandler *replyHandler=NULL);
		status_t PostMessage(BMessage *message);
		status_t PostMessage(uint32 command);
			
		bool QuitRequested(); 
		void Quit();
#ifdef __HAIKU__
		void SetLayout(BLayout* layout);
#endif
		void Show();
		
		void UpdateIfNeeded(); 
	
		void WindowActivated(bool active);
		
};

/*////////////////////////////////
void OWindow::AddChild(BView *aView, BView *sibling = NULL){
	CAMLparam1(interne);
	
	if (sibling == NULL) 
		caml_callback2(*caml_named_value("OWindow::AddChild"), interne, caml_copy_int32((value)aView));
	else 
		caml_callback3(*caml_named_value("OWindow::AddChild_sibling"), interne, caml_copy_int32((value)aView),
																		   caml_copy_int32((value)sibling));
	CAMLreturn0;
}
*/
////////////////////////////////
BView *OWindow::CurrentFocus() {
	return BWindow::CurrentFocus();
}


/*virtual void OWindow::DispatchMessage(BMessage *message, BHandler *target){
	CAMLparam1(interne);
	BMessage *m;
	m = new BMessage(*message);
	
	switch(message->what) {
			case B_MOUSE_MOVED : printf("Owindow : envoi de MOUSE_MOVED(0x%lx) a %s.\n", message,target->Name());
								 message->PrintToStream();
	}
	printf("Owindow : dispatch message to %s, de classe %s.\n", target->Name(), class_name(target));
	BWindow::DispatchMessage(m, target);
	printf("Owindow : apres dispatch message to %s, de classe %s.\n", target->Name(), class_name(target));
	
	CAMLreturn0;
}
*/

//**********************
void OWindow::MenusBeginning(){
	//CAMLparam1(interne);
	//**acquire_sem(ocaml_sem);
	CAMLparam0();
	CAMLlocal1( fun);
	//caml_c_thread_register();	
	//**release_sem(ocaml_sem);
	caml_acquire_runtime_system();
//		//**acquire_sem(callback_sem);
		fun = caml_get_public_method(interne, hash_variant("menusBeginning"));
			caml_callback2(fun, interne, Val_unit);
//		//**release_sem(callback_sem);
	caml_release_runtime_system();	
	CAMLreturn0;
}

//************************************
void OWindow::MessageReceived(BMessage *message) {
	//**acquire_sem(ocaml_sem);
	CAMLparam0();
	CAMLlocal3(p_message, ocaml_message, fun);
	//caml_c_thread_register();
	
	printf("[C] OWindow::MessageReceived\n");fflush(stdout);
	caml_acquire_runtime_system();
//		caml_register_global_root(&win_caml);
//		caml_register_global_root(&mess_caml);
//		caml_register_global_root(&fun);

		//**release_sem(ocaml_sem);
		//**acquire_sem(ocaml_sem);
		printf("OWindow::MessageReceived(%c%c%c%c)\n",
						message->what >> 24, 
						message->what >>16, 
						message->what >> 8,
						message->what);fflush(stdout);
		//caml_leave_blocking_section();
		//mess_caml = caml_copy_int32((int32)message);
		//win_caml  = caml_copy_int32((int32)this);	
		p_message = alloc_small(1,Abstract_tag);
		caml_register_global_root(&p_message); //TODO unregister

		
		ocaml_message = caml_callback(*caml_named_value("new_be_message"), p_message);
		caml_register_global_root(&ocaml_message);//TODO unregister 
	caml_release_runtime_system();
		OMessage *omessage = new OMessage(ocaml_message,message);
	caml_acquire_runtime_system();	
		Field(p_message,0) = (value)omessage;
		fun = caml_get_public_method(interne, hash_variant("messageReceived"));
		caml_callback2(fun, interne, ocaml_message);
	//caml_enter_blocking_section();		
	caml_release_runtime_system();
		//**release_sem(ocaml_sem);
		CAMLreturn0;
}

//************************************
status_t OWindow::PostMessage(BMessage *message, BHandler *handler, BHandler *replyHandler=NULL){
//**acquire_sem(ocaml_sem);
	CAMLparam0();
	CAMLlocal3(v, res_caml, fun);
	CAMLlocalN(argv, 4);
	//caml_c_thread_register();
	
	caml_register_global_root(&v);
	caml_register_global_root(&fun);
	caml_register_global_root(&res_caml);
	caml_register_global_root(&(argv[0]));
	caml_register_global_root(&(argv[1]));
	caml_register_global_root(&(argv[2]));
	caml_register_global_root(&(argv[3]));
	
	//**release_sem(ocaml_sem);
	
	BMessage *m;
	status_t res;
	m = new BMessage(*message);
	
	caml_leave_blocking_section();
	
		v = caml_copy_int32((uint32)m);
				
		argv[0] = caml_copy_int32((int32)this);
		argv[1] = caml_copy_int32((int32)m);
		argv[2] = caml_copy_int32((int32)handler);
		argv[3] = caml_copy_int32((int32)replyHandler);
		
		fun = *caml_named_value("Owindow::postMessage_message_handler");
			res_caml = caml_callbackN(fun, 4, argv);
//		//**release_sem(callback_sem);
		res = Int32_val(res_caml);
	caml_enter_blocking_section();
			
	CAMLreturn(res);
}

status_t OWindow::PostMessage(uint32 command){
	//**acquire_sem(ocaml_sem);
	CAMLparam0();
	CAMLlocal4(win_caml, command_caml, res_caml, fun);
	//caml_c_thread_register();	
	printf("[C] OWindow::PostMessage\n");fflush(stdout);
	caml_acquire_runtime_system();
		caml_register_global_root(&win_caml);
		caml_register_global_root(&command_caml);
		caml_register_global_root(&res_caml);
		caml_register_global_root(&fun);
	caml_release_runtime_system();	
	//**release_sem(ocaml_sem);
	
	BMessage *m;
	status_t res;
	
	m = new BMessage(command);
			
	caml_acquire_runtime_system();
		win_caml = caml_copy_int32((int32)this);
		command_caml = caml_copy_int32(command);
		res_caml = caml_callback2(fun, win_caml, command_caml);
		res = Int32_val(res_caml);
	caml_release_runtime_system();
	
	CAMLreturn(res);
}

status_t OWindow::PostMessage(BMessage *message){
	//CAMLparam1(interne);
	//**acquire_sem(ocaml_sem);
	CAMLparam0();
	CAMLlocal4(win_caml, mes_caml, res_caml, fun);
	//caml_c_thread_register();	
	caml_acquire_runtime_system();
		caml_register_global_root(&win_caml);
		caml_register_global_root(&mes_caml);
		caml_register_global_root(&res_caml);
		caml_register_global_root(&fun);
	caml_release_runtime_system();
	//**release_sem(ocaml_sem);
	
	BMessage *m;
	status_t res;
	
	m = new BMessage(*message);
	
	//**acquire_sem(ocaml_sem);
	caml_acquire_runtime_system();
		win_caml = caml_copy_int32((int32)this);
		mes_caml = caml_copy_int32((int32)m);
		fun = *caml_named_value("OWindow::postMessage_message");
		res_caml = caml_callback2(fun, win_caml, mes_caml);
		res = Int32_val(res_caml);
	caml_release_runtime_system();
	//**release_sem(ocaml_sem);

	CAMLreturn(res);
}

bool OWindow::QuitRequested() {
//			CAMLparam1(interne);
	//**acquire_sem(ocaml_sem);
	CAMLparam0();
	CAMLlocal3(win_caml, res_caml, fun);
	//caml_c_thread_register();
	//**release_sem(ocaml_sem);
	
	OWindow *owin;
	bool res;

	//**acquire_sem(ocaml_sem);
	caml_acquire_runtime_system();
		printf("[C++]OWindow::QuitRequested, appel de caml_named_value(\"OWindow::QuitRequested\")\n");fflush(stdout);
		res = caml_callback2(caml_get_public_method(interne,hash_variant("quitRequested")), interne, Val_unit);
		printf("[C++]OWindow::QuitRequested, retour de caml_named_value(\"OWindow::QuitRequested\")\n");fflush(stdout);
		res_caml = Val_bool(res);
	caml_release_runtime_system();
	//**release_sem(ocaml_sem);
			
	CAMLreturn(res_caml);
}

void OWindow::Quit() {
	//**acquire_sem(ocaml_sem);
		CAMLparam0();
		CAMLlocal2(win_caml, fun);
	//caml_c_thread_register();	
		
		
		caml_acquire_runtime_system();
			caml_callback2(caml_get_public_method(interne,hash_variant("quit")), interne, Val_unit);
		caml_release_runtime_system();
	//**release_sem(ocaml_sem);
	CAMLreturn0;
}

#ifdef __HAIKU__

void OWindow::SetLayout(BLayout* layout) {
}

#endif

void OWindow::Show() {
//	CAMLparam1(interne);
	CAMLparam0();
	CAMLlocal1(win_caml);
	//caml_c_thread_register();	
	printf("[C++]OWindow#Show\n");fflush(stdout);
	caml_acquire_runtime_system();
		////**acquire_sem(callback_sem);
		caml_callback(caml_get_public_method(interne, hash_variant("show")), interne);
		////**release_sem(callback_sem);
	caml_release_runtime_system ();
	CAMLreturn0;
}
		
void OWindow::UpdateIfNeeded() {
			printf("OWindow->UpdateIfNeeded appele.\n");
			BWindow::UpdateIfNeeded();
}
	
void OWindow::WindowActivated(bool active){
			BWindow::WindowActivated(active);
}
		
extern "C" {

	value b_not_movable(value unit);
	value b_not_resizable(value unit);
	value b_not_zoomable(value unit);
	value b_not_minimizable(value unit);
	value b_asynchronous_controls(value unit);
	value b_current_workspace(value unit);

	value b_window_type_native(value self, value frame, value title, value type, 
					value flags, value workspaces);
	value b_window_type_bytecode(value *argv, int argn);
//	value b_window(value w);
	value b_window_look_feel();
	value b_window_activate(value window, value flag);
//	value b_window_addChild_sibling();
	value b_window_addChild_view(value window, value aView);
	value b_window_bounds(value unit);
	value b_window_currentFocus(value window);
	value b_window_currentMessage(value window);
	value b_window_instantiate();
	value b_window_isActive();
	value b_window_menusBeginning(value window);
	value b_window_messageReceived(value window, value message);
	value b_window_postMessage_handler_message_reply(value window, value handler, value message, value replyHandler);
	value b_window_postMessage_handler_message(value window, value handler, value message);
	value b_window_postMessage_handler_command_reply();
	value b_window_postMessage_handler_command();
	value b_window_postMessage_message(value window, value message);
	value b_window_postMessage_command();	
	value b_window_quit(value window);
	value b_window_quitRequested(value window);
	value b_window_removeChild(value window, value aView);
	value b_window_resizeTo(value window, value width, value height);
	value b_window_setTitle(value window, value title);
	value b_window_show(value window);
	value b_window_title(value window);
	value b_window_type();
	value b_window_windowActivated();
	window_type decode_type(int type);
}

window_type decode_type(int type) {
	switch(type) {
		case 0 : return B_TITLED_WINDOW;
				 break;
		case 1 : return B_DOCUMENT_WINDOW;
				 break;
		case 2 : return B_MODAL_WINDOW;
				 break;
		case 3 : return B_FLOATING_WINDOW;
				 break;
		case 4 : return B_BORDERED_WINDOW;
				 break;
		case 5 : return B_UNTYPED_WINDOW;
				 break;
	}
}

//**************************
value b_not_movable(value unit) {
CAMLparam1(unit);

CAMLreturn(caml_copy_int32(B_NOT_MOVABLE));

}

//**************************
value b_not_resizable(value unit) {
CAMLparam1(unit);

CAMLreturn(caml_copy_int32(B_NOT_RESIZABLE));

}

//**************************
value b_not_zoomable(value unit) {
CAMLparam1(unit);

CAMLreturn(caml_copy_int32(B_NOT_ZOOMABLE));

}

//**************************
value b_not_minimizable(value unit) {
CAMLparam1(unit);

CAMLreturn(caml_copy_int32(B_NOT_MINIMIZABLE));

}

//**************************
value b_asynchronous_controls(value unit) {
	CAMLparam1(unit);

	CAMLreturn(caml_copy_int32(B_ASYNCHRONOUS_CONTROLS));
}

//**************************
value b_current_workspace(value unit) {
CAMLparam1(unit);

CAMLreturn(caml_copy_int32(B_CURRENT_WORKSPACE));

}

//***************************
value b_window_type_native (value objet, value frame, value title, value type, value flags, value workspaces){
	CAMLparam5(objet, frame, title, type, flags);
	CAMLxparam1(workspaces);
	CAMLlocal1(w);
	OWindow *win;
	BRect r;
	uint32 f;
	uint32 worksp;
	char c_title[caml_string_length(title)];
	
	
	strcpy(c_title, String_val(title));
//	printf("[C] b_window_type_native : title size = %d", caml_string_length(title));fflush(stdout);
	
	//register_global_root(&w);
	
	r = *(ORect *)Field(frame,0); 
	f = Int32_val(flags);
	worksp = Int32_val(workspaces);
	
	caml_release_runtime_system();
		win = new OWindow(objet,
				  r,
				  c_title,
				  decode_type(Int_val(type)),
				  f, 
				  worksp);
		printf("[C] b_window_type_native : OWindow = 0x%lX\n", (int32)win);fflush(stdout);
	caml_acquire_runtime_system();
	w = alloc_small(1, Abstract_tag);
	Field(w,0) = (value) win;

	CAMLreturn(w);
}

value b_window_type_bytecode(value *argv, int argc) {
	b_window_type_native(argv[0],argv[1],argv[2],argv[3],argv[4],argv[5]);
} 
value b_window_quit(value window) {
	////**acquire_sem(ocaml_sem);
	CAMLparam1(window);
	////**release_sem(ocaml_sem);

	OWindow * win;
	win = (OWindow *)Field(window,0);
	
	//**release_sem(ocaml_sem);
	caml_enter_blocking_section();
		win->BWindow::Quit();
		//code below won't be reached !!!
	caml_leave_blocking_section();
		
	CAMLreturn(Val_unit);
}

//***************
value b_window_quitRequested(value window) {
	////**acquire_sem(ocaml_sem);
		CAMLparam1(window);
		CAMLlocal1(res_caml);
	////**release_sem(ocaml_sem);
	OWindow *owin;
	bool res;
	owin = (OWindow *)Field(window,0);
	printf("[C++] appel de b_window_quitRequested (OWindow =0x%lx\n",owin);fflush(stdout);
	caml_release_runtime_system();
		res = owin->BWindow::QuitRequested();
	caml_acquire_runtime_system();
	////**acquire_sem(ocaml_sem);
//	caml_leave_blocking_section();
		res_caml = Val_bool(res);
//	caml_enter_blocking_section();
//	//**release_sem(ocaml_sem);
	CAMLreturn(res_caml);

}


//----------
value b_window_show(value window){
 	CAMLparam1(window);
	OWindow *owindow;

	owindow = (OWindow *)(Field(window,0));

	caml_release_runtime_system();
		owindow->BWindow::Show();
 	caml_acquire_runtime_system();
	CAMLreturn(Val_unit);
}

//----------
value b_window_bounds(value window) {
	CAMLparam1(window);
	CAMLlocal2(p_rect, ocaml_rect);
	
	p_rect = alloc_small(1,Abstract_tag);
	caml_register_global_root(&p_rect); //TODO unregister

	ocaml_rect = callback(*caml_named_value("new_be_rect"), p_rect);
	caml_register_global_root(&ocaml_rect);//TODO unregister

	caml_release_runtime_system();
		ORect *r = new ORect(ocaml_rect, (((OWindow *)(Field(window,0)))->Bounds()));
	caml_acquire_runtime_system();
	////**acquire_sem(ocaml_sem);
	//caml_leave_blocking_section();
	Field(p_rect,0) = (value)r;
	// 	caml_enter_blocking_section();
//	//**release_sem(ocaml_sem);
	
	CAMLreturn(p_rect);
}

value b_window_removeChild(value window, value aView){
	CAMLparam2(window, aView);
	BWindow *bwin = ((BWindow *)Int32_val(window));
	BView * bview = ((BView *)Int32_val(aView));
	
	CAMLreturn(Val_bool(bwin->BWindow::RemoveChild(bview)));
}

value b_window_addChild_sibling(){
printf("b_window_addChild_sibling non implemente.\n");
}

//******************
value b_window_addChild_view(value window, value aView){
	CAMLparam2(window, aView);
	BWindow *bwin;
	BView * bview;
	
	bwin = ((OWindow *)Field(window,0));
	bview = ((BView *)Field(aView,0));

	caml_release_runtime_system();	
		bwin->BWindow::AddChild(bview);
	caml_acquire_runtime_system();
	CAMLreturn(Val_unit);
}

//****************************
value b_window_currentFocus(value window) {
	CAMLparam1(window);
	CAMLlocal1(view);

	//**acquire_sem(ocaml_sem);
	caml_leave_blocking_section();
		view = caml_copy_int32((value)(((BWindow *)Int32_val(window))->CurrentFocus()));
	caml_enter_blocking_section();
	//**release_sem(ocaml_sem);
	
	CAMLreturn(view);
}

//************************
value b_window_currentMessage(value window) {
	CAMLparam1(window);
	CAMLlocal1(message);

	//**acquire_sem(ocaml_sem);
	caml_leave_blocking_section();
		message = caml_copy_int32((value)(((BWindow *)Int32_val(window))->CurrentMessage()));
	caml_enter_blocking_section();
	//**release_sem(ocaml_sem);
	
	CAMLreturn(message);
}

//***********************************
value b_window_postMessage_handler_message_reply(value window, value handler, value message, value replyHandler){	
	CAMLparam4(window, handler, message, replyHandler);

	CAMLreturn(caml_copy_int32(
	((BWindow *)Int32_val(window))->BWindow::PostMessage((BMessage *)Int32_val(message),
														 (BHandler *)Int32_val(handler),
														 (BHandler *)Int32_val(replyHandler)								
											   )
	));
}

//*********************************
value b_window_postMessage_handler_message(value window, value handler, value message){
	CAMLparam3(window, handler, message);
	CAMLlocal1(caml_status);
	status_t status;

	OWindow *w = (OWindow *)Field(window,0);
	OMessage *m = (OMessage *)Field(message,0);
	OHandler *h = (OHandler *)Field(handler,0);
	
	caml_release_runtime_system();
		status = w->BWindow::PostMessage(m,h);
	caml_acquire_runtime_system();

	caml_status = caml_copy_int32(status);

	CAMLreturn(caml_status);
}

value b_window_postMessage_handler_command_reply(){
printf("b_window_postMessage_handler_command_reply non implemente");fflush(stdout);
}
value b_window_postMessage_handler_command(){}

//*******************
value b_window_postMessage_message(value window, value message){
	CAMLparam2(window, message);
	CAMLlocal1(res_caml);
	status_t res;
	BMessage *m;
	OWindow *w;

	m = (OMessage *)Field(message,0);
	w = (OWindow *)Field(window,0);
	
	printf("appel de b_window_postMessage_message what = %c%c%c%c.\n",
					m->what >> 24, 
					m->what >>16, 
					m->what >> 8,
					m->what  );fflush(stdout);
		
	caml_release_runtime_system();
		res =	w->BWindow::PostMessage(m);
	caml_acquire_runtime_system();
	
	res_caml = caml_copy_int32(res);
	
	CAMLreturn(res_caml);

}

value b_window_postMessage_command(value window, value command){
		CAMLparam2(window, command);
		CAMLreturn(caml_copy_int32(
			((BWindow *)Int32_val(window))->BWindow::PostMessage(Int32_val(command))
		));
}

//***********************
value b_window_title(value window) {
	CAMLparam1(window);
	
	CAMLreturn(caml_copy_string(((BWindow *)Int32_val(window))->Title()));
}

//*****************************
value b_window_resizeTo(value window, value width, value height){
	CAMLparam3(window, width, height);

	((BWindow *)Int32_val(window))->BWindow::ResizeTo(Double_val(width), Double_val(height));
	
	CAMLreturn(Val_unit);

}

//**********************
value b_window_setTitle(value window, value title) {
	CAMLparam2(window, title);

	((BWindow *)Int32_val(window))->SetTitle(String_val(title));
	CAMLreturn(Val_unit);
}

//************************
value b_window_menusBeginning(value window) {
	CAMLparam1(window);

	((BWindow *)Int32_val(window))->BWindow::MenusBeginning();
	
	CAMLreturn(Val_unit);
}

//************************
value b_window_messageReceived(value window, value message) {
	CAMLparam2(window, message);

	((BWindow *)Int32_val(window))->BWindow::MessageReceived((BMessage *)Int32_val(message));
	
	CAMLreturn(Val_unit);
}

value b_window_updateIfNeeded(value window){
	CAMLparam1(window);

	((BWindow *)Int32_val(window))->BWindow::UpdateIfNeeded();
	
	CAMLreturn(Val_unit);
}

//**********************
value b_window_windowActivated(){
printf("b_window_windowActivated non implemente.\n");
}
value b_window_isActive(){
printf("b_window_isActive non implemente.\n");
}

//**************************
value b_window_activate(value window, value flag){
	CAMLparam2(window, flag);
	
	((BWindow *)Int32_val(window))->BWindow::Activate(Bool_val(flag));

	CAMLreturn(Val_unit);
}

value b_window_instantiate(){
printf("b_window_instantiate non implemente.\n");
}
value b_window_type(){
printf("b_window_type non implemente.\n");
}
value b_window_look_feel(){
printf("b_window_look_feel non implemente.\n");
}
