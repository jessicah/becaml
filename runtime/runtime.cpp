#include <Application.h>
#include <stdio.h>
#include "/boot/home/lib/ocaml/caml/callback.h"

void main (int argc, char **argv) {
BApplication *app;
app = new BApplication("application/x.runtime.ocaml.3.00.BeOS");
caml_main(argv);
printf("Code Caml execute.\n");
return B_OK;
}

