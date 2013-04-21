OCAMLC=ocamlc.opt
OCAMLOPT=ocamlopt.opt
OCAMLDEP=ocamldep
INCLUDES= -I /BeOS/home/beos
OCAMLFLAGS=$(INCLUDES)   -w mv
OCAMLOPTFLAGS=$(INCLUDES)

IterView_OBJS=iterview.cmo

all : IterView

IterView: $(IterView_OBJS) /BeOS/home/beos/libbeos.cma
	$(OCAMLC) -o IterView $(OCAMLFLAGS) /BeOS/home/beos/libbeos.cma $(IterView_OBJS)

.SUFFIXES: .ml .mli .cmo .cmi

.ml.cmo: 
	$(OCAMLC) $(OCAMLFLAGS) -c $<

.mli.cmi:
	$(OCAMLC) $(OCAMLFLAGS) -c $<

clean:
		rm -f IterView
		rm -f *.cm[io]

depend : 
	$(OCAMLDEP) *.ml *.mli > .depend
	
include .depend
