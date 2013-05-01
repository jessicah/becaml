open Glue
open Message
open Rect
open SupportDefs

external b_printJob_printJob : pointer -> string -> pointer = "b_printJob_printJob"
external b_printJob_beginJob : pointer -> unit = "b_printJob_beginJob" 
external b_printJob_canContinue : pointer -> bool = "b_printJob_canContinue" 
external b_printJob_commitJob : pointer -> unit = "b_printJob_commitJob" 
external b_printJob_configPage : pointer -> status_t = "b_printJob_configPage" 
external b_printJob_drawView : pointer -> pointer -> pointer -> pointer -> unit = "b_printJob_drawView"

external b_printJob_printableRect : pointer -> pointer = "b_printJob_printableRect"
external b_printJob_setSettings : pointer -> pointer -> unit = "b_printJob_setSettings"
external b_printJob_settings : pointer -> pointer = "b_printJob_settings"
external b_printJob_spoolPage : pointer -> unit = "b_printJob_spoolPage" 

class be_printJob =
	object(self)
	inherit be_interne

	method be_printJob ~name =
		self#set_interne(b_printJob_printJob (self#get_interne()) name)

	method beginJob () =
		b_printJob_beginJob (self#get_interne())

	method canContinue () =
		b_printJob_canContinue (self#get_interne())

	method configPage () =
		b_printJob_configPage (self#get_interne())

	method commitJob () =
		b_printJob_commitJob (self#get_interne())

	method drawView : 'a 'b 'c . view:(#View.be_view as 'a) -> rect:(#Rect.be_rect as 'b) -> point:(#Point.be_point as 'c) -> unit =
		fun ~view ~rect ~point ->
		b_printJob_drawView (self#get_interne()) (view#get_interne()) (rect#get_interne()) (point#get_interne())
		
	method printableRect () =
		let rect = new be_rect in
		rect#set_interne (b_printJob_printableRect (self#get_interne()));
		rect

	method settings () =
		let message = new be_message in
		message#set_interne (b_printJob_settings (self#get_interne()));
		message
	
	method setSettings : 'a . configuration:(#Message.be_message as 'a) -> unit = fun ~configuration ->
		b_printJob_setSettings (self#get_interne()) ((configuration :> be_message)#get_interne())
		
	method spoolPage () =
		b_printJob_spoolPage (self#get_interne())

end;;
