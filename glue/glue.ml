open Hashtbl
open SupportDefs
(*
type be = int32;;
*)
exception Break;;
(*
external be : unit -> be = "be"
*)
type c_pointer = int32;;
external delete : c_pointer -> unit = "b_glue_delete"
(*
let null = be();;

let print_be (b : be) = Format.printf "0x%lx" b;;

class be_interne =
   object
      
	val mutable interne = be () (*mutable nécessaire pour l'héritage*)
	  
	method get_interne = 
		interne

	method set_interne interne' = 
		interne <- interne'
end
;;

let delete obj = delete obj(*#get_interne*)
*)

let null = Int32.zero;;

let (c_to_caml : (c_pointer, Obj.t) t) = create 0
let (caml_to_c : (Obj.t, c_pointer) t) = create 0

let ajout_c_to_caml val_c val_ocaml = add c_to_caml val_c (Obj.repr val_ocaml)
let ajout_caml_to_c val_ocaml val_c = add caml_to_c (Obj.repr val_ocaml) val_c

let ajout c caml = 
Printf.printf "[OCaml] ajout c=0x%lx caml = 0x%lx\n" c (Obj.magic caml);flush stdout;
ajout_c_to_caml c caml;
				   ajout_caml_to_c caml c;;

let find obj_c = Obj.obj (find c_to_caml obj_c) ;;
(*
let launch f = ignore (Thread.create (fun () -> begin
										Printf.eprintf "c->caml[%d] caml->c[%d]\n"
									    			    (Hashtbl.length c_to_caml)
														(Hashtbl.length caml_to_c);flush stderr; 
										f() end) 
									());
					Thread.yield();;
let launch_and_get f = let t= Event.new_channel () in
launch (fun () -> 
		Event.sync(Event.send t (f()));
		Event.sync(Event.receive t));;
*)
class be_interne = object(self) 
	method set_interne value_c = ajout value_c self
	method get_interne () = Hashtbl.find caml_to_c (Obj.repr self)
end;;

Callback.register "glue::remove" (fun v_c -> let v = find v_c in Hashtbl.remove c_to_caml v_c;Hashtbl.remove caml_to_c v);;

