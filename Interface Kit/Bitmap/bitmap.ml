open Archivable
open Glue
open GraphicsDefs
open Rect

external b_bitmap_bitmap : pointer -> color_space -> bool -> bool -> pointer = "b_bitmap_bitmap"
external b_bitmap_bits : pointer -> pointer = "b_bitmap_bits"
external b_bitmap_bounds : pointer -> pointer = "b_bitmap_bounds"
external b_bitmap_bitsLength : pointer -> int32 = "b_bitmap_bitsLength"
external b_bitmap_colorSpace : pointer -> color_space = "b_bitmap_colorSpace"
external b_bitmap_setBits : pointer -> pointer -> int32 -> int32 -> color_space -> unit = "b_bitmap_setBits"

class be_Bitmap =
	object(self)
	inherit be_Archivable

	method be_Bitmap : 'a 'b. ?bounds:(#be_rect as 'a) -> 
							?space:color_space ->
							?acceptsViews:bool ->
							?needsContiguousMemory:bool -> 
							?archive:(#be_Archivable as 'b) ->
							unit -> 
							unit = 
		fun ?bounds ?space ?(acceptsViews = false) ?(needsContiguousMemory = false) ?archive () -> 
		match bounds, space, archive with 
		| _,_,Some archive -> failwith "b_Bitmap_bitmap_archive non implémenté."
		| Some bounds,Some space,None -> self#set_interne (b_bitmap_bitmap (bounds#get_interne()) space acceptsViews needsContiguousMemory)
		| _ -> failwith "b_Bitmap_bounds et b_Bitmap_space non implémentés."

	
	method bits () =
		b_bitmap_bits (self#get_interne())
		
	method bitsLength () =
		b_bitmap_bitsLength (self#get_interne())
		
	method bounds () =
		let rect = new be_rect
		in
		rect#set_interne (b_bitmap_bounds (self#get_interne()));
		rect

	method colorSpace () =
		b_bitmap_colorSpace (self#get_interne())
		
	method setBits ~data ~length ~offset ~mode =
		b_bitmap_setBits (self#get_interne()) data length offset mode
		
end	
