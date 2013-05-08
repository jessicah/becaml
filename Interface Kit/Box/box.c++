#include <Box.h>
#include <stdio.h>

#include "mlvalues.h"
#include "alloc.h"
#include "memory.h"

#include "glue.h"
#include "interfaceDefs.h"
#include "point_rect.h"

extern "C" {

	extern sem_id ocaml_sem;
	value b_box_box_native(value self, value frame, value name, value resizingMode, value flags, value border);
	value b_box_box_bytecode(value *argv, int argc);
	value b_box_addChild(value box, value aView);
	value b_box_allAttached(value box);
	value b_box_attachedToWindow(value box);
	value b_box_windowActivated(value box, value active);
}

class OBox : public BBox, public Glue
  {

	public :
	
		OBox(value ocaml_objet, BRect frame, char *name, int32 resizingMode, int32 flags, border_style border):
			BBox(frame, name, resizingMode, flags, border)
		, Glue(ocaml_objet) {}
		void AllAttached();
		void AttachedToWindow(); 
		void Draw(BRect updateRect);
	 	virtual void MouseMoved(BPoint pt, uint32 code, const BMessage *msg); 
#ifdef __HAIKU__
		BSize MinSize();
 		BSize MaxSize();
#endif
		void WindowActivated(bool state); 	
};

//************************
void OBox::AllAttached(){
	printf("[C++] OBox::AllAttached appele.\n");
	BBox::AllAttached();
	return;
}

//*************************
void OBox::AttachedToWindow(){
	
	BBox::AttachedToWindow();
	
	return;
}

//*************************
void OBox::Draw(BRect updateRect){
	
	BBox::Draw(updateRect);
	return;
}

#ifdef __HAIKU__
//*************************
BSize OBox::MinSize(){
	return BBox::MinSize();
}

//*************************
BSize OBox::MaxSize(){
	return BBox::MaxSize();
}
#endif

//*****************************
void OBox::MouseMoved(BPoint pt, uint32 code, const BMessage *msg){
	//CAMLparam1(interne);
//	CAMLparam0();

//	printf("OBox::MouseMoved appele.\n");
	BBox::MouseMoved(pt, code, msg);
	
	return;	
//	CAMLreturn0;
}

//****************************
void OBox::WindowActivated(bool state){
	
	BBox::WindowActivated(state);
	return;
}

//*********************
value b_box_box_native(value ocaml_objet, value frame, value name, value resizingMode, value flags, value border){
	CAMLparam5(ocaml_objet, frame, name, resizingMode, flags);
	CAMLxparam1(border);
//	CAMLlocal1(box);
	OBox *b;
	
	caml_release_runtime_system();
		b= new OBox(ocaml_objet,
						   *(ORect *)Field(frame,0), 
						   String_val(name), 
						   Int32_val(resizingMode), 
						   Int32_val(flags), 
						   decode_border_style(border));
		printf("C 0x%lx : %lx\n", b, sizeof(OBox));
	caml_acquire_runtime_system();
//	box = copy_int32((value)b);
	
	CAMLreturn(caml_copy_int32((int32)b));
}

//*******************
value b_box_box_bytecode(value *argv, int argc) {
	return b_box_box_native(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]);
}

//*******************************
value b_box_addChild(value box, value aView){
	CAMLparam2(box, aView);

	((BBox *)Int32_val(box))->BBox::AddChild((BView *)Int32_val(aView));
	
	CAMLreturn(Val_unit);

}

//********************************
value b_box_allAttached(value box){
	CAMLparam1(box);
	
	((BBox *)Int32_val(box))->BBox::AllAttached();
	
	CAMLreturn(Val_unit);
}

value b_box_attachedToWindow(value box){
	CAMLparam1(box);

	((BBox *)Int32_val(box))->BBox::AttachedToWindow();
	
	CAMLreturn(Val_unit);
}

value b_box_windowActivated(value box, value active){
	CAMLparam2(box, active);

	((BBox *)Int32_val(box))->BBox::WindowActivated(Bool_val(active));
	
	CAMLreturn(Val_unit);
}
