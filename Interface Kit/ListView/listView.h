#ifndef BEOS
	#define BEOS
#endif

#include <ListView.h>

#include "alloc.h"
#include "mlvalues.h"
#include "memory.h"

extern "C" {

	list_view_type decode_list_view_type(value list_view_type);
	
	value b_listView_addItem(value listView, value item);
	value b_listView_addItem_index(value listView, value item, value index);
	value b_listView_currentSelection(value listView, value index);
	value b_listView_itemAt(value listView, value index);
	value b_listView_itemFrame(value listView, value index);
	value b_listView_removeItem(value listView, value index);
	value b_listView_setSelectionMessage(value listView, value message);
}
