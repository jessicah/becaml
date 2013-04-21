%{ 
open Struct;;

let macro_list = ref [] 
let inclusion_list = ref []
let enum_list = ref []
let classe_list = ref []
let private_methodes = ref []
let attributes = ref []
%}

%token <string> IDENTIFIER 
%token <int32> INTEGER
%token <float> FLOATING
%token <string> CHARACTER
%token <string> STRING

%token TYPEDEF_NAME NAMESPACE_NAME CLASS_NAME ENUM_NAME TEMPLATE_NAME

%token ELLIPSIS COLONCOLON DOTSTAR ADDEQ SUBEQ MULEQ DIVEQ MODEQ
%token XOREQ ANDEQ OREQ SL SR SREQ SLEQ EQ NOTEQ LTEQ GTEQ ANDAND OROR
%token PLUSPLUS MINUSMINUS ARROWSTAR ARROW
%token SHARP LBRACE RBRACE LBRACKET RBRACKET LPARENTHESIS RPARENTHESIS 
%token SEMICOLON COLON TILDE COMMA EXCLAMATION QUESTION DOT BACKSLASH PLUS MINUS STAR DIV PERCENT QUOTE
%token AND OR XOR EQUAL INF SUP ZERO 

%token ATTRIBUTE

%token ASM AUTO BOOL BREAK CASE CATCH CHAR CLASS CONST CONST_CAST CONTINUE
%token DEFAULT DELETE DO DOUBLE DYNAMIC_CAST ELSE ENUM EXPLICIT EXPORT EXTERN
%token FALSE FLOAT FOR FRIEND GOTO IF INHERITED INLINE INT LONG MUTABLE NAMESPACE NEW
%token OPERATOR PRIVATE PROTECTED PUBLIC REGISTER REINTERPRET_CAST RETURN
%token SHORT SIGNED SIZEOF STATIC STATIC_CAST STRUCT SWITCH TEMPLATE THIS
%token THROW TRUE TRY TYPEDEF TYPEID TYPENAME UNION UNSIGNED USING VIRTUAL
%token VOID VOLATILE WCHAR_T WHILE
%token IFNDEF DEFINE INCLUDE IFDEF ELIF ENDIF UNDEF LINE ERROR PRAGMA
%token EOF

%type <Struct.translation_unit> translation_unit
%start translation_unit


%%
/*
	| abstract_struct {}
$Id: grammar.txt,v 1.1 1997/11/19 15:13:14 sandro Exp $

This is a literal copy of the ISO C++ (December '96 draft) grammar.

All the XXX_opt elements (not defined in this grammar) should be
treaded as optional elements.

The tokens used in the grammar are the following:

Identifier and constant tokens:
    IDENTIFIER INTEGER FLOATING CHARACTER STRING

Operators tokens of length >= 2:
    ELLIPSIS COLONCOLON DOTSTAR ADDEQ SUBEQ MULEQ DIVEQ MODEQ
    XOREQ ANDEQ OREQ SL SR SREQ SLEQ EQ NOTEQ LTEQ GTEQ ANDAND OROR
    PLUSPLUS MINUSMINUS ARROWSTAR ARROW

Keyword tokens:
    ASM AUTO BOOL BREAK CASE CATCH CHAR CLASS CONST CONST_CAST CONTINUE
    DEFAULT DELETE DO DOUBLE DYNAMIC_CAST ELSE ENUM EXPLICIT EXPORT EXTERN
    FALSE FLOAT FOR FRIEND GOTO IF INLINE INT LONG MUTABLE NAMESPACE NEW
    OPERATOR PRIVATE PROTECTED PUBLIC REGISTER REINTERPRET_CAST RETURN
    SHORT SIGNED SIZEOF STATIC STATIC_CAST STRUCT SWITCH TEMPLATE THIS
    THROW TRUE TRY TYPEDEF TYPEID TYPENAME UNION UNSIGNED USING VIRTUAL
    VOID VOLATILE WCHAR_T WHILE
*/
/*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/

/*----------------------------------------------------------------------
 * Lexical elements.
 *----------------------------------------------------------------------*/

identifier:
	IDENTIFIER { $1 }
	| OPERATOR EQ { "operator==" }
	| OPERATOR NOTEQ { "operator!=" }
	| OPERATOR EQUAL { "operator=" }
;

literal:
	integer_literal { $1 } 
	| character_literal { $1 }
	| floating_literal { $1 }
	| string_literal { $1 }
	| boolean_literal { $1 }
	;

