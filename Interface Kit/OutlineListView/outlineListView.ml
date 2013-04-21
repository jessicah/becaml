open Glue
open Handler
open ListItem
open ListView
open Looper
open Messenger
open Point
open Rect
open SupportDefs
open View

external b_outlineListView_outlineListView : c_pointer -> string -> list_view_type -> int32 -> int32 -> c_pointer =
		"b_outlineListView_outlineListView_bytecode" 
		"b_outlineListView_outlineListView_nativecode"
external b_outlineListView_addItem : c_pointer -> c_pointer -> bool = "b_outlineListView_addItem"
external b_outlineListView_addItem_index : c_pointer -> c_pointer -> int32 -> bool = "b_outlineListView_addItem_index"
external b_outlineListView_countItemsUnder : c_pointer -> c_pointer -> bool -> int32 = "b_outlineListView_countItemsUnder"
external b_outlineListView_itemUnderAt : c_pointer -> c_pointer -> bool -> int32 -> c_pointer = "b_outlineListView_itemUnderAt"
external b_outlineListView_fullListIndexOf : c_pointer -> c_pointer -> int32 = "b_outlineListView_fullListIndexOf"
external b_outlineListView_removeItem : c_pointer -> int32 -> c_pointer = "b_outlineListView_removeItem"
external b_outlineListView_removeItem_item : c_pointer -> c_pointer -> bool = "b_outlineListView_removeItem_item"
external b_outlineListView_setTarget_handler : c_pointer -> c_pointer -> status_t = "b_outlineListView_setTarget_handler"
external b_outlineListView_superitem : c_pointer -> c_pointer -> c_pointer = "b_outlineListView_superitem"

class be_outlineListView =
	object(self)
	inherit be_listView as listView

	method be_outlineListView : 'a.	frame:(#be_rect as 'a) ->
									name:string ->
									?list_view_type:list_view_type ->
									?resizingMode:int32 ->
									?flags:int32 ->
									unit ->
									unit =
		fun ~frame 
			~name  
			?(list_view_type = B_SINGLE_SELECTION_LIST)
			?(resizingMode = Int32.logor kB_FOLLOW_LEFT 
										 kB_FOLLOW_TOP)
			?(flags = (Int32.logor kB_WILL_DRAW 
					  (Int32.logor kB_FRAME_EVENTS 
			  					   kB_NAVIGABLE))) 
			() -> 
		self#set_interne (b_outlineListView_outlineListView (frame#get_interne())
															name
															list_view_type
															resizingMode
															flags)
	method addItem : 'a. 
		item:(#be_listItem as 'a) -> 
		?index:int32 -> 
		unit ->
		bool = 
		fun ~item ?index () ->
			match index with 
			| None -> b_outlineListView_addItem (self#get_interne()) (item#get_interne())
			| Some index -> b_outlineListView_addItem_index (self#get_interne()) (item#get_interne()) index
			
	method countItemsUnder : 'a.
		underItem:(#be_listItem as 'a) ->
		oneLevelOnly:bool ->
		int32 =
		fun ~underItem ~oneLevelOnly ->
			b_outlineListView_countItemsUnder (self#get_interne()) (underItem#get_interne()) oneLevelOnly
			
	method fullListIndexOf : 'a 'b.
		?point:(#be_point as 'a) ->
		?item:(#be_listItem as 'b) ->
		unit ->
		int32 =
		fun ?point ?item () ->
		match point,item with 
		| None, Some item -> b_outlineListView_fullListIndexOf (self#get_interne()) (item#get_interne())
		| _ -> Printf.printf "be_outlineListView#fullListIndexOf non implemente avec d'autres parametres que item.\n"; flush stdout;
		
		Int32.zero
		
	method itemUnderAt : 'a.
		underItem:(#be_listItem as 'a) ->
		oneLevelOnly:bool ->
		index:int32 ->
		be_listItem =
		fun ~underItem ~oneLevelOnly ~index ->
		let li = new be_listItem
		in
		li#set_interne(b_outlineListView_itemUnderAt (self#get_interne()) (underItem#get_interne()) 
																	  oneLevelOnly 
																	  index);
		li
	
	method removeItem : 'a 'b.
		?item:(#be_listItem as 'a) ->
  		?index:int32 -> unit -> 
		( ((#be_listItem as 'b) option) * 
		  (bool option)
		)
		 =
		fun ?item ?index () ->
			match item,index with
			| None, Some index -> let li = new be_listItem
								  in 
								  li#set_interne (b_outlineListView_removeItem (self#get_interne()) index);
								  Some (Obj.magic li), None
			| Some item, None ->
				None, Some (b_outlineListView_removeItem_item (self#get_interne()) (item#get_interne()))
				
			| _ -> failwith "b_outlineListView_removeItem : parametres incorrects."

	method setTarget : 'a 'b 'c. 
		?messenger:(#be_messenger as 'a) ->
		?handler:(#be_Handler as 'b) ->
		?looper:(#be_Looper as 'c) -> 
		unit -> 
		SupportDefs.status_t =
		
		fun ?messenger ?handler ?looper () ->
		match handler,looper with 
		| Some handler, None -> b_outlineListView_setTarget_handler (self#get_interne()) (handler#get_interne())
		| _ -> failwith "be_outlineListView#setTarget implemente seulement avec un handler en parametres."
		
	method superitem : 'a 'b.
		item:(#be_listItem as 'a) ->
		(#be_listItem as 'b)=
		fun ~item -> 
		let li = new be_listItem
		in
		li#set_interne (b_outlineListView_superitem (self#get_interne()) (item#get_interne()));
		Obj.magic li
		
	
end;;
