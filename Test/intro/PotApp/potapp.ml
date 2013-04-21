open Alert
open Application
open FilePanel

open Constants

class potApp =
	object(self)
	inherit be_application as super
	
	val m_pOpenPanel = new be_filePanel

	method potApp() =
		self#be_application ~signature:kAPP_SIG ();
		m_pOpenPanel#be_filePanel 0

	method aboutRequested () =
		let pAlert = new be_alert
		in 
		pAlert#be_alert ~title:"About PotApp" 
		~text:"PotApp\na demonstration of asynchronous controls\n\n\
		Usage:\n\n\
		*\tClick and drag on a pot to adjust the\n\
		\tcolor overlay.\n\
		*\tClick on a check box to mark/unmark\n\
		\ta pot.\n\
		*\tCommand-click anywhere else and\n\
		\tdrag to adjust all marked pots\n\
		\tsimultaneously." 
		~button0Label:"OK" ();
		pAlert#go()

	method readyToRun () =
			let count = TestWin.countWindows()
			in
			if (count < 1) then self#onOpen();

	method argsReceived ~argc ~argv =
		let message = new be_message
		in
		for i = 1 to (argc - 1) do
		    let refs = 1 
			and err = get_ref_for_path argv.(i) refs
			in
			if (err == B_OK) then
				begin
					if (!message) then
							begin
								message#be_message;
								message#what := B_REFS_RECEIVED;
							end
					message#addRef "refs" refs;		
				end
		done;
		if (message) then self#refsReceived(message)

	method messageReceived ~message =
		match message#what with
		| MSG_FILE_OPEN -> self#onOpen()
		| B_CANCEL -> if (TestWin.countWindows() < 1) then self#postMessage B_QUIT_REQUESTED
		| _ -> super#messageReceived ~message
	
end;;	

let _ = 

	let theApp = new potApp
	in
	theApp#run();
	0
;;	
