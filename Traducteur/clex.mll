{
open Cgram
}


let intsuffix =				(['u''U']['l''L']?)|(['l''L']['u''U']?)
let fracconst =				(['0'-'9']*'.'['0'-'9']+)|(['0'-'9']+'.')
let exppart	=				['e''E']['-''+']?['0'-'9']+
let floatsuffix	=			['f''F''l''L']
let chartext =				([^'\''])|('\\'_)
let stringtext =			([^'"'])|('\\'_)




rule token = 
	parse

|"#"				{ SHARP }
|"{"				{ LBRACE }
|"<%"				{ LBRACE }
|"}"				{ RBRACE }
|"%>"				{ RBRACE }
|"["				{ LBRACKET }
|"<:"				{ LBRACKET }
|"]"				{ RBRACKET }
|":>"				{ RBRACKET }
|"("				{ LPARENTHESIS }
|")"				{ RPARENTHESIS }
|";"				{ SEMICOLON }
|":"				{ print_string"lex: :\n";flush stdout; COLON }
|"..."				{ ELLIPSIS }
|"?"				{ QUESTION }
|"::"				{  print_string"lex: ::\n";flush stdout;COLONCOLON }
|"."				{ print_string "lex: .\n";flush stdout;DOT }
|".*"				{ DOTSTAR }
|"+"				{ PLUS }
|"-"				{ MINUS }
|"*"				{ print_string "lex: STAR\n";flush stdout;STAR }
|"/"				{ print_string "lex: BACKSLASH\n";flush stdout; DIV }
|"\\"				{ BACKSLASH }
|"%"				{ PERCENT }
|"^"				{ XOR }
|"xor"				{ XOR }
|"&"				{ print_string "lex: AND\n";flush stdout; AND }
|"bitand"			{ AND }
|"|"				{ OR }
|"bitor"			{ OR }
|"~"				{ TILDE }
|"compl"			{ TILDE }
|"!"				{ EXCLAMATION }
|"not"				{ EXCLAMATION }
|"="				{ print_string "lex: EQUAL\n";flush stdout; EQUAL }
|"<"				{ INF }
|">"				{ SUP }
|"+="				{ ADDEQ }
|"-="				{ SUBEQ }
|"*="				{ MULEQ }
|"/="				{ DIVEQ }
|"%="				{ MODEQ }
|"^="				{ XOREQ }
|"xor_eq"			{ XOREQ }
|"&="				{ ANDEQ }
|"and_eq"			{ ANDEQ }
|"|="				{ OREQ }
|"or_eq"				{ OREQ }
|"<<"				{ SL }
|">>"				{ SR }
|"<<="				{ SLEQ }
|">>="				{ SREQ }
|"=="					{ EQ }
|"!="					{ NOTEQ }
|"not_eq"				{ NOTEQ }
|"<="					{ LTEQ }
|">="					{ GTEQ }
|"&&"					{ ANDAND }
|"and"					{ ANDAND }
|"||"					{ OROR }
|"or"					{ OROR }
|"++"					{ PLUSPLUS }
|"--"					{ MINUSMINUS }
|","					{ COMMA }
|"->*"					{ ARROWSTAR }
|"->"					{ ARROW }

