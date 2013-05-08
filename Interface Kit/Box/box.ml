open Glue;;
open View;;
open Rect;;
open InterfaceDefs;;

external b_box_box : #be_interne -> pointer -> string -> int32 -> int32 -> border_style -> pointer = "b_box_box_bytecode" "b_box_box_native"
external b_box_addChild : pointer -> pointer -> unit = "b_box_addChild" 
external b_box_allAttached : pointer -> unit = "b_box_allAttached"
external b_box_attachedToWindow : pointer -> unit = "b_box_attachedToWindow"
external b_box_windowActivated : pointer -> bool -> unit = "b_box_windowActivated"

class be_box =
	object(self)
	inherit be_view as view

	method be_box ~(frame : be_rect) 
				  ?(name = "") 
				  ?(resizingMode = Int32.logor kB_FOLLOW_LEFT kB_FOLLOW_TOP) 
				  ?(flags  = Int32.logor 
				  			(Int32.logor kB_WILL_DRAW 
				  						 kB_FRAME_EVENTS) 
				  						 kB_NAVIGABLE_JUMP)
				  ?(border = B_FANCY_BORDER) () =
		self#set_interne (b_box_box self (frame#get_interne()) name resizingMode flags border);

	method addChild : 'a 'b.
		aView:(#be_interne as 'a) ->
		?before:(#be_interne as 'b) ->
		unit ->
		unit =
		fun ~aView ?before () ->
		match before with 
		| None -> b_box_addChild (self#get_interne()) (aView#get_interne()) 
		| Some before -> failwith "be_box#addChild_before non implemente.\n"
		

	method allAttached () = 
		b_box_allAttached (self#get_interne())
		
	method attachedToWindow () = 
		b_box_attachedToWindow (self#get_interne())
		
	method windowActivated ~(active:bool) =
		b_box_windowActivated (self#get_interne())
	
end;;
