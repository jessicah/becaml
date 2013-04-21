open Errors

open MenuApp;;
Gc.set { (Gc.get()) with Gc.verbose = 0x0; Gc.minor_heap_size = 65536*256;
Gc.space_overhead = 100; Gc.max_overhead = 1_000_000};;

let app = new menuApp
in
app#menuApp();
ignore (app#run ());
kB_NO_ERROR;
