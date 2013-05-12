
open Archivable
open Bitmap
open Bstring
open Font
open Glue
open GraphicsDefs
open Handler
open Looper
open Message
open Point
open Polygon
open Rect
open Shape
open SupportDefs

(*Constantes*)
external b_follow_all : unit -> int32 = "b_follow_all"
external b_follow_left : unit -> int32 = "b_follow_left"
external b_follow_left_right : unit -> int32 = "b_follow_left_right"
external b_follow_top : unit -> int32 = "b_follow_top"
external b_follow_none : unit -> int32 = "b_follow_none"
external b_will_draw : unit -> int32 = "b_will_draw"
external b_frame_events : unit -> int32 = "b_frame_events"
external b_navigable :  unit -> int32 = "b_navigable"
external b_navigable_jump :  unit -> int32 = "b_navigable_jump"

external b_font_all : unit -> int32 = "b_font_all"
external b_primary_mouse_button : unit -> int32 = "b_primary_mouse_button"
external b_secondary_mouse_button : unit -> int32 = "b_secondary_mouse_button"
external b_tertiary_mouse_button : unit -> int32 = "b_tertiary_mouse_button"

external b_not_movable : unit -> int32 = "b_not_movable"
external b_not_resizable : unit -> int32 = "b_not_resizable"
external b_not_zoomable : unit -> int32 = "b_not_zoomable"
external b_not_minimizable : unit -> int32 = "b_not_minimizable"
external b_asynchronous_controls : unit -> int32 = "b_asynchronous_controls"
external b_current_workspace : unit -> int32 = "b_current_workspace"

