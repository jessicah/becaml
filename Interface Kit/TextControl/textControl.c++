#ifndef BEOS
	#define BEOS
#endif

#include <TextControl.h>
#include <stdio.h>

#include "mlvalues.h"
#include "memory.h"
#include "alloc.h"
#include "callback.h"


#include "glue.h"

extern "C" {
	extern sem_id ocaml_sem;
	value b_textControl_textControl_bytecode(value *argv, int argc);
	value b_textControl_textControl_nativecode(value textControl, value frame, value name, value label, value string, value message, value resizingMode, value flags);
	value b_textControl_resizeToPreferred(value textControl);
	value b_textControl_setText(value textControl, value text);
	value b_textControl_text(value textControl);
	value b_textControl_textView(value textControl);
}

class OTextControl : public BTextControl, public Glue {
	public :
			OTextControl(value ocaml_objet, BRect frame, char *name, char *label, char *string, BMessage *message, uint32 resizingMode, uint32 flags) :
				BTextControl(frame, name, label, string, message, resizingMode, flags),
				Glue(ocaml_objet){
				}

			void MouseDown(BPoint where) {
					printf("OTextControl::MouseDown appele.\n");
					BTextControl::MouseDown(where);
			}
};

//***********************************************
value b_textControl_textControl_bytecode(value *argv, int argc) {
	return b_textControl_textControl_nativecode(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6], argv[7]);
}

//************************************************
value b_textControl_textControl_nativecode(value self, value frame, value name, value label, value string, value message, value resizingMode, value flags){
	CAMLparam5(self, frame, name, label, string);
	CAMLxparam3(message, resizingMode, flags);
	
	OTextControl *bt = new OTextControl(self,
										*(BRect *)Int32_val(frame),
										String_val(name),
										String_val(label),
										String_val(string),
										(BMessage *)Int32_val(message),
										Int32_val(resizingMode),
										Int32_val(flags));
	
	CAMLreturn(copy_int32((int32)bt));
}

//************************************
value b_textControl_resizeToPreferred(value textControl){
	CAMLparam1(textControl);
	
	((BTextControl *)Int32_val(textControl))->BTextControl::ResizeToPreferred();

	CAMLreturn(Val_unit);
}

//***********************************
value b_textControl_setText(value textControl, value text){
	CAMLparam2(textControl, text);

	((BTextControl *)Int32_val(textControl))->BTextControl::SetText(String_val(text));

	CAMLreturn(Val_unit);
}

//***********************************
value b_textControl_text(value textControl){
	CAMLparam1(textControl);

	CAMLreturn(copy_string(((BTextControl *)Int32_val(textControl))->BTextControl::Text()));
}

//***********************************
value b_textControl_textView(value textControl){
	CAMLparam1(textControl);

	CAMLreturn(copy_int32((value)((BTextControl *)Int32_val(textControl))->TextView()));
}
