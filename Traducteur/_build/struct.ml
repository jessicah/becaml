type ctype = 
	| TVoid 
	| TBool
	| TChar
	| TUint32
	| TFloat
	| TShort
	| TPointeur of ctype
	| TReference of ctype
	| Type of string
	| TArray of int32 * ctype
	| TConst of ctype
;;

type array_pointer = 
	| Pointer 
	| Array_Size of int32
;;

type cmethod = {
	type_decl : ctype ;
	name : string ;
	parametres : (ctype * string) list ;
};;
(* A Supprimmer
type decl = 
	| Constructeur of cmethod 
	| Destructeur of cmethod
	| Methode of cmethod
;;

type cstruct = { 
	name : string ; 
	public : decl list;
	prive : decl list
}
*)
type inclusion =
	| User of string
	| System of string
;;

type expression = 
	| VInteger of int32
	| VChar of string
	| VFloat of float
	| VString of string
	| VBool of bool
	| VVariable of string
	| VFunction of string * expression list
	| VOp of expression * string * expression
;;

type macro = 
	| Define of string * (expression option)
	| Typedef of string
;;	

type enum_value = 
	{ 
	  enum_value_name : string; 
	  enum_value_value : expression option;
	}

type enum =
	{
	  enum_name : string option;
	  enum_values: enum_value list;
	}

type qualifier =
	| QPublic
	| QStatic
	| QVirtual
	| QPrivate_attribute
	| QConst
	| QInline
		
	
type param = 
		| Param of ctype * string * (expression option)

type attribute = qualifier * param

type methode = 
	{
		qualifiers : qualifier list;
		meth_type : ctype;
		name : string;
		params : param list;
	}

type heritage = 
	| Public of string
	| Private of string
	
type classe =
	{
		class_name : string;
		heritages : heritage  list;
		public_methodes : methode list;
		private_methodes : methode list;
		attributes : attribute list;
	}

type translation_unit = {
	macros : macro list;
	inclusions : inclusion list;
	enums : enum list;
	classes : classe list
	
	};;
