open Font;;
open StringView;;
open View;;

class helloView =
	object(self)
	inherit be_stringview 

	method helloView rect name text =
		Printf.printf "[OCaml] constructeur de helloView\n";flush stdout;
		self#be_stringView ~frame:rect ~name ~text ~resizing_mode:kB_FOLLOW_ALL ~flags:kB_WILL_DRAW ();
		Printf.printf "[OCaml] appel de setFont";flush stdout;
		self#setFont ~font:be_bold_font ();
		Printf.printf "[OCaml] apres appel de setFont";flush stdout;
		self#setFontSize 24.
end;;
	
