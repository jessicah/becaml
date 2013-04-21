GCC=g++
OCAMLC=ocamlc.opt
OCAMLOPT=ocamlopt.opt
OCAMLDEP=ocamldep
OCAMLMKTOP=ocamlmktop
OCAMLBEOSLIB=/BeOS/home/beos/libbeos.cma
OCAMLFLAGS=-g -custom -w mv -ccopt -g -ccopt -L~/beos -I /BeOS/home/beos/  
OCAMLOPTFLAGS=$(INCLUDES)
OCAML_SOURCES=msgVals.ml tweakWin.ml colorWin.ml filterView.ml dDWindow.ml dDApp.ml main.ml
OCAML_OBJS=$(OCAML_SOURCES:.ml=.cmo)

C_OBJS=

APP=dynadraw3

all: $(APP) 

$(APP): $(OCAML_OBJS) $(OCAMLBEOSLIB)
	$(OCAMLC) $(OCAMLFLAGS) -o $(APP) unix.cma  /BeOS/home/beos/libbeos.cma $(OCAML_OBJS) 


.SUFFIXES: .ml .cmo .mli .cmi .cmx

.ml.cmo: $(OCAMLBEOSLIB)
	$(OCAMLC) $(OCAMLFLAGS) -c $<

.ml.cmx: $(OCAMLBEOSLIB)
	$(OCAMLOPT) $(OCAMLFLAGS) -c $<

.mli.cmi: $(OCAMLBEOSLIB)
	$(OCAMLC) $(OCAMLFLAGS) -c $<

.c.o:
	$(GCC) -c -g -DBEOS -DBEOS_ROOTS $< -o $*.o
	
clean:
		rm -f $(APP) 
		rm -f *.cm[io] *.o

depend: 
	$(OCAMLDEP) *.mli *.ml > .depend

include .depend
