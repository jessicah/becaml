open Glue;;

external b_string_string_string : string -> c_pointer = "b_string_string_string"
external b_string_string : c_pointer -> string = "b_string_string"
external b_string_length : c_pointer -> int32 = "b_string_length"

class be_string =
	object(self)
	inherit be_interne

	method be_string ~string =
		self#set_interne (b_string_string_string string)

	method length () =
		b_string_length (self#get_interne())
		
	method string () =
		b_string_string (self#get_interne())
end;;
