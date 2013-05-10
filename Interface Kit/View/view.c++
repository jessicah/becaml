#include <Message.h>
#include <View.h>
#include <Window.h>
#include <stdio.h>

#include "alloc.h"
#include "callback.h"
#include "memory.h"
#include "mlvalues.h"
#include "signals.h"
#include "threads.h"

#include "bitmap.h"
#include "glue.h"
#include "graphicsDefs.h"
#include "message.h"
#include "point_rect.h"
#include "polygon.h"
#include "shape.h"

extern "C" {
	extern sem_id callback_sem;
	extern sem_id ocaml_sem;
	extern thread_id beos_thread;
	value b_will_draw(value unit);
	value b_follow_all(value unit);
	value b_follow_left(value unit);
	value b_follow_left_right(value unit);
	value b_follow_top(value unit);
	value b_follow_none(value unit);
	value b_navigable(value unit);
	value b_navigable_jump(value unit);
	value b_frame_events(value unit);
	value b_font_all(value unit);
	value b_primary_mouse_button(value unit);
	value b_secondary_mouse_button(value unit);
	value b_tertiary_mouse_button(value unit);
	
	value b_view(value self, value frame, value name, value resizingMode, value flags);
	value b_view_addChild(value view, value aView);
	value b_view_allAttached(value view);
	value b_view_attachedToWindow(value view);
	value b_view_bounds(value view);
	value b_view_childAt(value view, value index);
	value b_view_countChildren(value view);
	value b_view_draw(value view, value updateRect);
	value b_view_drawBitmap_destination(value view, value image, value destination);
	value b_view_drawString(value view, value chaine, value point);
	value b_view_fillPolygon_aPolygon(value view, value aPolygon, value aPattern);
	value b_view_fillPolygon_pointList(value view, value pointList, value numPoints, value aPattern);
	value b_view_fillPolygon_pointList_rect(value view, value pointList, value numPoints, value rect, value aPattern);
	value b_view_fillRect(value view, value rect, value aPattern);
	value b_view_frame(value view);
	value b_view_getFont(value view, value font);
	value b_view_getMouse(value view, value location, value buttons, value checkMessageQueue);
	value b_view_highColor(value view);
	value b_view_invalidate(value view);
	value b_view_invalidate_rect(value view, value rect);
	value b_view_isPrinting(value view);
	value b_view_messageReceived(value view, value message);
	value b_view_mouseDown(value view, value point);
	//value b_view_mouseMoved(value view, value where, value code, value a_message);
	value b_view_moveBy(value view, value dh, value dv);
	value b_view_movePenTo_pt(value view, value pt);
	value b_view_moveTo(value view, value where);
	value b_view_name(value view);
	value b_view_resizeBy(value view, value horizontal, value vertical);
	value b_view_resizeTo(value view, value width, value height);
	value b_view_resizeToPreferred(value view);
	value b_setfont(value view, value font, value properties);
	value b_setfontsize(value view, value points);
	value b_view_setDrawingMode(value view, value mode);
	value b_view_setHighColor(value view, value red, value green, value blue, value alpha);
	value b_view_setHighColor_rgb(value view, value color);
	value b_view_setScale(value view, value ratio);
	value b_view_setPenSize(value view, value size);
	value b_view_setViewColor(value view, value red, value green, value blue, value alpha);
	value b_view_setViewColor_rgb(value view, value color);
	value b_view_strokePolygon_polygon(value view, value polygon, value isClosed, value aPattern);
	value b_view_strokePolygon_pointList(value view, value pointList, value numPoints, value isClosed, value aPattern);
	value b_view_strokePolygon_pointList_rect_nativecode(value view, value pointList, value numPoints, value rect, value isClosed, value aPattern);
	value b_view_strokePolygon_pointList_rect_bytecode(value *argv, int argn);
	value b_view_strokeShape(value view, value shape, value pattern);
	value b_view_windowActivated(value view, value active);
	value b_view_window(value view);
}

class OView : public BView, public Glue 
		{
		public :
				OView(value objet, BRect frame, const char *name, uint32 resizingMode, uint32 flags);
				~OView();
				void AddChild(BView *child, BView *before = NULL);
				void AllAttached();
				void AttachedToWindow();
				void Draw(BRect updateRect);
				void DrawString(const char *string, BPoint point,escapement_delta *delta = NULL);
				void Invalidate(BRect invalRect); 
                void Invalidate(const BRegion *invalRegion); 
                void Invalidate(); 
				void KeyDown(const char *bytes, int32 numBytes);
				void MessageReceived(BMessage *message);
				void MouseDown(BPoint where);
				void MouseMoved(BPoint where, uint32 code, const BMessage *a_message);
#ifdef __HAIKU__
				BSize MinSize();
				BSize MaxSize();
				BSize PreferredSize();
				BAlignment LayoutAlignment();
				void SetLayout(BLayout *layout);
				void InvalidateLayout(bool descendants);
				void DoLayout();
				bool HasHeightForWidth();
				bool GetToolTipAt(BPoint point, BToolTip** _tip);
#endif
				void GetHeightForWidth(float width, float* min, float* max, float* preferred);
				void WindowActivated(bool active);
};

