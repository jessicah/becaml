#ifndef BEOS
	#define BEOS
#endif

#include <SupportDefs.h> 

#include "glue.h"
#include "stdio.h"

#include "alloc.h"
#include "callback.h"
#include "memory.h"
#include "mlvalues.h"
#include "signals.h"

#ifdef __cplusplus
	extern "C" {
#endif
		value be(value unit);
		//	value print_be(value be);
		value b_glue_delete(value objet);
		void b_glue_remove(void *c_object);
#ifdef __cplusplus
	}
#endif
//sem_id callback_sem = create_sem(100000000,"callback_sem");
//sem_id ocaml_sem = create_sem(1,"ocaml_sem");
//thread_id beos_thread = -1;
//***********************

Glue::Glue(/*value objet*/) {/*
	CAMLparam1(objet);
	interne = (value *)malloc(sizeof(value));
//	caml_register_global_root(interne);	
//	caml_register_global_root(&objet);

	*interne = objet;
	CAMLreturn0;
	*/
}

void b_glue_remove(void *c_object){
	CAMLparam0();
		printf("[C] destruction de 0x%lx\n", (int32)c_object);fflush(stdout);
		caml_leave_blocking_section();
			callback(*caml_named_value("glue::remove"), copy_int32((int32)c_object));	

			caml_enter_blocking_section();
	CAMLreturn0;
}

value be(value unit){ 
 CAMLparam1(unit);
 //CAMLlocal1(val_be);

 //caml_register_global_root(&val_be);
 
 //val_be = copy_int32((value)NULL);

 CAMLreturn(caml_copy_int32((value)NULL));
}

//***************
value print_be(value be) { 
 CAMLparam1(be);


 CAMLreturn(Val_unit);
}

//********************
value b_glue_delete(value objet){
	CAMLparam1(objet);
	
	delete((void*)(int32)Int32_val(objet));

	CAMLreturn(Val_unit);
}



