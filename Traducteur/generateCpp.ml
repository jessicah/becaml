open Struct
open Utils

let entete = "
#include <stdio.h>
#include <string.h>

#include \"alloc.h\"
#include \"callback.h\"
#include \"memory.h\"
#include \"mlvalues.h\"
#include \"signals.h\"

#include \"glue.h\"

extern sem_id ocaml_sem;
extern thread_id beos_thread;\n"

let prepare_methode_for_ocaml classe= function 
{
		qualifiers = qualifiers;
		meth_type = meth_type;
		name = name;
		params = params;
} ->
{
		qualifiers = qualifiers;
		meth_type = meth_type;
		name = if name=classe then "O"^name else 
			   if name = "~"^classe then "~O"^classe else name;
		params = params;
}	


let prepare_class_for_ocaml = function {
		class_name = class_name;
		heritages = heritages;
		public_methodes = public_methodes;
		private_methodes = private_methodes;
		attributes = attributes;
	}
->
{
		class_name =  "O"^class_name;
		heritages = heritages;
		public_methodes = List.map (prepare_methode_for_ocaml class_name) public_methodes;
		private_methodes = List.map (prepare_methode_for_ocaml class_name) private_methodes;
		attributes = attributes;
}

let generate_macro = function
| Define (s, None) ->  "#define " ^ s ^ "\n";
| Define (s, (Some e)) -> "#define " ^ s ^ (expression_to_string e) ^ "\n";
| Typedef s -> "#typedef " ^ s ^ "\n";
;;

let generate_inclusion = function
| User s -> "#include \"" ^ s  ^ "\"\n"
| System s -> Printf.printf "generate_inclusion %s\n" s; "#include <" ^ s ^ ">\n"
;;

let generate_enum_value = function
| {enum_value_name=v; enum_value_value=None} -> v
| {enum_value_name=v; enum_value_value=Some e} -> v^" = "^(expression_to_string e)

let generate_enum enum = 
"enum " ^
(
match enum.enum_name with 
| None -> ""
| Some name -> name
)
^ "{\n" ^
(to_string_with_separator (generate_enum_value) ",\n" enum.enum_values)
^ "};\n\n"
;;

let generate_heritage = function
| Public s -> "public " ^ s
| Private s -> "private " ^ s
;;

let generate_constructeur = function
{ 
  qualifiers= ql;
  meth_type=meth_type;
  name=name;
  params=pl;
} ->
name
^ "(" ^
(to_string_with_separator param_to_string " " pl)
^ "):\n"
^ name 
^"("

^")"
;;


let generate_methode class_name= function 
{ 
  qualifiers= ql;
  meth_type=meth_type;
  name=name;
  params=pl;
} ->

(to_string_with_separator qualifier_to_string " " ql)
^" "
^ (ctype_to_string meth_type)
^ " "
^ name
^ "(" ^
(to_string_with_separator param_to_string " " pl)
^ ");"
;;

let generate_attribute a = 
(attribute_to_string a)
;;

let generate_class = function 
{ class_name=class_name;
  heritages=heritages;
  public_methodes=public_methodes;
  private_methodes=private_methodes;
  attributes=attributes;
} -> 
"classe "
^ class_name 
^" : "
^(to_string_with_separator generate_heritage ", " ((Public "Glue")::heritages))
^ " {\n"	
^ "public :\n"
^ (to_string_with_separator (generate_methode class_name)  ";\n" public_methodes)
^ "private :\n"
^ (to_string_with_separator (generate_methode class_name)  ";\n" private_methodes)
^ (to_string_with_separator generate_attribute ";\n" attributes)
^ "};\n"	
;;

let generate_cpp ast = 
entete
^ "\n"
^
(to_string_with_separator generate_macro "\n" ast.macros)
^ "\n\n"
^(to_string_with_separator generate_inclusion "\n" ast.inclusions)
^ "\n\n"
^(to_string_with_separator generate_enum "\n" ast.enums)
^ "\n\n"
^(to_string_with_separator (fun c -> generate_class (prepare_class_for_ocaml c)) "\n" ast.classes)

