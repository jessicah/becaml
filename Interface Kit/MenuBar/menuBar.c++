#define BEOS

#include <cstdio>
#include <MenuBar.h>

#include "alloc.h"
#include "memory.h"
#include "signals.h"

#include "glue.h"
#include "menu.h"

extern "C" {
	extern sem_id ocaml_sem;
	value b_menuBar_menuBar_nativecode(value frame, value name, value resizingMode, value layout, value resizeToFit);
//	value b_menuBar_menuBar_bytecode(value *argv, int argn);
	value b_menuBar_addItem(value menuBar, value menuItem);
	value b_menuBar_addItem_frame(value menuBar, value menuItem, value frame);
	value b_menuBar_addItem_submenu(value menuBar, value submenu);
	value b_menuBar_addItem_submenu_index(value menuBar, value submenu, value index);
	value b_menuBar_addItem_submenu_frame(value menuBar, value submenu, value frame);
}

class OMenuBar : public BMenuBar//, public Glue 
{
	public :
		OMenuBar(/*value self,*/ BRect frame, char *name, int32 resizingMode, menu_layout layout, bool resizeToFit) :
				BMenuBar(frame, name, resizingMode, layout, resizeToFit)
				//, Glue(self)
				{}
		~OMenuBar(){
			b_glue_remove(this);
		}

};


value b_menuBar_menuBar_nativecode(/*value self,*/ value frame, value name, value resizingMode, value layout, value resizeToFit){
	//**acquire_sem(ocaml_sem);
	CAMLparam5(/*self,*/ frame, name, resizingMode, layout, resizeToFit);
//	CAMLxparam1(resizeToFit);
	CAMLlocal1(menuBar);
	//caml_register_global_root(&menuBar);
	//**release_sem(ocaml_sem);
	
	OMenuBar *mb = new OMenuBar(//self,
								*(BRect *)Int32_val(frame),
								String_val(name),
								Int32_val(resizingMode),
								decode_menu_layout(Int_val(layout)),
								Bool_val(resizeToFit));
//	caml_leave_blocking_section();
		menuBar = caml_copy_int32((value)mb);
		printf("[C++]b_menuBar_menuBar_nativecode menuBar=0x%lx\n", menuBar);fflush(stdout);
//	caml_enter_blocking_section();
	CAMLreturn(menuBar);
}
	
//***************************
value b_menuBar_menuBar_bytecode(value *argv, int argn){
	return b_menuBar_menuBar_nativecode(argv[0], argv[1], argv[2], argv[3], argv[4]/*, argv[5]*/);
}

//***********************
value b_menuBar_addItem(value menuBar, value menuItem) {
	CAMLparam2(menuBar, menuItem);
	BMenu *me = (BMenuBar *)Int32_val(menuBar);
	BMenuItem *mi = (BMenuItem *)Int32_val(menuItem);
	
	CAMLreturn(Val_bool(((BMenuBar *)Int32_val(menuBar))->BMenuBar::AddItem((BMenuItem *)Int32_val(menuItem))));
}

//***********************
value b_menuBar_addItem_frame(value menuBar, value menuItem, value frame) {
	CAMLparam3(menuBar, menuItem, frame);

	BMenu *me = (BMenuBar *)Int32_val(menuBar);
	BMenuItem *mi = (BMenuItem *)Int32_val(menuItem);
	
	CAMLreturn(Val_bool(((BMenuBar *)Int32_val(menuBar))->BMenuBar::AddItem((BMenuItem *)Int32_val(menuItem),
																			*(BRect *)Int32_val(frame)
														   		  		   )));
}

//***********************
value b_menuBar_addItem_submenu(value menuBar, value submenu) {
	CAMLparam2(menuBar, submenu);

	OMenuBar *mb = (OMenuBar *)Int32_val(menuBar);
	BMenu *mi = (BMenu *)Int32_val(submenu);
	
	CAMLreturn(Val_bool(mb->BMenuBar::AddItem(mi)));
}

//****************************
value b_menuBar_addItem_submenu_index(value menuBar, value submenu, value index){
	CAMLparam3(menuBar, submenu, index);

	CAMLreturn(Val_bool(((BMenuBar *)Int32_val(menuBar))->BMenuBar::AddItem((BMenu *)Int32_val(submenu), Int32_val(index))));
}

//***********************
value b_menuBar_addItem_submenu_frame(value menuBar, value submenu, value frame) {
	CAMLparam3(menuBar, submenu, frame);

	CAMLreturn(Val_bool(((BMenuBar *)Int32_val(menuBar))->BMenuBar::AddItem((BMenu *)Int32_val(submenu),
																  			*(BRect *)Int32_val(frame)
																		   )));
}

