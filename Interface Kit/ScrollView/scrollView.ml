open Glue
open InterfaceDefs
open ScrollBar
open View

external b_scrollView_scrollView : string -> pointer -> int32 -> int32 -> bool -> bool -> border_style -> pointer =
		"b_scrollView_scrollView_bytecode"
		"b_scrollView_scrollView_nativecode"

external b_scrollView_scrollBar : pointer -> orientation -> pointer = "b_scrollView_scrollBar"

class be_scrollView =
	object(self)
	inherit be_view as view

	method be_scrollView : 'a.
		name:string ->
		target:(#be_view as 'a) ->
		?resizingMode:int32 ->
		?flags:int32 ->
		?horizontal:bool ->
		?vertical:bool ->
		?border:border_style ->
		unit ->
		unit =

		fun ~name 
			~target
			?(resizingMode = Int32.logor kB_FOLLOW_LEFT 
										 kB_FOLLOW_TOP)
			?(flags = Int32.zero)
			?(horizontal = false)
			?(vertical = false)
			?(border = B_FANCY_BORDER)
			() ->
		self#set_interne (b_scrollView_scrollView name 
												  (target#get_interne())
												  resizingMode 
												  flags 
												  horizontal 
												  vertical
												  border)
		
	method scrollBar ~(posture:orientation) =
		let sc = new be_scrollBar
		in
		sc#set_interne (b_scrollView_scrollBar (self#get_interne()) posture);
		sc
end;;
