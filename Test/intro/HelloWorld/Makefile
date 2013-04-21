GCC=g++
OCAMLC=ocamlc
OCAMLOPT=ocamlc.opt
OCAMLDEP=ocamldep
OCAMLMKTOP=ocamlmktop
OCAMLBEOSLIB=/boot/home/beos/libbeos.cma
OCAMLFLAGS=-g -custom -w mv -ccopt -L~/beos -I /boot/home/beos/  
OCAMLOPTFLAGS=$(INCLUDES)
OCAML_SOURCES=helloView.ml helloWindow.ml helloWorld.ml
OCAML_OBJS=$(OCAML_SOURCES:.ml=.cmo)

C_OBJS=

APP=HelloWorld

all: $(APP) 

$(APP): $(OCAML_OBJS) $(OCAMLBEOSLIB)
	$(OCAMLOPT) $(OCAMLFLAGS) -o $(APP) unix.cma /boot/home/beos/libbeos.cma $(OCAML_OBJS) 


.SUFFIXES: .ml .cmo .mli .cmi

.ml.cmo: $(OCAMLBEOSLIB)
	$(OCAMLC) $(OCAMLFLAGS) -c $<

.mli.cmi: $(OCAMLBEOSLIB)
	$(OCAMLC) $(OCAMLFLAGS) -c $<

.c.o:
	$(GCC) -c -g -DBEOS $< -o $*.o
	
clean:
		rm -f $(APP) 
		rm -f *.cm[io] *.o

depend: 
	$(OCAMLDEP) *.mli *.ml > .depend

include .depend
