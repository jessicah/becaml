#define BEOS

#include <ListItem.h>

#include "alloc.h"
#include "mlvalues.h"
#include "memory.h"

extern "C" {

	value b_listItem_outlineLevel(value listItem);
}

//****************
value b_listItem_outlineLevel(value listItem){
	CAMLparam1(listItem);

	CAMLreturn(copy_int32(((BListItem *)Int32_val(listItem))->BListItem::OutlineLevel()));
}

