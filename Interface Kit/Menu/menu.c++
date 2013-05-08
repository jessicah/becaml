#include <Application.h>
#include <Menu.h>
#include <MenuItem.h>
#include "alloc.h"
#include "callback.h"
#include "memory.h"
#include "signals.h"
#include "threads.h"

#include "glue.h"
#include "handler.h"
#include "menuItem.h"

extern "C" {
	menu_layout decode_menu_layout(value layout);
	value b_menu_menu(value menu, value name, value layout);
	value b_menu_menu_width_height(value menu, value name, value width, value height);
	value b_menu_addItem(value menu, value menuItem);
	value b_menu_addItem_frame(value menu, value menuItem, value frame);
	value b_menu_addItem_submenu(value menu, value submenu);
	value b_menu_addItem_submenu_frame(value menu, value submenu, value frame);
	value b_menu_addSeparatorItem(value menu);
	value b_menu_countItems(value menu);
	value b_menu_itemAt(value menu, value index);
	value b_menu_removeItem_index(value menu, value index);
	value b_menu_removeItem_item(value menu, value item);
	value b_menu_setHighColor(value menu, value red, value green, value blue, value alpha);
	value b_menu_setHighColor_rgb(value menu, value color);
	value b_menu_setTargetForItems(value menu, value handler);
	value b_menu_submenuAt(value menu, value index);
//	extern sem_id callback_sem;
	extern sem_id ocaml_sem;
	
}

menu_layout decode_menu_layout(value layout) {
	switch(Int_val(layout)) {
		case 0 : return B_ITEMS_IN_ROW;
		case 1 : return B_ITEMS_IN_COLUMN;
		case 2 : return B_ITEMS_IN_MATRIX;
	}
}

class OMenu : public BMenu, public Glue{
	public:
		OMenu(value ocaml_menu, const char *title,
			  menu_layout layout = B_ITEMS_IN_COLUMN):
			BMenu(title, layout), Glue(ocaml_menu) {};
		OMenu(value ocaml_menu, const char *title, float width, float height):
				BMenu(title, width, height), Glue(ocaml_menu) {};

		status_t SetTargetForItems(BHandler * target);
		~OMenu(){
			b_glue_remove(this);
		}
			
};

status_t OMenu::SetTargetForItems(BHandler *target){
	CAMLparam0();
	CAMLlocal3(p_handler, ocaml_target, caml_status); 
	OHandler * o_target;	
	
//	caml_leave_blocking_section();
//		caml_menu = caml_copy_int32((int32)this);
//		caml_target = caml_copy_int32((int32)target);
	
		////**acquire_sem(callback_sem);
	caml_acquire_runtime_system();	
		p_handler = alloc_small(1,Abstract_tag);
		caml_register_global_root(&p_handler); //TODO unregister
		
		ocaml_target = caml_callback(*caml_named_value("new_be_handler"), p_handler);	
	caml_release_runtime_system();
		o_target = new OHandler(ocaml_target, target);
	caml_acquire_runtime_system();
		Field(p_handler,1) = (value)o_target;
		caml_status = caml_callback2(caml_get_public_method(interne, hash_variant("setTargetForItems")), interne, ocaml_target);
	caml_release_runtime_system();	
		////**release_sem(callback_sem);
//	caml_enter_blocking_section();
	CAMLreturn(caml_status);
}
//********************
value b_menu_menu(value self, value name, value layout){
	CAMLparam3(self, name, layout);
	CAMLlocal1(p_menu);

	OMenu *m;
	caml_release_runtime_system();
		m = new OMenu(self, String_val(name), decode_menu_layout(layout));
	caml_acquire_runtime_system();
	p_menu = alloc_small(1,Abstract_tag);
	Field(p_menu,0) = (value)m;

//	caml_leave_blocking_section();
//	caml_enter_blocking_section();
		
	CAMLreturn(p_menu);
}

//********************
value b_menu_menu_width_height(value self, value name, value width, value height){
	CAMLparam4(self, name, width, height);
	CAMLlocal1(menu);

	OMenu *m;
       	caml_release_runtime_system();
		m = new OMenu(self, String_val(name), 
				    Double_val(width),
				    Double_val(height));
	caml_acquire_runtime_system();

//	caml_leave_blocking_section();
		menu = caml_copy_int32((int32)m);
//	caml_enter_blocking_section();
	
	CAMLreturn(menu);
}

//***********************
value b_menu_addItem(value menu, value menuItem) {
	CAMLparam2(menu, menuItem);
	
	OMenu * m =	((OMenu *)Field(menu,0));
	OMenuItem * mi = ((OMenuItem *)Field(menuItem,0));

	CAMLreturn(Val_bool(m->BMenu::AddItem(mi)));
}

