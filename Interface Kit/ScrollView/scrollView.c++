#ifndef BEOS
	#define BEOS
#endif

#include <ScrollView.h>

#include "mlvalues.h"
#include "memory.h"
#include "alloc.h"

#include "glue.h"
#include "interfaceDefs.h"

extern "C" {
	extern sem_id ocaml_sem;
	value b_scrollView_scrollView_bytecode(value *argv, int argn);
	value b_scrollView_scrollView_nativecode(value self, value name, value target, value resizingMode, value flags, value horizontal, value vertical, value border);
	value b_scrollView_scrollBar(value scrollView, value orientation);
}

class OScrollView : public BScrollView, public Glue {
	public :
		OScrollView(value self, char *name, BView *target, uint32 resizingMode, uint32 flags, bool horizontal, bool vertical, border_style border):
				BScrollView(name, target, resizingMode, flags, horizontal, vertical, border),
				Glue(self){}
		
};

//**********************
value b_scrollView_scrollView_bytecode(value *argv, int argn){
	return b_scrollView_scrollView_nativecode(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6], argv[7]);
}

//************************
value b_scrollView_scrollView_nativecode(value self, value name, value target, value resizingMode, value flags, value horizontal, value vertical, value border){
	CAMLparam5(self, name, target, resizingMode, flags);
	CAMLxparam3(horizontal, vertical, border);

	OScrollView *sv = new OScrollView(self,
									  String_val(name),
									  (BView *)Int32_val(target),
									  Int32_val(resizingMode),
									  Int32_val(flags),
									  Bool_val(horizontal),
									  Bool_val(vertical),
									  decode_border_style(border));
	
	CAMLreturn(copy_int32((int32)sv));
}

//**********************
value b_scrollView_scrollBar(value scrollView, value orientation){
	CAMLparam2(scrollView, orientation);

	CAMLreturn(copy_int32((int32) ((BScrollView *)Int32_val(scrollView))->BScrollView::ScrollBar(decode_orientation(orientation))));

}
