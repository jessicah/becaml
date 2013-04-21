#include <CheckBox.h>
#include <stdio.h>
#include "alloc.h"
#include "callback.h"
#include "memory.h"
#include "mlvalues.h"
#include "signals.h"



#include "glue.h"

extern "C" {
	value b_checkBox_checkBox_native(/*value self,*/ value frame, value name, value label, value message, value resizingMode, value flags);
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


class OCheckBox : public BCheckBox//, public Glue 
{

		public :
				OCheckBox(/*value self,*/ BRect frame, char *name, char *label, BMessage *message, uint32 resizingMode, uint32 flags);

				status_t Invoke(BMessage *message = NULL);
				status_t Invoke_prot(BMessage *message = NULL);
				status_t SetTarget(const BHandler *handler, const BLooper *loop = NULL);

};

OCheckBox::OCheckBox(/*value self,*/ BRect frame, char *name, char *label, BMessage *message, uint32 resizingMode, uint32 flags):
	BCheckBox(frame, name, label, message, resizingMode, flags)
//	,Glue(self)
{
}

status_t OCheckBox::Invoke(BMessage *message){
	CAMLparam0();
	CAMLlocal1(res_caml);
	status_t res;

//	//**acquire_sem(ocaml_sem);
		caml_leave_blocking_section();
			////**acquire_sem(callback_sem);
				res = callback2(*caml_named_value("OCheckBox#Invoke"), copy_int32((int32)this), 
															   copy_int32((int32)message));
			////**release_sem(callback_sem);
			res_caml=caml_copy_int32(res);
		caml_enter_blocking_section();

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
				res = callback2(*caml_named_value("OCheckBox#SetTarget"), copy_int32((int32)handler), copy_int32((int32)looper));
//			//**release_sem(callback_sem);
			res_caml = caml_copy_int32(res);
		caml_enter_blocking_section();

		CAMLreturn(res_caml);
}

//*************************
value b_checkBox_checkBox_native(/*value self,*/ value frame, value name, value label, value message, value resizingMode, value flags){
	CAMLparam5(/*self,*/ frame, name, label, message, resizingMode);
	CAMLxparam1(/*resizingMode,*/ flags);
	CAMLlocal1(checkBox);
	OCheckBox *box;
	
	//caml_leave_blocking_section();
	box = new OCheckBox(//self,
						*(BRect *)Int32_val(frame), 
				   		String_val(name), 
						String_val(label), 
						(BMessage *)Int32_val(message), 
						Int32_val(resizingMode), 
						Int32_val(flags));
		printf("C 0x%lx : %lx\n", box, sizeof(OCheckBox));
	

	checkBox = copy_int32((value)box);

	//caml_enter_blocking_section();
	
	CAMLreturn(checkBox);

}
//****************************
value b_checkBox_checkBox_bytecode(value *argv, int argc){
	
	return b_checkBox_checkBox_native(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]/*, argv[6]*/);
}

//*******************
value b_checkBox_invoke(value checkBox){
	CAMLparam1(checkBox);
	CAMLlocal1(res);

	//caml_leave_blocking_section();
		res = copy_int32(((OCheckBox *)Int32_val(checkBox))->Invoke_prot());
	//caml_enter_blocking_section();
	
	CAMLreturn(res);
}

//*******************
value b_checkBox_invoke_message(value checkBox, value message){
	CAMLparam2(checkBox, message);
	CAMLlocal1(res);

	//caml_leave_blocking_section();
		res = copy_int32(((OCheckBox *)Int32_val(checkBox))->Invoke_prot((BMessage *)Int32_val(message)));
	//caml_enter_blocking_section();
	
	CAMLreturn(res);
}


//*******************
value b_checkBox_resizeToPreferred(value checkBox){
	CAMLparam1(checkBox);
	
	//caml_leave_blocking_section();
		((BCheckBox *)Int32_val(checkBox))->BCheckBox::ResizeToPreferred();
	//caml_enter_blocking_section();

	CAMLreturn(Val_unit);
}

//*************************
value b_checkBox_setTarget_view(value checkBox, value view){
	CAMLparam2(checkBox, view);

	//caml_leave_blocking_section();
		((BCheckBox *)Int32_val(checkBox))->BCheckBox::SetTarget((BView *)Int32_val(view));
	//caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}

//*************************
value b_checkBox_setTarget_handler(value checkBox, value handler){
	CAMLparam2(checkBox, handler);

	//caml_leave_blocking_section();
		((BCheckBox *)Int32_val(checkBox))->BCheckBox::SetTarget((BHandler *)Int32_val(handler));
	//caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}

//***********************
value b_checkBox_setTarget_name(value checkBox, value name){
	CAMLparam2(checkBox, name);

	//caml_leave_blocking_section();
			((BCheckBox *)Int32_val(checkBox))->BCheckBox::SetTarget(String_val(name));
	//caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}

//***********************
value b_checkBox_setValue(value checkBox, value val32){
	CAMLparam2(checkBox, val32);

	//caml_leave_blocking_section();
			((BCheckBox *)Int32_val(checkBox))->BCheckBox::SetValue(Int32_val(val32));
	//caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}

//***********************************
value b_checkBox_value(value checkBox){
	CAMLparam1(checkBox);
	CAMLlocal1(caml_value);
	
	BCheckBox *b = (BCheckBox *)Int32_val(checkBox);
	int32 res;
	
	printf("on = 0x%lx, off = 0x%lx\n", B_CONTROL_ON, B_CONTROL_OFF);fflush(stdout);

	//caml_leave_blocking_section();
		res = ((BCheckBox *)Int32_val(checkBox))->BCheckBox::Value();
		caml_value = caml_copy_int32((int32)res);
	//caml_enter_blocking_section();
	
	CAMLreturn(caml_value);
}

