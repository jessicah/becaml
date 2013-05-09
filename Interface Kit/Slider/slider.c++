#include <Slider.h>

#include "memory.h"
#include "alloc.h"
#include "mlvalues.h"
#include "signals.h"
#include "threads.h"

#include "glue.h"
#include "message.h"
#include "point_rect.h"

extern "C" {
	extern sem_id ocaml_sem;
	thumb_style decode_thumb_style(value thumb_style);
	hash_mark_location decode_hash_mark_location(value hash_mark_location);

	value b_slider_slider_nativecode(value self, value frame, value name, value label, value message, value minValue, value maxValue, value thumbType, value resizingMode, value flags);
	value b_slider_slider_bytecode(value *argv, int argn);
	value b_slider_setHashMarks(value slider, value where);
	value b_slider_setLimitLabels(value slider, value minLabel, value maxLabel);
	value b_slider_setValue(value slider, value valeur);
	value b_slider_value(value slider);
}

//*******************
hash_mark_location decode_hash_mark_location(value hash_mark_location){
	switch(Int_val(hash_mark_location)) {
			case 0 : return B_HASH_MARKS_NONE;
			case 1 : return B_HASH_MARKS_TOP ;
			case 2 : return B_HASH_MARKS_LEFT;
			case 3 : return B_HASH_MARKS_BOTTOM;
			case 4 : return B_HASH_MARKS_RIGHT;
			case 5 : return B_HASH_MARKS_BOTH;
	}
}

//*******************
thumb_style decode_thumb_style(value thumb_style){
	switch(Int_val(thumb_style)) {
			case 0 : return B_BLOCK_THUMB;
			case 1 : return B_TRIANGLE_THUMB;
	}
}

//**************************
class OSlider : public BSlider , public Glue 
	{
		public :
				OSlider(value self, BRect frame, char *name, char *label, BMessage *message, int32 minValue, int32 maxValue, thumb_style thumbType, uint32 resizingMode, uint32 flags) :
					BSlider(frame, name, label, message, minValue, maxValue, thumbType, resizingMode, flags)
					, Glue(self) {
//					CAMLparam1(self);
//					CAMLreturn0;
				}
				
};

//***************************************
value b_slider_slider_nativecode(value self, value frame, value name, value label, value message, 
								 value minValue, value maxValue, value thumbType, value resizingMode, 
								 value flags) {
	CAMLparam5(self, frame, name, label, message);
	CAMLxparam5(minValue, maxValue, thumbType, resizingMode, flags);
	CAMLlocal1(p_slider);
   	
	caml_release_runtime_system();
		OSlider *bslider = new OSlider(self,
						   *(ORect *)Field(frame,0),
						   String_val(name), 
						   String_val(label), 
						   (OMessage *)Field(message,0), 
						   Int32_val(minValue), 
						   Int32_val(maxValue), 
						   decode_thumb_style(thumbType), 
						   Int32_val(resizingMode), 
						   Int32_val(flags));
	
	caml_acquire_runtime_system();
	//caml_leave_blocking_section();
	p_slider = alloc_small(1,Abstract_tag);
	Field(p_slider,0) = (value)bslider;
	//caml_enter_blocking_section();

	CAMLreturn(p_slider);
	
}

//***************************************
value b_slider_slider_bytecode(value *argv, int argn) {

	return b_slider_slider_nativecode(argv[0], argv[1], argv[2], argv[3], argv[4], 
									  argv[5], argv[6], argv[7], argv[8], argv[9]);
}

//*************************************
value b_slider_setHashMarks(value slider, value where){
	CAMLparam2(slider, where);
	
	((OSlider *)Field(slider,0))->SetHashMarks(decode_hash_mark_location(where));

	CAMLreturn(Val_unit);

}

//*************************************
value b_slider_setLimitLabels(value slider, value minLabel, value maxLabel){
	CAMLparam3(slider, minLabel, maxLabel);

	((OSlider *)Field(slider,0))->SetLimitLabels(String_val(minLabel), String_val(maxLabel));

	CAMLreturn(Val_unit);
}

//******************************************
value b_slider_setValue(value slider, value valeur){
	CAMLparam2(slider, valeur);
	
	((OSlider *)Field(slider,0))->SetValue(Int32_val(valeur));
	
	CAMLreturn(Val_unit);
}

//*****************************************
value b_slider_value(value slider){
	CAMLparam1(slider);
	CAMLlocal1(caml_value);
	
	//caml_leave_blocking_section();
		caml_value = caml_copy_int32(((OSlider *)Field(slider,0))->Value());
	//caml_enter_blocking_section();
	
	CAMLreturn(caml_value);

}
