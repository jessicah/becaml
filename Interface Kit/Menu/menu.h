#include <Menu.h>
#include "mlvalues.h"

extern "C" {
	menu_layout decode_menu_layout(value layout);
	class OMenu : public BMenu, public Glue{
		public:
			OMenu(value ocaml_menu, const char *title,
				  menu_layout layout = B_ITEMS_IN_COLUMN);
			OMenu(value ocaml_menu, const char *title, float width, float height);
			status_t SetTargetForItems(BHandler * target);
			~OMenu();
				
	};
}