OView::OView(value objet, BRect frame, const char *name, uint32 resizingMode, uint32 flags) :
		BView(frame, name, resizingMode, flags)
		, Glue(objet) {}

OView::~OView() {
	printf("[C++]OView destruction de 0x%lx\n", this);fflush(stdout);
	}

//******************************
void OView::AddChild(BView *child, BView *before = NULL){
//	CAMLparam1(*interne);
	CAMLparam0();
	CAMLlocal3(view_caml, child_caml, before_caml);
	//caml_c_thread_register();	

	if(before == NULL) {
//			//**acquire_sem(ocaml_sem);
				caml_leave_blocking_section();
				view_caml = caml_copy_int32((int32)this);
				child_caml = caml_copy_int32((int32)child);
					callback2(*caml_named_value("OView::AddChild"), 
									view_caml, 
									child_caml);
				caml_enter_blocking_section();
//			//**release_sem(ocaml_sem);
	}
	else {
//		//**acquire_sem(ocaml_sem);
			caml_leave_blocking_section();
			printf("OView::AddChild non implemente avec before!= null");fflush(stdout);
				view_caml = caml_copy_int32((int32)this);
				child_caml = caml_copy_int32((int32)child);
				before_caml = caml_copy_int32((int32)before);
				callback3(*caml_named_value(""),view_caml, 
												child_caml,
												before_caml);
			caml_enter_blocking_section();
//		//**release_sem(ocaml_sem);
	}
	CAMLreturn0;
}

//**************************
void OView::AllAttached(){
//	CAMLparam1(interne);
	CAMLparam0();
	//caml_c_thread_register();	
//	//**acquire_sem(ocaml_sem);
//		caml_leave_blocking_section();
	caml_acquire_runtime_system();
		caml_callback(caml_get_public_method(interne, hash_variant("allAttached")),interne);
	caml_release_runtime_system();
//		caml_enter_blocking_section();
	
//	//**release_sem(ocaml_sem);
	CAMLreturn0;
}

//**************************
void OView::AttachedToWindow(){
//	CAMLparam1(interne);
	CAMLparam0();
	//caml_c_thread_register();	
	printf("[C] OView::AttachedToWindow (0x%lx)\n", (int32)this);fflush(stdout);	
	
//	//**acquire_sem(ocaml_sem);
//		caml_leave_blocking_section();
	caml_acquire_runtime_system();
		callback(caml_get_public_method(interne, hash_variant("attachedToWindow")), interne);
	caml_release_runtime_system();
//		caml_enter_blocking_section();
//	//**release_sem(ocaml_sem);
	CAMLreturn0;
}

//****************************
void OView::Draw(BRect updateRect) { //OK en 2013 !!!
	//**acquire_sem(ocaml_sem);	
	CAMLparam0();
	CAMLlocal3(view_caml, rect, p_rect);
	ORect *localUpdateRect;
		
//		caml_register_global_root(&view_caml);
//		caml_register_global_root(&rect);
//		caml_register_global_root(&fun);
//	//**release_sem(ocaml_sem);	
//
	//caml_c_thread_register();TODO
	
	printf("[C] OView::Draw (0x%lx)\n", (int32)this);fflush(stdout);	
	
	//**acquire_sem(ocaml_sem);	

	caml_acquire_runtime_system();
		/*Création couple ocaml/C pour localUpdateRect*/
		caml_register_global_root(&p_rect);
		p_rect = alloc_small(1,Abstract_tag);
		
		caml_register_global_root(&rect);
		rect = callback(*caml_named_value("new_be_rect"),p_rect);
		
	caml_release_runtime_system();
		localUpdateRect=new ORect(rect, updateRect);
	caml_acquire_runtime_system();
		
		Field(p_rect,0) = (value)localUpdateRect;
		
		callback2(caml_get_public_method(interne, hash_variant("draw")), interne, rect);

	caml_release_runtime_system();
	//**release_sem(ocaml_sem);
	CAMLreturn0;
}

void OView::DrawString (const char *string, BPoint point, escapement_delta *delta =NULL) {
	CAMLparam0();
	CAMLlocal3(view_caml, point_caml, caml_string);
	//caml_c_thread_register();	
	
	BPoint *point1;
	point1 = new BPoint(point);
	
//	//**acquire_sem(ocaml_sem);
		caml_leave_blocking_section();
			point_caml = copy_int32((value)point1);
			view_caml = caml_copy_int32((int32)this);
			caml_string = caml_copy_string(string);
			////**acquire_sem(callback_sem);
				callback3(*caml_named_value("OView::DrawString"), view_caml, caml_string, point_caml);
//			//**release_sem(callback_sem);
		caml_enter_blocking_section();
//	//**release_sem(ocaml_sem);

	CAMLreturn0;

}

