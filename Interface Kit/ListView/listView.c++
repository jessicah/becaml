#include <stdio.h>
#include "listView.h"

list_view_type decode_list_view_type(value list_view_type){
	CAMLparam1(list_view_type);

	switch(Int_val(list_view_type)) {
		case 0 :	CAMLreturnT(enum list_view_type, B_SINGLE_SELECTION_LIST); 
		case 1 :	CAMLreturnT(enum list_view_type, B_MULTIPLE_SELECTION_LIST); 
	}
}

//***************************
value b_listView_addItem(value listView, value item){
	CAMLparam2(listView, item);

	CAMLreturn(Val_bool(((BListView *)Int32_val(listView))->BListView::AddItem((BListItem *)Int32_val(item))));
}

//***************************
value b_listView_addItem_index(value listView, value item, value index){
	CAMLparam3(listView, item, index);

	CAMLreturn(Val_bool(((BListView *)Int32_val(listView))->BListView::AddItem((BListItem *)Int32_val(item), Int32_val(index))));
}

//*****************************
value b_listView_currentSelection(value listView, value index){
	CAMLparam2(listView, index);

	CAMLreturn(copy_int32(((BListView *)Int32_val(listView))->BListView::CurrentSelection(Int32_val(index))));
}

//***************************
value b_listView_itemAt(value listView, value index){
	CAMLparam2(listView, index);

	CAMLreturn(copy_int32((value) ((BListView *)Int32_val(listView))->BListView::ItemAt(Int32_val(index))));
}

//***************************
value b_listView_itemFrame(value listView, value index){
	CAMLparam2(listView, index);
	
	BRect *r;
	r = new BRect(((BListView *)Int32_val(listView))->BListView::ItemFrame(Int32_val(index)));

	printf("C 0x%lx : %lx\n", r, sizeof(BRect));
	CAMLreturn(copy_int32((value)r));
}

//*****************************
value b_listView_removeItem(value listView, value index){
	CAMLparam2(listView, index);
	CAMLreturn(copy_int32((value) ((BListView *)Int32_val(listView))->BListView::RemoveItem(Int32_val(index))));
}

//*****************************
value b_listView_setSelectionMessage(value listView, value message){
	CAMLparam2(listView, message);

	((BListView *)Int32_val(listView))->BListView::SetSelectionMessage((BMessage *)Int32_val(message));
	
	CAMLreturn(Val_unit);
}