integer_literal:
	INTEGER { print_string ("yacc: literal =" ^ (Int32.to_string $1));flush stdout;
	          VInteger $1 }
	;

character_literal:
	CHARACTER { VChar $1 }
	; 

floating_literal:
	FLOATING { VFloat $1 }
	;

string_literal:
	STRING { VString $1 }
	;

boolean_literal:
	TRUE {print_string "yacc: TRUE\n";flush stdout;VBool true}
	| FALSE { VBool false}
	;

/*----------------------------------------------------------------------
 * Translation unit.
 *----------------------------------------------------------------------*/

translation_unit:
	statement_list EOF { let m = !macro_list
						 and i = !inclusion_list
						 and e = !enum_list
						 and c = !classe_list
						 in 
						 macro_list := [];
						 inclusion_list := [];
						 enum_list := [];
						 classe_list := [];
						 
						 {	macros = m;
	                        inclusions = i;
	                        enums = e;	
	                        classes = c; } 
	                   }
;

statement:
	|directive {print_string"yacc: statement (directive)\n";flush stdout;}
	|declaration {print_string"yacc: statement (declaration)\n";flush stdout;}
	|inline_methode {}
;

statement_list:
	/*epsilon*/ { [] }
	| statement statement_list 
		{ $1 :: $2}
;

directive:
	| SHARP IF expression {}
	| SHARP IFDEF expression {}
	| SHARP IF EXCLAMATION identifier {print_string ("yacc: #if !"^$4^"\n");flush stdout;}
	| SHARP IFNDEF identifier {}
	| SHARP ENDIF {print_string "yacc: #endif\n";flush stdout;}
	| SHARP DEFINE identifier LPARENTHESIS param_list RPARENTHESIS expression {}
	| SHARP DEFINE identifier directive_attribute {}
	| SHARP DEFINE identifier expression_opt {print_string ("yacc: #define " ^ $3 ^"\n");flush stdout;}
	| SHARP INCLUDE inclusion {}
	| SHARP ELIF expression {}
	| SHARP ELSE directive {}
	| SHARP ERROR  identifier identifier identifier EXCLAMATION {}
;

directive_attribute:
	ATTRIBUTE LPARENTHESIS LPARENTHESIS expression RPARENTHESIS RPARENTHESIS {}
;

inclusion:
	| INF filename SUP {inclusion_list := (System $2 ):: !inclusion_list}
	| QUOTE filename QUOTE {inclusion_list := (User $2 ):: !inclusion_list}
;

filename:
	identifier { $1 }
	| identifier DOT identifier { $1 ^ "." ^ $3 }
	| identifier DIV filename   { $1 ^ "/" ^ $3}
;
;
declaration:
	named_enum { enum_list := $1 :: !enum_list; }
	| anonymous_enum { enum_list := $1 :: !enum_list; }
	| abstract_struct {}
	| abstract_class {}
	| concrete_class {print_string "yacc: declaration\n";flush stdout; classe_list := $1 :: !classe_list }
	| fonction_declaration {}
;

anonymous_enum:
	ENUM  LBRACE constant_constructor_list RBRACE SEMICOLON { { enum_name = None; enum_values = $3; } }
;

named_enum:
	ENUM identifier LBRACE constant_constructor_list RBRACE SEMICOLON { { enum_name = Some $2; enum_values = $4; } }
;

constant_constructor_list:
	/* epsilon */ { [] }
	| constant_constructor { [ $1 ] }
	| constant_constructor COMMA constant_constructor_list{ $1 :: $3; }
;

constant_constructor:
	| identifier { { enum_value_name = $1; enum_value_value = None;} }
	| identifier EQUAL integer_literal { { enum_value_name = $1; enum_value_value = Some $3; } }
;

abstract_class:
	CLASS identifier SEMICOLON{}
;

abstract_struct:
	STRUCT identifier SEMICOLON {}
;

public_methodes :
	PUBLIC COLON declarations_list { $3 }
;

private_methodes :
	/*epsilon*/ { [] }
	| PRIVATE COLON declarations_list { $3 }
;	
concrete_class:
	CLASS identifier heritage LBRACE 
	public_methodes 
	private_methodes
	RBRACE SEMICOLON 
	
	{
		print_string "yacc : concrete_class\n";flush stdout;
		let p = !private_methodes 
		and a = !attributes 
		in
		private_methodes:= [];
		attributes := [];
		{
			class_name = $2;
			heritages = $3;
			public_methodes= $5;
			private_methodes = p;
			attributes = a;
		}
	};
