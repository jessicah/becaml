open Glue;;
open Menu;;
open Rect;;
open View;;

external b_menuBar_menuBar : pointer -> string -> int32 -> menu_layout -> bool -> pointer = (*"b_menuBar_menuBar_bytecode"*) "b_menuBar_menuBar_nativecode"
external b_menuBar_addItem : pointer -> pointer -> bool = "b_menuBar_addItem"
external b_menuBar_addItem_frame : pointer -> pointer -> pointer -> bool = "b_menuBar_addItem_frame"
external b_menuBar_addItem_submenu : pointer -> pointer -> bool = "b_menuBar_addItem_submenu"
external b_menuBar_addItem_submenu_index : pointer -> pointer -> int32 -> bool = "b_menuBar_addItem_submenu_index"
external b_menuBar_addItem_submenu_frame : pointer -> pointer -> pointer -> bool = "b_menuBar_addItem_submenu_frame"

class be_menuBar =
	object(self)
	inherit be_menu

	method be_menuBar ~(frame : be_rect) 
					  ~name ?(resizingMode = Int32.logor kB_FOLLOW_LEFT_RIGHT kB_FOLLOW_TOP)
					  ?(layout = B_ITEMS_IN_ROW)
					  ?(resizeToFit = true) ()=
		self#set_interne (b_menuBar_menuBar (frame#get_interne()) name resizingMode layout resizeToFit)

	method addItem : 'a 'b 'c. ?item:(#be_interne as 'a) ->  
							   ?index:int32 ->
							   ?submenu:(#be_interne(*be_menu*) as 'b) ->
							   ?frame:(#be_rect as 'c) ->
							   unit -> bool =
		fun ?item ?index ?submenu ?frame () ->
		match item, index, submenu, frame with
		| Some menuItem, None, None, None ->       b_menuBar_addItem               (self#get_interne()) (menuItem#get_interne())
		| Some menuItem, None, None, Some frame -> b_menuBar_addItem_frame         (self#get_interne()) (menuItem#get_interne()) (frame#get_interne())
		| None, None, Some submenu, None ->        b_menuBar_addItem_submenu       (self#get_interne()) (submenu#get_interne())
		| None, Some index, Some submenu, None ->  b_menuBar_addItem_submenu_index (self#get_interne()) (submenu#get_interne()) index
		| None, None, Some submenu, Some frame ->  b_menuBar_addItem_submenu_frame (self#get_interne()) (submenu#get_interne()) (frame#get_interne())
		| _ -> failwith "be_menuBar#addItem : parametres manquants ou panel d'options non implemente."
	
end;;
