OCAMLC=ocamlc.opt
OCAMLOPT=ocamlopt.opt
OCAMLDEP=ocamldep
INCLUDES= -I /BeOS/home/beos
OCAMLFLAGS=$(INCLUDES) -g -w mv
OCAMLOPTFLAGS=$(INCLUDES)

DoubleClick_OBJS=doubleClick.cmo

DoubleClick: $(DoubleClick_OBJS) /BeOS/home/beos/libbeos.cma
	$(OCAMLC) -ccopt -g -verbose -o DoubleClick $(OCAMLFLAGS) /BeOS/home/beos/libbeos.cma $(DoubleClick_OBJS)

.SUFFIXES: .ml .mli .cmo .cmi

.ml.cmo: 
	$(OCAMLC) $(OCAMLFLAGS) -c $<

.mli.cmi:
	$(OCAMLC) $(OCAMLFLAGS) -c $<

clean:
		rm -f DoubleClick
		rm -f *.cm[io]

depend : 
	$(OCAMLDEP) *.ml *.mli > .depend
	
include .depend
