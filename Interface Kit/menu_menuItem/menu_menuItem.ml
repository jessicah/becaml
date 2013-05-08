open Glue
open GraphicsDefs
open Handler
open Invoker
open Looper
open Messenger
open Message
open Rect
open SupportDefs
open View

type menu_layout =
| B_ITEMS_IN_ROW
| B_ITEMS_IN_COLUMN
| B_ITEMS_IN_MATRIX
;;

external b_menu_menu : #be_interne -> string -> menu_layout -> pointer = "b_menu_menu"
external b_menu_menu_width_height : #be_interne -> string -> float -> float -> pointer = "b_menu_menu_width_height"
external b_menu_addItem : pointer -> pointer -> bool = "b_menu_addItem"
external b_menu_addItem_frame : pointer -> pointer -> pointer -> bool = "b_menu_addItem_frame"
external b_menu_addItem_submenu : pointer -> pointer -> bool = "b_menu_addItem_submenu"
external b_menu_addItem_submenu_frame : pointer -> pointer -> pointer -> bool = "b_menu_addItem_submenu_frame"
external b_menu_addSeparatorItem : pointer -> bool = "b_menu_addSeparatorItem"
external b_menu_countItems : pointer -> int32 = "b_menu_countItems"
external b_menu_itemAt : pointer -> int32 -> pointer = "b_menu_itemAt"
external b_menu_removeItem_index : pointer -> int32 -> pointer = "b_menu_removeItem_index"
external b_menu_removeItem_item : pointer -> pointer -> bool = "b_menu_removeItem_item"
external b_menu_setHighColor : pointer -> int -> int -> int -> int -> unit = "b_menu_setHighColor"
external b_menu_setHighColor_rgb : pointer -> rgb_color -> unit = "b_menu_setHighColor_rgb"
external b_menu_setTargetForItems : pointer -> pointer -> status_t = "b_menu_setTargetForItems"
external b_menu_submenuAt : pointer -> int32 -> pointer = "b_menu_submenuAt"

external b_menuItem_menuItem : #be_interne -> string -> pointer -> char -> int -> pointer = "b_menuItem_menuItem"
external b_menuItem_draw : pointer -> unit = "b_menuItem_draw"
external b_menuItem_frame : pointer -> pointer = "b_menuItem_frame"
external b_menuItem_getContentSize : pointer -> float ref -> float ref -> unit = "b_menuItem_getContentSize_prot"
external b_menuItem_invoke : pointer -> status_t = "b_menuItem_invoke"
external b_menuItem_invoke_message : pointer -> pointer -> status_t = "b_menuItem_invoke_message"
external b_menuItem_isMarked : pointer -> bool = "b_menuItem_isMarked"
external b_menuItem_isSelected : pointer -> bool = "b_menuItem_isSelected"
external b_menuItem_label : pointer -> string = "b_menuItem_label"
external b_menuItem_menu : pointer -> pointer = "b_menuItem_menu"
external b_menuItem_setEnabled : pointer -> bool -> unit = "b_menuItem_setEnabled"
external b_menuItem_setMarked : pointer -> bool -> unit = "b_menuItem_setMarked"
external b_menuItem_setTarget : pointer -> pointer -> status_t = "b_menuItem_setTarget"
external b_menuItem_setTarget_looper : pointer -> pointer -> pointer -> status_t = "b_menuItem_setTarget_looper"

external b_separatorItem_separatorItem : unit -> pointer = "b_separatorItem_separatorItem"

