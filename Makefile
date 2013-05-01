GCC=g++ -I /boot/common/lib/ocaml/caml/
OCAMLC=ocamlc.opt
OCAMLOPT=ocamlopt
OCAMLDEP=ocamldep
OCAMLMKTOP=ocamlmktop

OCAMLFLAGS=-thread -g -custom -w mv -ccopt -L~/beos unix.cma threads.cma -ccopt -g
OCAMLOPTFLAGS=$(INCLUDES)

OCAML_OBJS=glue.cmo filePanel.cmo interfaceDefs.cmo graphicsDefs.cmo errors.cmo bstring.cmo \
		   flattenable.cmo messenger.cmo point_rect.cmo rect.cmo point.cmo \
		   supportDefs.cmo message.cmo archivable.cmo messageQueue.cmo \
		   blist.cmo semaphores.cmo threads.cmo os.cmo \
		   handler_looper_messageFilter.cmo handler.cmo looper.cmo \
		   messageFilter.cmo invoker.cmo bitmap.cmo font.cmo polygon.cmo \
		   view_window.cmo view.cmo picture.cmo shape.cmo textView.cmo scrollBar.cmo \
		   scrollView.cmo listItem.cmo stringItem.cmo listView.cmo \
		   outlineListView.cmo menu_menuItem.cmo menu.cmo menuItem.cmo \
		   menuBar.cmo box.cmo printJob.cmo stringView.cmo window.cmo \
		   alert.cmo control.cmo colorControl.cmo textControl.cmo slider.cmo \
		   checkBox.cmo button.cmo appDefs.cmo application.cmo mime.cmo translatorRoster.cmo \
		   translationUtils.cmo posix.cmo

C_OBJS= glue.o posix.o blist.o graphicsDefs.o \
		interfaceDefs.o errors.o threads.o \
		bstring.o message.o archivable.o \
		handler_looper_messageFilter.o invoker.o \
		point_rect.o bitmap.o shape.o view.o polygon.o menuItem.o \
		menu.o menuBar.o listItem.o listView.o outlineListView.o\
		textControl.o textView.o colorControl.o \
		scrollView.o scrollBar.o slider.o \
		checkBox.o button.o stringView.o stringItem.o window.o \
		box.o printJob.o alert.o appDefs.o \
		application.o font.o 

BELIB=/system/lib/libbe.so
LIBOCAML=libbeos.cma
TOPLEVEL=ocaml-beos

all: $(LIBOCAML) $(TOPLEVEL)

$(LIBOCAML): $(OCAML_OBJS) $(C_OBJS) 
	ar rc libbeocaml.a *.o
	$(OCAMLC) $(OCAMLFLAGS) -a -o $(LIBOCAML) $(OCAML_OBJS) -ccopt -L/Data1/ocaml-beos -cclib /Data1/ocaml-beos/libbeocaml.a -cclib $(BELIB)

ocaml-beos: $(LIBOCAML)
	$(OCAMLMKTOP) $(OCAMLFLAGS) -o $(TOPLEVEL) $(LIBOCAML) -cclib $(BELIB)

.SUFFIXES: .ml .cmo .mli .cmi

.ml.cmo:
	$(OCAMLC) $(OCAMLFLAGS) -c $<

.mli.cmi:
	$(OCAMLC) $(OCAMLFLAGS) -c $<

.c.o:
	$(GCC) -DBEOS -g -c $< -o $*.o
	
clean:
		rm -f $(LIBOCAML) $(TOPLEVEL) libbeocaml.a
		rm -f *.cm[io] *.o

depend: 
	$(OCAMLDEP) *.mli *.ml > .depend

include .depend
