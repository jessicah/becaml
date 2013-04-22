#include "mlvalues.h"

#ifndef glue

#define glue
#include <OS.h>

#ifdef __cplusplus 
extern "C" {
#endif
		
void b_glue_remove(void *c_object);


class Glue {
		public :
				Glue(/*value objet*/);
		//private :
			//	value *interne;		
//				~Glue();

};

#ifdef __cplusplus
}
#endif
#endif //glue
