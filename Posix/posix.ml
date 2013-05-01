open Glue

module Size_t =
struct
	type size_t = int32
end

module String =
struct
	external memcpy : dst:pointer -> src:pointer -> len:Size_t.size_t -> pointer = "memcpy_be" 
end