#ifdef __HAIKU__
BSize OView::MinSize () {
	BSize t;
	return	t;
}

BSize OView::MaxSize () {
	BSize t;
	return	t;
}

BSize OView::PreferredSize () {
	BSize t;
	return	t;
}

BAlignment OView::LayoutAlignment() {
	BAlignment t;
	return	t;
}

void OView::SetLayout(BLayout *layout) {
}

void OView::InvalidateLayout(bool descendants) {
}

void OView::DoLayout() {
}

bool OView::HasHeightForWidth() {
	CAMLparam0();
	return true;
}

void OView::GetHeightForWidth(float width, float* min, float* max, float* preferred) {
}

bool OView::GetToolTipAt(BPoint point, BToolTip** _tip) {
	return true;
}

#endif

//***************************
/*void OView::Invalidate(BRect invalRect); 
void OView::Invalidate(const BRegion *invalRegion); */
void OView::Invalidate(){
	CAMLparam0();
	CAMLlocal1(view_caml);
	//caml_c_thread_register();
	
//	//**acquire_sem(ocaml_sem);
		caml_acquire_runtime_system();
			view_caml = caml_copy_int32((int32)this);
			callback(*caml_named_value("OView#Invalidate"), view_caml);
		caml_release_runtime_system();
//	//**release_sem(ocaml_sem);
	CAMLreturn0;
} 

//***************************
void OView::KeyDown(const char *bytes, int32 numBytes){
//	CAMLparam0();
	//CAMLparam1(interne);

	//caml_c_thread_register();	
	printf("OView::KeyDown(%s, %lu) de %s appele.\n", bytes, numBytes, Name());
	BView::KeyDown(bytes, numBytes);
	
//	CAMLreturn0;
//	return;
}

//*************************
void OView::MessageReceived(BMessage *message) {
	CAMLparam0();
//	CAMLparam1(interne);
	CAMLlocal2(p_omess, message_ocaml);
	OMessage * omess; 
//	ocaml_message = (value *)malloc(sizeof(value *));
	printf("[C] OView::MessageReceived avant register\n");fflush(stdout);
	//caml_c_thread_register();	
	
//	caml_acquire_runtime_system();
	//m = new BMessage(*message);
	//register_global_root((value *)&m);
//	//**acquire_sem(ocaml_sem);
	caml_acquire_runtime_system();
		//Création couple OCaml/C++ pour message 
		p_omess = alloc_small(1,Abstract_tag);
		caml_register_global_root(&p_omess); //TODO unregister
		
		caml_register_global_root(&message_ocaml); //TODO unregister
		message_ocaml = caml_callback(*caml_named_value("new_be_message"), p_omess);
	caml_release_runtime_system();		
		omess = new OMessage(message_ocaml, message);
	caml_acquire_runtime_system();
		Field(p_omess,0) = (value)omess;
		
		printf("[C++]OView::MessageReceived(message->what=0x%lx) avant appel de callback\n", message->what);fflush(stdout);
		
		caml_callback2(caml_get_public_method(interne, hash_variant("messageReceived")) ,interne, message_ocaml);
		
		printf("[C++]OView::MessageReceived apres appel de callback\n");fflush(stdout);
		
	caml_release_runtime_system();
//	//**release_sem(ocaml_sem);
	//remove_global_root((value *)&m);
	
	CAMLreturn0;
}

//******************************
void OView::MouseDown(BPoint where) {
//	bool new_lock = false;
//	if (beos_thread != find_thread(NULL)) {
//		new_lock = true;
//		//**acquire_sem(ocaml_sem);	
//		beos_thread = find_thread(NULL);
//	}
	CAMLparam0();
	CAMLlocal4(point_caml, p_wh,o_where_x, o_where_y);
	//caml_c_thread_register();
//	if(new_lock) {
//			//**release_sem(ocaml_sem);	
//	}
	printf("appel de OView#MouseDown\n");fflush(stdout);
//	if (beos_thread != find_thread(NULL)) {
//		new_lock = true;
//		//**acquire_sem(ocaml_sem);	
//		beos_thread = find_thread(NULL);
//	}
	OPoint *wh;

	caml_acquire_runtime_system();
		//Création couple OCaml/C++ pour where
		p_wh = alloc_small(1,Abstract_tag);
		caml_register_global_root(&p_wh);

		o_where_x = caml_copy_double(where.x);
		o_where_y = caml_copy_double(where.y);
		
		point_caml = caml_callback3(*caml_named_value("new_be_point_x_y"), p_wh, o_where_x, o_where_y);
		caml_register_global_root(&point_caml);

	caml_release_runtime_system();
	
		wh = new OPoint(point_caml, where);
	
	caml_acquire_runtime_system();
		Field(p_wh,0)=(value)wh;
		callback2(caml_get_public_method(interne, hash_variant("mouseDown")), interne, point_caml);
	caml_release_runtime_system();
//	if(new_lock)	
//			//**release_sem(ocaml_sem);
//	remove_global_root(point_where);

	CAMLreturn0;
}

