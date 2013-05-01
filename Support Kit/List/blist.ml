open Glue 

external b_list_list : #be_interne -> int32 -> pointer = "b_list_list"
external b_list_addItem : pointer -> pointer -> bool = "b_list_addItem"
external b_list_countItems : pointer -> int32 = "b_list_countItems"
external b_list_firstItem : pointer -> pointer = "b_list_firstItem"
external b_list_itemAt : pointer -> int32 -> pointer = "b_list_itemAt"
external b_list_removeItem : pointer -> int32 -> pointer = "b_list_removeItem"

class be_list =
object(self)
	inherit be_interne
	
	method be_list ?(count = Int32.of_int 20) () =
		self#set_interne (b_list_list self count);
	
	method addItem ~(item : be_interne) =
		b_list_addItem (self#get_interne()) (item#get_interne())
	
	method countItems () =
		b_list_countItems (self#get_interne())

	method firstItem() =
		b_list_firstItem (self#get_interne())

	method itemAt ~index =
		b_list_itemAt (self#get_interne()) index
		
	method removeItem : 'a 'b .
		?item:(#be_interne as 'a) ->
		?index:int32 ->
		unit ->
		(#be_interne as 'b) =
		fun ?item ?index () ->
			match item,index with 
			| None, Some index ->
					let li = new be_interne
					in
					li#set_interne (b_list_removeItem (self#get_interne()) index);
					Obj.magic li
			| _ -> failwith "be_list#removeItem non implemente avec item\n"	
		
end;;