;

heritage:
	/* epsilon */ { [] }
	| COLON heritage_list { $2 };

;

heritage_list:
	accessor identifier { 
							if $1 = "public" then [Public $2]
						  	else if $1 = "private" then [Private $2]
						  	else raise (Invalid_argument $1)	
						}
	| accessor identifier COMMA heritage_list 
						{ 
							if $1 = "public" then (Public $2)::$4
						  	else if $1 = "private" then (Private $2)::$4
						  	else raise (Invalid_argument $1)
						}
;

accessor :
	|PUBLIC { "public" }
	|PRIVATE { "private" }
;

declarations_list:
	/* epsilon */ { [] }
	| methode declarations_list { $1::$2 }
	| directive declarations_list {print_string "yacc: directive\n";flush stdout;$2}
	| attribute declarations_list { attributes := $1:: !attributes; $2 }
;

attribute:
var_type identifier array_size_opt SEMICOLON 
 {
    match $3 with | None -> QPrivate_attribute,Param ($1,$2, None)
 	              | Some array_length -> QPrivate_attribute, Param (TArray(array_length,$1), $2, None)
 }
;

methode:
	| constructor { $1 }
	| qualifier destructor 
		{ 
			{
				qualifiers = [ $1 ];
				meth_type = $2.meth_type;
				name = $2.name;
				params = $2.params;
			}
		}
	| pure_methode {print_string "yacc: methode(pure_methode)\n";flush stdout; $1 }
	| qualifier pure_methode 
		{
			print_string "yacc: methode(pure_methode)\n";flush stdout; 
			{
				qualifiers = [ $1 ];
				meth_type = $2.meth_type;
				name = $2.name;
				params = $2.params;
			}
		}
	| typedef_declaration 
		{ 
			macro_list := $1 :: !macro_list;
			{
				qualifiers = [];
				meth_type = TVoid;
				name = "";
				params = [];
			}
		}
	| friend_declaration 
		{ 
			{
				qualifiers = [];
				meth_type = TVoid;
				name = "";
				params = [];
			}
		}
/*	| operator_declaration 
		{ 
			{
				qualifiers = [];
				meth_type = TVoid;
				name = "";
				params = [];
			}
		}
*/
;

qualifier : 
	| VIRTUAL {print_string "yacc: VIRTUAL\n";flush stdout; QVirtual }
	| STATIC {print_string "yacc: STATIC\n";flush stdout; QStatic }
	| INLINE {QInline }


;

constructor:
	identifier LPARENTHESIS param_list RPARENTHESIS SEMICOLON 
	{
		{
			qualifiers = [];
			meth_type = TVoid;
			name = $1;
			params = $3;
		}	
	}
| qualifier identifier LPARENTHESIS param_list RPARENTHESIS SEMICOLON 
	{
		{
			qualifiers = [];
			meth_type = TVoid;
			name = $2;
			params = $4;
		}	
	}	
;

destructor :
	TILDE identifier LPARENTHESIS RPARENTHESIS SEMICOLON 
		{
			{
				qualifiers = [];
				meth_type = TVoid;
				name = "~"^$2;
				params = [] ;
			}	
		}
;

pure_methode:
storage_class var_type identifier LPARENTHESIS param_list RPARENTHESIS 
methode_storage_class_opt SEMICOLON 
	{
	print_string ("yacc: storage_class pure_methode(identifier="^$3^")\n");flush stdout;
		{
			qualifiers = [QConst];
			meth_type = $2;
			name = $3;
			params = $5;
		}
	}
|
var_type identifier LPARENTHESIS param_list RPARENTHESIS 
methode_storage_class_opt SEMICOLON {print_string ("yacc: pure_methode(identifier="^$2^")\n");flush stdout;

	print_string ("yacc: storage_class pure_methode(identifier="^$2^")\n");flush stdout;
		{
			qualifiers = [];
			meth_type = $1;
			name = $2;
			params = $4;
		}
	 

}
;

typedef_declaration:
	TYPEDEF identifier inherited_opt SEMICOLON {Typedef $2;}
;

friend_declaration:
	| FRIEND abstract_class {}
	| FRIEND fonction_declaration {}
;

