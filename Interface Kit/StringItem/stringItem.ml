open Glue
open ListItem

external b_stringItem_stringItem : string -> int32 -> bool -> pointer = "b_stringItem_stringItem"
external b_stringItem_text : pointer -> string = "b_stringItem_text"

class be_stringItem =
	object(self)
	inherit be_listItem

	method be_stringItem ~(text:string) ?(level = Int32.zero) ?(expanded = true) () =
		self#set_interne (b_stringItem_stringItem text level expanded);

	method text () =
		b_stringItem_text (self#get_interne())
end
