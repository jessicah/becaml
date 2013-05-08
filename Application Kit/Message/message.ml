open Int32;;

open Flattenable;;
open Glue;;
open Bstring;;
open Messenger;;
open Point;;
open Rect;;
open SupportDefs;;

type ssize_t
;;
type type_code
;;


external b_message_message_command : #be_interne -> int32 	-> pointer	= "b_message_message_command"
external b_message_message_message : #be_interne -> pointer -> pointer	= "b_message_message_message"
external b_message_message         : unit -> pointer		= "b_message_message"
external b_message_        : pointer-> unit      = "b_message_"
(*external b_message_addData :pointer-> string -> type_code ->pointer-> ssize_t -> bool -> int -> status_t = "b_message_addData"*)
external b_message_addBool   : pointer-> string -> bool   -> status_t = "b_message_addBool"
external b_message_addInt8   : pointer-> string -> int8   -> status_t = "b_message_addInt8"
external b_message_addInt16  : pointer-> string -> int16  -> status_t = "b_message_addInt16"
external b_message_addInt32  : pointer-> string -> int32  -> status_t = "b_message_addInt32"
external b_message_findInt16 : pointer-> string -> int16  ref -> status_t = "b_message_findInt16"
external b_message_findInt32 : pointer-> string -> int32  ref -> status_t = "b_message_findInt32"
external b_message_findInt16_index : pointer-> string -> int16 -> int16 ref -> status_t = "b_message_findInt16_index"
external b_message_findInt32_index : pointer-> string -> int32 -> int32 ref -> status_t = "b_message_findInt32_index"
external b_message_findPointer : pointer-> string ->pointer ref -> status_t = "b_message_findPointer"
external b_message_addInt64  : pointer-> string -> int64  -> status_t = "b_message_addInt64"
external b_message_addFloat  : pointer-> string -> bfloat -> status_t = "b_message_addfloat"
external b_message_addDouble : pointer-> string -> double -> status_t = "b_message_addDouble"
external b_message_addString_string :pointer-> string -> string -> status_t = "b_message_addString_string"
external b_message_addString_be_string :pointer-> string ->pointer-> status_t = "b_message_addString_be_string"
external b_message_addPoint :pointer-> string ->pointer-> status_t = "b_message_addPoint" 
external b_message_addRect :pointer-> string ->pointer-> status_t = "b_message_addRect"
external b_message_addRef :pointer-> string ->pointer-> status_t = "b_message_addRef"
external b_message_addMessage :pointer-> string ->pointer-> status_t = "b_message_addMessage"
external b_message_addMessenger :pointer-> string ->pointer-> status_t = "b_message_addMessenger"
external b_message_addPointer :pointer-> string ->pointer-> status_t = "b_message_addPointer" 
external b_message_addFlat :pointer-> string ->pointer-> int32 -> status_t = "b_message_addFlat"
external b_message_addSpecifier_message :pointer->pointer-> status_t = "b_message_addSpecifier_message"
external b_message_addSpecifier_property :pointer-> string -> status_t = "b_message_addSpecifier_property"
external b_message_addSpecifier_index :pointer-> string -> int32 -> status_t = "b_message_addSpecifier_index"
external b_message_addSpecifier_range :pointer-> string -> int32 -> int32 -> status_t = "b_message_addSpecifier_range"
external b_message_addSpecifier_name :pointer-> string -> string -> status_t = "b_message_addSpecifier_name"
external b_message_countNames :pointer-> type_code -> int32 = "b_message_countNames"
external b_message_findString :pointer-> string -> string ref -> status_t = "b_message_findString"
external b_message_printToStream :pointer-> unit = "b_message_printToStream"
external b_message_what :pointer-> int32 = "b_message_what"

