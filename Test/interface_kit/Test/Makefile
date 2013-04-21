OCAMLC=ocamlc
OCAMLOPT=ocamlopt.opt
OCAMLDEP=ocamldep
INCLUDES= -I $(HOME)/beos
OCAMLFLAGS=$(INCLUDES) -g -i -w mv
OCAMLOPTFLAGS=$(INCLUDES)

TEST_OBJS=constants.cmo postDispatchInvoker.cmo stddlg.cmo testIcons.cmo \
               bitmapMenuItem.cmo testMenuBuilder.cmo viewLayoutFactory.cmo \
			   menuViewWindow.cmo menuApp.cmo main.cmo

Test: $(TEST_OBJS) /boot/home/beos/libbeos.cma
			$(OCAMLC) -verbose -o Test $(OCAMLFLAGS) ../../../libbeos.cma $(TEST_OBJS)

.SUFFIXES: .ml .mli .cmo .cmi

.ml.cmo: 
	$(OCAMLC) $(OCAMLFLAGS) -c $<

.mli.cmi:
	$(OCAMLC) $(OCAMLFLAGS) -c $<

clean:
		rm -f Test
		rm -f *.cm[io]

depend : 
	$(OCAMLDEP) *.ml *.mli > .depend
	
include .depend
