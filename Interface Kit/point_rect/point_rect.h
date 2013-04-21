#ifndef BEOS
	#define BEOS
#endif

#include "alloc.h"
#include "memory.h"

#include "glue.h"
#include <Point.h>
#include <Rect.h>

class OPoint : public BPoint
			   //, public Glue 
			   {
	public :
			
		OPoint(/*value point_caml*/):
			BPoint()//,Glue(/*point_caml*/)
		{
//			CAMLparam1(point_caml);
//			CAMLreturn0;
		}
		
		OPoint(/*value point_caml, */ float x, float y):
			BPoint(x, y)//,Glue(/*point_caml*/)
		{
//			CAMLparam1(point_caml);
//			CAMLreturn0;
		}
		
		OPoint(/*value point_caml,*/ BPoint point):
			BPoint(point)//,Glue(/*point_caml*/)
		{
//			CAMLparam1(point_caml);
//			CAMLreturn0;
		}

	
};

class ORect : public BRect//, public Glue
{
		public:
				ORect(/*value interne,*/ float left, float top, float right, float bottom):
					BRect(left, top, right, bottom)
//					Glue(/*interne*/)
					{
//					CAMLparam1(interne);
//					CAMLreturn0;
				};
					
				ORect(/*value interne,*/ BPoint leftTop, BPoint rightBottom):
					BRect(leftTop, rightBottom)
//					,Glue(/*interne*/)
				{
//					CAMLparam1(interne);
//					CAMLreturn0;

				};
					
				ORect(/*value interne,*/ BRect rect):
					BRect(rect)
//					, Glue(/*interne*/)
				{
//					CAMLparam1(interne);
//					CAMLreturn0;

				};
					
			ORect(/*value interne*/):
					BRect()
//					, Glue(/*interne*/)
				{
//					CAMLparam1(interne);
//					CAMLreturn0;
				};
};

