#ifndef BEOS
	#define BEOS
#endif

#include "alloc.h"
#include "memory.h"
#include "signals.h"

#include <ColorControl.h>
#include <stdio.h>
#include "glue.h"

extern "C" {
	extern sem_id ocaml_sem;
	value b_colorControl_colorControl_native(value self, value leftTop, value matrix, value cellSide, value name, value message, value bufferedDrawing);
	value b_colorControl_colorControl_bytecode(value *argv, int argc);
	value b_colorControl_setValue(value self, value color);
	value b_colorControl_getPreferredSize(value colorControl, value width, value height);
	value b_colorControl_valueAsColor(value colorControl);
}

color_control_layout decode_color_control_layout(int matrix) {
	switch(matrix) {
		case 0 : return B_CELLS_4x64;
		case 1 : return B_CELLS_8x32;
 		case 2 : return B_CELLS_16x16;
		case 3 : return B_CELLS_32x8;
		case 4 : return B_CELLS_64x4;
	}
}

class OColorControl : public BColorControl, public Glue {
		public :
				OColorControl(value self, BPoint leftTop, color_control_layout matrix, 
							  float cellSide, char *name, BMessage *message, bool bufferedDrawing) :
					BColorControl(leftTop, matrix, cellSide, name, message, bufferedDrawing), 
					Glue(self)
					{}
};

//*************************
value b_colorControl_colorControl_native(value self, value leftTop, value matrix, value cellSide, 
										 value name, value message, value bufferedDrawing){
	CAMLparam5(self, leftTop, matrix, cellSide, name);
	CAMLxparam2( message, bufferedDrawing);
	CAMLlocal1(caml_cc);
	OColorControl *cc;
	
	cc = new OColorControl(self,
										  *(BPoint *)Int32_val(leftTop), 
										  decode_color_control_layout(Int_val(matrix)), 
										  Double_val(cellSide), 
										  String_val(name), 
										  (BMessage *)Int32_val(message), 
										  Bool_val(bufferedDrawing));
	printf("C 0x%lx : %lx\n", cc, sizeof(OColorControl));	
//	caml_leave_blocking_section();
		caml_cc = caml_copy_int32((int32)cc);
//	caml_enter_blocking_section();
	
	CAMLreturn(caml_cc);	
}

//********************
value b_colorControl_colorControl_bytecode(value *argv, int argc){

	return b_colorControl_colorControl_native(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6]);
}
//***************************
value b_colorControl_setValue(value colorControl, value color){
	CAMLparam2(colorControl, color);
	rgb_color couleur;
	
	couleur.red   = Int_val(Field(color, 0));
	couleur.green = Int_val(Field(color, 1));
	couleur.blue  = Int_val(Field(color, 2));
	couleur.alpha = Int_val(Field(color, 3));
	
	((BColorControl *)Int32_val(colorControl))->BColorControl::SetValue(couleur);
	
	CAMLreturn(Val_unit);
}

//*******************
value b_colorControl_getPreferredSize(value colorControl, value width, value height) {
	CAMLparam3(colorControl, width, height);
	CAMLlocal2(caml_w, caml_h);
	float w,h;

	((BColorControl *)Int32_val(colorControl))->BColorControl::GetPreferredSize(&w, &h);
	
//	caml_leave_blocking_section();
		
		caml_w = caml_copy_double(w);
		caml_h = caml_copy_double(h);
		
		Store_field(width, 0, caml_w);
		Store_field(height, 0, caml_h);
		
//	caml_enter_blocking_section();

	CAMLreturn(Val_unit);
}

//*******************
value b_colorControl_valueAsColor(value colorControl){
	CAMLparam1(colorControl);
	CAMLlocal1(valeur);
	rgb_color color;
	
	color = ((BColorControl *)Int32_val(colorControl))->BColorControl::ValueAsColor();
//	caml_leave_blocking_section();
		valeur = alloc(4, 0);
	
		Store_field(valeur, 0, Val_int(color.red));
		Store_field(valeur, 1, Val_int(color.green));
		Store_field(valeur, 2, Val_int(color.blue));
		Store_field(valeur, 3, Val_int(color.alpha));
//	caml_enter_blocking_section();
	
	CAMLreturn(valeur);
}