var_type : 
	| VOID {print_string "yacc:void\n";flush stdout;TVoid}
	| CHAR {TChar }
	| BOOL {print_string "yacc:BOOL\n";flush stdout;TBool}
	| FLOAT {TFloat }
	| SHORT {TShort}
    | identifier {print_string ("yacc: "^ $1 ^" (identifier_type)\n");flush stdout;Type $1}
	| var_type STAR { TPointeur $1 }
	| var_type AND  { TReference $1 }
	
;

param_list       :
	/* epsilon */ { [] }
	| param { print_string "yacc : param\n";flush stdout; [ $1] }
	| param COMMA param_list { $1 :: $3 }
;

param :
	|storage_class_opt var_type_opt identifier default_value_opt array_size_and_opt 
		{	
			let name = match $3 with | None -> ""
									 | Some s -> s
			and	default_value = $4
			and param_type = match $5 with | None -> $2
										   | Some Pointer -> TPointeur $2
                                           | Some (Array_Size n) -> TArray (n,$2)
			in
			let param_type_storage_class = match $1 with | None -> param_type
														 | Some QConst -> TConst param_type
														 | Some _ -> $2
			in											 
			Param (param_type_storage_class, name,default_value)
		}
;


param_directive :
	|storage_class_opt var_type identifier default_value_opt array_size_and_opt 
		{	
			let name = match $3 with | None -> ""
									 | Some s -> s
			and	default_value = $4
			and param_type = match $5 with | None -> $2
										   | Some Pointer -> TPointeur $2
                                           | Some (Array_Size n) -> TArray (n,$2)
			in
			let param_type_storage_class = match $1 with | None -> param_type
														 | Some QConst -> TConst param_type
														 | Some _ -> $2
			in											 
			Param (param_type_storage_class, name,default_value)
		}
;
storage_class:
	CONST {print_string "yacc:CONST\n";flush stdout; QConst;}
;

default_value:
	EQUAL expression {print_string "yacc: default_value";flush stdout ; $2}
;

expression :
	| identifier {VVariable $1}
	| literal {$1}
	| identifier LPARENTHESIS arguments RPARENTHESIS SEMICOLON {VFunction ($1, $3); }
	| expression_booleenne { $1 }
;

expression_booleenne:
	| expression EQ expression { VOp($1,"==", $3) }
;

expression_list:
	| expression {}
	| expression expression_list {}
;	

arguments:
	| /**/ { [] }
	| expression { [$1] }
	| expression COMMA arguments { $1 :: $3}
;	

inline_methode:
	| INLINE storage_class_opt var_type identifier COLONCOLON identifier LPARENTHESIS param_list RPARENTHESIS 
	  methode_storage_class_opt LBRACE expression_list RBRACE{}
;

fonction_declaration:
var_type identifier LPARENTHESIS param_list RPARENTHESIS SEMICOLON {}

;
/*
operator_declaration :
	  var_type OPERATOR EQUAL LPARENTHESIS var_type RPARENTHESIS SEMICOLON {}
	| INLINE var_type OPERATOR EQUAL LPARENTHESIS var_type RPARENTHESIS SEMICOLON {}
;
*/
/*----------------------------------------------------------------------
 * Epsilon (optional) definitions.
 *----------------------------------------------------------------------*/

storage_class_opt:
	/*epsilon*/ { None}
	| storage_class { Some $1 }
;

default_value_opt:
	/*epsilon*/ { None }
	|default_value { Some $1 }
;
	
expression_opt:
	/*epsilon*/ { None }
	|expression { Some $1 }
;
	
methode_storage_class_opt :
	/*epsilon*/ {}
	|CONST {print_string "yacc : CONST(methode_storage_class)";flush stdout;}
;

identifier_opt:
	/*epsilon*/ {print_string ("yacc : epsilon (identifier_opt)");flush stdout; None }
	| identifier {print_string ("yacc : "^$1^" (identifier_opt)");flush stdout; Some $1}
;

inherited_opt:
	|/*epsilon*/ { }
	|INHERITED {}
;

array_size_and_opt:
	/*epsilon*/ { None}
	//| AND { Some Pointer }
	| LBRACKET INTEGER RBRACKET 
		{
			print_string "yacc: array_size_opt\n";flush stdout;
			Some (Array_Size $2)
	   }
;

array_size_opt:
	/*epsilon*/ { None }
	| LBRACKET INTEGER RBRACKET 
		{
			print_string "yacc: array_size_opt\n";flush stdout;
			Some $2
		}
;

var_type_opt:
	/*epsilon*/ { None }
	| var_type
		{
			print_string "yacc: array_size_opt\n";flush stdout;
			Some $1
		}
/* EOF */
%%
