#define BEOS

#include <Looper.h>
#include <TextView.h>
#include <MessageFilter.h>

#include "mlvalues.h"
#include "memory.h"

extern "C" {

	value b_textView_addFilter(value textView, value filter);
}

//***********
value b_textView_addFilter(value textView, value filter) {
  
	CAMLparam2(textView,filter);
 	BMessageFilter *mf;
	
	mf = (BMessageFilter *)Int32_val(filter);
 
	((BTextView *)Int32_val(textView))->BTextView::AddFilter(mf);
  
	CAMLreturn(Val_unit);
}