//******************************
void OView::MouseMoved(BPoint where, uint32 code, const BMessage *a_message) {
//	CAMLparam0();
//	CAMLparam1(interne);
	//CAMLlocal1(addr_where);
//	BPoint *wh = new BPoint(where);
//	value argv[4] = {interne, copy_int32((uint32)wh), copy_int32(code), copy_int32((uint32)a_message)};
	//register_global_root((value *)&wh);
	//addr_where =  copy_int32((uint32)wh);
	
//	callbackN(*caml_named_value("mouseMoved"), 4, argv);
	BView::MouseMoved(where, code, a_message);
	//remove_global_root((value *)&wh);
	
//	CAMLreturn0;
	return;
}
//*/

//******************************** 
void OView::WindowActivated(bool active){
//	CAMLparam1(interne);
//	CAMLparam0();

	BView::WindowActivated(active);
	
//	CAMLreturn0;
	return;
}

//**************************
value b_will_draw(value unit) {
CAMLparam1(unit);
CAMLlocal1(caml_res);

//caml_leave_blocking_section();
	caml_res = caml_copy_int32(B_WILL_DRAW);
//caml_enter_blocking_section();

CAMLreturn(caml_res);
}

//**************************
value b_frame_events(value unit) {
CAMLparam1(unit);
CAMLlocal1(caml_res);

//caml_leave_blocking_section();
	caml_res = caml_copy_int32(B_FRAME_EVENTS);
//caml_enter_blocking_section();

CAMLreturn(caml_res);

}


//**************************
value b_navigable(value unit) {
CAMLparam1(unit);
CAMLlocal1(caml_res);

//caml_leave_blocking_section();
	caml_res = caml_copy_int32(B_NAVIGABLE);
//caml_enter_blocking_section();

CAMLreturn(caml_res);

}

//**************************
value b_navigable_jump(value unit) {
CAMLparam1(unit);
CAMLlocal1(caml_res);

//caml_leave_blocking_section();
	caml_res = caml_copy_int32(B_NAVIGABLE_JUMP);
//caml_enter_blocking_section();

CAMLreturn(caml_res);

}


//**************************
value b_follow_all(value unit) {
CAMLparam1(unit);
CAMLlocal1(caml_res);

//caml_leave_blocking_section();
	caml_res = caml_copy_int32(B_FOLLOW_ALL);
//caml_enter_blocking_section();

CAMLreturn(caml_res);

}

//**************************
value b_follow_left(value unit) {
CAMLparam1(unit);
CAMLlocal1(caml_res);

//caml_leave_blocking_section();
	caml_res = caml_copy_int32(B_FOLLOW_LEFT);
//caml_enter_blocking_section();

CAMLreturn(caml_res);

}

//**************************
value b_follow_left_right(value unit) {
CAMLparam1(unit);
CAMLlocal1(caml_res);

//caml_leave_blocking_section();
	caml_res = caml_copy_int32(B_FOLLOW_LEFT_RIGHT);
//caml_enter_blocking_section();

CAMLreturn(caml_res);

}

//**************************
value b_follow_top(value unit) {
CAMLparam1(unit);
CAMLlocal1(caml_res);

//caml_leave_blocking_section();
	caml_res = caml_copy_int32(B_FOLLOW_TOP);
//caml_enter_blocking_section();

CAMLreturn(caml_res);

}

//**************************
value b_follow_none(value unit) {
CAMLparam1(unit);
CAMLlocal1(caml_res);

//caml_leave_blocking_section();
	caml_res = caml_copy_int32(B_FOLLOW_NONE);
//caml_enter_blocking_section();

CAMLreturn(caml_res);

}

//**************************
value b_font_all(value unit) {
CAMLparam1(unit);
CAMLlocal1(caml_res);

//caml_leave_blocking_section();
	caml_res = caml_copy_int32(B_FONT_ALL);
//caml_enter_blocking_section();

CAMLreturn(caml_res);

}

//***************************
value b_primary_mouse_button(value unit) {
CAMLparam1(unit);
CAMLlocal1(caml_res);

//caml_leave_blocking_section();
	caml_res = caml_copy_int32(B_PRIMARY_MOUSE_BUTTON);
//caml_enter_blocking_section();

CAMLreturn(caml_res);

}

//*****************************
value b_secondary_mouse_button(value unit) {
CAMLparam1(unit);
CAMLlocal1(caml_res);

//caml_leave_blocking_section();
	caml_res = caml_copy_int32(B_SECONDARY_MOUSE_BUTTON);
//caml_enter_blocking_section();

CAMLreturn(caml_res);

}

//****************************
value b_tertiary_mouse_button(value unit) {
CAMLparam1(unit);
CAMLlocal1(caml_res);

//caml_leave_blocking_section();
	caml_res = caml_copy_int32(B_TERTIARY_MOUSE_BUTTON);
//caml_enter_blocking_section();

CAMLreturn(caml_res);

}



