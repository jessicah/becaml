#include <CheckBox.h>
#include <stdio.h>
#include "alloc.h"
#include "callback.h"
#include "memory.h"
#include "mlvalues.h"
#include "signals.h"
#include "threads.h"



#include "glue.h"
#include "message.h"
#include "point_rect.h"

extern "C" {
	value b_checkBox_checkBox_native(value self, value frame, value name, value label, value message, value resizingMode, value flags);
	value b_checkBox_checkBox_bytecode(value *argv, int argc);
	value b_checkBox_invoke(value checkBox);
	value b_checkBox_invoke_message(value checkBox, value message);
	value b_checkBox_resizeToPreferred(value checkBox);
	value b_checkBox_setTarget_handler(value checkBox, value handler);
	value b_checkBox_setTarget_view(value checkBox, value view);
	value b_checkBox_setTarget_name(value checkBox, value name);
	value b_checkBox_setValue(value checkBox, value val32);
	value b_checkBox_value(value checkBox);
	extern sem_id callback_sem;
	extern sem_id ocaml_sem;
}


class OCheckBox : public BCheckBox, public Glue 
{

		public :
				OCheckBox(value self, BRect frame, char *name, char *label, BMessage *message, uint32 resizingMode, uint32 flags);

				status_t Invoke(BMessage *message = NULL);
				status_t Invoke_prot(BMessage *message = NULL);
				status_t SetTarget(const BHandler *handler, const BLooper *loop = NULL);

};

OCheckBox::OCheckBox(value self, BRect frame, char *name, char *label, BMessage *message, uint32 resizingMode, uint32 flags):
	BCheckBox(frame, name, label, message, resizingMode, flags)
	,Glue(self)
{
}

status_t OCheckBox::Invoke(BMessage *message){
	CAMLparam0();
	CAMLlocal3(ocaml_message, p_message, res_caml);
	status_t res;

//	//**acquire_sem(ocaml_sem);

	//caml_c_thread_register();

	caml_acquire_runtime_system();
		p_message = alloc_small(1,Abstract_tag);
		caml_register_global_root(&p_message);

		ocaml_message = caml_callback(*caml_named_value("new_be_message"), p_message);
		caml_register_global_root(&ocaml_message);
	caml_release_runtime_system();
		OMessage *m = new OMessage(ocaml_message, message);
	caml_acquire_runtime_system();
	Field(p_message,0) = (value)ocaml_message;
////**acquire_sem(callback_sem);
		res = caml_callback2( caml_get_public_method(interne, hash_variant("invoke")), interne, ocaml_message);
////**release_sem(callback_sem);
	caml_release_runtime_system();
	res_caml=caml_copy_int32(res);

//	//**release_sem(ocaml_sem);
	CAMLreturn(res_caml);

}

status_t OCheckBox::Invoke_prot(BMessage *message){
	BCheckBox::Invoke(message);
}

status_t OCheckBox::SetTarget(const BHandler *handler, const BLooper *looper = NULL){
		CAMLparam0();
		CAMLlocal1(res_caml);
		status_t res;
		
		caml_leave_blocking_section();
//			//**acquire_sem(callback_sem);
				res = caml_callback2(*caml_named_value("OCheckBox#SetTarget"), copy_int32((int32)handler), copy_int32((int32)looper));
//			//**release_sem(callback_sem);
			res_caml = caml_copy_int32(res);
		caml_enter_blocking_section();

		CAMLreturn(res_caml);
}

//*************************
value b_checkBox_checkBox_native(value self, value frame, value name, value label, value message, value resizingMode, value flags){
	CAMLparam5(self, frame, name, label, message);
	CAMLxparam2(resizingMode, flags);
	CAMLlocal1(p_checkBox);
	OCheckBox *box;
	
	//caml_leave_blocking_section();
	caml_release_runtime_system();
		box = new OCheckBox(self,
						*(ORect *)Field(frame,0), 
				   		String_val(name), 
						String_val(label), 
						(OMessage *)Field(message,0), 
						Int32_val(resizingMode), 
						Int32_val(flags));
	caml_acquire_runtime_system();
	printf("C 0x%lx : %lx\n", box, sizeof(OCheckBox));
	

	p_checkBox = alloc_small(1,Abstract_tag);
	Field(p_checkBox,0) = (value)box;

	//caml_enter_blocking_section();
	
	CAMLreturn(p_checkBox);

}
//****************************
value b_checkBox_checkBox_bytecode(value *argv, int argc){
	
	return b_checkBox_checkBox_native(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6]);
}

//*******************
value b_checkBox_invoke(value checkBox){
	CAMLparam1(checkBox);
	CAMLlocal1(res);

	//caml_leave_blocking_section();
		res = copy_int32(((OCheckBox *)Field(checkBox,0))->Invoke_prot());
	//caml_enter_blocking_section();
	
	CAMLreturn(res);
}

//*******************
value b_checkBox_invoke_message(value checkBox, value message){
	CAMLparam2(checkBox, message);
	CAMLlocal1(res);

	//caml_leave_blocking_section();
		res = copy_int32(((OCheckBox *)Field(checkBox,0))->Invoke_prot((OMessage *)Field(message,0)));
	//caml_enter_blocking_section();
	
	CAMLreturn(res);
}


//*******************
value b_checkBox_resizeToPreferred(value checkBox){
	CAMLparam1(checkBox);
	
	//caml_leave_blocking_section();
		((OCheckBox *)Field(checkBox,0))->BCheckBox::ResizeToPreferred();
	//caml_enter_blocking_section();

	CAMLreturn(Val_unit);
}

//*************************
value b_checkBox_setTarget_view(value checkBox, value view){
	CAMLparam2(checkBox, view);

	//caml_leave_blocking_section();
		((OCheckBox *)Field(checkBox,0))->BCheckBox::SetTarget((BView *)Field(view,0));
	//caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}

//*************************
value b_checkBox_setTarget_handler(value checkBox, value handler){
	CAMLparam2(checkBox, handler);

	//caml_leave_blocking_section();
		((OCheckBox *)Field(checkBox,0))->BCheckBox::SetTarget((BHandler *)Field(handler,0));
	//caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}

//***********************
value b_checkBox_setTarget_name(value checkBox, value name){
	CAMLparam2(checkBox, name);

	//caml_leave_blocking_section();
			((OCheckBox *)Field(checkBox,0))->BCheckBox::SetTarget(String_val(name));
	//caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}

//***********************
value b_checkBox_setValue(value checkBox, value val32){
	CAMLparam2(checkBox, val32);

	//caml_leave_blocking_section();
			((OCheckBox *)Field(checkBox,0))->BCheckBox::SetValue(Int32_val(val32));
	//caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}

//***********************************
value b_checkBox_value(value checkBox){
	CAMLparam1(checkBox);
	CAMLlocal1(caml_value);
	
	BCheckBox *b = (OCheckBox *)Field(checkBox,0);
	int32 res;
	
	printf("on = 0x%lx, off = 0x%lx\n", B_CONTROL_ON, B_CONTROL_OFF);fflush(stdout);

	//caml_leave_blocking_section();
		res = ((OCheckBox *)Field(checkBox,0))->BCheckBox::Value();
		caml_value = caml_copy_int32((int32)res);
	//caml_enter_blocking_section();
	
	CAMLreturn(caml_value);
}

