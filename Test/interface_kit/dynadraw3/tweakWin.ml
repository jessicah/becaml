open Box;;
open Slider;;
open CheckBox;;
open AppDefs;;
open Application;;
open Window;;
open Rect;;
open View;;
open Message;;
open Handler;;
open Invoker;;
open MsgVals;;

let kMIN_SLEEP = Int32.of_int 3000
and kMAX_SLEEP = Int32.of_int 30000;;

class tweakWin =
	object(self)
	inherit be_window as window

	val handler = ref (new be_window)
	val mass = new be_slider
	val drag = new be_slider
	val width = new be_slider
	val sleepage = new be_slider

	method tweakWin hand (imass:int32) (idrag:int32) (iwidth:int32) (isleepage:int32) =
		window#be_window ~frame:(let r = new be_rect 
                                         in 
                                         r#be_rect ~left:610. 
                                                   ~top:50. 
                                                   ~right:760. 
                                                   ~bottom:500. 
                                                   ();
                                         r) 
                                 ~title:"Tweakables" 
                                 ~window_type:B_FLOATING_WINDOW 
                                 ~flags:Int32.zero 
                                 ();
		handler := hand;
		let tv = new be_view
		in
		tv#be_view (self#bounds()) "tweakview" kB_FOLLOW_ALL kB_WILL_DRAW;
		let bb = new be_box 
		in
		bb#be_box ~frame:(let r = new be_rect in 
						  r#be_rect ~left:5. 
				 		  ~top:10. 
						  ~right:((self#bounds())#width() -. 5.) 
						  ~bottom:((self#bounds())#height() -. 10.) 
						  ();
						  r) 
				   ();
		tv#addChild ~aView:(bb :> be_view) ();
		mass#be_slider ~frame:(let r = new be_rect in 
							  r#be_rect ~left:5. 
							  			~top:20. 
										~right:135. 
										~bottom:50. 
										();
							  r) 
					   ~name:"mass" 
					   ~label:"Mass"
					   ~message:(let m = new be_message in 
					   			 m#be_message ~command:kMASS_CHG ();
								 m) 
					   ~minValue:Int32.zero 
					   ~maxValue:(Int32.of_int 100) ();
		mass#setHashMarks B_HASH_MARKS_BOTTOM;
		mass#setLimitLabels "Light" "Heavy";
		mass#setValue imass;
		bb#addChild ~aView:(mass :> be_view) ();

		drag#be_slider ~frame:(let _r = new be_rect in _r#be_rect ~left:5. ~top:90. ~right:135. ~bottom:120. ();_r) ~name:"drag" ~label:"Drag"
						  ~message:(let _m = new be_message in _m#be_message ~command:kDRAG_CHG ();_m) ~minValue:Int32.zero ~maxValue:(Int32.of_int 100) ();
		drag#setHashMarks B_HASH_MARKS_BOTTOM;
		drag#setLimitLabels "Glass" "Carpet";
		drag#setValue idrag;
		bb#addChild ~aView:(drag :> be_view) ();

		width#be_slider ~frame:(let r = new be_rect in 
								r#be_rect ~left:5. 
										  ~top:160. 
										  ~right:135. 
										  ~bottom:190. 
										  ();
								r) 
						~name:"width" 
						~label:"Width"
						~message:(let m = new be_message in 
								  m#be_message ~command:kWIDTH_CHG 
								  			   ();
								  m)  
						~minValue:Int32.zero 
					    ~maxValue:(Int32.of_int 100) ();
		width#setHashMarks B_HASH_MARKS_BOTTOM;
		width#setLimitLabels "Narrow" "Wide";
		width#setValue iwidth;
		bb#addChild ~aView:(width :> be_view) ();

		sleepage#be_slider ~frame:(let _r = new be_rect in _r#be_rect ~left:5. ~top:230. ~right:135. ~bottom:260. ();_r) ~name:"sleepage" ~label:"Snooze Factor"
						   ~message:(let _m = new be_message in _m#be_message ~command:kSLEEPAGE_CHG ();_m)  
						   ~minValue:kMIN_SLEEP
					   	   ~maxValue:kMAX_SLEEP ();

		sleepage#setHashMarks B_HASH_MARKS_BOTTOM;
		sleepage#setLimitLabels "Coma" "Catnap";
		sleepage#setValue isleepage;
		bb#addChild ~aView:(sleepage :> be_view) ();

		let fill = new be_checkBox 
		in
		fill#be_checkBox ~frame:(let r = new be_rect in 
								 r#be_rect ~left:25. 
								 		   ~top:320. 
										   ~right:135. 
										   ~bottom:340. 
										   ();
								 r) 
						 ~name:"fill" 
						 ~label:"Wireframe"
						 ~message:(let m = new be_message in m#be_message ~command:kFILL_CHG ();m) 
						 ();
		ignore (fill#setTarget ~handler:!handler ());
		bb#addChild ~aView:(fill :> be_view) ();

		let angle = new be_checkBox 
		in
		angle#be_checkBox ~frame:(let _r = new be_rect in _r#be_rect ~left:25. ~top:350. ~right:135. ~bottom:370. ();_r) ~name:"angle" ~label:"Fixed Angle"
						  ~message:(let _m = new be_message in _m#be_message ~command:kANGLE_CHG ();_m) ();
		angle#setValue Int32.one;
		ignore (angle#setTarget ~handler:(!handler :> be_Handler) ());
		bb#addChild ~aView:(angle :> be_view) ();
		tv#setViewColor ~red:216 ~green:216 ~blue:216 ();
		self#addChild ~aView:(tv :> be_view) ();
		self#show ();

	method messageReceived ~message:msg =
		let val32 = ref Int32.zero
		in
		match msg#what with
		| m when m = kMASS_CHG -> val32 := mass#value();
								  ignore(msg#addInt32 "Mass" !val32);
								  ignore(!handler#postMessage ~message:msg ())
		| m when m = kDRAG_CHG -> val32 := drag#value();
								  ignore(msg#addInt32 "Drag" !val32);
								  ignore(!handler#postMessage ~message:msg ())
		| m when m = kWIDTH_CHG -> val32 := width#value();
								   ignore(msg#addInt32 "Width" !val32);
								   ignore(!handler#postMessage ~message:msg ())
		| m when m = kSLEEPAGE_CHG -> val32 := sleepage#value();
									  ignore(msg#addInt32 "Sleepage" !val32);
									  ignore(!handler#postMessage ~message:msg ())
		| _ -> window#messageReceived ~message:msg 

	method quit () =
		Printf.printf "tweakWin#quit () appele\n";
		flush stdout;
		ignore(be_app#postMessage ~command:kTWEAK_QUIT ());
		window#lock();
		window#quit()
								   

		
end;;	
