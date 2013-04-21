open Glue;;
open Point;;

external b_polygon_polygon_ : c_pointer -> unit = "b_polygon_polygon_"
external b_polygon_polygon : c_pointer array -> int32 -> c_pointer = "b_polygon_polygon"
external b_polygon_printToStream : c_pointer -> unit = "b_polygon_printToStream"

class be_polygon =
	object(self)
	inherit be_interne

	method be_polygon : 'a. pointList:(#be_point as 'a) array -> numPoints:int32 -> unit =
	fun ~pointList ~numPoints ->
		self#set_interne(b_polygon_polygon (Array.map (fun p -> p#get_interne()) pointList) 
										   numPoints);

	method be_polygon_ () =
		b_polygon_polygon_ (self#get_interne())

	method printToStream () =
		b_polygon_printToStream (self#get_interne())
		
end;;
