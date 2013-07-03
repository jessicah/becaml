#include "point_rect.h"
#include <stdio.h>

#include "signals.h"
extern "C" {

 extern sem_id ocaml_sem;
 value b_point_point(value interne);
 value b_point_point_point(value interne, value point);
 value b_point_point_x_y(value interne, value x, value y);
 
 value b_point_set(value point, value x, value y);
 value b_point_set_x(value point, value x);
 value b_point_set_y(value point ,value y);
 value b_point_constrainTo();
 value b_point_printtostream(value point);
 value b_point_x(value point);
 value b_point_y(value point);
 
 value b_rect_rect_left(value interne, value left, value top, value right, value bottom); 
 value b_rect_rect_leftTop(value interne, value leftTop, value rightBottom);
 value b_rect_rect(value interne, value rect_param);
 value b_rect(value interne);
 value b_rect_insetBy_x_y(value rect, value x, value y);
 value b_rect_left(value rect);
 value b_rect_top(value rect);
 value b_rect_right(value rect);
 value b_rect_bottom(value rect);
 value b_rect_offsetBy_x_y(value rect, value x, value y);
 value b_rect_offsetTo_point(value rect, value point);
 value b_rect_offsetTo(value rect, value x, value y);
 value b_rect_printtostream(value rect);
 value b_rect_set(value rect, value left, value top, value right, value bottom);
 value b_rect_width(value rect);
 value b_rect_height(value rect);
}

//**************************
value b_point_point(value interne){
	CAMLparam1(interne);
	CAMLlocal1(p_point);

	p_point = alloc_small(1,Abstract_tag);
	caml_register_global_root(&p_point);

	////register_global_root(&point); INUTILE
	OPoint *p;
	caml_release_runtime_system();
		p = new OPoint(interne);
	caml_acquire_runtime_system();
	Field(p_point,0) = (value)p;

	CAMLreturn(p_point);
}

//*******************************
value b_point_point_point(value ocaml_point, value param_point){
	CAMLparam2(ocaml_point, param_point);
	CAMLlocal1(p_param_point);
	//register_global_root(&be_point);

	OPoint *p,*opoint;
	opoint = (OPoint *)Field(param_point,0);
	
	p_param_point = alloc(1,Abstract_tag);
	caml_register_global_root(&p_param_point);

	caml_release_runtime_system();
		p = new OPoint(ocaml_point, *opoint);
	caml_acquire_runtime_system();

	Field(p_param_point,0) = (value)p;
	CAMLreturn(p_param_point);
}

//*******************************
value b_point_point_x_y(value interne, value x, value y){
	CAMLparam3(interne, x, y);
	CAMLlocal1(p_point);

	p_point = alloc_small(1,Abstract_tag);
	caml_register_global_root(&p_point);

	////register_global_root(&point); INUTILE
	OPoint *p;
	caml_release_runtime_system();
		p = new OPoint(interne, Double_val(x), Double_val(y));
	caml_acquire_runtime_system();
	Field(p_point,0) = (value)p;

	CAMLreturn(p_point);
}

//*************************
value b_point_printtostream(value point)
{
 CAMLparam1(point);
 
 ((BPoint *)Field(point,0))->PrintToStream();
 
 CAMLreturn(Val_unit);
}


//********************
value b_point_set(value point, value x, value y){
	CAMLparam3(point, x, y);

	((BPoint *)Field(point,0))->Set(Double_val(x), Double_val(y));
	 
	CAMLreturn(Val_unit);
}

//********************
value b_point_set_x(value point, value x){
	CAMLparam2(point, x);

	((BPoint *)Field(point,0))->x = Double_val(x);
	 
	CAMLreturn(Val_unit);
}

//********************
value b_point_set_y(value point, value y){
	CAMLparam2(point, y);

	((BPoint *)Field(point,0))->y = Double_val(y);
	 
	CAMLreturn(Val_unit);
}

//************************
 value b_point_constrainTo(){}

//*************************
value b_point_x(value point){
 	CAMLparam1(point);
	CAMLlocal1(caml_x);

//	caml_leave_blocking_section();
		caml_x = caml_copy_double(((BPoint *)Field(point,0))->x);
//	caml_enter_blocking_section();

	CAMLreturn(caml_x);
 }

//*************************
value b_point_y(value point){
 	CAMLparam1(point);
	CAMLlocal1(caml_y);

//	caml_leave_blocking_section();
		caml_y = caml_copy_double(((BPoint *)Field(point,0))->y);
//	caml_enter_blocking_section();

	CAMLreturn(caml_y);
 }

//************************
value b_rect_rect_left(value interne, value left, value top, value right, value bottom) {
	CAMLparam5(interne, left,top,right,bottom);
	CAMLlocal1(rect);
	////register_global_root(&rect);
	
	caml_release_runtime_system();
		ORect *r = new ORect(interne,
						 Double_val(left),
						 Double_val(top),
						 Double_val(right),
						 Double_val(bottom));
	caml_acquire_runtime_system();						 
//	caml_leave_blocking_section();
	rect = alloc_small(1,Abstract_tag);
	Field(rect,0) = (value)r;
//	caml_enter_blocking_section();
//	printf("[C] creation de be_rect : 0x%lX\n", rect);fflush(stdout);
	CAMLreturn(rect);
	
}

