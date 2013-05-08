#include "alloc.h"
#include "memory.h"
#include "signals.h"

#include <List.h>
#include <stdio.h>
#include "glue.h"
#include "threads.h"

extern "C" {
	extern sem_id ocaml_sem;
	value b_list_list(value self, value count);
	value b_list_addItem(value list, value item);
	value b_list_countItems(value list);
	value b_list_firstItem(value list);
	value b_list_itemAt(value list, value index);
	value b_list_removeItem(value list, value index);
}

class OList : public BList, public Glue 
{
	public :
		OList(value interne, int32 count):
			BList(count), Glue(interne) {
//			CAMLparam1(interne);
//			CAMLreturn0;
		}
};

//******************
value b_list_list(value self, value count){
	CAMLparam2(self, count);
	CAMLlocal1(list);
	//register_global_root(&list);
	
//	caml_leave_blocking_section();	
		OList *bl;
	caml_release_runtime_system();
		bl = new OList(self, Int32_val(count));
	caml_acquire_runtime_system();	
	printf("[C] b_list_list 0x%lx : %lx\n", bl, sizeof(OList));fflush(stdout);
	list = caml_copy_int32((uint32)bl);
//	caml_enter_blocking_section();
	
	CAMLreturn(list);
}

//*******************
value b_list_addItem(value list, value item){
	CAMLparam2(list, item);
	CAMLlocal1(caml_bool);

//	caml_leave_blocking_section();
		BList *bl = ((BList *)Int32_val(list));
		void *i = (void *)Int32_val(item);
		printf("[C] b_list_addItem 0x%lx\n",i);fflush(stdout);
		caml_bool = Val_bool(bl->BList::AddItem(i));
//	caml_enter_blocking_section();
	
	CAMLreturn(caml_bool);
}

//***********************
value b_list_countItems(value list) {
	CAMLparam1(list);
	CAMLlocal1(caml_count);
	int32 count;

//	caml_leave_blocking_section();
		caml_count = caml_copy_int32(((BList *)Int32_val(list))->BList::CountItems());
//	caml_enter_blocking_section();

	CAMLreturn(caml_count);
	
}

//***********************
value b_list_firstItem(value list) {
	CAMLparam1(list);
	CAMLlocal1(val);

//	caml_leave_blocking_section();
		val = caml_copy_int32((value)((BList *)Int32_val(list))->BList::FirstItem());
//	caml_enter_blocking_section();
	
	CAMLreturn(val);
}

//**************************
value b_list_itemAt(value list, value index) {
	CAMLparam2(list, index);
	CAMLlocal1(item);

//	caml_leave_blocking_section();
		item =copy_int32((value)((BList *)Int32_val(list))->BList::ItemAt(Int32_val(index)));
//	caml_enter_blocking_section();
	
	CAMLreturn(item);
}

//*************************
value b_list_removeItem(value list, value index) {
	CAMLparam2(list, index);
	CAMLlocal1(caml_res);
	void *res;
	
//	caml_leave_blocking_section();
		res =	((BList *)Int32_val(list))->BList::RemoveItem(Int32_val(index));
		caml_res = caml_copy_int32((uint32)res);
//	caml_enter_blocking_section();
	
	CAMLreturn(caml_res);
}
