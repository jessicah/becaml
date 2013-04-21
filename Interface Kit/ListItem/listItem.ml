open Glue

external b_listItem_outlineLevel : c_pointer -> int32 = "b_listItem_outlineLevel"

class be_listItem =
	object(self)
	inherit be_interne

	method outlineLevel () =
		b_listItem_outlineLevel (self#get_interne())
end
