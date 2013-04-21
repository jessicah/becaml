#include <InterfaceDefs.h>

#define BEOS

#include "mlvalues.h"
#include "memory.h"
#include "alloc.h"


extern "C" {
	border_style decode_border_style(value border_style);		
	button_width decode_button_width(value button_width);
	orientation decode_orientation(value orientation);
}

//********************
border_style decode_border_style(value border_style){
	CAMLparam1(border_style);

	switch(Int_val(border_style)) {
		case 0 : CAMLreturnT(enum border_style, B_PLAIN_BORDER);
		case 1 : CAMLreturnT(enum border_style, B_FANCY_BORDER);
		case 2 : CAMLreturnT(enum border_style, B_NO_BORDER);
	}
}

//********************
button_width decode_button_width(value button_width){
	CAMLparam1(button_width);
	
	switch(Int_val(button_width)) {
		case 0 : CAMLreturnT(enum button_width, B_WIDTH_AS_USUAL);
		case 1 : CAMLreturnT(enum button_width, B_WIDTH_FROM_WIDEST);
		case 2 : CAMLreturnT(enum button_width, B_WIDTH_FROM_LABEL);
	}
}

//**********************
orientation decode_orientation(value orientation){
	CAMLparam1(orientation);

	switch(Int_val(orientation)) {
		case 0 : CAMLreturnT(enum orientation, B_HORIZONTAL);
		case 1 : CAMLreturnT(enum orientation, B_VERTICAL);
	}
}
