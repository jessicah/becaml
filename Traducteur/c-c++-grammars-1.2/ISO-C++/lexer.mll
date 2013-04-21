(*	$Id: lexer.l,v 1.2 1997/11/19 15:13:15 sandro Exp $	*/

/*
 * Copyright (c) 1997 Sandro Sigala <ssigala@globalnet.it>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 * ISO C++ lexical analyzer.
 *
 * Based on the ISO C++ draft standard of December '96.
 *)

{
(*
#include <ctype.h>
#include <stdio.h>

#include "parser.h"
*)
open Parser
(*
int lineno;
*)

let lineno = ref 0;;

(*
static int yywrap(void);
static void skip_until_eol(void);
static void skip_comment(void);
static int check_identifier(const char * );
*)
let yywrap () = 1;;

(*
 * We use this routine instead a lex pattern because we don't need
 * to save the matched comment in the `yytext' buffer.
 *)
(*
let skip_comment () =

	try 
   
			let c1 = ref (input_char())
			and c2 = ref (input_char())
			in

			while ( not (!c1 == '*' && !c2 == '/')) do
				if (!c1 == '\n')
				then incr lineno;
				
				c1 := !c2;
				c2 := input_char ()
			done	
	with End_of_file -> ();;
*)	


(*
 * See the previous comment for an explanation.
 *)
(* 
let skip_until_eol () =
	try
		let c = ref (input_char)
		in
		while ( input_char() != '\n') do 
			()
		done	;
		incr lineno;
	with End_of_file -> ()
*)
let check_identifier s = 

	(*
	 * This function should check if `s' is a typedef name or a class
	 * name, or a enum name, ... etc. or an identifier.
	 *)

	match s.[0] with 
	| 'D' -> TYPEDEF_NAME
	| 'N' -> NAMESPACE_NAME
	| 'C' -> CLASS_NAME
	| 'E' -> ENUM_NAME
	| 'T' -> TEMPLATE_NAME
	|  _  -> IDENTIFIER
;;

}

let intsuffix =				(['u''U']['l''L']?)|(['l''L']['u''U']?)
let fracconst =				(['0'-'9']*'.'['0'-'9']+)|(['0'-'9']+'.')
let exppart	=				['e''E']['-''+']?['0'-'9']+
let floatsuffix =			['f''F''l''L']
let chartext =				([^'''])|('\\'[^'\n'])
let stringtext =			([^'"'])|('\\'[^'\n'])

(* %% *)
rule token = parse
"\n"					{ incr lineno; }
|['\t''\r' ]+			{ (* Ignore whitespace. *) }

|"/*"					{ KEYW (Lexing.lexeme lexbuf) }
|"//"					{ skip_until_eol() }

|"{"					{ KEYW '{'; }
|"<%"					{ KEYW '{'; }
|"}"					{ KEYW '}'; }
|"%>"					{ KEYW '}'; }
|"["					{ KEYW '['; }
|"<:"					{ KEYW '['; }
|"]"					{ KEYW ']'; }
|":>"					{ KEYW ']'; }
|"("					{ KEYW '('; }
|")"					{ KEYW ')'; }
|";"					{ KEYW ';'; }
|":"					{ KEYW ':'; }
|"..."					{ ELLIPSIS; }
|"?"					{ KEYW '?'; }
|"::"					{ COLONCOLON; }
|"."					{ KEYW '.'; }
|".*"					{ DOTSTAR; }
|"+"					{ KEYW '+'; }
|"-"					{ KEYW '-'; }
|"*"					{ KEYW '*'; }
|"/"					{ KEYW '/'; }
|"%"					{ KEYW '%'; }
|"^"					{ KEYW '^'; }
|"xor"					{ KEYW '^'; }
|"&"					{ KEYW '&'; }
|"bitand"				{ KEYW '&'; }
|"|"					{ KEYW '|'; }
|"bitor"					{ KEYW '|'; }
|"~"					{ KEYW '~'; }
|"compl"					{ KEYW '~'; }
|"!"					{ KEYW '!'; }
|"not"					{ KEYW '!'; }
|"="					{ KEYW '='; }
|"<"					{ KEYW '<'; }
|">"					{ KEYW '>'; }
|"+="					{ ADDEQ; }
|"-="					{ SUBEQ; }
|"*="					{ MULEQ; }
|"/="					{ DIVEQ; }
|"%="					{ MODEQ; }
|"^="					{ XOREQ; }
|"xor_eq"				{ XOREQ; }
|"&="					{ ANDEQ; }
|"and_eq"				{ ANDEQ; }
|"|="					{ OREQ; }
|"or_eq"				{ OREQ; }
|"<<"					{ SL; }
|">>"					{ SR; }
|"<<="					{ SLEQ; }
|">>="					{ SREQ; }
|"=="					{ EQ; }
|"!="					{ NOTEQ; }
|"not_eq"				{ NOTEQ; }
|"<="					{ LTEQ; }
|">="					{ GTEQ; }
|"&&"					{ ANDAND; }
|"and"					{ ANDAND; }
|"||"					{ OROR; }
|"or"					{ OROR; }
|"++"					{ PLUSPLUS; }
|"--"					{ MINUSMINUS; }
|","					{ KEYW ','; }
|"->*"					{ ARROWSTAR; }
|"->"					{ ARROW; }

|"asm"					{ ASM; }
|"auto"					{ AUTO; }
|"bool"					{ BOOL; }
|"break"				{ BREAK; }
|"case"					{ CASE; }
|"catch"				{ CATCH; }
|"char"					{ CHAR; }
|"class"				{ CLASS; }
|"const"				{ CONST; }
|"const_cast"			{ CONST_CAST; }
|"continue"				{ CONTINUE; }
|"default"				{ DEFAULT; }
|"delete"				{ DELETE; }
|"do"					{ DO; }
|"double"				{ DOUBLE; }
|"dynamic_cast"			{ DYNAMIC_CAST; }
|"else"					{ ELSE; }
|"enum"					{ ENUM; }
|"explicit"				{ EXPLICIT; }
|"export"				{ EXPORT; }
|"extern"				{ EXTERN; }
|"false"				{ FALSE; }
|"float"				{ FLOAT; }
|"for"					{ FOR; }
|"friend"				{ FRIEND; }
|"goto"					{ GOTO; }
|"if"					{ IF; }
|"inline"				{ INLINE; }
|"int"					{ INT; }
|"long"					{ LONG; }
|"mutable"				{ MUTABLE; }
|"namespace"			{ NAMESPACE; }
|"new"					{ NEW; }
|"operator"				{ OPERATOR; }
|"private"				{ PRIVATE; }
|"protected"			{ PROTECTED; }
|"public"				{ PUBLIC; }
|"register"				{ REGISTER; }
|"reinterpret_cast"		{ REINTERPRET_CAST; }
|"return"				{ RETURN; }
|"short"				{ SHORT; }
|"signed"				{ SIGNED; }
|"sizeof"				{ SIZEOF; }
|"static"				{ STATIC; }
|"static_cast"			{ STATIC_CAST; }
|"struct"				{ STRUCT; }
|"switch"				{ SWITCH; }
|"template"				{ TEMPLATE; }
|"this"					{ THIS; }
|"throw"				{ THROW; }
|"true"					{ TRUE; }
|"try"					{ TRY; }
|"typedef"				{ TYPEDEF; }
|"typeid"				{ TYPEID; }
|"typename"				{ TYPENAME; }
|"union"				{ UNION; }
|"unsigned"				{ UNSIGNED; }
|"using"				{ USING; }
|"virtual"				{ VIRTUAL; }
|"void"					{ VOID; }
|"volatile"				{ VOLATILE; }
|"wchar_t"				{ WCHAR_T; }
|"while"				{ WHILE; }

|['a'-'z''A'-'Z''_']['a'-'z''A'-'Z''_''0'-'9']*			{ check_identifier lexbuf; }

|"0"['x''X']['0'-'9''a'-'f''A'-'F']+intsuffix?		{  INTEGER; }
|"0"['0'-'7']+ intsuffix?			{  INTEGER; }
|['0'-'9']+ intsuffix?			{ INTEGER; }

|fracconst exppart? floatsuffix?	{  FLOATING; }
|['0'-'9']+ exppart floatsuffix?		{  FLOATING; }

|"'" chartext* "'"			{  CHARACTER; }
|"L'" chartext* "'"			{  CHARACTER; }

|"\"" stringtext* "\""			{  STRING; }
|"L\"" stringtext* "\""			{  STRING; }

|[^'\n']					{ fprintf(stderr, "%d: unexpected character `%c'\n", lineno, yytext[0]); }


and comment = parse
| "*/" {token lexbuf}
| _   {comment lexbuf}

(*%%*)


