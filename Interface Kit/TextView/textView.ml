open Glue
open View

external b_textView_addFilter : c_pointer -> c_pointer -> unit = "b_textView_addFilter"

class be_textView =
	object(self)
	inherit be_view

	method be_textView () =
		Printf.printf "be_textView#be_textView non implemente.\n";flush stdout;
			
	method addFilter : 'a. filter:(#be_interne as 'a) -> unit =
  		fun ~filter ->
		b_textView_addFilter (self#get_interne()) (filter#get_interne())


end
