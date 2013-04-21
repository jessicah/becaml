#include <InterfaceDefs.h>

#ifndef BEOS
	#define BEOS
#endif

extern "C" {
	border_style decode_border_style(int border_style);
	button_width decode_button_width(value button_width);
	orientation  decode_orientation(value orientation);
}
