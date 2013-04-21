open Glue;;

open Archivable;;
open Message;;

external b_cursor_cursorData : be -> be -> be = "b_cursor_cursorData"
external b_cursor_archive : be -> be -> be = "b_cursor_archive"
external b_cursor_ : be -> unit = "b_cursor_"
external b_cursor_instantiate : be -> be -> be = "b_cursor_instantiate"

class be_cursor =
	object(self)
	inherit be_archivable

	method be_cursor ?cursorData ?archive () = (*FORMAT DE cursorData A REVOIR*) 
	           match cursorData,archive with 
			   | Some (c : be_interne), None -> self#_BE_set_interne(b_cursor_cursorData self#_BE_interne c#_BE_interne)
			   | None, Some m -> self#_BE_set_interne(b_cursor_archive self#_BE_interne ((m : be_message)#_BE_interne))
			   | _ -> failwith "be_cursor#be_cursor : paramètres incorrects."
	
	method be_cursor_ () = b_cursor_ self#_BE_interne
	method instantiate ~archive = let archivable = new be_archivable 
	                              in
								  begin
								  	archivable#_BE_set_interne(b_cursor_instantiate self#_BE_interne ((archive : be_message)#_BE_interne));
									archivable
								  end
	
end;;
