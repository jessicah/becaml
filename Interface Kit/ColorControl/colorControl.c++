#ifndef BEOS
	#define BEOS
#endif

#include "alloc.h"
#include "memory.h"
#include "signals.h"

#include <ColorControl.h>
#include <stdio.h>

#include "glue.h"
#include "message.h"
#include "point_rect.h"
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
	OPoint *opoint;
	OMessage *omessage;

	opoint = (OPoint *)Field(leftTop,0);
	omessage = (OMessage *)Field(message,0);
	caml_cc = caml_alloc_small(1,Abstract_tag);
	caml_register_global_root(&caml_cc);

	caml_release_runtime_system();
		cc = new OColorControl(self,
				       *opoint, 
				       decode_color_control_layout(Int_val(matrix)), 
				       Double_val(cellSide), 
				       String_val(name), 
				       omessage, 
				       Bool_val(bufferedDrawing));
	caml_acquire_runtime_system();
	printf("C 0x%lx : %lx\n", cc, sizeof(OColorControl));	
//	caml_leave_blocking_section();
	Field(caml_cc,0) = (value)cc;
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
	
	OColorControl *ocolorcontrol;

	rgb_color couleur;
		
	ocolorcontrol = (OColorControl *)Field(colorControl,0);

	couleur.red   = Int_val(Field(color, 0));
	couleur.green = Int_val(Field(color, 1));
	couleur.blue  = Int_val(Field(color, 2));
	couleur.alpha = Int_val(Field(color, 3));
	
	caml_release_runtime_system();
		ocolorcontrol->SetValue(couleur);
	caml_acquire_runtime_system();
	
	CAMLreturn(Val_unit);
}

//*******************
value b_colorControl_getPreferredSize(value colorControl, value width, value height) {
	CAMLparam3(colorControl, width, height);
	CAMLlocal2(caml_w, caml_h);
	OColorControl *ocolorcontrol;

	float w,h;
		
	ocolorcontrol = (OColorControl *)Field(colorControl,0);

	caml_release_runtime_system();
		ocolorcontrol->BColorControl::GetPreferredSize(&w, &h);
	caml_acquire_runtime_system();
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
	
	OColorControl *ocolorcontrol;
	rgb_color color;
	
	ocolorcontrol = (OColorControl *)Field(colorControl,0);

	caml_release_runtime_system();
		color = ocolorcontrol->BColorControl::ValueAsColor();
	caml_acquire_runtime_system();
//	caml_leave_blocking_section();
	valeur = caml_alloc_small(4, 0);

	Store_field(valeur, 0, Val_int(color.red));
	Store_field(valeur, 1, Val_int(color.green));
	Store_field(valeur, 2, Val_int(color.blue));
	Store_field(valeur, 3, Val_int(color.alpha));
//	caml_enter_blocking_section();
	
	CAMLreturn(valeur);
}