class be_message =
	object(self)

	inherit be_interne
   
         method be_message ?command ?message () = 
           interne <- (match command,message with
                 			 | Some (com : int32 ), None -> b_message_message_command self com
                                         | None, Some (mes : be_message) -> b_message_message_message self (mes#get_interne())
                                         | None, None -> b_message_message () 
                                         | Some _, Some _ -> failwith "Constructeur be_message : 2 paramètres au lieu d'un ou zéro"
                        )

	method be_message_ = b_message_ (self#get_interne())
	(*method addData ~name ~type_code ~data ~numBytes ?(fixedSize = true) ?(numItems = 1) () = 
		  b_message_addData self#get_interne() name type_code data numBytes fixedSize numItems
		  *)
	method addBool ~name ~aBool     = b_message_addBool   (self#get_interne()) name aBool
	method addInt8 ~name ~anInt8    = b_message_addInt8   (self#get_interne()) name anInt8
	method addInt16 ~name ~anInt16  = b_message_addInt16  (self#get_interne()) name anInt16
	method addInt32 ~name ~anInt32  = b_message_addInt32  (self#get_interne()) name anInt32
	method addInt64 ~name ~anInt64  = b_message_addInt64  (self#get_interne()) name anInt64
	method addFloat ~name ~aFloat   = b_message_addFloat  (self#get_interne()) name aFloat
	method addDouble ~name ~aDouble = b_message_addDouble (self#get_interne()) name aDouble
	method addString ~name ?chaine ?bchaine () =
		match chaine, bchaine with
		| Some c, None -> b_message_addString_string 	(self#get_interne()) name c
		| None, Some s -> b_message_addString_be_string (self#get_interne()) name ((s : be_string)#get_interne())
		| _ -> failwith "b_message#addString : paramètres incorrects"
	method addPoint ~name ~point =
		b_message_addPoint (self#get_interne()) name ((point : be_point)#get_interne())
	method addRect ~name ~rect =
			b_message_addRect (self#get_interne()) name ((rect : be_rect)#get_interne())
	method addRef ~name ~ref =
			b_message_addRef (self#get_interne()) name ((ref : be_interne)#get_interne())

	method addMessage : 'a.
		name:string ->
		message:(#be_interne  as 'a) -> (* #be_message *)
		status_t = fun ~name ~message ->
			b_message_addMessage (self#get_interne()) name (message#get_interne())
			
	method addMessenger ~name ~messenger =
			b_message_addMessenger (self#get_interne()) name ((messenger : be_messenger)#get_interne()) 	
	method addPointer ~name ~pointer =
			b_message_addPointer (self#get_interne()) name ((pointer : be_interne)#get_interne())
	method addFlat ~name ~flattenable ?(numItems = of_int 1) () =
			b_message_addFlat (self#get_interne()) name ((flattenable : be_flattenable)#get_interne()) numItems
	method b_message_addSpecifier ?message ?property ?index ?range ?name () =
		match message,property,index,range,name with
                | Some m, None, None, None, None     ->
                                b_message_addSpecifier_message  interne ( (m : be_message)#get_interne() : pointer )
		| None, Some p, None, None, None     -> b_message_addSpecifier_property interne p
		| None, Some p, Some i, None, None   -> b_message_addSpecifier_index    interne p i
		| None, Some p, Some i, Some r, None -> b_message_addSpecifier_range    interne p i r
		| None, Some p, None, None, Some n   -> b_message_addSpecifier_name     interne p n
		| _ -> failwith "be_message#addSpecifier : paramètres incorrects"
	method countNames ~type_code = 
		b_message_countNames (self#get_interne()) type_code
	(*method findData ~name ~type_code ?index ~data ~numBytes =
		match index with
		| None -> b_message_findData name type_code data numBytes
		| Some i -> b_message_findData_index name type_code i data numBytes
	method findBool ~name ?index ~aBool =
		match index with
		| None -> b_message_findBool name aBool
		| Some i -> b_message_findBool_index name i aBool
	method findInt8 ~name ?index ~anInt8 =
		match index with
		| None -> b_message_findInt8 name anInt8
		| Some i -> b_message_findInt8_index name i anInt8*)
		
	method findInt16 ~name ?index ~anInt16 () =
		match index with
		| None -> b_message_findInt16 (self#get_interne()) name anInt16
		| Some i -> b_message_findInt16_index (self#get_interne()) name i anInt16
	
	method findInt32 ~name ?index ~anInt32 () =
		match index with
		| None -> b_message_findInt32 (self#get_interne()) name anInt32
		| Some i -> b_message_findInt32_index (self#get_interne()) name i anInt32
		
(*	method findInt64 ~name ?index ~anInt64 =
		match index with
		| None -> b_message_findInt64 name anInt64
		| Some i -> b_message_findInt64_index name i anInt64
	method findFloat ~name ?index ~aFloat =
		match index with
		| None -> b_message_findFloat name aFloat
		| Some i -> b_message_findFloat_index name i aFloat
	method findDouble ~name ?index ~aDouble =
		match index with
		| None -> b_message_findDouble name aDouble
		| Some i -> b_message_findDouble_index name i aDouble
	*)
	
	method findPointer ~(name :string) ?(index:int32 option) ~(pointer:pointer ref) () =
		match index with
		| None -> 	b_message_findPointer (self#get_interne()) name pointer
		| Some index -> failwith "be_message#findPointer implemente juste avec name, string."
	
	method findString ~(name:string) ?(index:int32 option) ?(string:string ref option) ?(bstring:be_string option) () =
		match string with 
		| Some string ->
			b_message_findString (self#get_interne()) name string
		| _ -> failwith "be_message#findString implemente juste avec name, string."
		
	method printToStream () =
		b_message_printToStream (self#get_interne())

	method what =
		b_message_what interne
end
;;

let new_be_message p_c = 
        let m = new be_message
        in
        m#set_interne p_c;
        m
;;

Callback.register "new_be_message" new_be_message;;