value b_rect_rect_leftTop(value interne, value leftTop, value rightBottom) {
	CAMLparam3(interne, leftTop, rightBottom);
	CAMLlocal1(rect);
	//register_global_root(&rect);

	ORect *r;
	r = new ORect(interne,
						 *(BPoint *)Field(leftTop,0), 
						 *(BPoint *)Field(rightBottom,0));
					 
//	caml_leave_blocking_section();
		rect = caml_copy_int32((int32)r);
//	caml_enter_blocking_section();
	
	CAMLreturn(rect);
}

value b_rect_rect(value interne, value rect_param) {
	CAMLparam1(rect_param);
	CAMLlocal1(p_rect);
	//register_global_root(&rect);

	ORect *r;
	caml_release_runtime_system();
		r = new ORect(interne, *(BRect *)Field(rect_param,0));
	caml_acquire_runtime_system();	
//	caml_leave_blocking_section();
		p_rect = alloc_small(1,Abstract_tag);
		Field(p_rect,0)=(value)r;
//	caml_enter_blocking_section();

	CAMLreturn(p_rect);
}

value b_rect(value interne) {
	CAMLparam1(interne);
	CAMLlocal1(rect);
	//register_global_root(&rect);

	ORect *r;
	r = new ORect(interne);
//	caml_leave_blocking_section();
		rect = caml_copy_int32((int32)r);
//	caml_enter_blocking_section();

	CAMLreturn(rect);
}

//********************
value b_rect_insetBy_x_y(value rect, value x, value y){
	CAMLparam3(rect, x, y);
	
	((BRect *)Field(rect,0))->BRect::InsetBy(Double_val(x), Double_val(y));
	
	CAMLreturn(Val_unit);
}

//********************
value b_rect_left(value rect){
	CAMLparam1(rect);
	CAMLlocal1(caml_left);

//	caml_leave_blocking_section();
		caml_left = caml_copy_double(((BRect *)Field(rect,0))->left);
//	caml_enter_blocking_section();

	CAMLreturn(caml_left);
}

//********************
value b_rect_top(value rect){
	CAMLparam1(rect);
	CAMLlocal1(caml_top);

//	caml_leave_blocking_section();
		caml_top = caml_copy_double(((BRect *)Field(rect,0))->top);
//	caml_enter_blocking_section();

	CAMLreturn(caml_top);
}

//********************
value b_rect_right(value rect){
	CAMLparam1(rect);
	CAMLlocal1(caml_right);

//	caml_leave_blocking_section();
		caml_right = caml_copy_double(((ORect *)Field(rect,0))->right);
//	caml_enter_blocking_section();

	CAMLreturn(caml_right);
}

//********************
value b_rect_bottom(value rect){
	CAMLparam1(rect);
	CAMLlocal1(caml_bottom);

//	caml_leave_blocking_section();
		caml_bottom = caml_copy_double(((BRect *)Field(rect,0))->bottom);
//	caml_enter_blocking_section();

	CAMLreturn(caml_bottom);
}

//********************
value b_rect_offsetBy_x_y(value rect, value x, value y){
	CAMLparam3(rect, x, y);
	
	((BRect *)Field(rect,0))->BRect::OffsetBy(Double_val(x), Double_val(y));
	
	CAMLreturn(Val_unit);
}

//*********************
value b_rect_offsetTo_point(value rect, value point) {
	CAMLparam2(rect, point);

	((BRect *)Field(rect,0))->OffsetTo(*((BPoint *)Field(point,0)));

	CAMLreturn(Val_unit);
}

//*********************
value b_rect_offsetTo(value rect, value x, value y) {
	CAMLparam3(rect, x, y);

	((BRect *)Field(rect,0))->OffsetTo(Double_val(x), Double_val(y));

	CAMLreturn(Val_unit);
}

//****************
value b_rect_set(value rect, value left, value top, value right, value bottom) {
	CAMLparam5(rect, left, top, right, bottom) ;

	((BRect *)Field(rect,0))->Set(
								   (float)Double_val(left), 
								   (float)Double_val(top), 
								   (float)Double_val(right), 
								   (float)Double_val(bottom)
								   );

	CAMLreturn(Val_unit);
}

//**********************
value b_rect_printtostream(value rect) {
	CAMLparam1(rect);

	((BRect *)Field(rect,0))->PrintToStream();
	
	CAMLreturn(Val_unit);
}

//************************
value b_rect_width(value rect) {
	CAMLparam1(rect);
	CAMLlocal1(caml_width);

//	caml_leave_blocking_section();
		caml_width = caml_copy_double(((BRect *)Field(rect,0))->Width());
//	caml_enter_blocking_section();

	CAMLreturn(caml_width);
}

//************************
value b_rect_height(value rect){
	CAMLparam1(rect);
	CAMLlocal1(caml_height);

//	caml_leave_blocking_section();
		caml_height = caml_copy_double(((ORect *)Field(rect,0))->BRect::Height());
//	caml_enter_blocking_section();

	CAMLreturn(caml_height);
}


