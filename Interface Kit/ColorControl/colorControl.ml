open Control;;
open Glue;;
open Message;;
open Point;;
open GraphicsDefs;;


type color_control_layout =
| B_CELLS_4x64
| B_CELLS_8x32
| B_CELLS_16x16
| B_CELLS_32x8
| B_CELLS_64x4
;;

external b_colorControl_colorControl : pointer -> color_control_layout -> float -> string -> pointer -> bool -> pointer = "b_colorControl_colorControl_bytecode" "b_colorControl_colorControl_native"
external b_colorControl_setValue : pointer -> rgb_color -> unit = "b_colorControl_setValue"
external b_colorControl_getPreferredSize : pointer -> float ref -> float ref -> unit = "b_colorControl_getPreferredSize"
external b_colorControl_valueAsColor : pointer -> rgb_color = "b_colorControl_valueAsColor"

class be_colorControl =
	object(self)
	inherit be_control as control

	method be_colorControl ~(leftTop : be_point) 
						   ~matrix 
						   ~cellSide 
						   ~name 
						   ?(message : be_message option) 
						   ?(bufferedDrawing = false) () =
		match message with 
		| Some message -> self#set_interne(b_colorControl_colorControl (leftTop#get_interne()) matrix cellSide name (message#get_interne()) bufferedDrawing)
		| None -> failwith "be_colorControl constructeur non implemente avec un message nul."
	
	method setValue ~rgb_color =
		b_colorControl_setValue (self#get_interne()) rgb_color

	method getPreferredSize ~width ~height =
		b_colorControl_getPreferredSize (self#get_interne()) width height
	
	method valueAsColor () =
		b_colorControl_valueAsColor (self#get_interne())
end;;	
