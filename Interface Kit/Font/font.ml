open Glue
open Point
open Shape

type font_height = { 
	ascent	: float;
	descent	: float;
	leading	: float;
};;

type escapement_delta = {
 	nonspace : float; 
	space	 : float; 
};;

external b_plain_font : unit -> pointer = "b_plain_font"
external b_bold_font : unit -> pointer = "b_bold_font"

external b_font_font : 'a -> pointer = "b_font_font"
external b_font_getEscapementsArray : pointer -> char array -> int32 -> escapement_delta -> 
									  pointer array ref ->
									  pointer array ref -> unit 
									= "b_font_getEscapementsArray_bytecode" 
									  "b_font_getEscapementsArray_nativecode"
external b_font_getGlyphShapes : pointer -> char array -> int32 -> pointer array ref -> unit = "b_font_getGlyphShapes"
external b_font_getHeight : pointer -> font_height ref -> unit = "b_font_getHeight"
external b_font_printtostream : pointer -> unit = "b_font_printtostream"
external b_font_setSize : pointer -> float -> unit = "b_font_setSize"
external b_font_size : pointer -> float  = "b_font_size"
external b_font_stringWidth : pointer -> string -> float = "b_font_stringWidth"

class be_font = 
	object(self)
	inherit be_interne
	
	method be_font () =
		self#set_interne(b_font_font self)

	method getEscapements ~(charArray				 : char array) 
						  ~(numChars				 : int32)
						  ?(delta					 : escapement_delta option) 
						  ?(float_escapementArray	 : float array option)
						  ?(be_point_escapementArray : be_point array ref option)
                     	  ?(offsetArray				 : be_point array ref option)
						  () =
		match float_escapementArray, delta, be_point_escapementArray, offsetArray with
		| None, Some delta, Some be_point_escapementArray, Some offsetArray -> 
			let be_point_escapement_addrArray = ref(Array.make (Int32.to_int numChars) (null))
			and offset_addrArray = ref(Array.make (Int32.to_int numChars) (null))
			in
			b_font_getEscapementsArray (self#get_interne())
									   charArray 
									   numChars 
									   delta
									   be_point_escapement_addrArray 
									   offset_addrArray;
			for i = 0 to pred (Int32.to_int numChars) do
				(!be_point_escapementArray.(i))#set_interne(!be_point_escapement_addrArray.(i));
				(!offsetArray.(i))#set_interne(!offset_addrArray.(i))
			done;

		| _ -> failwith "implementation incomplete de be_font#getEscapements."
		
	method getGlyphShapes ~(charArray : char array) 
						  ~(numChars : int32) 
						  ~(glyphShapeArray : be_shape array ref) =
		let glyphShape_addrArray = ref(Array.make (Int32.to_int numChars) (null))
		in
		b_font_getGlyphShapes (self#get_interne()) charArray numChars glyphShape_addrArray;
		for i = 0 to pred (Int32.to_int numChars) do
			(!glyphShapeArray.(i))#set_interne(!glyphShape_addrArray.(i))
		done;
	
	method getHeight ~(height : font_height ref) =
		b_font_getHeight (self#get_interne()) height		
	
	method printToStream () =
		b_font_printtostream (self#get_interne())
	
	method setSize ~(size:float) =
		b_font_setSize (self#get_interne()) size

	method size () =
		b_font_size (self#get_interne())

	method stringWidth ~(string : string) =
		b_font_stringWidth (self#get_interne()) string
		
end;;

let be_plain_font = 
	new be_font (*initialisee avec b_bold_font qd une BApplication est cree (cf BeBook)*)
;;

let be_bold_font = 
	new be_font (*initialisee avec b_bold_font qd une BApplication est cree (cf BeBook)*)
;;
