open Glue
open Invoker
open ListItem
open Message
open Rect
open View

type list_view_type = 
| B_SINGLE_SELECTION_LIST 
| B_MULTIPLE_SELECTION_LIST
;;
external b_listView_addItem : c_pointer -> c_pointer -> bool = "b_listView_addItem"
external b_listView_addItem_index : c_pointer -> c_pointer -> int32 -> bool = "b_listView_addItem_index"
external b_listView_currentSelection : c_pointer -> int32 -> int32 = "b_listView_currentSelection"
external b_listView_itemAt : c_pointer -> int32 -> c_pointer = "b_listView_itemAt"
external b_listView_itemFrame : c_pointer -> int32 -> c_pointer = "b_listView_itemFrame"
external b_listView_removeItem : c_pointer -> int32 -> c_pointer = "b_listView_removeItem"
external b_listView_setSelectionMessage : c_pointer -> c_pointer -> unit = "b_listView_setSelectionMessage"

class be_listView =
	object(self)
	inherit be_view as view
	inherit be_Invoker as invoker
	
	method addItem : 'a.
		item:(#be_listItem as 'a) ->
		?index:int32 ->
		unit ->
		bool =
		fun ~item ?index () -> 
			match index with
			| Some index -> b_listView_addItem_index (self#get_interne()) (item#get_interne()) index
			| None -> b_listView_addItem (self#get_interne()) (item#get_interne())

	method currentSelection ?(index = Int32.zero) () =
		b_listView_currentSelection (self#get_interne()) index
		
	method itemAt : 'a.	index:int32 -> (#be_listItem as 'a) =
		fun ~index ->
		let li = new be_listItem
		in
		Printf.printf "be_listView#itemAt : attention au Obj.magic!!!!\n";flush stdout;
		li#set_interne (b_listView_itemAt (self#get_interne()) index);
		Obj.magic li
			
	method itemFrame ~(index:int32) =
		let r = new be_rect
		in
		r#set_interne (b_listView_itemFrame (self#get_interne()) index);
		r
		
	method removeItem : 'a 'b .
		?item:(#be_listItem as 'a) ->
		?index:int32 ->
		unit ->
		((#be_listItem as 'b) option) * (bool option) =
		fun ?item ?index () ->
			match item,index with 
			| None, Some index ->
					let li = new be_listItem
					in
					li#set_interne (b_listView_removeItem (self#get_interne()) index);
					Some (Obj.magic li),None
			| _ -> failwith "be_listView#removeItem non implemente avec item\n"

	method setSelectionMessage :'a.
		message:(#be_message as 'a) ->
		unit =
		fun ~message ->
		b_listView_setSelectionMessage (self#get_interne()) (message#get_interne())
	
end
