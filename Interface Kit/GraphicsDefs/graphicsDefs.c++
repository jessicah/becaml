#define BEOS

#include <stdio.h>

#include "alloc.h"
#include "mlvalues.h"
#include "memory.h"

#include <GraphicsDefs.h>

extern "C"{
	drawing_mode decode_drawing_mode(value mode);
	pattern 	 decode_pattern(value pattern);
	color_space  decode_color_space(value space);
	value 		 encode_color_space(color_space space);
	value kB_SOLID_HIGH(value unit);
}

//********************
drawing_mode decode_drawing_mode(value mode){
	CAMLparam1(mode);
	
	switch(Int_val(mode)) {
		case 0 : CAMLreturnT(drawing_mode, B_OP_COPY);
		case 1 : CAMLreturnT(drawing_mode, B_OP_OVER);
		case 2 : CAMLreturnT(drawing_mode, B_OP_ERASE);
		case 3 : CAMLreturnT(drawing_mode, B_OP_INVERT);
		case 4 : CAMLreturnT(drawing_mode, B_OP_ADD);
		case 5 : CAMLreturnT(drawing_mode, B_OP_SUBTRACT);
		case 6 : CAMLreturnT(drawing_mode, B_OP_BLEND);
		case 7 : CAMLreturnT(drawing_mode, B_OP_MIN);
		case 8 : CAMLreturnT(drawing_mode, B_OP_MAX);
		case 9 : CAMLreturnT(drawing_mode, B_OP_SELECT);
		case 10: CAMLreturnT(drawing_mode, B_OP_ALPHA);
	}
	
}

//**************************
pattern decode_pattern(value pattern){
	CAMLparam1(pattern);
	struct pattern motif;

	for(int i=0;i<8;i++)
			motif.data[i] = Int_val(Field(Field(pattern, 0), i));
	
	CAMLreturnT(struct pattern, motif);
}

//**************************
color_space decode_color_space(value space){
	CAMLparam1(space);
	switch(Int_val(space)) {
		case  4 : CAMLreturnT(color_space, B_RGB16);
		case  7 : CAMLreturnT(color_space, B_CMAP8);
		case 53 : CAMLreturnT(color_space, B_COLOR_8_BIT);
		default : printf("%d non décodée par decode_color_space !!!\n", Int_val(space)); 
	}
	CAMLreturnT(color_space, (color_space)Int_val(space));
}

//******************
value encode_color_space(color_space space){
	
	switch(space) {
	
		case B_CMAP8 : return(Val_int(7));
	}
}


//************************
value kB_SOLID_HIGH(value unit){
	CAMLparam1(unit);
	CAMLlocal2(pattern, solid_high);

	pattern = alloc(1, 0);
	solid_high = alloc(8, 0);
	for(int i=0;i<8;i++) 
			Store_field(solid_high, i, Val_int(B_SOLID_HIGH.data[i]));
	
	Store_field(pattern, 0, solid_high);
	
	CAMLreturn(pattern);
}

