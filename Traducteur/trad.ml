open Cgram
open Clex
open GenerateCpp
open GenerateH
open GenerateML

let trad fichier =
	let lexbuf = Lexing.from_channel fichier 
	in (translation_unit token) lexbuf


let entete = "#ifndef BEOS
	#define BEOS
#endif
#include <stdio.h>
#include <string.h>

#include \"alloc.h\"
#include \"callback.h\"
#include \"memory.h\"
#include \"mlvalues.h\"
#include \"signals.h\"

#include \"glue.h\""

let rec traduit_dir src_dir dest_dir =
	let liste_fichiers = Sys.readdir src_dir 
	in
	for i = 0 to (Array.length liste_fichiers) -1 do
	let f = liste_fichiers.(i) 
	in
	let f_complete_path = src_dir ^"/"^f
	in 
	print_string  ("file : "^ f);print_newline();
	
	if Sys.is_directory f_complete_path 
	then begin
	       	ignore (Sys.command ("mkdir "^ (Filename.concat dest_dir f)) );
			traduit_dir f_complete_path (dest_dir^"/"^f)
		 end
	else begin
		 let ast = trad (open_in f_complete_path) 
		 and cpp = open_out (dest_dir^"/"^ (Filename.chop_extension f)^ ".cpp")
		 and h   = open_out (dest_dir^"/"^ f)
		 and ml  = open_out (dest_dir^"/"^ (Filename.chop_extension f)^ ".ml")
		 in
         output_string cpp (generate_cpp ast); 
		 generate_h ast h;
		 generate_ml ast ml;
		 close_out cpp;
		 close_out h;
		 close_out ml;
		 
		 print_string ((src_dir ^"/"^f) ^ "\t" ^  (dest_dir^"/"^f));print_newline();
		 end
done
;;

let _ = traduit_dir Sys.argv.(1) Sys.argv.(2)