//***********************
value b_menu_addItem_frame(value menu, value menuItem, value frame) {
	CAMLparam3(menu, menuItem, frame);

	BMenu *me = (BMenu *)Int32_val(menu);
	BMenuItem *mi = (BMenuItem *)Int32_val(menuItem);
	
	CAMLreturn(Val_bool(((BMenu *)Int32_val(menu))->BMenu::AddItem((BMenuItem *)Int32_val(menuItem),
																   *(BRect *)Int32_val(frame)
														   		  )));
}

//***********************
value b_menu_addItem_submenu(value menu, value submenu) {
	CAMLparam2(menu, submenu);
	OMenu *m = (OMenu *)Int32_val(menu);
	OMenu *sm = (OMenu *)Int32_val(submenu);
	
	CAMLreturn(Val_bool(m->BMenu::AddItem(sm)));
}

//***********************
value b_menu_addItem_submenu_frame(value menu, value submenu, value frame) {
	CAMLparam3(menu, submenu, frame);

	CAMLreturn(Val_bool(((BMenu *)Int32_val(menu))->BMenu::AddItem((BMenu *)Int32_val(submenu),
																   *(BRect *)Int32_val(frame)
														   )));
}

//***********************
value b_menu_addSeparatorItem(value menu) {
	CAMLparam1(menu);

	CAMLreturn(Val_bool(((OMenu *)Field(menu,0))->BMenu::AddSeparatorItem()));
}

//***********************
value b_menu_countItems(value menu){
	CAMLparam1(menu);
	CAMLlocal1(caml_items);
	
//	caml_leave_blocking_section();
		caml_items = caml_copy_int32(((BMenu *)Int32_val(menu))->BMenu::CountItems());
//	caml_enter_blocking_section();

	CAMLreturn(caml_items);
}

//*************************
value b_menu_itemAt(value menu, value index){
	CAMLparam2(menu, index);
	CAMLlocal1(caml_item);
	
//	caml_leave_blocking_section();
		caml_item = caml_copy_int32((value)((BMenu *)Int32_val(menu))->BMenu::ItemAt(Int32_val(index)));
//	caml_enter_blocking_section();

	CAMLreturn(caml_item);
}

//***************************
value b_menu_removeItem_index(value menu, value index){
	CAMLparam2(menu, index);
	CAMLlocal1(caml_index);

	BMenuItem *item = ((BMenu *)Int32_val(menu))->BMenu::RemoveItem(Int32_val(index));
	
//	caml_leave_blocking_section();
		caml_index = caml_copy_int32((value)item);
//	caml_enter_blocking_section();

	CAMLreturn(caml_index);
}

//***************************
value b_menu_removeItem_item(value menu, value item){
	CAMLparam2(menu, item);

	bool res = ((BMenu *)Int32_val(menu))->BMenu::RemoveItem((BMenuItem *)Int32_val(item));
	
	CAMLreturn(Val_bool(res));
}

//*************************
value b_menu_setHighColor(value menu, value red, value green, value blue, value alpha){
	CAMLparam5(menu, red, green, blue, alpha);

	((BMenu *)Int32_val(menu))->BMenu::SetHighColor(Int_val(red),
													Int_val(green),
													Int_val(blue),
													Int_val(alpha));

	CAMLreturn(Val_unit);
}

//*************************
value b_menu_setHighColor_rgb(value menu, value color){
	CAMLparam2(menu, color);
	rgb_color couleur;

	couleur.red   = Int_val(Field(color, 0));
	couleur.green = Int_val(Field(color, 1));
	couleur.blue  = Int_val(Field(color, 2));
	couleur.alpha = Int_val(Field(color, 3));
	
	((BMenu *)Int32_val(menu))->BMenu::SetHighColor(couleur);
	
	CAMLreturn(Val_unit);
}

//***********************
value b_menu_setTargetForItems(value menu, value handler) {
	CAMLparam2(menu, handler);
	CAMLlocal1(caml_status);
	
	OMenu *m = (OMenu *)Field(menu,0);
	BApplication * a = be_app;
	OHandler *h = (OHandler *)Field(handler,0);
	status_t status;

	caml_release_runtime_system();
		status = m->BMenu::SetTargetForItems(h); 
	caml_acquire_runtime_system();
//	caml_leave_blocking_section();
		caml_status = caml_copy_int32(status);
//	caml_enter_blocking_section();

	CAMLreturn(caml_status);
}

//*************************
value b_menu_submenuAt(value menu, value index){
	CAMLparam2(menu, index);
	CAMLlocal1(caml_submenu);

//	caml_leave_blocking_section();
		caml_submenu = caml_copy_int32((value)((BMenu *)Int32_val(menu))->BMenu::SubmenuAt(Int32_val(index)));
//	caml_enter_blocking_section();
	
	CAMLreturn(caml_submenu);
}
