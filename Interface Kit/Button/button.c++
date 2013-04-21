#include <Button.h>
#ifndef BEOS
	#define BEOS
#endif

#include "glue.h"
#include <stdio.h>

#include "alloc.h"
#include "mlvalues.h"
#include "memory.h"



extern "C" 
{
	extern sem_id ocaml_sem;
	value b_button_button_native(/*value self,*/ value frame, value name, value label, value message, 
								 value resizingMode, value flags);
	value b_button_button_bytecode(value *argv, int argc);
	value b_button_makeDefault(value button, value state);
	value b_button_setEnabled(value button, value enabled);
	value b_button_setLabel(value button, value label);
	value b_button_setTarget_handler(value button, value handler);
}


class OButton : public BButton//, public Glue 
{
	public :
		OButton(/*value self,*/ BRect frame, char *name, char *label, BMessage *message, uint32 resizingMode,
				uint32 flags) :
		BButton(frame, name, label, message, resizingMode, flags) 
//		,Glue(/*self*/)
		{
//			CAMLparam1(self);
			
//			CAMLreturn0;
		}

				/*status_t Invoke(BMessage *message) {
				 printf("appel de OButton::Invoke\n");
				 message->PrintToStream();
				 BButton::Invoke(new BMessage(*message));
				}*/

				/*void MouseDown(BPoint point) {

						
				}*/


};



//***********************
value b_button_button_native(/*value self,*/ value frame, value name, value label, value message, value resizingMode, value flags) {
		CAMLparam5(/*self,*/ frame, name, label, message, resizingMode);
		CAMLxparam1(flags);

		BMessage *m;
		OButton *ob;
		
		m = new BMessage(*(BMessage *)Int32_val(message));
		printf("C 0x%lx : %lx\n", m, sizeof(BMessage));
		ob = new OButton(//self, 
												 *(BRect *)Int32_val(frame), 
												 String_val(name), 
												 String_val(label), 
												 m,
												 Int32_val(resizingMode), 
												 Int32_val(flags)
												);
		printf("C 0x%lx : %lx\n", ob, sizeof(OButton));

		CAMLreturn(caml_copy_int32((value)ob));
}

//*************************************
value b_button_button_bytecode(value *argv, int argc){
	return b_button_button_native(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]/*, argv[6]*/); 
}

//*********************************
value b_button_makeDefault(value button, value state){
	CAMLparam2(button, state);

	((OButton *)Int32_val(button))->BButton::MakeDefault(Bool_val(state));

	CAMLreturn(Val_unit);
}

//*********************************
value b_button_setEnabled(value button, value enabled){
	CAMLparam2(button, enabled);

	((OButton *)Int32_val(button))->BButton::SetEnabled(Bool_val(enabled));

	CAMLreturn(Val_unit);
}

//*********************************
value b_button_setLabel(value button, value label){
	CAMLparam2(button, label);

	((OButton *)Int32_val(button))->BButton::SetLabel(String_val(label));

	CAMLreturn(Val_unit);
}

//******************************
value b_button_setTarget_handler(value button, value handler){
	CAMLparam2(button, handler);
	status_t res = ((BButton *)Int32_val(button))->BButton::SetTarget((BHandler *)Int32_val(handler));

	CAMLreturn(caml_copy_int32(res));
}

