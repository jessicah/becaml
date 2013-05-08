#include <stdio.h>
#ifndef BEOS
	#define BEOS
#endif

#include <Rect.h>
#include <Shape.h> 

#include "glue.h"

#include "alloc.h"
#include "callback.h"
#include "memory.h"
#include "mlvalues.h"
#include "signals.h"
#include "threads.h"

extern "C" {
	extern sem_id ocaml_sem;
	value b_shape_shape(/*value self*/);
	value b_shape_bounds(/*value self*/);
	value b_shapeIterator_shapeIterator(/*value self*/);
	value b_shapeIterator_iterate(value shapeIterator, value shape);
}

class OShape: public BShape, public Glue {
	public :

		OShape(value ocaml_objet):
			BShape(),
			Glue(ocaml_objet){
		}
};

class OShapeIterator : public BShapeIterator, public Glue {
	public :

		OShapeIterator(value ocaml_objet):
			BShapeIterator(),
			Glue(ocaml_objet){
		}

		status_t Iterate(BShape *shape);
			
};


status_t OShapeIterator::Iterate(BShape *shape){
	//CAMLparam1(interne);
	CAMLparam0();
	CAMLlocal1(res_caml);
			
	printf("appel de OShapeIterator->Iterate\n");fflush(stdout);
//	//**acquire_sem(ocaml_sem);
	caml_leave_blocking_section();
	res_caml = caml_callback(*caml_named_value("OShapeIterator::Iterate"),/* *interne,*/
									caml_copy_int32((int32)shape));
	caml_enter_blocking_section();
//	//**release_sem(ocaml_sem);
	CAMLreturn(res_caml);
}

//***********************
value b_shapeIterator_shapeIterator(value self){
	CAMLparam1(self);
	CAMLlocal1(os_caml);
	OShapeIterator *os;

	os = new OShapeIterator(self);
	
//	//**acquire_sem(ocaml_sem);
	caml_leave_blocking_section();
		os_caml = caml_copy_int32((int32)os);
	caml_enter_blocking_section();
//	//**release_sem(ocaml_sem);
	
	CAMLreturn(os_caml);
}

//***********************
value b_shape_shape(value self){
	CAMLparam1(self);
	CAMLlocal1(caml_shape);	
	OShape *os;

	os = new OShape(self);
	caml_shape = caml_copy_int32((int32)os);
	
	CAMLreturn(caml_shape);
}

//***********************
value b_shape_bounds(value shape){
	CAMLparam1(shape);
	CAMLlocal1(bounds);
	BRect *r;

	r = new BRect(((OShape *)Int32_val(shape))->BShape::Bounds());
	bounds = caml_copy_int32((int32)r);

	CAMLreturn(bounds);
}

//*****************************
value b_shapeIterator_iterate(value shapeIterator, value shape){
	CAMLparam2(shapeIterator, shape);
	OShapeIterator *osi;
	BShape *s;
	
//	//**acquire_sem(ocaml_sem);
		osi = (OShapeIterator *)Int32_val(shapeIterator);
		s =   (BShape *)Int32_val(shape);
	caml_enter_blocking_section();
//	//**release_sem(ocaml_sem);
	
	osi->BShapeIterator::Iterate(s);
	caml_leave_blocking_section();
	
	CAMLreturn(Val_unit);
}
