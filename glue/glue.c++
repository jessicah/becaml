#include <SupportDefs.h> 

#include "glue.h"
#include "stdio.h"

#include "alloc.h"
#include "callback.h"
#include "memory.h"
#include "mlvalues.h"
#include "signals.h"
#include "threads.h"

#ifdef __cplusplus
	extern "C" {
#endif
		value b_c_null(value unit);
		//	value print_be(value be);
		value b_glue_delete(value objet);
	//	void b_glue_remove(void *c_object);
	value b_glue_compare_pointer(value ptr1, value ptr2);
	value b_glue_associate_c_object(value ocaml_object);
	

#ifdef __cplusplus
	}
#endif
//sem_id callback_sem = create_sem(100000000,"callback_sem");
//sem_id ocaml_sem = create_sem(1,"ocaml_sem");
//thread_id beos_thread = -1;
//***********************

Glue::Glue(value ocaml_objet) {
/*	thread_info th_info;
	get_thread_info(find_thread(NULL),&th_info);
	if (th_info.team != th_info.thread) {
		caml_c_thread_register();
	}
*/	
	CAMLparam1(ocaml_objet);
	caml_acquire_runtime_system();
		caml_register_global_root(&interne);
		interne = ocaml_objet;
	caml_release_runtime_system();
	CAMLreturn0;
}

value b_glue_associate_c_object(value be_interne) {
CAMLparam1(be_interne);
CAMLlocal1(pointer);

Glue *obj = new Glue(be_interne);

pointer=caml_alloc_small(1,Abstract_tag);
Field(pointer, 1) = (long int)obj;

CAMLreturn(pointer);
}
void b_glue_remove(void *c_object){
	CAMLparam0();
		printf("[C] destruction de 0x%lx\n", (int32)c_object);fflush(stdout);
		caml_leave_blocking_section();
			callback(*caml_named_value("glue::remove"), copy_int32((int32)c_object));	

			caml_enter_blocking_section();
	CAMLreturn0;
}

value b_c_null(value unit){ 
 CAMLparam1(unit);
 CAMLlocal1(val_be);

 val_be = alloc_small(1,Abstract_tag);
 caml_register_global_root(&val_be);
 Field(val_be,0) = (value)NULL;
 
 CAMLreturn(val_be);
}

value b_glue_compare_pointer(value ptr1, value ptr2){
}

//***************
value print_be(value be) { 
 CAMLparam1(be);


 CAMLreturn(Val_unit);
}

//********************
value b_glue_delete(value objet){
	CAMLparam1(objet);
	
//	delete((void*)(int32)Int32_val(objet));

	CAMLreturn(Val_unit);
}



