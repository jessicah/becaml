#define BEOS

#include <ScrollBar.h>

#include "memory.h"
#include "mlvalues.h"

extern "C" {

	value b_scrollBar_setRange(value scrollBar, value min, value max);
}

//*******************************
value b_scrollBar_setRange(value scrollBar, value min, value max){
	CAMLparam3(scrollBar, min, max);

	((BScrollBar *)Int32_val(scrollBar))->BScrollBar::SetRange(Double_val(min), Double_val(max));
	
	CAMLreturn(Val_unit);
}
