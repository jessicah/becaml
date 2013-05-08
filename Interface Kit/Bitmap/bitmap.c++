#include "mlvalues.h"
#include "memory.h"
#include "alloc.h"
#include "signals.h"
#include "threads.h"

#include <Bitmap.h>
#include <stdio.h>

#include "glue.h"
#include "graphicsDefs.h"
#include "point_rect.h"
//#include "view.h"



class OBitmap :public BBitmap, public Glue 
{
	public:

		OBitmap(value objet, BRect bounds, color_space space, bool acceptsViews = false, bool needsContiguousMemory = false):
			BBitmap(bounds, space, acceptsViews, needsContiguousMemory) 
			,Glue(objet) {
//				CAMLparam1(objet);
				
//				CAMLreturn0;
		}

};

extern "C" {
	extern sem_id ocaml_sem;
	value b_bitmap_bitmap(value objet, value bounds, value space, value acceptsViews, value needsContiguousMemory);
	value b_bitmap_bits(value bitmap);
	value b_bitmap_bitsLength(value bitmap);
	value b_bitmap_bounds(value bitmap);
	value b_bitmap_colorSpace(value bitmap);
	value b_bitmap_setBits(value bitmap, value data, value length, value offset, value mode);
}

//******************************************
value b_bitmap_bitmap(value objet, value bounds, value space, value acceptsViews, value needsContiguousMemory){
	CAMLparam5(objet, bounds, space, acceptsViews, needsContiguousMemory);
	CAMLlocal1(bitmap);
	
	OBitmap *be_bitmap;

	caml_release_runtime_system();	
		be_bitmap = new OBitmap(objet, 
					*(ORect *)Field(bounds,0), 
					decode_color_space(space), 
					Bool_val(acceptsViews), 
					Bool_val(needsContiguousMemory));
	caml_acquire_runtime_system();
	
	bitmap = alloc_small(1,Abstract_tag);
	Field(bitmap,0) = (value) be_bitmap;
	
	printf("C 0x%lx : %lx\n", be_bitmap, sizeof(OBitmap));
	
	CAMLreturn(bitmap);
}

//***************************************
value b_bitmap_bits(value bitmap) {
	CAMLparam1(bitmap);
	CAMLlocal1(caml_res);

	caml_leave_blocking_section();
		caml_res = caml_copy_int32((value)((OBitmap *)Field(bitmap,0))->BBitmap::Bits());
	caml_enter_blocking_section();

	CAMLreturn(caml_res);
	
}

//***************************************
value b_bitmap_bitsLength(value bitmap) {
	CAMLparam1(bitmap);
	CAMLlocal1(caml_res);

	caml_leave_blocking_section();
		caml_res = caml_copy_int32(((OBitmap *)Field(bitmap,0))->BBitmap::BitsLength());
	caml_enter_blocking_section();

	CAMLreturn(caml_res);
}

//***************************************
value b_bitmap_bounds(value bitmap) {
printf("b_bitmap_bounds a reimplementer !!!\n");fflush(stdout);
		/*	CAMLparam1(bitmap);

	OBitmap *b = (OBitmap *)Field(bitmap,0);
	BRect *r;
	
	r= new BRect(b->Bounds());
	printf("C 0x%lx : %lx\n", r, sizeof(BRect));*/
	
/*	CAMLreturn(copy_int32((value)r));*/
}

//***************************************
value b_bitmap_colorSpace(value bitmap) {
	CAMLparam1(bitmap);
	CAMLlocal1(caml_res);

	caml_leave_blocking_section();
		caml_res = encode_color_space(((OBitmap *)Field(bitmap,0))->BBitmap::ColorSpace());
	caml_enter_blocking_section();

	CAMLreturn(caml_res);
}

//**************************************
value b_bitmap_setBits(value bitmap, value data, value length, value offset, value mode) {
	CAMLparam5(bitmap, data, length, offset, mode);

	((OBitmap *)Field(bitmap,0))->BBitmap::SetBits((void *)Int32_val(data), 
													 Int32_val(length), 
													 Int32_val(offset), 
													 decode_color_space(mode));

	CAMLreturn(Val_unit);
}
