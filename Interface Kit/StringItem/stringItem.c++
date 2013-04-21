#define BEOS

#include <ListItem.h>

#include "alloc.h"
#include "memory.h"
#include "mlvalues.h"


extern "C" {

	value b_stringItem_stringItem(value self, value text, value level, value expanded);
	value b_stringItem_text(value stringItem);
}

value b_stringItem_stringItem(value self, value text, value level, value expanded){
	CAMLparam3(self, text, level);
	
	BStringItem *si;
	si = new BStringItem(String_val(text), Int32_val(level), Bool_val(expanded));
	
	CAMLreturn(copy_int32((uint32)si));
}

//*********************
value b_stringItem_text(value stringItem){
	CAMLparam1(stringItem);

	CAMLreturn(copy_string(((BStringItem *)Int32_val(stringItem))->BStringItem::Text()));
}
