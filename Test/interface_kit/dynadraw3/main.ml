open Message
open Errors
open DDApp
open MsgVals
open Gc


 let _ = 

Gc.set { (Gc.get()) with Gc.verbose = 0x3ff };

let app = new ddApp 
in 
app#ddApp();
ignore(app#postMessage ~command:kTWEAK_REQ ()); 
ignore (app#run())
(*;kB_NO_ERROR*);;
