open Glue;;

external b_string_string_string : string -> pointer = "b_string_string_string"
external b_string_string : pointer -> string = "b_string_string"
external b_string_length : pointer -> int32 = "b_string_length"

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
