#include "alloc.h"
#include "memory.h"
#include "threads.h"

#include "glue.h"
#include <Point.h>
#include <Rect.h>

class OPoint : public BPoint, public Glue 
			   {
	public :
			
		OPoint(value point_caml):
			BPoint(),Glue(point_caml) {}
		
		OPoint(value point_caml,  float x, float y):
			BPoint(x, y),Glue(point_caml) {}
		
//		OPoint(BPoint point):
//			BPoint(point),Glue(Val_unit) {}
		
		OPoint(value point_caml, BPoint point):
			BPoint(point),Glue(point_caml) {}

	
};

class ORect : public BRect, public Glue
{
		public:
				ORect(value interne, float left, float top, float right, float bottom):
					BRect(left, top, right, bottom),
					Glue(interne) {};
					
				ORect(value interne, BPoint leftTop, BPoint rightBottom):
					BRect(leftTop, rightBottom)
					,Glue(interne) {};
					
	//			ORect(BRect rect): BRect(rect),Glue(Val_unit) {};
				ORect(value interne, BRect rect):
					BRect(rect)
					, Glue(interne) {};
					
				ORect(value interne):
					BRect()
					, Glue(interne) {};
};

