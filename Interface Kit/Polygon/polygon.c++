#include "alloc.h"
#include "memory.h"

#include "glue.h"
#include <Polygon.h>
#include <Point.h>
#include <stdio.h>

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
value b_polygon_polygon(value interne, value pointList, value numPoints) {
	CAMLparam3(interne, pointList, numPoints);
	CAMLlocal1(polygon);
    BPoint liste_points[Int32_val(numPoints)];	
	BPolygon *be_poly;
	//register_global_root(&polygon);

	for(int i = 0 ; i < Int32_val(numPoints) ; i++)
			liste_points[i] = *(BPoint *)Int32_val(Field(pointList, i));

	be_poly = new OPolygon(interne, liste_points, Int32_val(numPoints));
	polygon = copy_int32((uint32)be_poly);

//	delete *liste_points;
	
	CAMLreturn(polygon);
		
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

