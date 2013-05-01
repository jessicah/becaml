#include "mlvalues.h"

#ifndef glue

#define glue
#include <OS.h>

#ifdef __cplusplus 
extern "C" {
#endif
	
value b_glue_associate_c_object(value ocaml_objet);	
void b_glue_remove(void *c_object);


class Glue {
		public :
				Glue(value ocaml_object);
		public :
		value interne;		
//				~Glue();

};

#ifdef __cplusplus
}
#endif
#endif //glue
