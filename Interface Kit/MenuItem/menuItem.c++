#ifndef BEOS
	#define BEOS
#endif

#include <MenuItem.h>
#include <stdio.h>

#include "alloc.h"
#include "callback.h"
#include "memory.h"
#include "signals.h"

#include "glue.h"

extern "C" {
//	extern sem_id callback_sem;
	extern sem_id ocaml_sem;
//	extern thread_id beos_thread;
	value b_menuItem_menuItem(/*value self,*/ value label, value message, value shortcut, value modifiers);
	value b_menuItem_draw(value menuItem);
	value b_menuItem_frame(value menuItem);
	value b_menuItem_getContentSize_prot(value menuItem, value width, value height);
	value b_menuItem_invoke(value menuItem);
	value b_menuItem_invoke_message(value menuItem, value message);
	value b_menuItem_isMarked(value menuItem);
	value b_menuItem_isSelected(value menuItem);
	value b_menuItem_label(value menuItem);
	value b_menuItem_menu(value menuItem);
	value b_menuItem_setEnabled(value menuItem, value enabled);
	value b_menuItem_setMarked(value menuItem, value flag);
	value b_menuItem_setTarget(value menuItem, value handler);
	value b_menuItem_setTarget_looper(value menuItem, value handler, value looper);

	value b_separatorItem_separatorItem(value unit);
}

class OMenuItem : public BMenuItem//, public Glue 
{
	public :
			OMenuItem(/*value self,*/ char *label, BMessage *message, char shortcut, uint32 modifiers);
			~OMenuItem(){
				b_glue_remove(this);
			}
			void Draw(void);
			void Draw2();
			void GetContentSize(float *width, float *height);
			void GetContentSize_prot(float *width, float *height);
			status_t Invoke(BMessage *message = NULL);
			status_t Invoke_prot(BMessage *message = NULL);
			bool IsSelected2();
};

OMenuItem::OMenuItem(/*value self,*/ char *label, BMessage *message, char shortcut, uint32 modifiers):
	BMenuItem(label, message, shortcut, modifiers)//, Glue(/*self*/) 
{
}


void OMenuItem::Draw(void) {
//	CAMLparam1(interne);
	//**//**acquire_sem(ocaml_sem);
		CAMLparam0();	
		CAMLlocal1(mi);
	//**release_sem(ocaml_sem);
		caml_leave_blocking_section();
		
//			caml_register_global_root(&mi);
			mi = caml_copy_int32((int32)this);
//			//**//**acquire_sem(callback_sem);
				callback(*caml_named_value("MenuItem#draw"), mi/**interne*/);
//			//**release_sem(callback_sem);
		caml_enter_blocking_section();
//	//**release_sem(ocaml_sem);
	CAMLreturn0;
}

void OMenuItem::Draw2(void) {
		BMenuItem::Draw();
}

void OMenuItem::GetContentSize(float *width, float *height){
//	CAMLparam1(interne);
		//**//**acquire_sem(ocaml_sem);
	CAMLparam0();
	CAMLlocal2(w,h);
	printf("[C] OMenuItem::GetContentSize avant register\n");fflush(stdout);
//	register_global_root(&w);
//	register_global_root(&h);
	//**release_sem(ocaml_sem);
//	caml_leave_blocking_section();
		w = alloc(1, 0); /*0 = record_tag*/
		h = alloc(1, 0);
		
//		//**//**acquire_sem(callback_sem);
			callback3(*caml_named_value("MenuItem#getContentSize"),copy_int32((int32)this), /**interne*/w, h);
//		//**release_sem(callback_sem);	
	
	*width = Double_val(Field(w, 0));
	*height = Double_val(Field(h, 0));
//	caml_enter_blocking_section();
	
	CAMLreturn0;
}

void OMenuItem::GetContentSize_prot(float *width, float *height) {
	BMenuItem::GetContentSize(width, height);
}

