open Glue

module Size_t =
struct
	type size_t = int32
end

module String =
struct
	external memcpy : dst:c_pointer -> src:c_pointer -> len:Size_t.size_t -> c_pointer = "memcpy_be" 
end
