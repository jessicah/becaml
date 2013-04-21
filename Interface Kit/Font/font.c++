#ifndef BEOS
	#define BEOS
#endif

#include <Font.h>
#include <Point.h>
#include <Shape.h>
#include <stdio.h>

#include "mlvalues.h"
#include "alloc.h"
#include "memory.h"
#include "signals.h"

#include "glue.h"

extern "C" {
	extern sem_id ocaml_sem;
	escapement_delta decode_escapement_delta(value delta);
	value b_plain_font(value unit);
	value b_bold_font(value unit);

	value b_font_font(/*value unit*/);
	value b_font_getEscapementsArray_bytecode(value *argv, int argn);
	value b_font_getEscapementsArray_nativecode(value font, 
												value charArray, 
												value numChars, 
												value delta, 
												value be_point_escapementArray, 
												value offsetArray);
	value b_font_getGlyphShapes(value font, value charArray, value numChars, value glyphShapeArray);
	value b_font_getHeight(value font, value height);
	value b_font_printtostream(value font);
	value b_font_setSize(value font, value size);
	value b_font_size(value font);
	value b_font_stringWidth(value font, value string);
}

class OFont : public BFont//, public Glue 
{
	public :
		OFont(/*value self*/);		
};

OFont::OFont(/*value self*/):
	BFont()//,
//	Glue(/*self*/) 
{
}
	
//*************************
escapement_delta decode_escapement_delta(value delta){
	CAMLparam1(delta);
	escapement_delta d;
	
//	caml_leave_blocking_section();	
		d.nonspace = Double_field(delta, 0);
		d.space = Double_field(delta, 1);
//	caml_enter_blocking_section();
	
	CAMLreturnT(escapement_delta, d);
}
	
//***********************
value b_plain_font(value unit){ 
	CAMLparam1(unit);
	CAMLlocal1(font);

//	caml_leave_blocking_section();
	 	font = caml_copy_int32((int32)be_plain_font);
//	caml_enter_blocking_section();
	
 	CAMLreturn(font);
}

//***********************
value b_bold_font(value unit) 
{ 
 CAMLparam1(unit);
 CAMLlocal1(font);

//	 caml_leave_blocking_section();
	 	font = caml_copy_int32((int32)be_bold_font);
//	caml_enter_blocking_section();
	
 CAMLreturn(font);
}

//*********************
value b_font_font(/*value self*/) {
	CAMLparam0();
	CAMLlocal1(caml_font);
	
	OFont *font;
	
	font = new OFont(/*self*/);
	printf("C 0x%lx : %lx\n", font, sizeof(OFont));
	
//	caml_leave_blocking_section();
		caml_font = caml_copy_int32((int32)font);
//	caml_enter_blocking_section();
	
	CAMLreturn(caml_font);
}

//***************************
value b_font_getEscapementsArray_bytecode(value *argv, int argn){
	b_font_getEscapementsArray_nativecode(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]);
}

//****************************
value b_font_getEscapementsArray_nativecode(value font, value charArray, value numChars, value delta, value be_point_escapementArray, value be_point_offsetArray){
	CAMLparam5(font, charArray, numChars, delta, be_point_escapementArray);
	CAMLxparam1(be_point_offsetArray);

	BPoint *be_point_escapementArray_c;
	BPoint *be_point_offsetArray_c;
	char *charArray_c;
	escapement_delta *d;
	 
//	caml_leave_blocking_section();
	d				 = (escapement_delta *) malloc(sizeof(escapement_delta));
	charArray_c				   = (char   *) malloc(sizeof(char)     * Int32_val(numChars));
	be_point_escapementArray_c = (BPoint *) malloc(sizeof(BPoint *) * Int32_val(numChars));
	be_point_offsetArray_c	   = (BPoint *) malloc(sizeof(BPoint *) * Int32_val(numChars));
	 
	*d = decode_escapement_delta(delta);
	
	for(int i = 0; i < Int32_val(numChars); i++) {  //Attention si chaine unicode, size(charArray) <> numChars !!!
			charArray_c[i] = Int_val(Field(charArray, i));
	}
	
	((OFont *)Int32_val(font))->BFont::GetEscapements(charArray_c, 
													  Int32_val(numChars), 
													  d,
													  be_point_escapementArray_c,
													  be_point_offsetArray_c
													 );
	for(int i = 0; i < Int32_val(numChars); i++) {
			modify(&Field(Field(be_point_escapementArray, 0), i), 
				   copy_int32((value)&(be_point_escapementArray_c[i])));

			modify(&Field(Field(be_point_offsetArray, 0), i), 
				   copy_int32((value)&(be_point_offsetArray_c[i])));
	}
//	caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}
	

//****************************
value b_font_getGlyphShapes(value font, value charArray, value numChars, value glyphShapeArray){
	CAMLparam4(font, charArray, numChars, glyphShapeArray);
	
	BShape **glyphShapeArray_c;
	char *charArray_c;
	
//	caml_leave_blocking_section();
	charArray_c = (char *)malloc(sizeof(char) * Int32_val(numChars));
	glyphShapeArray_c = (BShape **)malloc(sizeof(BShape *)* Int32_val(numChars));
	
	for(int i = 0; i < Int32_val(numChars); i++) {
			charArray_c[i] = Int_val(Field(charArray, i));
			glyphShapeArray_c[i] = new BShape();
	}
		
	((OFont *)Int32_val(font))->BFont::GetGlyphShapes(charArray_c, Int32_val(numChars), 
													  glyphShapeArray_c);
			
	for(int i = 0; i < Int32_val(numChars); i++) {
			modify(&Field(Field(glyphShapeArray, 0), i), copy_int32((value)glyphShapeArray_c[i]));
	}
	
//	caml_enter_blocking_section();
	CAMLreturn(Val_unit);
}

//****************************
value b_font_getHeight(value font, value height){
	CAMLparam2(font, height);
	font_height hgt;
	
//	caml_leave_blocking_section();
	((OFont *)Int32_val(font))->BFont::GetHeight(&hgt);
	
	Store_double_field(Field(height, 0), 0, hgt.ascent); //Store_double_field car font_height est un record ne contenant que des float
	Store_double_field(Field(height, 0), 1, hgt.descent);
	Store_double_field(Field(height, 0), 2, hgt.leading);
	
//	caml_enter_blocking_section();
	CAMLreturn(Val_unit);
}

//************************
value b_font_printtostream(value font) {
	CAMLparam1(font);

//	caml_leave_blocking_section();
		((OFont *)Int32_val(font))->BFont::PrintToStream();
//	caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}

//************************
value b_font_setSize(value font, value size) {
	CAMLparam2(font, size);

//	caml_leave_blocking_section();
		((OFont *)Int32_val(font))->BFont::SetSize(Double_val(size));
//	caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}

//************************
value b_font_size(value font) {
	CAMLparam1(font);
	CAMLlocal1(caml_size);	
	
//	caml_leave_blocking_section();
		caml_size = caml_copy_double(((OFont *)Int32_val(font))->BFont::Size());
//	caml_enter_blocking_section();
	
	CAMLreturn(caml_size);
}

//**************************
value b_font_stringWidth(value font, value string){
	CAMLparam2(font, string);
	CAMLlocal1(caml_width);	
	
//	caml_leave_blocking_section();
		caml_width = caml_copy_double(((OFont *)Int32_val(font))->BFont::StringWidth(String_val(string)));
//	caml_enter_blocking_section();
	
	CAMLreturn(caml_width);

}
