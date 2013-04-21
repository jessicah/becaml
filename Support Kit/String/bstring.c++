#ifndef BEOS
	#define BEOS
#endif

#include <String.h>
#include <stdio.h>

#include "alloc.h"
#include "memory.h"
#include "signals.h"

#include "glue.h"

extern "C" {
	extern sem_id ocaml_sem;
	value b_string_string_string(/*value self,*/ value chaine);
	value b_string_length(value string);
	value b_string_string(value string);
}

class OString : public BString//, public Glue 
{
	public :
			OString(/*value self,*/ char *string);
};

OString::OString(/*value self,*/ char *string) :
	BString(string)//,
//	Glue(/*self*/)
{
}

//******************
value b_string_string_string(/*value self,*/ value chaine) {
	CAMLparam1(/*self,*/ chaine);
	CAMLlocal1(caml_string);
	OString *st;
	
//	caml_leave_blocking_section();
		st = new OString(/*self,*/ String_val(chaine));
		printf("C 0x%lx : %lx\n", st, sizeof(OString));
		caml_string = caml_copy_int32((int32)st);
//	caml_enter_blocking_section();
	
	CAMLreturn(caml_string);
}

//********************
value b_string_length(value string){
	CAMLparam1(string);
	CAMLlocal1(caml_length);

//	caml_leave_blocking_section();
		caml_length = caml_copy_int32(((OString *)Int32_val(string))->BString::Length());
//	caml_enter_blocking_section();
	
	CAMLreturn(caml_length);
}

//******************
value b_string_string(value string) {
	CAMLparam1(string);
	CAMLlocal1(caml_string);

//	caml_leave_blocking_section();
		caml_string = caml_copy_string(((OString *)Int32_val(string))->BString::String());
//	caml_enter_blocking_section();
	
	CAMLreturn(caml_string);
}


