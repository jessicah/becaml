#ifndef BEOS
	#define BEOS
#endif

#include <Message.h>
#include <StringView.h>
#include <stdio.h>

#include "alloc.h"
#include "callback.h"
#include "memory.h"
#include "mlvalues.h"
#include "signals.h"

#include "glue.h"
#include "view.h"

extern "C" {
	extern sem_id ocaml_sem;
	value b_stringView_stringview_bytecode(value *argv, int argn);
	value b_stringView_stringview_native(//value self, 
										 value bounds, 
										 value name, 
										 value text, 
										 value resize_flags, 
										 value flags);
	value b_stringView_allAttached(value stringView);
	value b_stringView_attachedToWindow(value stringView);
	value b_stringView_draw(value stringView, value updateRect);
}

class OStringView : public BStringView, public Glue {
		public :
		OStringView(/*value self,*/ BRect frame, const char *name, const char *text, uint32 resizingMode, uint32 flags) :
			BStringView(frame, name, text, resizingMode, flags),
			Glue(/*self*/) {
//			CAMLparam1(self);
			printf("appel de OStringView->OStringView.\n");
//			CAMLreturn0;
		};
		void AllAttached();
		void AttachedToWindow();
//		void Draw(BRect updateRect);
//		void MessageReceived(BMessage *message);
		virtual void MouseMoved(BPoint pt, uint32 code, const BMessage *msg);
//		void WindowActivated(bool active);

};

//******************************
void OStringView::AllAttached(){
	CAMLparam0();
		printf("OStringView::AllAttached appele.\n");fflush(stdout);
		caml_leave_blocking_section();
			callback(*caml_named_value("OStringView::allAttached"), copy_int32((int32)this)/* *interne*/);
		caml_enter_blocking_section();
	CAMLreturn0;
		
}

//*******************************
void OStringView::AttachedToWindow(){
	printf("OStringView::AttachedToWindow appele.\n");fflush(stdout);
	BStringView::AttachedToWindow();
}

/****************************
void OStringView::Draw(BRect updateRect) {
	CAMLparam1(interne);
	BRect *rect = new BRect(updateRect);
	
	printf("OStringView::Draw de %s appele.\n", Name());
	callback2(*caml_named_value("OStringView#draw"), interne, copy_int32((value)rect));

	CAMLreturn0;
}
*/
/*
void OStringView::MessageReceived(BMessage *message) {
//	CAMLparam0();
	CAMLparam1(interne);
//	CAMLlocal1(ocaml_message);
//	register_global_root(&ocaml_message);
	printf("OStringView->MessageReceived appele.\n");
	
	BMessage *m;
	
	m = new BMessage(*message);
	
	//register_global_root((value *)&m);
	
//	ocaml_message = copy_int32((value)m);
	
	callback2(*caml_named_value("OStringView::messageReceived"), interne, copy_int32((value)m));

//	remove_global_root(&ocaml_message);
	//remove_global_root((value *)&m);
	
	CAMLreturn0;
}
*/
//****************************
void OStringView::MouseMoved(BPoint pt, uint32 code, const BMessage *msg){
//	CAMLparam1(interne);
	CAMLparam0();
	
	printf("OStringView::MouseMoved appele.\n");
	BStringView::MouseMoved(pt, code, msg);
	
	CAMLreturn0;
}

/*****************************
void OStringView::WindowActivated(bool active){
	CAMLparam1(interne);

	printf("OStringView::WindowActivated appele.\n");
	BStringView::WindowActivated(active);

	CAMLreturn0;
}
*/
//****************
value b_stringView_stringview_native(//value self, 
									 value bounds, 
									 value name, 
									 value text, 
									 value resize_flags, 
									 value flags) {
	CAMLparam5(/*self,*/ bounds, name, text, resize_flags, flags);
	//CAMLxparam1(flags);
	
	OStringView *osv;
	
	osv = new OStringView(//self,
						  *((BRect *)Int32_val(bounds)),
						  String_val(name),
						  String_val(text),
						  Int32_val(resize_flags),
						  Int32_val(flags));

	CAMLreturn(copy_int32((int32)osv));
}

//************************
value b_stringView_stringview_bytecode(value * argv, int argn) {

	return(b_stringView_stringview_native(argv[0], argv[1], argv[2], argv[3], argv[4]/*, argv[5]*/));
}

//***********************
value b_stringView_allAttached(value stringView){
	CAMLparam1(stringView);
	printf("b_stringview_allAttached appele.\n");
	
	((BStringView *)Int32_val(stringView))->BStringView::AllAttached();	
	
	CAMLreturn(Val_unit);
}

//*************************
value b_stringView_attachedToWindow(value stringView){
	CAMLparam1(stringView);
	printf("b_stringview_attachedToWindow appele.\n");
	
	((BStringView *)Int32_val(stringView))->BStringView::AttachedToWindow();	
	
	CAMLreturn(Val_unit);
}

//****************************
value b_stringView_draw(value stringView, value updateRect){
	CAMLparam2(stringView, updateRect);

	((BStringView *)Int32_val(stringView))->BStringView::Draw(*(BRect *)Int32_val(updateRect));	
	
	CAMLreturn(Val_unit);
}

