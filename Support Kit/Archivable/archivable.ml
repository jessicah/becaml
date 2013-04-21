open Glue;;
open Message;;
open SupportDefs;;

external b_archivable0 : unit ->c_pointer  = "b_archivable0" 
external b_archivable1 : c_pointer  ->c_pointer  = "b_archivable1" 
external b_archivable_ : c_pointer  -> unit = "b_archivable_"
external b_archive     : c_pointer-> bool -> status_t = "b_archive"
external b_instantiate : c_pointer->c_pointer= "b_instantiate" (* A encapsuler pour être utilisée dans un type class be_message -> class be_Archivable *) 
(* À partir du be_message (représentation externe en OCaml), on récupère le b_message
   (représentation interne en C++) en accédant au champ correspondant dans le value
   (valeur C) encodant le be_message.
*)

class be_Archivable =
	object (self)
	    inherit be_interne
		
	    method be_Archivable ?archive () = 
		                     let c_pointer = match archive 
                                      with 
        		                      | None -> b_archivable0 ()
                                      | Some (mes : be_message) -> b_archivable1 (mes#get_interne())
							 in
							 self#set_interne c_pointer
		method be_Archivable_ = b_archivable_ (self#get_interne()) 
        method instantiate ~archive = 
		         let archivable = new be_Archivable
		         in 
				 begin archivable#set_interne (b_instantiate ((archive : be_message)#get_interne())) ;
				       archivable
			     end
        method archive ~archive  ?(deep = true) () = b_archive ((archive : be_message)#get_interne()) deep
	end
;;	