//******************
value b_view(value self, value frame, value name, value resizingMode, value flags) {
	CAMLparam5(self, frame, name, resizingMode, flags);
	CAMLlocal1(caml_view);
	
	OView *ov;
//	caml_leave_blocking_section();	
	caml_release_runtime_system();
		ov = new OView(self, 
				   *((ORect *)Field(frame,0)), 
				   String_val(name), 
				   Int32_val(resizingMode), 
				   Int32_val(flags));
	caml_acquire_runtime_system();
//	caml_enter_blocking_section();
//	register_global_root(&caml_view);
	
	caml_view = alloc_small(1,Abstract_tag);
	Field(caml_view,0) = (value)ov;

	CAMLreturn(caml_view);

}

//***********************
value b_view_addChild(value view, value aView){
	CAMLparam2(view, aView);
	OView * oview = (OView *)Field(view,0);
	BView * bview = (BView *)Field(aView,0);
	OView * cview = (OView *)Field(aView,0);

	caml_release_runtime_system();
		oview->BView::AddChild(bview);
	caml_acquire_runtime_system();

	CAMLreturn(Val_unit);
}

//***********************
value b_view_allAttached(value view){
	CAMLparam1(view);
	OView *v;

	v =((OView *)Field(view,0));
	
//	caml_enter_blocking_section();
		v->BView::AllAttached();
//	caml_leave_blocking_section();
	
	CAMLreturn(Val_unit);
}

//***********************
value b_view_attachedToWindow(value view){
	CAMLparam1(view);
	OView *v;

	v =((OView *)Field(view,0));
	
//	caml_enter_blocking_section();
		v->BView::AttachedToWindow();
//	caml_leave_blocking_section();
	

	
	CAMLreturn(Val_unit);
}

//*************************
value b_view_bounds(value view) {
	CAMLparam1(view);
	CAMLlocal2(ocaml_rect, p_rect);
	
//	caml_leave_blocking_section();
	p_rect = alloc_small(1,Abstract_tag);
	caml_register_global_root(&p_rect); //TODO unregister

        ocaml_rect = caml_callback(*caml_named_value("new_be_rect"), p_rect);
	caml_release_runtime_system();
		ORect *orect = new ORect(ocaml_rect, ((OView *)Field(view,0))->BView::Bounds());
	caml_acquire_runtime_system();
//	caml_enter_blocking_section();
	Field(p_rect,0) = (value)orect;	

	CAMLreturn(p_rect);
}

//**********************
value b_view_childAt(value view, value index){
	CAMLparam2(view, index);
	CAMLlocal1(caml_child);

//	caml_leave_blocking_section();
		caml_child = caml_copy_int32((int32) ((OView *)Field(view,0))->BView::ChildAt(Int32_val(index)));
//	caml_enter_blocking_section();

	CAMLreturn(caml_child);
}

//*************************

value b_view_countChildren(value view){
	CAMLparam1(view);
	CAMLlocal1(caml_count);
	
//	caml_leave_blocking_section();
		caml_count = caml_copy_int32(((OView *)Field(view,0))->BView::CountChildren());
//	caml_enter_blocking_section();

	CAMLreturn(caml_count);
}

//**************************
value b_view_draw(value view, value updateRect) {
	CAMLparam2(view, updateRect);
	OView *v;
	ORect *r;
	
//	//**acquire_sem(ocaml_sem);
//	caml_leave_blocking_section();
	v = (OView *)Field(view, 0);
	r = (ORect *)Field(updateRect, 0);
//	caml_enter_blocking_section();
//	//**release_sem(ocaml_sem);
	
	v->BView::Draw(*r);
//	caml_leave_blocking_section();
	CAMLreturn(Val_unit);
}

