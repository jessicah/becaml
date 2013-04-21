OCAMLC=ocamlc
OCAMLOPT=ocamlopt.opt
OCAMLDEP=ocamldep
INCLUDES= -I $(HOME)/beos
OCAMLFLAGS=$(INCLUDES) -g -w mv
OCAMLOPTFLAGS=$(INCLUDES)

POTAPP_OBJS=constants.cmo potview.cmo testWin.cmo potapp.cmo
POTAPP: $(POTAPP_OBJS) /boot/home/beos/libbeos.cma
	$(OCAMLC) -verbose -o PotApp $(OCAMLFLAGS) ../../../libbeos.cma $(POTAPP_OBJS)

.SUFFIXES: .ml .mli .cmo .cmi

.ml.cmo: 
	$(OCAMLC) $(OCAMLFLAGS) -c $<

.mli.cmi:
	$(OCAMLC) $(OCAMLFLAGS) -c $<

clean:
		rm -f PotApp
		rm -f *.cm[io]

depend: 
	$(OCAMLDEP) *.ml *.mli > .depend
	
include .depend
