open Glue
open InterfaceDefs
open Window

type alert_type =
| B_EMPTY_ALERT
| B_INFO_ALERT
| B_IDEA_ALERT
| B_WARNING_ALERT
| B_STOP_ALERT
;;

type button_spacing =
| B_EVEN_SPACING 
| B_OFFSET_SPACING 
;;

external b_alert_alert : #be_interne -> string -> string -> string -> string option -> string option -> button_width -> alert_type -> pointer = "b_alert_alert_bytecode" "b_alert_alert_nativecode"
external b_alert_alert_spacing : #be_interne -> string -> string -> string -> string option -> string option -> button_width -> button_spacing -> alert_type -> pointer = "b_alert_alert_spacing_bytecode" "b_alert_alert_spacing_nativecode"
external b_alert_go : pointer -> int32 = "b_alert_go"

class be_alert = 
	object(self)
	inherit be_window as window

	method be_alert	~title
					~text 
					~button0Label 
					?button1Label 
					?button2Label 
					?(widthStyle=B_WIDTH_AS_USUAL)
					?spacing 
					?(alert_type=B_INFO_ALERT) () =
		self#set_interne 
		(
			match spacing with 
			| None -> b_alert_alert self title text button0Label button1Label button2Label widthStyle alert_type
			| Some spacing -> b_alert_alert_spacing self title text button0Label button1Label button2Label widthStyle spacing alert_type
		)

	method go () = 
		b_alert_go (self#get_interne())
		
end;;
