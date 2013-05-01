open Glue;;
open Rect;;
open View;;

external b_stringView_stringview : pointer -> string -> string -> int32 -> int32 -> pointer = 
		(*"b_stringView_stringview_bytecode"*) 
		"b_stringView_stringview_native"
(*		
external b_stringView_attachedToWindow : be -> unit = "b_stringView_attachedToWindow"

external b_stringView_allAttached : be -> unit = "b_stringview_allAttached"
external b_stringView_draw : be -> be -> unit = "b_stringView_draw"
*)
class be_stringview =
	object(self)
	inherit be_view

	method be_stringView 
						 ~(frame : be_rect) 
						 ~(name:string) 
						 ~(text:string)
						 ?(resizing_mode = (Int32.logor kB_FOLLOW_LEFT 
						 								kB_FOLLOW_TOP)) 
						 ?(flags = kB_WILL_DRAW)
						 () = 
		self#set_interne (b_stringView_stringview ((frame : be_rect)#get_interne())
												  name 
												  text 
												  resizing_mode 
												  flags
						 )

(*		self#set_interne (b_view self 
								 (frame : be_rect)#get_interne 
								 name 
								 resizing_mode 
								 flags)
*)
(*
	method attachedToWindow () = 
		b_stringView_attachedToWindow self#get_interne
*)
(*	
	method allAttached () =
		b_stringView_allAttached self#get_interne
*)
(*	
	method draw : 'a. 
		updateRect:(#be_rect as 'a) ->
		unit =
		fun ~updateRect ->
		b_stringView_draw self#get_interne updateRect#get_interne
*)		
	method setText ~(string :string) =
		Printf.printf "be_stringView#setText non implemente.\n"; flush stdout;
(*
	method windowActivated ~(active:bool) =
		Printf.printf "be_stringView#WindowActivated non implemente.\n"; flush stdout;
*)		
end;;
(*
Callback.register "OStringView::allAttached" (fun o_c -> (find o_c)#allAttached());;

Callback.register "OStringView#draw" (fun o -> fun r -> let rect = new be_rect 
														in rect#set_interne r; 
														o#draw rect);;
*)
														
