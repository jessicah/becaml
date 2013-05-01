open Control
open Glue
open Message
open Rect
open TextView
open View

external b_textControl_textControl : pointer -> 
									 string -> 
									 string -> 
									 string -> 
									 pointer -> 
									 int32 -> 
									 int32 -> 
									 pointer = 
									 "b_textControl_textControl_bytecode"
									 "b_textControl_textControl_nativecode"
external b_textControl_resizeToPreferred : pointer -> unit = "b_textControl_resizeToPreferred"
external b_textControl_textView : pointer -> pointer = "b_textControl_textView"
external b_textControl_text : pointer -> string = "b_textControl_text"
external b_textControl_setText : pointer -> string -> unit = "b_textControl_setText"

class be_textControl =
	object(self)
	inherit be_control as control

	method be_textControl : 
		'a 'b. frame:(#be_rect as 'a) -> 
			   name:string -> 
			   label:string -> 
			   text:string -> 
			   message:(#be_message as 'b) ->
			   ?resizingMode:int32 -> ?flags:int32 -> 
			   unit ->
			   unit =
		fun ~frame ~name ~label ~text ~message 
			?(resizingMode = Int32.logor kB_FOLLOW_LEFT kB_FOLLOW_TOP)
			?(flags = Int32.logor kB_WILL_DRAW kB_NAVIGABLE) () ->
		
		self#set_interne (b_textControl_textControl (frame#get_interne())
													name
													label
													text
													(message#get_interne())
													resizingMode
													flags)
				
	method resizeToPreferred () =
		b_textControl_resizeToPreferred (self#get_interne())
		
	method setText ~(text:string) =
		b_textControl_setText (self#get_interne()) text

	method text () =
		b_textControl_text (self#get_interne())

	method textView () =
		let tv = new be_textView
		in
		tv#set_interne (b_textControl_textView (self#get_interne()));
		tv
end