//**************************
value b_view_drawBitmap_destination(value view, value image, value destination) {
	CAMLparam3(view, image, destination);

//	caml_leave_blocking_section();
	((OView *)Field(view,0))->BView::DrawBitmap((BBitmap *)Field(image,0), *((ORect *)Field(destination,0)));
//	caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}

//*************************
value b_view_drawString(value view, value chaine, value point) {
	CAMLparam3(view, chaine, point);
	char * s;
	
//	caml_leave_blocking_section();
	s= String_val(chaine);
	((OView *)Field(view,0))->BView::DrawString(s, *(OPoint *)Field(point,0));
//	caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}

//*****************************
value b_view_fillPolygon_aPolygon(value view, value aPolygon, value aPattern){
	CAMLparam3(view, aPolygon, aPattern);

//	caml_leave_blocking_section();
	
	((OView *)Field(view,0))->BView::FillPolygon((OPolygon *)Field(aPolygon,0), 
											 decode_pattern(aPattern));
//	caml_enter_blocking_section();
	CAMLreturn(Val_unit);
}
	
//******************************
value b_view_fillPolygon_pointList(value view, value pointList, value numPoints, value aPattern){
	CAMLparam4(view, pointList, numPoints, aPattern);
	BPoint point_liste[Int32_val(numPoints)];
	
//	caml_leave_blocking_section();
	for(int i=0 ; i<Int32_val(numPoints) ; i++)	
			point_liste[i] = *(OPoint *)Field(Field(pointList, i),0);
	
	((OView *)Field(view,0))->BView::FillPolygon(point_liste, 
											Int32_val(numPoints), 
											decode_pattern(aPattern));
//	caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}
//*****************************
value b_view_fillPolygon_pointList_rect(value view, value pointList, value numPoints, value rect, value aPattern){
	CAMLparam5(view, pointList, numPoints, rect, aPattern);
	BPoint point_liste[Int32_val(numPoints)];
	
//	caml_leave_blocking_section();

	for(int i=0 ; i<Int32_val(numPoints) ; i++)	
			point_liste[i] = *(OPoint *)Field(Field(pointList, i) ,0);
	

	((OView *)Field(view,0))->BView::FillPolygon(point_liste, 
											 Int32_val(numPoints), 
											 *(ORect *)Field(rect,0), 
											 decode_pattern(aPattern));
//	caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}

//*****************************
value b_view_fillRect(value view, value rect, value aPattern) {
	CAMLparam3(view, rect, aPattern);
	
//	caml_leave_blocking_section();

	((OView *)Field(view,0))->BView::FillRect(*(ORect *)Field(rect,0),
										 decode_pattern(aPattern));

//	caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);

}

//*****************************
value b_view_frame(value view){
	CAMLparam1(view);
	CAMLlocal1(caml_frame);
	BRect *r;
	
//	caml_leave_blocking_section();
		r = new BRect(((OView *)Field(view,0))->BView::Frame());
		caml_frame =caml_copy_int32((int32)r);  
//	caml_enter_blocking_section();
	
	CAMLreturn(caml_frame);
}

//********************
value b_view_getFont(value view, value font){
	CAMLparam2(view, font);
	BFont *font_c;

	font_c = new(BFont);
//	caml_leave_blocking_section();
	((OView *)Field(view,0))->BView::GetFont(font_c);
		
	Store_field(font, 0, copy_int32((value)font_c));
//	caml_enter_blocking_section();
	
	CAMLreturn(font);
}
	
//*****************************
value b_view_getMouse(value view, value location, value buttons, value checkMessageQueue){
	CAMLparam4(view, location, buttons, checkMessageQueue);

	uint32 boutons;
	
//		caml_leave_blocking_section();
		((OView *)Field(view,0))->BView::GetMouse((OPoint *)Field(location,0), 
											  &boutons, 
											  (bool)Bool_val(checkMessageQueue));
		Store_field(buttons, 0, copy_int32(boutons));
//	caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}

//**************************
value b_view_highColor(value view) {
	CAMLparam1(view);
	CAMLlocal1(color);
	rgb_color rgb_color;

//	caml_leave_blocking_section();
	rgb_color = ((OView *)Field(view,0))->BView::HighColor();
	
	register_global_root(&color);
	color = caml_alloc(4, 0 /*tuple */);
	Store_field(color, 0, Val_int(rgb_color.red));
	Store_field(color, 1, Val_int(rgb_color.green));
	Store_field(color, 2, Val_int(rgb_color.blue));
	Store_field(color, 3, Val_int(rgb_color.alpha));
			
//	caml_enter_blocking_section();
	CAMLreturn(color);
}

//***************************
value b_view_invalidate(value view) {
	CAMLparam1(view);
	OView *v;
	v = (OView *)Field(view,0);
	
//	caml_enter_blocking_section();
		v->BView::Invalidate();
//	caml_leave_blocking_section();
	
	CAMLreturn(Val_unit);
}

//***************************
value b_view_invalidate_rect(value view, value rect) {
	CAMLparam2(view, rect);
	OView *v;
	BRect r;

	v =(OView *)Field(view,0);
	r = *(ORect *)Field(rect,0);
	
//	caml_enter_blocking_section();
		v->BView::Invalidate(r);
//	caml_leave_blocking_section();
	
	CAMLreturn(Val_unit);
}

//****************************
value b_view_isPrinting(value view) {
	CAMLparam1(view);
	CAMLlocal1(caml_bool);
//	caml_leave_blocking_section();
		caml_bool = Val_bool( ((OView *)Field(view,0))->BView::IsPrinting() );
//	caml_enter_blocking_section();

	CAMLreturn(caml_bool);
}

//************************
value b_view_messageReceived(value view, value message) {
	CAMLparam2(view, message);
	OView *v;
	BMessage *m;
	v = (OView *)Field(view,0);
	m = (OMessage *)Field(message,0);
	
	printf("[C++]appel de b_view_messageReceived what = %c%c%c%c.\n",
					m->what >> 24, 
					m->what >>16, 
					m->what >> 8,
					m->what  );fflush(stdout);
//	caml_leave_blocking_section();
	caml_release_runtime_system();
	if (m->what != '_MSI')
				(v)->BView::MessageReceived(m);
	caml_acquire_runtime_system();
//	caml_enter_blocking_section();
	printf("[C]b_view_messageReceived fin\n");fflush(stdout);
	CAMLreturn(Val_unit);
}

//******************************
value b_view_mouseDown(value view, value point){
	CAMLparam2(view, point);
	printf("[C]b_view_mouseDown\n");fflush(stdout);
	
//	caml_leave_blocking_section();
		((BView *)Field(view,0))->BView::MouseDown(*(OPoint *)Field(point,0));
//	caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}

//******************************
value b_view_mouseMoved(value view, value where, value code, value a_message){
	CAMLparam4(view, where, code, a_message);
	
//	caml_leave_blocking_section();
	((OView *)Field(view,0))->BView::MouseMoved(*(OPoint *)Field(where,0),
												   Int32_val(code),
												   (OMessage *)Field(a_message,0));
//	caml_enter_blocking_section();

	CAMLreturn(Val_unit);
}
//*/
//****************************
value b_view_moveBy(value view, value dh, value dv){
	CAMLparam3(view, dh, dv);

//	caml_leave_blocking_section();
			((OView *)Field(view,0))->MoveBy(Double_val(dh), Double_val(dv));
//	caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}

//*********************
value b_view_movePenTo_pt(value view, value pt){
	CAMLparam2(view, pt);
	OView *ov;
	BPoint p;

//	//**acquire_sem(ocaml_sem);
		ov = (OView *)Field(view,0);
		p =	*(OPoint *)Field(pt,0);
//	caml_enter_blocking_section();
//	//**release_sem(ocaml_sem);

	ov->BView::MovePenTo(p);
//	caml_leave_blocking_section();
	
	CAMLreturn(Val_unit);
}

//****************************
value b_view_moveTo(value view, value where){
	CAMLparam2(view, where);

	((OView *)Field(view,0))->BView::MoveTo(*(OPoint *)Field(where,0));
	
	CAMLreturn(Val_unit);
}

//********************
value b_view_name(value view){
	CAMLparam1(view);
	CAMLlocal1(caml_name);
	
//	caml_leave_blocking_section();
		caml_name = caml_copy_string(((OView *)Field(view,0))->BView::Name());
//	caml_enter_blocking_section();
	
	CAMLreturn(caml_name);
}

//**************************
value b_view_resizeBy(value view, value horizontal, value vertical) {
	CAMLparam3(view, horizontal, vertical);

//	caml_leave_blocking_section();
	((OView *)Field(view,0))->BView::ResizeBy(Double_val(horizontal), Double_val(vertical));
//	caml_enter_blocking_section();
		
	CAMLreturn(Val_unit);
}

//**************************
value b_view_resizeTo(value view, value width, value height) {
	CAMLparam3(view, width, height);

//	caml_leave_blocking_section();
		((OView *)Field(view,0))->BView::ResizeTo(Double_val(width), Double_val(height));
//	caml_enter_blocking_section();
		
	CAMLreturn(Val_unit);
}

//******************************
value b_view_resizeToPreferred(value view){
	CAMLparam1(view);

//	caml_leave_blocking_section();
	((OView *)Field(view,0))->BView::ResizeToPreferred();
//	caml_enter_blocking_section();
		
	CAMLreturn(Val_unit);

}

//*******************************
value b_view_setDrawingMode(value view, value mode){
	CAMLparam2(view, mode);

//	caml_leave_blocking_section();
	((OView *)Field(view,0))->SetDrawingMode(decode_drawing_mode(mode));
//	caml_enter_blocking_section();

	CAMLreturn(Val_unit);			
}

//***************************
value b_setfont(value view, value font, value properties){

	CAMLparam3(view, font, properties);

//	caml_leave_blocking_section();
	((OView *)Field(view,0))->SetFont(
									   (BFont *)Int32_val(font), 
									   Int32_val(properties)
									  );
//	caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);

}

//*****************************
value b_setfontsize(value view, value points) {
	CAMLparam2(view, points);

//	caml_leave_blocking_section();
	((OView *)Field(view,0))->SetFontSize(Double_val(points));
//	caml_enter_blocking_section();

	CAMLreturn(Val_unit);
}

//*************************
value b_view_setHighColor(value view, value red, value green, value blue, value alpha){
	CAMLparam5(view, red, green, blue, alpha);

//	caml_leave_blocking_section();
	((OView *)Field(view,0))->SetHighColor(Int_val(red),
											  Int_val(green),
											  Int_val(blue),
											  Int_val(alpha));

//	caml_enter_blocking_section();
	CAMLreturn(Val_unit);
}

//*************************
value b_view_setHighColor_rgb(value view, value color){
	CAMLparam2(view, color);
	rgb_color couleur;

//	caml_leave_blocking_section();
	couleur.red   = Int_val(Field(color, 0));
	couleur.green = Int_val(Field(color, 1));
	couleur.blue  = Int_val(Field(color, 2));
	couleur.alpha = Int_val(Field(color, 3));
	
	((OView *)Field(view,0))->SetHighColor(couleur);
//	caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}

//**************************
value b_view_setPenSize(value view, value size) {
	CAMLparam2(view, size);

//	caml_leave_blocking_section();
	((OView *)Field(view,0))->BView::SetScale(Double_val(size));
//	caml_enter_blocking_section();

	CAMLreturn(Val_unit);
}

//**************************
value b_view_setScale(value view, value ratio) {
	CAMLparam2(view, ratio);

//	caml_leave_blocking_section();
	((OView *)Field(view,0))->SetScale(Double_val(ratio));
//	caml_enter_blocking_section();

	CAMLreturn(Val_unit);
}

//*************************
value b_view_setViewColor(value view, value red, value green, value blue, value alpha){
	CAMLparam5(view, red, green, blue, alpha);

//	caml_leave_blocking_section();
	((OView *)Field(view,0))->BView::SetViewColor(Int_val(red),
													 Int_val(green),
													 Int_val(blue),
													 Int_val(alpha));
//	caml_enter_blocking_section();

	CAMLreturn(Val_unit);
}

//*************************
value b_view_setViewColor_rgb(value view, value color){
	CAMLparam2(view, color);
	rgb_color couleur;

//	caml_leave_blocking_section();
	couleur.red   = Int_val(Field(color, 0));
	couleur.green = Int_val(Field(color, 1));
	couleur.blue  = Int_val(Field(color, 2));
	couleur.alpha = Int_val(Field(color, 3));
	
	((OView *)Field(view,0))->BView::SetViewColor(couleur);
//	caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}

//****************************
value b_view_strokePolygon_polygon(value view, value polygon, value isClosed, value aPattern){
	CAMLparam4(view, polygon, isClosed, aPattern);

//	caml_leave_blocking_section();
	((OView *)Field(view,0))->StrokePolygon((BPolygon *)Int32_val(polygon), 
											   Bool_val(isClosed), 
											   decode_pattern(aPattern));
	
//	caml_enter_blocking_section();
	CAMLreturn(Val_unit);
}

//********************************
value b_view_strokePolygon_pointList(value view, value pointList, value numPoints, value isClosed, value aPattern)
{
	CAMLparam5(view, pointList, numPoints, isClosed, aPattern);
	BPoint point_liste[Int32_val(numPoints)];

//	caml_leave_blocking_section();
	for(int i=0 ; i<Int32_val(numPoints) ; i++)	
		point_liste[i] = *(OPoint *)Field(Field(pointList, i),0);

	((OView *)Field(view,0))->StrokePolygon(point_liste,
											 Int32_val(numPoints),
											 Bool_val(isClosed), 
											 decode_pattern(aPattern));
//	caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}

//******************************
value b_view_strokePolygon_pointList_rect_nativecode(value view, value pointList, value numPoints, value rect, value isClosed, value aPattern){
	CAMLparam5(view, pointList, numPoints, rect, isClosed);
	CAMLxparam1(aPattern);
	BPoint point_liste[Int32_val(numPoints)];

//	caml_leave_blocking_section();
	for(int i=0 ; i<Int32_val(numPoints) ; i++)	
		point_liste[i] = *(OPoint *)Field(Field(pointList, i),0);


	((OView *)Field(view,0))->StrokePolygon(point_liste,
											 Int32_val(numPoints),
											 *(BRect *)Int32_val(rect ),
											 Bool_val(isClosed), 
											 decode_pattern(aPattern));
//	caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}

//******************************
value b_view_strokePolygon_pointList_rect_bytecode(value *argv, int argn){
return b_view_strokePolygon_pointList_rect_nativecode(argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]);
}

//*******************************
value b_view_strokeShape(value view, value shape, value pattern){
	CAMLparam3(view, shape, pattern);

//	caml_leave_blocking_section();
	((OView *)Field(view,0))->BView::StrokeShape((OShape *)Field(shape,0), 
											   		decode_pattern(pattern));
//	caml_enter_blocking_section();
	
	CAMLreturn(Val_unit);
}

		
//*****************************
value b_view_windowActivated(value view, value active){
	CAMLparam2(view, active);

//	caml_leave_blocking_section();
	((OView *)Field(view,0))->BView::WindowActivated(Bool_val(active));
	caml_enter_blocking_section();

	CAMLreturn(Val_unit);
}

//*****************************
value b_view_window(value view) {
	CAMLparam1(view);
	CAMLlocal1(window);
	
//	caml_leave_blocking_section();
		window =caml_copy_int32((value)((OView *)Field(view,0))->Window());
//	caml_enter_blocking_section();
	
	CAMLreturn(window);
}

