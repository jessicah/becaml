OCAMLC=ocamlc.opt
OCAMLOPT=ocamlopt.opt
OCAMLDEP=ocamldep
INCLUDES= -I /BeOS/home/beos
OCAMLFLAGS=$(INCLUDES) -g -w mv -custom -ccopt -L~/beos
OCAMLOPTFLAGS=$(INCLUDES)

BASICBUTTON_OBJS=btsButtonWindow.cmo btsButtonApp.cmo

BASICBUTTON: $(BASICBUTTON_OBJS) 
	$(OCAMLC) -verbose  unix.cma -o BasicButton $(OCAMLFLAGS) ../../../libbeos.cma $(BASICBUTTON_OBJS)

.SUFFIXES: .ml .mli .cmo .cmi

.ml.cmo: 
	$(OCAMLC) $(OCAMLFLAGS) -c $<

.mli.cmi:
	$(OCAMLC) $(OCAMLFLAGS) -c $<

clean:
		rm -f BasicButton
		rm -f *.cm[io]

depend : 
	$(OCAMLDEP) *.ml *.mli > .depend
	
include .depend