(*Méthodes*)
external b_view : <get_interne : unit -> pointer;..> -> pointer -> string -> int32 -> int32 -> pointer = "b_view" 
external b_view_addChild : pointer -> pointer -> unit = "b_view_addChild"
external b_view_allAttached : pointer -> unit = "b_view_allAttached"
external b_view_attachedToWindow : pointer -> unit = "b_view_attachedToWindow"
external b_view_bounds : pointer -> pointer = "b_view_bounds"
external b_view_childAt : pointer -> int32 -> pointer = "b_view_childAt"
external b_view_countChildren : pointer -> int32 = "b_view_countChildren"
external b_view_draw : pointer -> pointer -> unit = "b_view_draw"
external b_view_drawBitmap_destination : pointer -> pointer -> pointer -> unit = "b_view_drawBitmap_destination"
external b_view_drawString : pointer -> string -> pointer -> unit = "b_view_drawString"
external b_view_fillPolygon_aPolygon : pointer -> pointer -> pattern -> unit = "b_view_fillPolygon_aPolygon"
external b_view_fillPolygon_pointList : pointer -> 'a array -> int32 -> pattern -> unit = "b_view_fillPolygon_pointList"
external b_view_fillPolygon_pointList_rect : pointer -> 'a array -> int32 -> pointer -> pattern -> unit = "b_view_fillPolygon_pointList_rect"
external b_view_fillRect : pointer -> pointer -> pattern -> unit = "b_view_fillRect"
external b_view_frame : pointer -> pointer = "b_view_frame"
external b_view_getFont : pointer -> pointer -> unit = "b_view_getFont"
external b_view_getMouse : pointer -> (#be_interne ref) -> int32 ref -> bool -> unit = "b_view_getMouse"
external b_view_highColor : pointer -> rgb_color = "b_view_highColor"
external b_view_invalidate : pointer -> unit = "b_view_invalidate"
external b_view_invalidate_rect : pointer -> 'a -> unit = "b_view_invalidate_rect"
external b_view_isPrinting : pointer -> bool = "b_view_isPrinting"
external b_view_messageReceived : pointer -> pointer -> unit = "b_view_messageReceived"
external b_view_mouseDown : pointer -> pointer -> unit = "b_view_mouseDown"
(*external b_view_mouseMoved : pointer -> pointer -> int32 -> pointer ->unit = "b_view_mouseMoved"*)
external b_view_moveBy : pointer -> float -> float -> unit = "b_view_moveBy"
external b_view_movePenTo_pt : pointer -> pointer -> unit = "b_view_movePenTo_pt"
external b_view_moveTo : pointer -> pointer -> unit = "b_view_moveTo"
external b_view_name : pointer -> string = "b_view_name"
external b_view_resizeBy : pointer -> float -> float -> unit = "b_view_resizeBy"
external b_view_resizeTo : pointer -> float -> float -> unit = "b_view_resizeTo"
external b_view_resizeToPreferred : pointer -> unit = "b_view_resizeToPreferred"
external b_view_setDrawingMode : pointer -> drawing_mode -> unit = "b_view_setDrawingMode"
external b_view_setHighColor : pointer -> int -> int -> int -> int -> unit = "b_view_setHighColor"
external b_view_setHighColor_rgb : pointer -> rgb_color -> unit = "b_view_setHighColor_rgb"external b_setfont : pointer -> pointer -> int32 -> unit = "b_setfont"
external b_setfontsize : 'a -> float -> unit = "b_setfontsize"
external b_view_setPenSize : pointer -> float -> unit = "b_view_setPenSize"
external b_view_setScale : pointer -> float -> unit = "b_view_setScale"
external b_view_setViewColor : pointer -> int -> int -> int -> int -> unit = "b_view_setViewColor"
external b_view_setViewColor_rgb : pointer -> rgb_color -> unit = "b_view_setViewColor_rgb"
external b_view_strokePolygon_polygon        : pointer -> pointer -> bool -> pattern -> unit = "b_view_strokePolygon_polygon" 
external b_view_strokePolygon_pointList      : pointer -> 'a array -> int32 -> bool -> pattern -> unit = "b_view_strokePolygon_pointList" 
external b_view_strokePolygon_pointList_rect : pointer -> 'a array -> int32 -> pointer -> bool -> pattern -> unit = "b_view_strokePolygon_pointList_rect_bytecode" "b_view_strokePolygon_pointList_rect_nativecode"
external b_view_strokeShape                  : pointer -> pointer -> pattern -> unit = "b_view_strokeShape"
external b_view_window : pointer -> pointer = "b_view_window"

type window_look = | B_DOCUMENT_WINDOW_LOOK
				   | B_TITLED_WINDOW_LOOK 
				   | B_FLOATING_WINDOW_LOOK 
				   | B_MODAL_WINDOW_LOOK
				   | B_BORDERED_WINDOW_LOOK
				   | B_NO_BORDER_WINDOW_LOOK

type window_feel = | B_NORMAL_WINDOW_FEEL 
				   | B_MODAL_SUBSET_WINDOW_FEEL 
				   | B_MODAL_APP_WINDOW_FEEL 
				   | B_MODAL_ALL_WINDOW_FEEL
				   | B_FLOATING_SUBSET_WINDOW_FEEL 
				   | B_FLOATING_APP_WINDOW_FEEL 
				   | B_FLOATING_ALL_WINDOW_FEEL

type window_type = | B_TITLED_WINDOW 
				   | B_DOCUMENT_WINDOW 
				   | B_MODAL_WINDOW 
				   | B_FLOATING_WINDOW 
				   | B_BORDERED_WINDOW 
				   | B_UNTYPED_WINDOW 

type view_events = | B_POINTER_EVENTS
				   | B_KEYBOARD_EVENTS

type events_mask = | B_LOCK_WINDOW_FOCUS
				   | B_SUSPEND_VIEW_FOCUS
				   | B_NO_POINTER_HISTORY

external b_window_type :  <set_interne : pointer -> unit; ..> -> pointer -> string -> window_type -> int32 -> int32 -> pointer = "b_window_type_bytecode" "b_window_type_native" 
(*
external b_window_look_feel : pointer -> string -> window_look -> window_feel -> int32 -> int32 -> pointer = "b_window_look_feel"
*)
external b_window_activate : pointer -> bool -> unit = "b_window_activate"
(*
external b_window_addChild_sibling : pointer -> pointer -> pointer -> unit = "b_window_addChild_sibling"
*)
external b_window_addChild_view : pointer -> pointer -> unit = "b_window_addChild_view"
external b_window_bounds : pointer -> pointer = "b_window_bounds"
external b_window_currentFocus : pointer -> pointer = "b_window_currentFocus"
external b_window_currentMessage : pointer -> pointer = "b_window_currentMessage"
external b_window_instantiate : pointer -> pointer -> pointer = "b_window_instantiate"
external b_window_isActive : pointer -> bool = "b_window_isActive"
external b_window_messageReceived : pointer -> pointer -> unit = "b_window_messageReceived"
external b_window_menusBeginning : pointer -> unit = "b_window_menusBeginning"
external b_window_postMessage_message : pointer -> pointer -> status_t = "b_window_postMessage_message"
external b_window_postMessage_command : pointer -> int32 -> status_t = "b_window_postMessage_command"
external b_window_postMessage_handler_message : pointer -> pointer -> pointer -> status_t = "b_window_postMessage_handler_message"
external b_window_postMessage_handler_message_reply : pointer -> pointer -> pointer -> pointer -> status_t = "b_window_postMessage_handler_message_reply"
external b_window_postMessage_handler_command : pointer -> pointer -> int32 -> status_t = "b_window_postMessage_handler_command"
external b_window_postMessage_handler_command_reply : pointer -> pointer -> int32 -> pointer -> status_t = "b_window_postMessage_handler_command_reply"
external b_window_quit: pointer -> unit = "b_window_quit"
external b_window_quitRequested : pointer -> bool = "b_window_quitRequested"
external b_window_removeChild : pointer -> pointer -> bool = "b_window_removeChild"
external b_window_resizeTo : pointer -> float -> float -> unit = "b_window_resizeTo"
external b_window_setTitle : pointer -> string -> unit = "b_window_setTitle"
external b_window_show : pointer -> unit = "b_window_show"
external b_window_title : pointer -> string = "b_window_title"
external b_window_windowActivated : pointer -> bool -> unit = "b_window_windowActivated"

let kB_FOLLOW_ALL = b_follow_all();;
let kB_FOLLOW_TOP = b_follow_top();;
let kB_FOLLOW_LEFT = b_follow_left();;
let kB_FOLLOW_LEFT_RIGHT = b_follow_left_right();;
let kB_FOLLOW_NONE = b_follow_none();;

let kB_FRAME_EVENTS = b_frame_events();;
let kB_WILL_DRAW = b_will_draw();;
let kB_NAVIGABLE = b_navigable();;
let kB_NAVIGABLE_JUMP = b_navigable_jump();;
let kB_FONT_ALL = b_font_all();;
let kB_PRIMARY_MOUSE_BUTTON = b_primary_mouse_button ();;
let kB_SECONDARY_MOUSE_BUTTON = b_secondary_mouse_button ();;
let kB_TERTIARY_MOUSE_BUTTON = b_tertiary_mouse_button ();;

let kB_NOT_RESIZABLE = b_not_resizable()
let kB_NOT_ZOOMABLE = b_not_zoomable()
let kB_NOT_MOVABLE = b_not_movable()
let kB_NOT_MINIMIZABLE = b_not_minimizable()
let kB_ASYNCHRONOUS_CONTROLS = b_asynchronous_controls()
let kB_CURRENT_WORKSPACE = b_current_workspace()




class be_view =
	object(self)
	inherit be_Handler as handler

         method be_view : 'a.frame:(#be_rect as 'a) -> name:string -> resizingMode:int32 -> flags:int32 -> unit =       
                fun ~frame ~name ~resizingMode ~flags ->
                let p = b_view self ((frame:#be_rect :> be_rect)#get_interne()) name resizingMode flags
                in
                interne <- p
	method addChild : 'a 'b.
		aView:(#be_interne as 'a) ->
		?before:(#be_interne as 'b) ->
		unit ->
		unit =
		fun ~aView ?before () ->
		match before with 
		| None -> b_view_addChild (self#get_interne()) (aView#get_interne()) 
		| Some before -> failwith "be_view#addChild_before non implemente.\n"
		
	method allAttached () =
		b_view_allAttached (self#get_interne()) 	
	
	method attachedToWindow () =
		b_view_attachedToWindow (self#get_interne()) 	

	method bounds () =
		let _r = new be_rect 
		in
		_r#set_interne(b_view_bounds (self#get_interne())); _r
	
	method childAt ~(index:int32) =
		let v = new be_view
		in
		v#set_interne(b_view_childAt (self#get_interne()) index);
		v
		
	method countChildren () =
		b_view_countChildren (self#get_interne())

	method draw : 'a.
		updateRect:(#be_rect as 'a) ->
		unit = 
		fun ~updateRect ->
		(*launch_and_get (fun () ->*)
		b_view_draw (self#get_interne()) (updateRect#get_interne())(* ) *)
	
	method drawBitmap : 'a 'b 'c 'd. image:(#be_Bitmap as 'a) -> ?point:(#be_rect as 'b) -> ?source:(#be_rect as 'c) -> ?destination:(#be_rect as 'd) -> unit -> unit =
		fun ~image ?point ?source ?destination () ->
		match point,source,destination with
		| None, None, Some destination -> b_view_drawBitmap_destination (self#get_interne()) (image#get_interne()) (destination#get_interne())
		| _ ->	Printf.printf "be_view#drawBitmap non implemente avec d'autres parametres que uniquement 'destination'\n";flush stdout;
		
	method drawString ~chaine ~point =
		b_view_drawString (self#get_interne()) chaine ((point : be_point)#get_interne())
		
	method fillEllipse ?(rect : be_rect option) 
					   ?(center : be_point option) 
					   ?(xRadius : float option) ?(yRadius : float option)
					   ?(aPattern  = kB_SOLID_HIGH) 
					   () =
		(failwith "be_view#fillEllipse" : unit)				   


	method fillPolygon  ?(aPolygon : be_polygon option) ?(aPattern = kB_SOLID_HIGH) 
						?(pointList : be_point array option) ?numPoints ?(rect : be_rect option) ()=
		match aPolygon, pointList, numPoints, rect with
		| Some aPolygon, None, None, None -> 
			b_view_fillPolygon_aPolygon (self#get_interne()) (aPolygon#get_interne()) aPattern
		| None, Some pointList, Some numPoints, None -> 
			b_view_fillPolygon_pointList (self#get_interne()) (Array.map (fun o -> o#get_interne()) pointList) 
														  numPoints 
														  aPattern
		| None, Some pointList, Some numPoints, Some rect -> 
		b_view_fillPolygon_pointList_rect (self#get_interne()) (Array.map (fun o -> o#get_interne()) pointList) numPoints (rect#get_interne()) aPattern
		| _ -> failwith "be_view#fillPolygon : parametres incorrects."
	
	method fillRect : 
		'a . rect:(#be_rect as 'a) -> 
			 ?pattern:pattern -> 
			 unit -> 
			 unit =
		fun	~rect ?(pattern = kB_SOLID_HIGH) () ->
			Printf.printf "view#fillRect avec rect =\n";flush stdout;
			rect#printToStream();
			b_view_fillRect (self#get_interne()) (rect#get_interne()) pattern
			
	method frame () =
		let f = new be_rect
		in
		f#set_interne (b_view_frame (self#get_interne()));
		f

	method getFont ~(font : be_font ref) =
		b_view_getFont (self#get_interne()) (!font#get_interne());
	
	method getMouse : 'a. location:((#be_point as 'a) ref) -> buttons:(int32 ref) -> ?checkMessageQueue:bool -> unit -> unit =
		fun ~location ~buttons ?(checkMessageQueue = true) () ->
		b_view_getMouse (self#get_interne()) location buttons checkMessageQueue
	
	method highColor () =
		b_view_highColor (self#get_interne())
		
	method invalidate ?rect () =
		match rect with
		| Some rect -> 
			print_string "[OCaml]be_view#invalidate_rect\n";flush stdout;
			b_view_invalidate_rect (self#get_interne()) ((rect : be_rect)#get_interne())
		| None -> 
			print_string "[OCaml]be_view#invalidate\n";flush stdout;
			b_view_invalidate (self#get_interne())
	
	method isPrinting () =
		b_view_isPrinting (self#get_interne())

	method messageReceived ~message =
		Printf.printf "[OCaml] be_view#messageReceived\n"; flush stdout;
		b_view_messageReceived (self#get_interne()) (message#get_interne())
	
	method mouseDown :	'a. point:(#be_point as 'a) -> unit =
		fun ~point -> 
			b_view_mouseDown (self#get_interne()) (point#get_interne())

(*	method mouseMoved : 'a 'b. where:(#be_point as 'a) -> code:int32 -> a_message:(#be_message as 'b) -> unit =
		fun ~where ~code ~a_message ->
			b_view_mouseMoved self#get_interne() where#get_interne() code a_message#get_interne()
*)		
	method moveBy ~(dh:float) ~(dv :float) =
		b_view_moveBy (self#get_interne()) dh dv
	
	method movePenTo ?(pt : be_point option) ?(x : float option)  ?(y : float option) () =
		match pt with 
		| Some pt -> b_view_movePenTo_pt (self#get_interne()) (pt#get_interne())
		| None -> (failwith "be_view#movePenTo_x_y non implemente" : unit)
	
	method moveTo : 
		'a. ?where:(#be_point as 'a) ->
			?x:float ->
			?y:float -> 
			unit ->
			unit =
		fun ?where ?x ?y () ->
			match where with 
			| Some where -> b_view_moveTo (self#get_interne()) (where#get_interne())
			| None ->
		Printf.printf "be_view#moveTo_x_y non implemente\n";flush stdout
		
	method name () =
		b_view_name (self#get_interne())

	method resizeTo ~width ~height =
		b_view_resizeTo (self#get_interne()) width height
	
	method resizeBy ~(horizontal : float) ~(vertical : float) =
		b_view_resizeBy (self#get_interne()) horizontal vertical

	method resizeToPreferred () =
		b_view_resizeToPreferred (self#get_interne())
		
	method setDrawingMode ~(mode : drawing_mode) =
		b_view_setDrawingMode (self#get_interne()) mode
	
	method setFont ~(font : be_font) ?(properties = kB_FONT_ALL) () =
		b_setfont (self#get_interne()) (font#get_interne()) properties

	method setFontSize  ~points =
		b_setfontsize (self#get_interne()) points
	
	method setHighColor ?rgb_color ?red ?green ?blue ?(alpha = 255) () =
		match rgb_color, red, green, blue with
		| None, Some red, Some green, Some blue ->
			b_view_setHighColor (self#get_interne()) red green blue alpha
		| Some rgb_color, None, None, None ->
			b_view_setHighColor_rgb (self#get_interne()) rgb_color
		| _ -> failwith "Erreur dans les parametres de be_view#setHighColor"
	
	method setMouseEventMask ~(mask:view_events) ?(options:events_mask list option) () =
		(failwith "be_view#setMouseEventMask" : unit)
	
	method setPenSize ~(size:float) =
		b_view_setPenSize (self#get_interne()) size
		
	method setScale ~ratio =
		b_view_setScale (self#get_interne()) ratio

	method setViewColor?rgb_color ?red ?green ?blue ?(alpha = 255) () =
		match rgb_color, red, green, blue with
		| None, Some red, Some green, Some blue ->
			b_view_setViewColor (self#get_interne()) red green blue alpha
		| Some rgb_color, None, None, None ->
			b_view_setViewColor_rgb (self#get_interne()) rgb_color
		| _ -> failwith "Erreur dans les parametres de be_view#setViewColor"

	method strokePolygon ?(polygon : be_polygon option) ?(isClosed = true) 
						 ?(aPattern = kB_SOLID_HIGH) 
						 ?(pointList : be_point array option) ?numPoints ?(rect : be_rect option) () =
		match polygon, pointList, numPoints, rect with
		| Some polygon, None, None, None -> 
				b_view_strokePolygon_polygon (self#get_interne()) 
											 (polygon#get_interne()) isClosed aPattern
		| None, Some pointList, Some numPoints, None -> 
				b_view_strokePolygon_pointList (self#get_interne()) 
											   (Array.map (fun o -> o#get_interne()) pointList) 
											   numPoints 
											   isClosed 
											   aPattern
		| None, Some pointList, Some numPoints, Some rect -> 
				b_view_strokePolygon_pointList_rect (self#get_interne()) 
													(Array.map (fun o -> o#get_interne()) pointList) 
													numPoints 
													(rect#get_interne()) 
													isClosed 
													aPattern
		| _ -> failwith "be_view#strokePolygon : parametres incorrects."	

	method strokeShape ~(shape : be_shape) ?(pattern = kB_SOLID_HIGH) () =
		b_view_strokeShape (self#get_interne()) (shape#get_interne()) pattern
	
	method strokeRect ~rect ?(pattern = kB_SOLID_HIGH) () =
		ignore (rect : be_rect);
		(failwith "be_view#strokeRect" : unit);
	
	method window () =
		let win = new be_window 
		in 
		win#set_interne	(b_view_window (self#get_interne()));
		win
		
end	
and be_window =
	object(self)
	inherit be_Looper
	
	method be_window ~frame ~title ?window_type ?window_look ?window_feel ~flags 
					 ?(workspaces = kB_CURRENT_WORKSPACE) ?archive () = 
		match window_type,window_look,window_feel,archive with
		| Some window_type, None, None, None -> 
			let w = b_window_type self  ((frame : be_rect)#get_interne())
											title 
											window_type 
											flags 
								 			workspaces
			in (*Printf.printf "[ocaml]b_window_type -> 0x%lX\n" w;
                        flush stdout;*)
                        interne <- w
		| None, Some (l:window_look), Some (f:window_feel), None ->()
			(*
			self#set_interne(b_window_look_feel (frame : be_rect)#get_interne() title l 
								 f flags workspaces)
			*)
		| None, None, None, Some a -> ignore (a : be_rect)
		| _ -> failwith "be_window#be_window : paramètres incorrects";

	method be_window_ () = ()
		method activate ?(flag = true) () = 
		b_window_activate (self#get_interne()) flag
		
    method addChild : 'a 'b. aView:(#be_interne as 'a) -> ?sibling:(#be_interne as 'b) -> unit -> unit =
		fun ~aView -> fun ?sibling -> fun () ->
		match sibling with
		| Some sibling -> failwith "appel de be_window#addChild ~aview ~sibling" (*b_window_addChild_sibling self#get_interne() aView#get_interne() sibling#get_interne()*)
		| None ->  b_window_addChild_view (self#get_interne()) (aView#get_interne())
	
	method bounds () = 
		let r = new be_rect 
		in 
		r#set_interne (b_window_bounds (self#get_interne()));
		r
		
	method currentFocus () =
		let v = new be_view
		in
		v#set_interne(b_window_currentFocus (self#get_interne()));
		v
		
	method currentMessage () =
		let mess = new be_message
		in
		mess#set_interne (b_window_currentMessage (self#get_interne()));
		mess

	method instantiate ~archive = 
		let archivable = new be_Archivable
		in
		archivable#set_interne(b_window_instantiate (self#get_interne()) (archivable#get_interne()));
		archivable
		
	method isActive () = 
		b_window_isActive (self#get_interne()) 
		
	method menusBeginning () =
		b_window_menusBeginning (self#get_interne())

(*	method messageReceived ~message =
		print_string "[OCaml] be_window#messageReceived non implemente XXXXXXXX\n";flush stdout;
*)	method postMessage : 'a.
		?message:(#be_message as 'a) ->
		?command:int32 ->
		?handler:be_Handler ->
		?reply_handler : be_Handler ->
		unit ->
		status_t =
		print_string "[OCaml] be_window#postMessage appele\n";flush stdout;
	fun ?message ?command ?handler ?reply_handler () ->
	         match handler,message,command,reply_handler  with
			 | None, Some m, None, None ->     b_window_postMessage_message (self#get_interne()) (m#get_interne())
			 | None, None, Some c, None ->     b_window_postMessage_command (self#get_interne()) c
			 | Some h, Some m, None, None ->   b_window_postMessage_handler_message (self#get_interne())       ((h : be_Handler)#get_interne()) (m#get_interne())
			 | Some h, Some m, None, Some r -> b_window_postMessage_handler_message_reply (self#get_interne()) ((h : be_Handler)#get_interne()) (m#get_interne()) ((r : be_Handler)#get_interne())
			 | Some h, None, Some c, None ->   b_window_postMessage_handler_command (self#get_interne())       ((h : be_Handler)#get_interne()) c
			 | Some h, None, Some c, Some r -> b_window_postMessage_handler_command_reply (self#get_interne()) ((h : be_Handler)#get_interne()) c ((r : be_Handler)#get_interne())
			 | _ -> failwith "be_window#postMessage : mauvais nombre d'arguments"
			 
	method quit () =
		Printf.printf "[OCaml] be_window#quit(), appel de b_window_quit\n";flush stdout;
		b_window_quit (self#get_interne())

	method quitRequested () =
		Printf.printf "[OCaml] be_window#quitRequested(), appel de b_window_quitrequested \n";flush stdout;
		b_window_quitRequested (self#get_interne())
		
        method removeChild ~aView = 
		b_window_removeChild (self#get_interne()) ((aView : #be_view :> be_view)#get_interne())
	
	method resizeTo ~width ~height =
		b_window_resizeTo (self#get_interne()) width height
	
	method show () =
		Printf.printf "[OCaml] be_window#show(), appel de b_window_show \n";flush stdout;
		b_window_show (self#get_interne())

	
	method title () =
		b_window_title (self#get_interne())

	method setTitle ~title =
		b_window_setTitle (self#get_interne()) title
	
	method windowActivated ~active = 
		b_window_windowActivated (self#get_interne()) active
	

end
;;
(*
Callback.register "OView::AddChild" (fun w_c -> fun v_c -> 
									(find w_c : #be_view)#addChild ~aView:(find v_c)  ()) ;;
Callback.register "OView::AddChild_sibling" (fun w_c -> fun v_c -> fun s_c ->
									(find w_c : #be_view)#addChild ~aView:(find v_c) 
																   ~before:(find s_c) ()) ;;
Callback.register "OView::AllAttached" (fun v_c -> let v = (find v_c : #be_view) in v#allAttached ()) ;;
Callback.register "OView::AttachedToWindow" (fun v_c -> let v : #be_view = (find v_c) in 
											v#attachedToWindow ()) ;;
Callback.register "OView::Draw" (
fun v_c -> fun r_c -> 
let r = try find r_c
		with Not_found -> let r' = new be_rect
						  in r'#set_interne r_c;
						     r'
in (find v_c : #be_view)#draw r
);;

Callback.register "OView::DrawString" (fun v_c -> fun s_c -> fun p_c -> 
let p = (*try*) find p_c
(*		with Not_found -> let p' = new be_point
						  in p'#set_interne p_c;
						     p'*)
in
(find v_c :#be_view)#drawString (find s_c) p);;


Callback.register "OWindow::QuitRequested"	(fun w_c -> 
		let o = (*try*) find w_c
(*			with Not_found ->
			begin
				print_string "callback OWindow::QuitRequested : w not found\n";flush stdout;
				let w' = new be_window in w'#set_interne w_c;
										  w'
			end*)
		 
		in 
		Printf.printf "[OCaml] Callback.register \"OWindow::QuitRequested\" o = 0x%lx\n" o; flush stdout;
		o#quitRequested ());; 
Callback.register "OView::MouseDown" (fun v_c -> fun p_c ->
												let p = try find p_c
														with Not_found -> 
														print_string "[OCaml] OView::MouseDown : creation d'un nouveau point\n";flush  stdout;
														let p' = new be_point
																		  in p'#set_interne p_c;
																		     p'
												in
												let v : #be_view = try find v_c
														with Not_found -> 
														failwith "[OCaml] OView::MouseDown : view non trouve !!!\n"
												in		
												v#mouseDown p)
;;

Callback.register "mouseMoved" (fun v_c -> fun w -> fun code -> fun m_c -> 
	let where = new be_point
	and m = (*try*) (find m_c) 
			(*with Not_found -> let m' = new be_message
							  in m'#set_interne m_c;
							     m'*)
	in
	where#set_interne w; 
	(find v_c : #be_view)#mouseMoved 
	~where:where 
	~code:code 
	~a_message:m)
;;

Callback.register "OView::MessageReceived" (fun v_c -> fun m_c ->
									Printf.printf "[OCaml] callback OView::MessageReceived(v_c=0x%lx, m_c=0x%lx)\n" v_c m_c;flush stdout;
	
									let m = try (find m_c : #be_message)
											with 
											| Not_found -> 
											begin
												Printf.printf "[OCaml] callback OView::MessageReceived. m not found\n";
												flush stdout;
												let m'= new be_message
												in m'#set_interne m_c;
												m'
											end
									and v =  try find v_c with Not_found -> begin 
																				Printf.printf "[OCaml] callback OView::MessageReceived. v NOT FOUND !!!\n";
																				flush stdout;
																				new be_view
																			end
									in
									Printf.printf "[OCaml] callback OView::MessageReceived : appel de v#messageReceived\n";flush stdout;
									v#messageReceived ~message:m);;
Callback.register "OWindow::MenusBeginning" (fun w_c -> (find w_c : #be_window)#menusBeginning ());;
Callback.register "OWindow::MessageReceived" (fun w_c -> fun m_c -> 
	
	let m = try (find m_c : #be_message)
			with 
			| Not_found -> 
				begin
					let m'= new be_message
					in m'#set_interne m_c;
					m'
				end
	   
	and w = (find w_c : #be_window)
	in
				
	
	begin
		w#messageReceived ~message:m 
	end
	);;
Callback.register "OWindow::postMessage_message_handler" (
	fun o_c -> 
	fun message -> let m = new be_message in m#set_interne message;
	fun handler -> let h = new be_Handler in h#set_interne handler;
	fun replyHandler -> let r = new be_Handler in r#set_interne replyHandler;
	(find o_c : #be_window)#postMessage 
	~message:m 
	~handler:h 
	~reply_handler:r ()
);;
*)
Callback.register "OWindow::postMessage_message" (
	fun w_c -> 
	fun message -> let m = new be_message in 
				   m#set_interne message;
				   w_c#postMessage ~message:m ()
);;
(*
 * Callback.register "OWindow::Quit" 			(fun o_c -> (find o_c : #be_window)#quit ()) ;;
 *)
Callback.register "OWindow::Show" (fun o_c -> o_c#show()) ;;

