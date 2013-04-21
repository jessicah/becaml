open Struct

let rec expression_to_string = function 
| VInteger  i -> Int32.to_string i
| VChar  s -> s
| VFloat f -> string_of_float f
| VString s -> s
| VBool b -> string_of_bool b
| VVariable s -> s
| VFunction (f,l) -> f^"("^(expression_list_to_string l)^")"

and expression_list_to_string = function 
| [] -> ""
| [e] -> expression_to_string e
| e1 ::el -> (expression_to_string e1) ^ ", " ^ (expression_list_to_string el)


let rec to_string_with_separator f sep = function
| [] -> ""
| [e] -> f e;
| e::l -> (f e) ^ sep ^ (to_string_with_separator f sep l)

let qualifier_to_string (q:qualifier) = match q with
| QPublic -> "public"
| QStatic -> "static"
| QVirtual -> "virtual"
| QPrivate_attribute -> ""
| QConst -> "const"
| QInline -> "inline"

let rec ctype_to_string = function
| TVoid -> "void" 
| TBool -> "bool"
| TChar -> "char"
| TUint32 -> "uint32"
| TFloat -> "float"
| TShort -> "short"
| TPointeur c-> (ctype_to_string c)^"*"
| TReference c -> (ctype_to_string c)^"&"
| Type s -> s
| TArray (i,t)-> (ctype_to_string t)^"["^(Int32.to_string i)^"]"
| TConst c -> "const "^(ctype_to_string c)
;;


let param_to_string = function
| Param (t,name,None) -> (ctype_to_string t)^" "^name
| Param (t,name,Some e) -> (ctype_to_string t)^" "^name^"="^(expression_to_string e)

let attribute_to_string (qual,param) = 
(qualifier_to_string qual) ^" "^ (param_to_string param)
