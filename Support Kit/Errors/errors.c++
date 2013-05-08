#include <Errors.h>

#include "mlvalues.h"
#include "alloc.h"
#include "memory.h"
#include "signals.h"

extern "C" {
		value k_B_NO_ERROR(value unit);
}

//*********************
value k_B_NO_ERROR(value unit) {
	CAMLparam1(unit);
	CAMLlocal1(caml_err);

//	caml_leave_blocking_section();
		caml_err = caml_copy_int32(B_NO_ERROR);
//	caml_enter_blocking_section();

	CAMLreturn(caml_err);
}
