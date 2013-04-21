open Errors

open MenuApp;;
Gc.set { (Gc.get()) with Gc.verbose = 0xfff; Gc.minor_heap_size = 65536;
Gc.space_overhead = 101; Gc.max_overhead = 1_000_001};;

let app = new menuApp
in
app#menuApp();
ignore (app#run ());
kB_NO_ERROR;
