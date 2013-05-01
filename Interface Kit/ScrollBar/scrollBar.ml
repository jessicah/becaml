open Glue
open InterfaceDefs
open Rect
open View

let kB_V_SCROLL_BAR_WIDTH = 14.0
and kB_H_SCROLL_BAR_HEIGHT = 14.0 

external b_scrollBar_setRange : pointer -> float -> float -> unit = "b_scrollBar_setRange"

class be_scrollBar =
	object(self)
	inherit be_view
	
	method be_scrollBar : 'a 'b.
		frame:(#be_rect as 'a) ->
		name:string ->
		target:(#be_view as 'b) ->
		min:float ->
		max:float ->
		posture:orientation ->
		unit =
		fun ~frame ~name ~target ~min ~max ~posture ->
		Printf.printf "be_scrollBar#be_scrollBar non implemente.\n"; flush stdout

	method setRange ~(min:float) ~(max:float) =
		b_scrollBar_setRange (self#get_interne()) min max	
end
