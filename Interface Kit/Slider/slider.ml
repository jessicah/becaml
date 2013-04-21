open Glue;;
open Control;;
open Rect;;
open Message;;
open View;;

type thumb_style =
| B_BLOCK_THUMB
| B_TRIANGLE_THUMB
;;

type hash_mark_location =
| B_HASH_MARKS_NONE 
| B_HASH_MARKS_TOP 
| B_HASH_MARKS_BOTTOM 
| B_HASH_MARKS_BOTH 
| B_HASH_MARKS_LEFT 
| B_HASH_MARKS_RIGHT 
;;

external b_slider_slider : c_pointer -> string -> string -> c_pointer -> int32 -> int32 -> thumb_style -> int32 ->
							int32 -> c_pointer = "b_slider_slider_bytecode" "b_slider_slider_nativecode"
external b_slider_setHashMarks : c_pointer -> hash_mark_location -> unit = "b_slider_setHashMarks" 
external b_slider_setLimitLabels : c_pointer -> string -> string -> unit = "b_slider_setLimitLabels"
external b_slider_setValue : c_pointer -> int32 -> unit = "b_slider_setValue"
external b_slider_value : c_pointer -> int32 = "b_slider_value"

class be_slider =
	object(self)
	inherit be_control as control

	method be_slider ~(frame : be_rect) 
					 ~name 
					 ~label 
					 ~(message : be_message) 
					 ~minValue 
					 ~maxValue 
					 ?(thumbType = B_BLOCK_THUMB) 
					 ?(resizingMode = Int32.logor kB_FOLLOW_LEFT 
					 							  kB_FOLLOW_TOP)
					 ?(flags = Int32.logor 
					 		  (Int32.logor kB_FRAME_EVENTS 
							  			   kB_WILL_DRAW) 
										   kB_NAVIGABLE) 
					 () =
		self#set_interne (b_slider_slider (frame#get_interne()) 
										  name 
										  label 
										  (message#get_interne()) 
										  minValue 
										  maxValue 
										  thumbType 
										  resizingMode 
										  flags)

	method setHashMarks ~where =
		b_slider_setHashMarks (self#get_interne()) where

	method setLimitLabels ~minLabel ~maxLabel =
		b_slider_setLimitLabels (self#get_interne()) minLabel maxLabel
		
	method setValue ~value =
		b_slider_setValue (self#get_interne()) value
	
	method value () =
		b_slider_value (self#get_interne())
end;;
