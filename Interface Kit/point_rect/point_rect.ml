(*open Point;;*)
open Glue;;

external b_point_point : unit -> pointer= "b_point_point"
external b_point_point_point : pointer -> pointer= "b_point_point_point"
external b_point_point_x_y : float -> float -> pointer= "b_point_point_x_y"
external b_point_constrainTo :pointer -> pointer-> unit = "b_point_constrainTo"
external b_point_printtostream :pointer-> unit = "b_point_printtostream"
external b_point_set :pointer-> float -> float -> unit = "b_point_set"
external b_point_set_x :pointer-> float -> unit = "b_point_set_x"
external b_point_set_y :pointer-> float -> unit = "b_point_set_y"
external b_point_x :pointer-> float = "b_point_x"
external b_point_y :pointer-> float = "b_point_y"

external b_rect_rect_left : float -> float -> float -> float ->pointer= "b_rect_rect_left" 
external b_rect_rect_leftTop : pointer->pointer->pointer= "b_rect_rect_leftTop" 
external b_rect_rect : pointer->pointer= "b_rect_rect" 
external b_rect : unit ->pointer= "b_rect"
external b_rect_insetBy_x_y :pointer-> float -> float -> unit = "b_rect_insetBy_x_y"
external b_rect_left :pointer-> float = "b_rect_left"
external b_rect_top :pointer-> float = "b_rect_top"
external b_rect_right :pointer-> float = "b_rect_right"
external b_rect_bottom :pointer-> float = "b_rect_bottom"
external b_rect_printtostream :pointer-> unit = "b_rect_printtostream"
external b_rect_offsetBy_x_y :pointer-> float -> float -> unit = "b_rect_offsetBy_x_y"
external b_rect_offsetTo :pointer-> float -> float -> unit = "b_rect_offsetTo"
external b_rect_offsetTo_point :pointer->pointer-> unit = "b_rect_offsetTo_point"
external b_rect_set :pointer-> float -> float -> float -> float -> unit = "b_rect_set"
external b_rect_width :pointer-> float = "b_rect_width"
external b_rect_height :pointer-> float = "b_rect_height"

class be_point =
object(self)
	inherit be_interne

	method be_point ?x ?y ?point () = 
		(match point,x,y with
		| None,None,None -> self#set_interne(b_point_point() )
		| Some p,None,None -> self#set_interne(b_point_point_point ((p : be_point)#get_interne ()))
		| None, Some x, Some y -> self#set_interne(b_point_point_x_y x y)
		| _ -> failwith "be_point#be_point : parametres incorrects"
		);
		
	method constrainTo ~rect = 
		b_point_constrainTo (self#get_interne()) ((rect : be_rect)#get_interne())

	method printToStream () =	
		b_point_printtostream (self#get_interne())
	
	method set ?x ?y () = 
		match x, y with
		| Some x, Some y -> b_point_set (self#get_interne()) x y
		| Some x, None -> b_point_set_x (self#get_interne()) x
		| None, Some y -> b_point_set_y (self#get_interne()) y
		| None, None -> failwith "Parametres de be_point#set manquants."
	
	method x =
		b_point_x (self#get_interne())
	method y =
		b_point_y (self#get_interne())
end

and be_rect =
object(self)
	inherit be_interne

	method be_rect ?left ?top ?right ?bottom ?leftTop ?rightBottom ?rect () =
		(match left, top, right, bottom, leftTop, rightBottom, rect with
		| Some l, Some t, Some r, Some b, None, None, None -> 
				self#set_interne( b_rect_rect_left l t r b )
		| None, None, None, None, Some l, Some r, None -> 
				self#set_interne( b_rect_rect_leftTop l r ) 
		| None, None, None, None, None, None, Some r -> 
				self#set_interne(b_rect_rect ((r : be_rect)#get_interne()) )
		| None, None, None, None, None, None, None -> 
				self#set_interne( b_rect ())
		| _ -> failwith "be_rect#be_rect : parametres incorrects"
		);

	method left =
		b_rect_left (self#get_interne())
	
	method top =
		b_rect_top (self#get_interne())
			
	method right =
		b_rect_right (self#get_interne())
		
	method bottom =
		b_rect_bottom (self#get_interne())
	
	method contains : 'a 'b. ?point:(#(*be_point*)be_interne as 'a) -> ?rect:(#(*be_rect*)be_interne as 'b) -> unit -> bool =
		fun ?point ?rect () ->
		match point, rect with 
		| _ -> failwith "be_rect#contains non implemente.\n"
		
	method insetBy : 'a . ?x:float -> ?y:float -> ?point:(#(*be_point*)be_interne as 'a) -> unit -> unit =
		fun ?x ?y ?point () ->
		match x,y,point with 
		| None, None, Some p -> failwith "b_rect_insetBy_point non implemente."
		| Some x, Some y, None -> b_rect_insetBy_x_y (self#get_interne()) x y
		| _ -> failwith "be_rect#insetBy parametres incorrects."
	
	method offsetBy : 'a . ?x:float -> ?y:float -> ?point:(#(*be_point*)be_interne as 'a) -> unit -> unit =
		fun ?x ?y ?point () ->
		match x,y,point with 
		| None, None, Some p -> failwith "b_rect_offsetBy_point non implemente."
		| Some x, Some y, None -> b_rect_offsetBy_x_y (self#get_interne()) x y
		| _ -> failwith "be_rect#offsetBy parametres incorrects."
	
	method offsetTo : 'a . ?x:float -> ?y:float -> ?point:(#be_interne as 'a) -> unit -> unit = 
		fun ?x ?y ?point () ->
		
		match x,y,point with 
		| None,None, Some point -> b_rect_offsetTo_point (self#get_interne()) (point#get_interne())
		| Some x, Some y, None -> b_rect_offsetTo (self#get_interne()) x y
		| _ -> failwith "be_rect#offsetTo : parametres incorrects"
	
	method printToStream () =
		b_rect_printtostream (self#get_interne())

	method set ?(left	= self#left) 
			   ?(top	= self#top) 
			   ?(right	= self#right) 
			   ?(bottom	= self#bottom) 
			   () =
		b_rect_set (self#get_interne()) left top right bottom
	
	
	method width () =
		b_rect_width (self#get_interne())
	
	method height () =
		b_rect_height (self#get_interne())
		
(*	method contains ?point ?rect =
	method intersects ?rect =
	method insetBy ?x ?y ?point =

BRect &InsetBySelf(float x, float y) 

BRect &InsetBySelf(BPoint point) 

BRect InsetByCopy(float x, float y) 

BRect InsetByCopy(BPoint point) 

void OffsetBy(float x, float y) 

void OffsetBy(BPoint point) 

BRect &OffsetBySelf(float x, float y) 

BRect &OffsetBySelf(BPoint point) 

BRect OffsetByCopy(float x, float y) 

BRect OffsetByCopy(BPoint point) 

void OffsetTo(float x, float y) 

void OffsetTo(BPoint point) 

BRect &OffsetToSelf(float x, float y) 

BRect &OffsetToSelf(BPoint point) 

BRect OffsetToCopy(float x, float y) 

BRect OffsetToCopy(BPoint point)
*)
end;;


let new_be_rect () = new be_rect;;

let b_origin = 
	let p = (new be_point)
	in
	p#be_point ~x:0.0 ~y:0.0 ();
	p
;;
Callback.register "new_be_rect" new_be_rect;;
