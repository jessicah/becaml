open Alert
open Application

open Constants
open MenuViewWindow

class menuApp =
	object(self)
	inherit be_application as app

	method menuApp () =
		app#be_application ~signature:kSTR_APP_SIG ()
		
	method aboutRequested() =
		let aboutBox = new be_alert
		in
		aboutBox#be_alert ~title:kSTR_ABOUT_TITLE 
						  ~text:kSTR_ABOUT_DESC 
						  ~button0Label:kSTR_ABOUT_BUTTON
						  ();
		aboutBox#go()
		
	method readyToRun() =
		let pWin = new menuWindow 
		in
		pWin#menuWindow kSTR_APP_NAME;
		pWin#show()

	end;;
	