status_t OMenuItem::Invoke(BMessage *message){
	bool new_lock = false;
//	if (beos_thread != find_thread(NULL)) {
//		new_lock = true;
//		//**//**acquire_sem(ocaml_sem);	
//		beos_thread = find_thread(NULL);
//	}
		CAMLparam0();
		CAMLlocal4(mi, me, caml_res,fun);

		//caml_register_global_root(&mi);
		//caml_register_global_root(&me);
		//caml_register_global_root(&caml_res);
		//caml_register_global_root(&fun);
//	if(new_lock) {
//			//**release_sem(ocaml_sem);	
//	}
	
	status_t res;
//printf("OMenuItem::Invoke(message->what= %c%c%c%c\n", message->what >>24,message->what >>16, message->what >>8, message->what);fflush(stdout);
//if (beos_thread != find_thread(NULL)) {
//		new_lock = true;
//		//**//**acquire_sem(ocaml_sem);	
//		beos_thread = find_thread(NULL);
//	}
	caml_leave_blocking_section();
		mi = caml_copy_int32((int32)this);
		me = caml_copy_int32((int32)message);
		fun = *caml_named_value("MenuItem#Invoke");
		
		res = callback2(*caml_named_value("MenuItem#Invoke"),mi, me);

		caml_res = caml_copy_int32(res);
	caml_enter_blocking_section();
//	if(new_lock) {
//			//**release_sem(ocaml_sem);	
//	}
	
	CAMLreturn(caml_res);
}

status_t OMenuItem::Invoke_prot(BMessage *message = NULL) {
	BMenuItem::Invoke(message);
}

bool OMenuItem::IsSelected2(){
	IsSelected();
}

class OSeparatorItem : public BSeparatorItem//, public Glue 
{
	public :
			OSeparatorItem(/*value self*/);
};

OSeparatorItem::OSeparatorItem(/*value self*/):
	BSeparatorItem()//, Glue(/*self*/) 
{
}


//***********************
value b_menuItem_menuItem(/*value self,*/ value label, value message, value shortcut, value modifiers) {
	CAMLparam4(/*self,*/ label, message, shortcut, modifiers);
	CAMLlocal1(menuItem);
	
//	caml_leave_blocking_section();
	OMenuItem *mi = new OMenuItem(//self,
								  String_val(label), 
								  (BMessage *)Int32_val(message),
								  (char)Int_val(shortcut), 
								  Int_val(modifiers)
								 );
			
	menuItem = caml_copy_int32((value)mi);
//	caml_enter_blocking_section();
	CAMLreturn(menuItem);

}

