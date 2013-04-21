#define BEOS
#include <stdio.h>

#include "alloc.h"
#include "memory.h"
#include "signals.h"

#include <AppDefs.h>
#ifdef __cplusplus
extern "C" 
{
	value kb_about_requested(value unit) ;
	value kb_quit_requested(value unit) ;
	value kb_key_down(value unit) ;
}
#endif
//****************************
value kb_about_requested(value unit) {
	CAMLparam1(unit);
	CAMLlocal1(c);
	int32 v = (int32)B_ABOUT_REQUESTED;
	c= caml_copy_int32(v);
	CAMLreturn(c);
}

//****************************
value kb_quit_requested(value unit) {
	CAMLparam1(unit);
	CAMLlocal1(caml_res);
	
//	caml_leave_blocking_section();
		caml_res = caml_copy_int32(B_QUIT_REQUESTED);
//	caml_enter_blocking_section();

	CAMLreturn(caml_res);
}

//****************************
value kb_key_down(value unit) {
	CAMLparam1(unit);
	CAMLlocal1(caml_res);
	
//	caml_leave_blocking_section();
		caml_res = caml_copy_int32(B_KEY_DOWN);
//	caml_enter_blocking_section();

	CAMLreturn(caml_res);

}

