open Archivable
open Glue
open Rect

external b_shape_shape: unit -> c_pointer = "b_shape_shape"
external b_shape_bounds : c_pointer -> c_pointer = "b_shape_bounds"
external b_shapeIterator_shapeIterator : unit -> c_pointer = "b_shapeIterator_shapeIterator"
external b_shapeIterator_iterate : c_pointer -> c_pointer -> unit = "b_shapeIterator_iterate"

class be_shape =
	object(self)
	inherit be_Archivable
	
	method be_shape () =
		self#set_interne(b_shape_shape ());
		
	method bounds () =
		let r = new be_rect 
		in
		r#set_interne(b_shape_bounds (self#get_interne())); 
		r
end

class be_shapeIterator =
	object(self)
	inherit be_interne

	method be_shapeIterator () =
			self#set_interne (b_shapeIterator_shapeIterator ());

	method iterate ~(shape : be_shape) =
		b_shapeIterator_iterate (self#get_interne()) (shape#get_interne())
end ;;

Callback.register "OShapeIterator::Iterate" (fun o -> fun s -> let bs = new be_shape 
															   in 
															   bs#set_interne s;
															   Printf.printf "appel de OShapeIterator#iterate\n"; flush stdout;
															   o#iterate bs)
