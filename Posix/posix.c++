#include "alloc.h"
#include "mlvalues.h"
#include "memory.h"


extern "C" {

	value memcpy_be(value dst, value src, value len);
}

//***********************
value memcpy_be(value dst, value src, value len){
	CAMLparam3(dst, src, len);

	CAMLreturn(copy_int32((value)memcpy((void *)Int32_val(dst), (void *)Int32_val(src), Int32_val(len))));
}
