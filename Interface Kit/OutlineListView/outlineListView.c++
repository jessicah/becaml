#include <OutlineListView.h>
#include <ListItem.h>
#include <stdio.h>

#include "mlvalues.h"
#include "alloc.h"
#include "memory.h"

#include "glue.h"
#include "listView.h"

extern "C" {
	extern sem_id ocaml_sem;
	value b_outlineListView_outlineListView_bytecode(value *argv, int argc);
	value b_outlineListView_outlineListView_nativecode(value self, value frame, value name, value list_view_type, value resizingMode, value flags);	
	value b_outlineListView_addItem(value outlineListView, value item);
	value b_outlineListView_addItem_index(value outlineListView, value item, value index);
	value b_outlineListView_countItemsUnder(value outlineListView, value underItem, value oneLevelOnly);
	value b_outlineListView_fullListIndexOf(value outlineListView, value item);
	value b_outlineListView_itemUnderAt(value outlineListView, value underItem, value oneLevelOnly, value index);
	value b_outlineListView_removeItem(value outlineListView, value index);
	value b_outlineListView_removeItem_item(value outlineListView, value item);
	value b_outlineListView_setTarget_handler(value outlineListView, value handler);
	value b_outlineListView_superitem(value outlineListView, value item);
}

class OOutlineListView : public BOutlineListView, public Glue {
	public :
			OOutlineListView(value self, BRect frame, char *name, list_view_type view_type, uint32 resizingMode, uint32 flags) :
				BOutlineListView(frame, name, view_type, resizingMode, flags),
				Glue(self){}
			void Draw(BRect updateRect){
				printf("OOutlineListView::Draw appele.\n");
				BOutlineListView::Draw(updateRect);
				return;
			}
};

//*************************
value b_outlineListView_outlineListView_bytecode(value *argv, int argc){
	return b_outlineListView_outlineListView_nativecode(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]);
}

//************************
value b_outlineListView_outlineListView_nativecode(value self, value frame, value name, value list_view_type, value resizingMode, value flags){
	CAMLparam5(self, frame, name, list_view_type, resizingMode);
	CAMLxparam1(flags);

	OOutlineListView *lv = new OOutlineListView(self,
												*(BRect *)Int32_val(frame),
												String_val(name),
												decode_list_view_type(list_view_type),
												Int32_val(resizingMode),
												Int32_val(flags)
											   );

	CAMLreturn(copy_int32((int32)lv));
}

//*********************************
value b_outlineListView_addItem(value outlineListView, value item){
	CAMLparam2(outlineListView, item);
	BOutlineListView *olv = ((BOutlineListView *)Int32_val(outlineListView));
	BListItem *li = (BListItem *)Int32_val(item);
	
	CAMLreturn(Val_bool(olv->BOutlineListView::AddItem(li)));
}

//*********************************
value b_outlineListView_addItem_index(value outlineListView, value item, value index){
	CAMLparam3(outlineListView, item, index);
	BOutlineListView *olv = ((BOutlineListView *)Int32_val(outlineListView));
	BListItem * li = (BListItem *)Int32_val(item);
	int i = Int32_val(index);

	CAMLreturn(Val_bool(olv->BOutlineListView::AddItem(li,i)));
}

//********************************
value b_outlineListView_countItemsUnder(value outlineListView, value underItem, value oneLevelOnly){
	CAMLparam3(outlineListView, underItem, oneLevelOnly);

	CAMLreturn(copy_int32(((BOutlineListView *)Int32_val(outlineListView))->BOutlineListView::CountItemsUnder(((BListItem *)Int32_val(underItem)), Bool_val(oneLevelOnly))));
}

//************************************
value b_outlineListView_fullListIndexOf(value outlineListView, value item){
	CAMLparam2(outlineListView, item);

	CAMLreturn(copy_int32(((BOutlineListView *)Int32_val(outlineListView))->BOutlineListView::FullListIndexOf(((BListItem *)Int32_val(item)))));
}

//***********************
value b_outlineListView_itemUnderAt(value outlineListView, value underItem, value oneLevelOnly, value index){
	CAMLparam4(outlineListView, underItem, oneLevelOnly, index);

	CAMLreturn(copy_int32((value) ((BOutlineListView *)Int32_val(outlineListView))->BOutlineListView::ItemUnderAt((BListItem *)Int32_val(underItem), Bool_val(oneLevelOnly), Int32_val(index))));
}

//************************************
value b_outlineListView_removeItem(value outlineListView, value index){
	CAMLparam2(outlineListView, index);
	BListItem *item = ((BOutlineListView *)Int32_val(outlineListView))->
						BOutlineListView::RemoveItem(Int32_val(index));
					
	CAMLreturn( copy_int32( (value)item ) );
}

//************************************
value b_outlineListView_removeItem_item(value outlineListView, value item){
	CAMLparam2(outlineListView, item);
	bool res = ((BOutlineListView *)Int32_val(outlineListView))->
						BOutlineListView::RemoveItem((BListItem *)Int32_val(item));
					
	CAMLreturn(Val_bool(res));
}

//******************************
value b_outlineListView_setTarget_handler(value outlineListView, value handler){
	CAMLparam2(outlineListView, handler);
	status_t res = ((BOutlineListView *)Int32_val(outlineListView))->BOutlineListView::SetTarget((BHandler *)Int32_val(handler));

	CAMLreturn(copy_int32(res));
}

//******************************
value b_outlineListView_superitem(value outlineListView, value item){
	CAMLparam2(outlineListView, item);

	CAMLreturn(copy_int32((value) ((BOutlineListView *)Int32_val(outlineListView))->BOutlineListView::Superitem((const BListItem *)Int32_val(item))));
}