class be_menu =
	object(self : 'be_menu)
	inherit be_view

	method be_menu ~name ?(width : float option) ?(height : float option) ?(menu_layout = B_ITEMS_IN_COLUMN) () =
		match width,height with
		| None, None -> self#set_interne(b_menu_menu self name menu_layout)
		| Some width, Some height ->
                                self#set_interne(b_menu_menu_width_height self name width height)
		| _ -> failwith "be_menu#be_menu : paramètres incorrects\n"

	method addItem : 'a 'b 'c. ?item:(#be_interne as 'a) ->  
							   ?index:int32 ->
							   ?submenu:(#be_interne(*be_menu*) as 'b) ->
							   ?frame:(#be_rect as 'c) ->
							   unit -> bool =
		fun ?item ?index ?submenu ?frame () ->
		match item, submenu, frame with
		| Some menuItem, None, None ->       b_menu_addItem               (self#get_interne()) (menuItem#get_interne())
		| Some menuItem, None, Some frame -> b_menu_addItem_frame         (self#get_interne()) (menuItem#get_interne())	(frame#get_interne())
		| None, Some submenu, None ->        b_menu_addItem_submenu       (self#get_interne()) (submenu#get_interne())
		| None, Some submenu, Some frame ->  b_menu_addItem_submenu_frame (self#get_interne()) (submenu#get_interne()) (frame#get_interne())
		| _ -> failwith "be_menu#addItem : parametres manquants."

	method addSeparatorItem () =
		b_menu_addSeparatorItem (self#get_interne())
	
	method countItems () =
		b_menu_countItems (self#get_interne())
		
	method itemAt ~index =	
		let mi = new be_menuItem
		in
		mi#set_interne (b_menu_itemAt (self#get_interne()) index);
		mi

	method removeItem : 'a 'b .
		?index:int32 ->
		?item:(#be_interne as 'a) ->
		?submenu:'b ->
		unit ->
		(bool option * (#be_interne ) (*be_menuItem*)option) =
		fun ?index ?item ?submenu () ->
		match index,item with
		| Some index, None -> let mi = new be_menuItem
							  in
							  mi#set_interne (b_menu_removeItem_index (self#get_interne()) index);
							  (None, Some mi)
		| None, Some item -> Some (b_menu_removeItem_item (self#get_interne()) (item#get_interne())),None
		| _ -> (Printf.printf "be_menu#removeItem non implemente avec d'autres parametres que item ou index.\n";flush stdout;
				(Some true, None)
			   )
		method setHighColor?rgb_color ?red ?green ?blue ?(alpha = 255) () =
			match rgb_color, red, green, blue with
			| None, Some red, Some green, Some blue ->
				b_menu_setHighColor (self#get_interne()) red green blue alpha
			| Some rgb_color, None, None, None ->
				b_menu_setHighColor_rgb (self#get_interne()) rgb_color
			| _ -> failwith "Erreur dans les parametres de be_menu#setHighColor"


	method setTargetForItems : 'a.  handler:(#be_Handler as 'a) -> status_t =
		fun ~handler ->
		print_string "[OCaml]be_menu#setTargetForItems\n";flush stdout;
		b_menu_setTargetForItems (self#get_interne()) (handler#get_interne())

	method submenuAt : 
		index:int32 ->
		#be_interne  =
		fun ~index ->
		let m = new be_menu
		in
		m#set_interne (b_menu_submenuAt (self#get_interne()) index);
		m
		

end
and be_menuItem =
	object(self)
	inherit be_Invoker

	method be_menuItem ~label ~(message : be_message) ?(shortcut='\000') ?(modifiers=0) ()=
                interne <- (b_menuItem_menuItem self label (message#get_interne()) shortcut modifiers)
	
	method draw () =
		b_menuItem_draw (self#get_interne())
		
	method frame () =
		let r = new be_rect
		in
		r#set_interne (b_menuItem_frame (self#get_interne()));
		r
	
	method getContentSize ~width ~height =
		b_menuItem_getContentSize (self#get_interne()) width height
		
	method invoke ?message () =
		match message with 
		| None ->  b_menuItem_invoke (self#get_interne()) 
		| Some message -> b_menuItem_invoke_message (self#get_interne()) (message#get_interne())

	method isMarked () =
		b_menuItem_isMarked (self#get_interne())

	method isSelected () =
		b_menuItem_isSelected (self#get_interne())
		
	method label () =
		b_menuItem_label (self#get_interne())
		
	method menu () = 
		let menu = new be_menu
		in
		menu#set_interne (b_menuItem_menu (self#get_interne()));
		menu
	
	method setEnabled ~(enabled : bool) =
		b_menuItem_setEnabled (self#get_interne()) enabled
	
	method setMarked ~flag =
		b_menuItem_setMarked (self#get_interne()) flag

	method setTarget : 'a 'b 'c.
		?messenger	:	(#be_messenger	as 'a) ->
		?handler	:	(#be_Handler	as 'b) ->
		?looper		:	(#be_Looper		as 'c) ->
		unit ->
		status_t =
		Printf.printf "Appel de menuItem#setTarget\n";flush stdout;
		fun ?messenger ?handler ?looper () ->
		match messenger,handler,looper with
		| None, Some handler, None -> b_menuItem_setTarget (self#get_interne()) (handler#get_interne())
		| None, Some handler, Some looper -> b_menuItem_setTarget_looper (self#get_interne()) (handler#get_interne()) (looper#get_interne())
		| _ -> failwith "be_menuItem#setTarget implémenté juste avec handler"
		
end;;


class be_separatorItem =
	object(self)
	inherit be_menuItem as menuItem

	method be_separatorItem () =
			self#set_interne(b_separatorItem_separatorItem ())
		
end;;
(*
 * Callback.register "Menu#SetTargetForItems" (fun m_c -> fun t_c -> 
launch_and_get (fun () -> ((find m_c)#setTargetForItems (find t_c)) ;;
*)
(*
Callback.register "MenuItem#Invoke" (fun mi_c -> fun m_c -> 
		print_string "[OCaml] MenuItem#Invoke\n";flush stdout;
		let m = try find m_c
				with Not_found -> print_string "[OCaml]MenuItem#Invoke : m_c not found.\n";flush stdout;
				                  let m' = new be_message
								  in m'#set_interne m_c;
								     m'
		and mi = try find mi_c
				with Not_found -> print_string "[OCaml]MenuItem#Invoke : mi_c not found.\n";flush stdout;
				                  let mi = new be_menuItem
								  in mi#set_interne mi_c;
								     mi

		in 
		(*launch_and_get (fun () ->*)  (mi :> #be_menuItem)#invoke 
									~message:(m :> #be_message) ()) 
		(*)*);;
Callback.register "MenuItem#draw" (fun m_c -> ((find m_c) :> be_menuItem)#draw ());;
Callback.register "MenuItem#getContentSize" 
	(fun m_c -> fun w -> fun h -> 
		((find m_c) :> be_menuItem)#getContentSize ~width:w ~height:h);;
*)
