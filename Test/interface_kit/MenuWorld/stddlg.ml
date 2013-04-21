open Alert
open Glue
open InterfaceDefs

open Constants

let ierror msg =
	let fullMsg = kSTR_IERROR ^ msg
	and alert = new be_alert
	in
	alert#be_alert ~title:"Internal Error" 
				   ~text:fullMsg 
				   ~button0Label:"OK" 
				   ~widthStyle:B_WIDTH_AS_USUAL 
				   ~alert_type:B_STOP_ALERT
				   ();
	alert#go ()
;;
	
	
