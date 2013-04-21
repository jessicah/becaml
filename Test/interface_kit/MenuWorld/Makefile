OCAMLC=ocamlc
OCAMLOPT=ocamlopt.opt
OCAMLDEP=ocamldep
INCLUDES= -I /BeOS/home/beos
OCAMLFLAGS=$(INCLUDES) -g  -w mv
OCAMLOPTFLAGS=$(INCLUDES)

MENUWORLD_OBJS=constants.cmo postDispatchInvoker.cmo stddlg.cmo testIcons.cmo \
               bitmapMenuItem.cmo testMenuBuilder.cmo viewLayoutFactory.cmo \
			   menuViewWindow.cmo menuApp.cmo main.cmo

MenuWorld: $(MENUWORLD_OBJS) /boot/home/beos/libbeos.cma
			$(OCAMLC) -verbose -o MenuWorld $(OCAMLFLAGS) /BeOS/home/beos/libbeos.cma $(MENUWORLD_OBJS)

.SUFFIXES: .ml .mli .cmo .cmi

.ml.cmo: 
	$(OCAMLC) $(OCAMLFLAGS) -c $<

.mli.cmi:
	$(OCAMLC) $(OCAMLFLAGS) -c $<

clean:
		rm -f MenuWorld
		rm -f *.cm[io]

depend : 
	$(OCAMLDEP) *.ml *.mli > .depend
	
include .depend
