#ifndef BEOS
	#define BEOS
#endif

#include "mlvalues.h"

#include <GraphicsDefs.h>

extern "C"{
	drawing_mode decode_drawing_mode(value mode);
	pattern 	 decode_pattern(value pattern);
	color_space  decode_color_space(value space);
	value 		 encode_color_space(color_space space);
	value b_B_SOLID_HIGH(value unit);
}