|"__attribute__"		{ ATTRIBUTE }
|"asm"					{ ASM }
|"auto"					{ AUTO }
|"bool"					{ BOOL }
|"break"					{ BREAK }
|"case"					{ CASE }
|"catch"					{ CATCH }
|"char"					{ CHAR }
|"class"					{ CLASS }
|"const"					{ CONST }
|"const_cast"			{ CONST_CAST }
|"continue"				{ CONTINUE }
|"default"				{ DEFAULT }
|"define"				{print_string "lex: define \n";flush stdout; DEFINE }
|"delete"				{ DELETE }
|"do"					{ DO }
|"double"				{ DOUBLE }
|"dynamic_cast"			{ DYNAMIC_CAST }
|"elif"					{ ELIF }
|"else"					{ ELSE }
|"endif"				{ ENDIF }
|"enum"					{ print_string "lex: enum \n";flush stdout; ENUM }
|"error"				{ ERROR }
|"explicit"				{ EXPLICIT }
|"export"				{ EXPORT }
|"extern"				{ EXTERN }
|"false"					{ FALSE }
|"float"					{ FLOAT }
|"for"					{ FOR }
|"friend"				{ FRIEND }
|"goto"					{ GOTO }
|"if"					{ print_string "if\n";flush stdout; IF }
|"ifdef"				{ IFDEF } 
|"ifndef"				{ print_string "ifndef \n";flush stdout;IFNDEF }
|"inherited"			{ INHERITED }
|"include"				{ print_string "include \n";flush stdout;INCLUDE }
|"inline"				{ print_string "lex: inline \n";flush stdout;INLINE }
|"int"					{ print_string "INT \n";flush stdout;INT }
(*|"int32"				{ INT32 }*)
|"long"					{ LONG }
|"mutable"				{ MUTABLE }
|"namespace"				{ NAMESPACE }
|"new"					{ NEW }
|"operator"				{ print_string "lex: OPERATOR\n";flush stdout; OPERATOR }
|"private"				{ print_string "lex: PRIVATE \n";flush stdout;PRIVATE }
|"protected"				{ PROTECTED }
|"public"				{ PUBLIC }
|"register"				{ REGISTER }
|"reinterpret_cast"		{ REINTERPRET_CAST }
|"return"				{ RETURN }
|"short"					{ SHORT }
|"signed"				{ SIGNED }
|"sizeof"				{ SIZEOF }
|"static"				{ STATIC }
|"static_cast"			{ STATIC_CAST }
|"struct"				{ STRUCT }
|"switch"				{ SWITCH }
|"template"				{ TEMPLATE }
|"this"					{ THIS }
|"throw"					{ THROW }
|"true"					{ TRUE }
|"try"					{ TRY }
|"typedef"				{ print_string "lex: TYPEDEF \n";flush stdout;TYPEDEF }
|"typeid"				{ TYPEID }
|"typename"				{ TYPENAME }
|"union"					{ UNION }
|"unsigned"				{ UNSIGNED }
|"using"					{ USING }
|"virtual"				{ VIRTUAL }
|"void"					{ VOID }
|"volatile"				{ VOLATILE }
|"wchar_t"				{ WCHAR_T }
|"while"				{ WHILE }
| eof					{ EOF }

(* commentaires, espaces *)
| "//" [^'\n']* '\n' 		{ token lexbuf } 
| "/*"  { skip_comment lexbuf} 
| [' ' '\t' '\n']	{ token lexbuf } 


| ['a'-'z''A'-'Z''_']['a'-'z''A'-'Z''_''0'-'9']* as s { print_string ("lex: "^s);print_newline();flush stdout;IDENTIFIER s }
| '0'['x''X']['0'-'9''a'-'f''A'-'F']+(intsuffix)? as i		{ INTEGER (Int32.of_string i); }
| '0'['0'-'7']+(intsuffix)?	as i		{ INTEGER (Int32.of_string i) }
| ['0'-'9']+(intsuffix)? as i			{ INTEGER (Int32.of_string i) }

|(fracconst)(exppart)?(floatsuffix)? as f	{ FLOATING (float_of_string f) }
|['0'-'9']+(exppart)(floatsuffix)? as f		{ FLOATING (float_of_string f) }

|"'"(chartext)*"'" as c			{ CHARACTER c; }
|"L'"(chartext)*"'" as c			{ CHARACTER c; }

|"\""(stringtext)*"\"" as s			{ STRING s; }
|"L\""(stringtext)*"\"" as s			{ STRING s; }

and 
skip_comment = shortest
 | _*  "*/"{ token lexbuf}
and 
skip_line = shortest
 | _*'\n' {token lexbuf}	
