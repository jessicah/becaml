#include <Polygon.h>
#include <Point.h>
#include <stdio.h>

#include "alloc.h"
#include "memory.h"
#include "threads.h"

#include "glue.h"
#include "point_rect.h"

extern "C" {
	extern sem_id ocaml_sem;
	value b_polygon_polygon(value interne, value pointList, value numPoints);
	value b_polygon_polygon_(value polygon);
	value b_polygon_printToStream(value polygon);	
}

class OPolygon : public BPolygon, public Glue {
	public :
		OPolygon(value interne, const BPoint *listePoints, int32 numPoints):
			BPolygon(listePoints, numPoints), Glue(interne){};
};


//*********************
value b_polygon_polygon(value self, value pointList, value numPoints) {
	CAMLparam3(self, pointList, numPoints);
	CAMLlocal1(p_polygon);
	BPoint liste_points[Int32_val(numPoints)];	
	OPolygon *opolygon;

	p_polygon = alloc_small(1,Abstract_tag);
	caml_register_global_root(&p_polygon);

	//register_global_root(&polygon);

	for(int i = 0 ; i < Int32_val(numPoints) ; i++)
		liste_points[i] = *(OPoint *)Field(Field(pointList, i),0);

	caml_release_runtime_system();
		opolygon = new OPolygon(self, liste_points, Int32_val(numPoints));
	caml_acquire_runtime_system();

	Field(p_polygon,0) = (value)opolygon;

//	delete *liste_points;
	
	CAMLreturn(p_polygon);
}

//*********************
value b_polygon_polygon_(value polygon) {
	CAMLparam1(polygon);

	((BPolygon *)Int32_val(polygon))->~BPolygon();
	
	CAMLreturn(Val_unit);

}

//****************************
value b_polygon_printToStream(value polygon){
	CAMLparam1(polygon);
	
	((BPolygon *)Int32_val(polygon))->PrintToStream();
	
	CAMLreturn(Val_unit);


}

