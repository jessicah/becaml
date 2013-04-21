#define BEOS

#include <OS.h>

#include "alloc.h"
#include "memory.h"

extern "C" {
	value b_threads_snooze(value t);
}

value b_threads_snooze(value t) {
	CAMLparam1(t);

	CAMLreturn(copy_int32(snooze(Int64_val(t))));
}