//*********************
value b_menuItem_draw(value menuItem){
	//**//**acquire_sem(ocaml_sem);
		CAMLparam1(menuItem);
	//**release_sem(ocaml_sem);
	
//	caml_leave_blocking_section();
		((OMenuItem *)Int32_val(menuItem))->OMenuItem::Draw2();
//	caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}

//*********************
value b_menuItem_frame(value menuItem){
	CAMLparam1(menuItem);
	CAMLlocal1(caml_frame);
	
//	caml_leave_blocking_section();
		BRect *r = new BRect(((BMenuItem *)Int32_val(menuItem))->BMenuItem::Frame());
	caml_frame = caml_copy_int32((value)r);
	
//	caml_enter_blocking_section();
	CAMLreturn(caml_frame);
}

//*************************
value b_menuItem_getContentSize_prot(value menuItem, value width, value height){
	float w;
	float h;
	CAMLparam3(menuItem, width, height);
	
//	caml_leave_blocking_section();
		((OMenuItem *)Int32_val(menuItem))->GetContentSize_prot(&w, &h);

		Store_field(width, 0, copy_double(w));
		Store_field(height, 0, copy_double(h));
	
//	caml_enter_blocking_section();
	CAMLreturn(Val_unit);
}

//************************
value b_menuItem_invoke(value menuItem){
	CAMLparam1(menuItem);
	CAMLlocal1(res_caml);
	
	OMenuItem *m;
	status_t res;
	m = (OMenuItem*)Int32_val(menuItem);
	
//	//**release_sem(ocaml_sem);
//	caml_enter_blocking_section;
		res = m->Invoke_prot();
//	//**//**acquire_sem(ocaml_sem);
	
//	caml_leave_blocking_section();
	res_caml = caml_copy_int32(res);
	
	CAMLreturn(res_caml);
}

//************************
value b_menuItem_invoke_message(value menuItem, value message){
	//**//**acquire_sem(ocaml_sem);
		CAMLparam2(menuItem, message);
		CAMLlocal1(caml_res);
	//**release_sem(ocaml_sem);

	OMenuItem *mi;
	BMessage *m;
	status_t res;
	
	mi = (OMenuItem *)Int32_val(menuItem);
	m  = (BMessage *) Int32_val(message);
	
//	caml_enter_blocking_section();
		res = mi->Invoke_prot(m);
//	caml_leave_blocking_section();
	
	caml_res = caml_copy_int32(res);
	
	CAMLreturn(caml_res);
}


//*********************
value b_menuItem_isMarked(value menuItem) {
	CAMLparam1(menuItem);
	
	CAMLreturn(Val_bool(((BMenuItem *)Int32_val(menuItem))->BMenuItem::IsMarked()));
}

//*********************
value b_menuItem_isSelected(value menuItem) {
	CAMLparam1(menuItem);
	
	CAMLreturn(Val_bool(((OMenuItem *)Int32_val(menuItem))->IsSelected2()));
}
//*********************
value b_menuItem_label(value menuItem){
	CAMLparam1(menuItem);
	CAMLlocal1(caml_label);
	
		caml_label = caml_copy_string(((OMenuItem *)Int32_val(menuItem))->BMenuItem::Label());
//	caml_enter_blocking_section();
	
	CAMLreturn(caml_label);
}

//*********************
value b_menuItem_menu(value menuItem){
	CAMLparam1(menuItem);
	CAMLlocal1(menu);
	
//	caml_leave_blocking_section();
		menu = caml_copy_int32((value)((BMenuItem *)Int32_val(menuItem))->Menu()); 
//	caml_enter_blocking_section();
	
	CAMLreturn(menu);

}

//*********************
value b_menuItem_setEnabled(value menuItem, value enabled) {
	CAMLparam2(menuItem, enabled);
 	
	((BMenuItem *)Int32_val(menuItem))->BMenuItem::SetEnabled(Bool_val(enabled));
	
	CAMLreturn(Val_unit);
}

//*********************
value b_menuItem_setMarked(value menuItem, value flag) {
	CAMLparam2(menuItem, flag);
 	
	((BMenuItem *)Int32_val(menuItem))->BMenuItem::SetMarked(Bool_val(flag));
	
	CAMLreturn(Val_unit);
}

//*********************
value b_menuItem_setTarget(value menuItem, value handler) {
	CAMLparam2(menuItem, handler);
	CAMLlocal1(caml_status);
	
	BHandler * h = (BHandler *)Int32_val(handler);
	OMenuItem * mi = (OMenuItem *)Int32_val(menuItem);
	
//	caml_leave_blocking_section();
		caml_status = caml_copy_int32((int32)mi->BMenuItem::SetTarget(h));
//	caml_enter_blocking_section();
	
	CAMLreturn(caml_status);
}

//*********************
value b_menuItem_setTarget_looper(value menuItem, value handler, value looper) {
	CAMLparam3(menuItem, handler, looper);
	CAMLlocal1(caml_status);
	
//	caml_leave_blocking_section();

		caml_status = caml_copy_int32(((OMenuItem *)Int32_val(menuItem))->
						BMenuItem::SetTarget((BHandler *)Int32_val(handler), (BLooper  *)Int32_val(looper ))); 
							
//	caml_enter_blocking_section();

	CAMLreturn(caml_status);

}

//***********************
value b_separatorItem_separatorItem(value unit) {
	CAMLparam1(unit);
	CAMLlocal1(separatorItem);
	
	OSeparatorItem *si = new OSeparatorItem(/*self*/);
			
//	caml_leave_blocking_section();
		separatorItem = caml_copy_int32((value)si);
//	caml_enter_blocking_section();
	
	CAMLreturn(separatorItem);
}
