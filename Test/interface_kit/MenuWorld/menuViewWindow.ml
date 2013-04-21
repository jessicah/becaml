open Alert
open Application
open AppDefs
open Blist
open Box
open Button
open CheckBox
open Control
open Errors
open Font
open Glue
open Handler
open InterfaceDefs
open ListItem
open ListView
open Menu
open MenuBar
open MenuItem
open Message
open MessageFilter
open Mime
open OutlineListView
open Point
open Rect
open ScrollBar
open ScrollView
open String
open StringItem
open StringView
open TextControl
open Window

open Constants
open PostDispatchInvoker
open Stddlg
open TestMenuBuilder
open ViewLayoutFactory

class menuView =
	object(self)
	inherit be_view as view

	val m_pLabelCtrl			= ref new be_textControl
	val m_pHideUserCheck		= ref new be_checkBox
	val m_pLargeTestIconCheck	= ref new be_checkBox
	val m_pAddMenuButton		= ref new be_button
	val m_pDelButton			= ref new be_button
	val m_pAddItemButton		= ref new be_button
	val m_pMenuOutlineView		= ref new be_outlineListView
	val m_pScrollView			= ref new be_scrollView

	method menuView ~resizingMode =
		view#be_view ~frame:(let r = new be_rect 
							 in 
							 r#be_rect ~left:0. ~top:0. ~right:360. ~bottom:360. ();
							 r) 
					  ~name:"MenuView" 
					  ~resizingMode ~flags:kB_WILL_DRAW;
		let aFactory = new viewLayoutFactory
		in
		self#setViewColor ~rgb_color:kBKG_GREY ();
		let fCheck_x = 20.0
		and fCheck_y = 100.0
		in
		m_pHideUserCheck := aFactory#makeCheckBox ~name:"Hide User Menus" 
												  ~label:kSTR_HIDE_USER_MENUS 
												  ~msgID:kMSG_WIN_HIDE_USER_MENUS 
												  ~pos:(let p = new be_point 
												   in 
												   p#be_point ~x:fCheck_x ~y:fCheck_y ();
												   p) ();
		!m_pHideUserCheck#setValue kB_CONTROL_OFF;
		self#addChild (!m_pHideUserCheck :> be_view) ();
	
		let fCheck_y = (!m_pHideUserCheck#frame())#bottom +. 10.
		in
		m_pLargeTestIconCheck := aFactory#makeCheckBox ~name:"Large Test Icons" 
													   ~label:kSTR_LARGE_TEST_ICONS 
													   ~msgID:kMSG_WIN_LARGE_TEST_ICONS 
													   ~pos:(let p = new be_point 
													    in 
														p#be_point ~x:fCheck_x ~y:fCheck_y (); 
														p) ();
		!m_pLargeTestIconCheck#setValue kB_CONTROL_OFF;
		self#addChild (!m_pLargeTestIconCheck :> be_view) ();
	
		let buttons = new be_list
		in
		buttons#be_list();
		let fButton_x = (!m_pHideUserCheck#frame())#right +. 15.
		and fButton_y = (!m_pHideUserCheck#frame())#top
		in
	
		m_pAddMenuButton := aFactory#makeButton ~name:"Add Menu Bar" 
												~label:kSTR_ADD_MENU 
												~msgID:kMSG_VIEW_ADD_MENU 
												~pos:(let p = new be_point 
												 	  in 
													  Printf.printf "creation du point de Add Menu Bar\n";flush stdout;
													  p#be_point ~x:fButton_x ~y:fButton_y (); 
													  p)
												();
		self#addChild ~aView:(!m_pAddMenuButton :> be_view) ();
		ignore (buttons#addItem ~item:(!m_pAddMenuButton :> be_interne));
	
		let itemLen = be_plain_font#stringWidth kSTR_ADD_ITEM
		and sepLen  = be_plain_font#stringWidth kSTR_ADD_SEP
		in
		let addItemText = if (itemLen > sepLen) 
						  then kSTR_ADD_ITEM 
						  else kSTR_ADD_SEP
		in
		m_pAddItemButton := aFactory#makeButton ~name:"Add Item To Menu" 
												~label:addItemText 
												~msgID:kMSG_VIEW_ADD_ITEM 
												~pos:(let p = new be_point 
													  in 
													  Printf.printf "creation du point de Add Item To Menu\n";flush stdout;
													  p#be_point ~x:fButton_x ~y:fButton_y (); 
													  p)
												();
		!m_pAddItemButton#setEnabled false;
		self#addChild (!m_pAddItemButton :> be_view) ();
		ignore (buttons#addItem (!m_pAddItemButton :> be_interne));
		
		m_pDelButton := aFactory#makeButton ~name:"Delete Menu Bar" 
											~label:kSTR_DELETE_MENU 
											~msgID:kMSG_VIEW_DELETE_MENU 
											~pos:(let p = new be_point 
												  in 
												  Printf.printf "creation du point de Delete Menu Bar\n";flush stdout;
												  p#be_point ~x:fButton_x ~y:fButton_y (); 
												  p)
											();
		Printf.printf "apres aFactory#makeButton\n";flush stdout;
		!m_pDelButton#setEnabled ~enabled:false;
		self#addChild (!m_pDelButton :> be_view) ();
		ignore(buttons#addItem (!m_pDelButton :> be_interne));
		Printf.printf "apres ignore(buttons#addItem (!m_pDelButton :> be_interne))\n";flush stdout;
	
		aFactory#resizeToListMax ~viewList:buttons ~resizeDim:RECT_WIDTH ();
		Printf.printf "apres resizeToListMax\n";flush stdout;
	
		aFactory#align buttons ALIGN_LEFT (((!m_pAddItemButton#frame())#height()) +. 15.);
		Printf.printf "apres align\n";flush stdout;
		
		!m_pAddMenuButton#makeDefault true;

		Printf.printf "apres !m_pAddMenuButton#makeDefault true\n";flush stdout;
	

		let fEdit_left = 20.0
		and fEdit_bottom = (!m_pHideUserCheck#frame())#top -. 20.
		and fEdit_right = (!m_pAddItemButton#frame())#right
		in
	
		m_pLabelCtrl := aFactory#makeTextControl ~name:"Menu Bar Control" 
												 ~label:kSTR_LABEL_CTRL 
												 ~text:"" (*null*) 
												 ~pos:(let p = new be_point 
												  in 
												  Printf.printf "creation du point de Menu Bar Control\n";flush stdout;
												  p#be_point ~x:fEdit_left ~y:fEdit_bottom (); 
												  p) 
												 ~controlWidth:(fEdit_right -. fEdit_left) 
												 ~posRef:CORNER_BOTTOMLEFT
												 ();
		self#addChild(!m_pLabelCtrl :> be_view) ();
		Printf.printf "frame de m_pLabelCtrl : ";flush stdout;
		((!m_pLabelCtrl)#frame())#printToStream();
		flush stdout;

		let r = new be_rect
		in
		r#be_rect ();
		r#set ~left:((!m_pAddItemButton#frame ())#right +. 30.) (); 
		r#set ~top:20.0 ();
		r#set ~right:(r#left +. 200. -. kB_V_SCROLL_BAR_WIDTH) ();
		r#set ~bottom:(r#top +. 100. -. kB_H_SCROLL_BAR_HEIGHT) ();
		Printf.printf "frame de Outline : ";flush stdout;
r#printToStream();flush stdout;
		m_pMenuOutlineView := (let olv = new be_outlineListView 
							   in
							   olv#be_outlineListView ~frame:r 
							   						  ~name:"Menu Outline" 
													  ~list_view_type:B_SINGLE_SELECTION_LIST 
													  ~resizingMode:kB_FOLLOW_ALL
													  ();
							   olv);
						  
		!m_pMenuOutlineView#setSelectionMessage ~message:(let m = new be_message 
														  in 
														  m#be_message ~command:kMSG_MENU_OUTLINE_SEL
														  			   (); 
														  m) ;
		
		m_pScrollView := (let sv = new be_scrollView 
						  in
						  sv#be_scrollView ~name:"Menu Outline Scroller" 
						  				   ~target:!m_pMenuOutlineView 
										   ~resizingMode:(Int32.logor kB_FOLLOW_LEFT 
										   							  kB_FOLLOW_TOP) 
										   ~flags:Int32.zero 
										   ~horizontal:true 
										   ~vertical:true
										   ();
						  sv);
		!m_pScrollView#setViewColor ~rgb_color:kBKG_GREY ();
		self#addChild (!m_pScrollView :> be_view) ();

	method messageReceived ~message =
		match (message#what) with
		| m when m = kMSG_VIEW_ADD_MENU -> self#addMenu ~message
		| m when m = kMSG_VIEW_DELETE_MENU -> self#deleteMenu ~message
		| m when m = kMSG_VIEW_ADD_ITEM -> self#addMenuItem ~message
		| m when m = kMSG_MENU_OUTLINE_SEL -> self#menuSelectionChanged ~message
		| m when m = kMSG_LABEL_EDIT -> self#setButtonState ()
		| _ -> view#messageReceived ~message
	
	method allAttached () =
		try 
			if (not (self#valid ())) 
			then raise Break;
			
	 		ignore (!m_pAddMenuButton#setTarget ~handler:self ());
			ignore (!m_pDelButton#setTarget ~handler:self ());
			ignore (!m_pAddItemButton#setTarget ~handler:self ());
			ignore (!m_pMenuOutlineView#setTarget ~handler:self ());

			self#setButtonState ();

			let p = new postDispatchInvoker
			in 
			p#postDispatchInvoker ~cmdFilter:kB_KEY_DOWN 
					   			  ~invokeMsg:(let m = new be_message
								    		  in 
											  m#be_message ~command:kMSG_LABEL_EDIT ();
											  m) 
								  ~invokeHandler:(self :> be_Handler)
								  (); 
			
			(!m_pLabelCtrl#textView())#addFilter ~filter:p;

			ignore (!m_pMenuOutlineView#addItem ~item:(let si = new be_stringItem
													   in 
													   si#be_stringItem ~text:"Dummy" ();
													   si)
												());
			let itemHeight = ref ((!m_pMenuOutlineView#itemFrame Int32.zero)#height ())
			in
			itemHeight := !itemHeight +. 1.;
			(*delete (match snd (!m_pMenuOutlineView#removeItem ~index:Int32.zero ())
					with Some menuItem -> menuItem
						|None -> raise Break);*)

			let viewHeight = 16. *. !itemHeight
			in
			!m_pScrollView#resizeTo ((!m_pScrollView#frame())#width())
								    (viewHeight +. kB_H_SCROLL_BAR_HEIGHT +. 4.);
			let pBar = !m_pScrollView#scrollBar ~posture:B_HORIZONTAL
			in
			if (pBar#get_interne != null) 
			then pBar#setRange ~min:0. ~max:300.;

			let aFactory = new viewLayoutFactory 
			in
			aFactory#resizeAroundChildren (self :> be_view)
										  (let p = new be_point
										   in 
										   p#be_point ~x:20. ~y:20. ();
										   p);
		with Break -> () 


	method populateUserMenu ~(pMenu : be_menu) ~index =
		if ((pMenu#get_interne = null) || (not (self#valid ())))
		then ()
		else begin
			 let pMenuItem = ref (match snd (pMenu#removeItem ~index:Int32.zero ())
			 					  with Some menuItem -> menuItem
									  |None -> raise Break);
								  
			 in
			 while (!pMenuItem#get_interne != null) do
			 	(*delete !pMenuItem;*)
				pMenuItem := match snd (pMenu#removeItem ~index:Int32.zero ())
							 with Some menuItem -> menuItem
							 	| None -> raise Break
			 done;
			 let pListItem = !m_pMenuOutlineView#itemUnderAt ~underItem:(let li = new be_listItem
			 															 in 
																		 li#set_interne null;
																		 li) 
															  ~oneLevelOnly:true 
															  ~index
			 in
			 self#buildMenuItems ~pMenu 
			 					 ~pSuperItem:pListItem 
								 ~pView:!m_pMenuOutlineView
			 end

	method private addMenu ~message =
	if (not (self#valid())) 
	then ()
	else begin
		 let menuName = !m_pLabelCtrl#text ()
		 in
		 if ((menuName = "")(* || (! *menuName)*)) 
		 then begin
	 			let pAlert = new be_alert
				in
				pAlert#be_alert ~title:"Add menu alert" 
								~text:"Please specify the menu name first." 
								~button0Label:"OK"
								();
				ignore (pAlert#go ());
			  end;
	
		 ignore (!m_pMenuOutlineView#addItem (let si = new be_stringItem
											  in 
										      si#be_stringItem menuName ();
										      si) 
											 ());	
	
		 let newMsg = new be_message
		 in
		 newMsg#be_message ~command:kMSG_WIN_ADD_MENU ();
		 ignore (newMsg#addString ~name:"Menu Name" ~chaine:menuName ());
		 let pWin = self#window ()
		 in
		 if (pWin#get_interne != null) 
		 then ignore (pWin#postMessage ~message:newMsg ());
	
		 !m_pLabelCtrl#setText "";
		 self#setButtonState ();
		 end
		 
	method private deleteMenu ~message =
	if (not (self#valid ()))
	then ()
	else begin 
			let itemCount = ref Int32.zero
			and selected = !m_pMenuOutlineView#currentSelection ()
			in
			if (selected < Int32.zero)
			then ()
			else begin	
					let pSelItem = new be_stringItem
					in
					pSelItem#set_interne ((!m_pMenuOutlineView#itemAt selected)#get_interne);
					if (pSelItem#get_interne != null)
					then ()
					else begin
							if (pSelItem#outlineLevel () = Int32.zero) 
							then begin
									itemCount := !m_pMenuOutlineView#countItemsUnder ~underItem:(let li = new be_listItem 
																					  			 in
																								 li#set_interne null;
																					  			 li)
																					  ~oneLevelOnly:true;
									let i = ref Int32.zero
									in
									try
									for j = 0 to (Int32.to_int !itemCount) - 1 do
										let pItem = !m_pMenuOutlineView#itemUnderAt ~underItem:(let li = new be_listItem 
																					 			in
																								li#set_interne null;
																					  			li)
																					~oneLevelOnly:true 
																					~index:(Int32.of_int j)
										in
										if (pItem#get_interne = pSelItem#get_interne) 
										then raise Break;
										i := Int32.add !i Int32.one;
									done;
									with Break -> ();
		
									let newMsg = new be_message
									in 
									newMsg#be_message ~command:kMSG_WIN_DELETE_MENU ();
									ignore (newMsg#addInt32 ~name:"Menu Index" ~anInt32:!i);
									let pWin = self#window()
									in
									if (pWin#get_interne != null) 
									then ignore (pWin#postMessage ~message:newMsg ());
								 end;
						 end;

					let subItems = new be_list
					in
					itemCount := !m_pMenuOutlineView#countItemsUnder pSelItem false;
					for j=0 to (Int32.to_int !itemCount) - 1 do
						let pItem = !m_pMenuOutlineView#itemUnderAt pSelItem false (Int32.of_int j)
						in
						ignore (subItems#addItem (pItem :> be_interne));
					done;
	
					let pSuperItem = new be_stringItem
					in
					pSuperItem#set_interne (!m_pMenuOutlineView#superitem pSelItem)#get_interne;
		
					ignore (!m_pMenuOutlineView#removeItem ~item:pSelItem ());
	
					let pWin = (new menuWindow : <updateStatus : ?str1:string -> str2:string -> unit -> unit ; ..>)
					in
					pWin#set_interne (self#window ())#get_interne;
					if (pWin#get_interne != null) 
					then let itemName = pSelItem#text ()
						 in
						 if ((String.compare itemName kSTR_SEPARATOR) != 0) 
							then pWin#updateStatus ~str1:kSTR_STATUS_DELETE_ITEM 
												   ~str2:itemName
												   ();
							else pWin#updateStatus ~str2:kSTR_STATUS_DELETE_SEPARATOR
												   ();

					for j = 0 to (Int32.to_int !itemCount) - 1 do
						let pItem = new be_listItem
						in
						pItem#set_interne (subItems#itemAt (Int32.of_int j));
						(*delete pItem;*)
					done;
					(*delete pSelItem; *)
	
					if (pSuperItem#get_interne != null) 
					then begin
							if ( (!m_pMenuOutlineView#countItemsUnder pSuperItem true) != Int32.zero)
							then begin
									let index = !m_pMenuOutlineView#fullListIndexOf ~item:pSuperItem ()
									in
									ignore (!m_pMenuOutlineView#removeItem ~item:pSuperItem ());
									let pCloneItem = new be_stringItem
									in
									pCloneItem#be_stringItem ~text:(pSuperItem#text ())
															 ~level:(pSuperItem#outlineLevel())
															 ();
									ignore (!m_pMenuOutlineView#addItem ~item:pCloneItem ~index ());
									(*delete pSuperItem;*)
								 end
						 end
				 end
		 end

								 
	method private addMenuItem ~message =
		if (not (self#valid ())) 
		then ()
		else begin
	
				let selected = !m_pMenuOutlineView#currentSelection ()
				in
				if (selected >= Int32.zero) 
				then begin
						let pSelItem = !m_pMenuOutlineView#itemAt selected
						in
						if (pSelItem#get_interne != null) 
						then begin
								let level = Int32.add (pSelItem#outlineLevel ()) Int32.one
								and index = (Int32.add (!m_pMenuOutlineView#fullListIndexOf ~item:pSelItem ())
											(Int32.add (!m_pMenuOutlineView#countItemsUnder pSelItem false) 
											 		   Int32.one))
								and itemName = !m_pLabelCtrl#text ()
								in
								let bIsSeparator = self#isSeparator ~text:itemName
								in
								ignore(
								if (bIsSeparator) 
								then !m_pMenuOutlineView#addItem ~item:(let si = new be_stringItem
																  		in
																  		si#be_stringItem ~text:kSTR_SEPARATOR ~level ();
																  		si)
																 ~index
																 ()
								else !m_pMenuOutlineView#addItem ~item:(let si = new be_stringItem
																  		in
																		si#be_stringItem ~text:itemName ~level ();
																		si)
																 ~index
																 ()
								);
								let pWin = new menuWindow
								in
								pWin#set_interne ((self#window ())#get_interne);
								
								if (pWin#get_interne != null) 
								then if (not bIsSeparator) 
									 then pWin#updateStatus ~str1:kSTR_STATUS_ADD_ITEM 
									 						~str2:itemName
															()
									 else pWin#updateStatus ~str2:kSTR_STATUS_ADD_SEPARATOR
									 						();
								
							 end;

						!m_pMenuOutlineView#invalidate();
			
						!m_pLabelCtrl#setText "";
						self#setButtonState ();
					 end
			 end

	method private menuSelectionChanged ~message =
		self#setButtonState ();

	method private buildMenuItems ~pMenu ~pSuperItem ~pView =
		if ((pMenu#get_interne		= null) || 
			(pSuperItem#get_interne = null) || 
			(pView#get_interne		= null)) 
		then ()
		else begin
	
				let len = pView#countItemsUnder pSuperItem true
				in
				if (len = Int32.zero) 
				then begin
						let pEmptyItem = new be_menuItem
						in
						pEmptyItem#be_menuItem ~label:kSTR_MNU_EMPTY_ITEM 
											   ~message:(let m = new be_message 
											   			 in
														 m#set_interne null;
														 m)
											   ();
						pEmptyItem#setEnabled false;
						ignore (pMenu#addItem ~item:pEmptyItem ());
					 end;
	
				for i = 0 to  (Int32.to_int len) - 1 do
					let pItem = new be_stringItem
					in
					pItem#set_interne (pView#itemUnderAt pSuperItem 
														 true 
														 (Int32.of_int i)
									  )#get_interne;
					if (pItem#get_interne != null) 
					then begin
							if ((pView#countItemsUnder pItem true) > Int32.zero) 
							then begin
									let pNewMenu = new be_menu
									in
									pNewMenu#be_menu (pItem#text ()) ();
									self#buildMenuItems ~pMenu:pNewMenu 
														~pSuperItem:(pItem :> be_listItem)
														~pView;
									ignore (pMenu#addItem ~submenu:pNewMenu ());
								 end 
							else begin
									if ((String.compare (pItem#text()) kSTR_SEPARATOR) != 0)
									then begin
											let pMsg = new be_message
											in
											pMsg#be_message ~command:kMSG_USER_ITEM ();
											ignore (pMsg#addString ~name:"Item Name" 
																   ~chaine:(pItem#text ())
																   ());
											ignore (pMenu#addItem ~item:(let mi = new be_menuItem
																			 in 
																			 mi#be_menuItem ~label:(pItem#text ()) 
																			 				~message:pMsg
																							();
																   			 mi)
																  ());
										 end
									else ignore (pMenu#addItem ~item:(let si = new be_separatorItem
																		  in
																		  si#be_separatorItem ();
																		  si :> be_menuItem)
															   ());
								 end
						 end
				 done
			 end

			 
	method private isSeparator ~text =
		try
			if (text = "") 
			then true
			else begin 
			(*if (! *text) {
						 true;
			  }
			*)
	
					let len = String.length text
					in
					for i = 0 to len - 1 do
						let ch = text.[i]
						in
						if ((ch != ' ') && (ch != '-')) 
						then raise Break
					done;
					true;
				 end
		with Break -> false

		 
	method private setButtonState () =
		try
			if (not (self#valid ())) 
			then raise Break;

			let index = !m_pMenuOutlineView#currentSelection ()
			in
            let bIsSelected = (index >= Int32.zero)
			and bSeparatorSelected = ref false
			in
			if (bIsSelected) 
			then begin
					let pItem = new be_stringItem
					in
					pItem#set_interne (!m_pMenuOutlineView#itemAt ~index)#get_interne;
					if (pItem#get_interne != null) 
					then bSeparatorSelected := ((String.compare (pItem#text ()) kSTR_SEPARATOR) = 0);
				
				 end;

			!m_pDelButton#setEnabled bIsSelected;
	
			let bEnableAddItem = bIsSelected && (not !bSeparatorSelected)
			in
			!m_pAddItemButton#setEnabled bEnableAddItem;

			let labelText = !m_pLabelCtrl#text ()
			in
			!m_pAddMenuButton#setEnabled (labelText != "");
		
			let itemText = ref ""
			in
			if (bEnableAddItem && (self#isSeparator labelText)) 
			then itemText := kSTR_ADD_SEP
			else itemText := kSTR_ADD_ITEM;
	
			!m_pAddItemButton#setLabel ~string:!itemText;

			if (bEnableAddItem) 
			then !m_pAddItemButton#makeDefault true
			else !m_pAddMenuButton#makeDefault true;
	
		with Break -> ()
		
	method private valid () =
		try 
			if (!m_pLabelCtrl#get_interne = null) 
			then begin
					ignore (ierror kSTR_NO_LABEL_CTRL);
					raise Break;
				 end;
				 
			if (!m_pHideUserCheck#get_interne = null) 
			then begin
					ignore (ierror kSTR_NO_HIDE_USER_CHECK);
					raise Break;
				 end;
				 
			if (!m_pLargeTestIconCheck#get_interne = null) 
			then begin
					ignore (ierror kSTR_NO_LARGE_ICON_CHECK);
					raise Break;
				 end;
				 
			if (!m_pAddMenuButton#get_interne = null)
			then begin
					ignore (ierror kSTR_NO_ADDMENU_BUTTON);
					raise Break;
				 end;
				 
			if (!m_pAddItemButton#get_interne = null)
			then begin
					ignore (ierror kSTR_NO_ADDITEM_BUTTON);
					raise Break;
				 end;
				 
			if (!m_pDelButton#get_interne = null) 
			then begin
					ignore (ierror kSTR_NO_DELETE_BUTTON);
					raise Break;
				 end;
				 
			if (!m_pMenuOutlineView#get_interne = null)
			then begin
					ignore (ierror kSTR_NO_MENU_OUTLINE);
					raise Break;
				 end;
				 
			if (!m_pScrollView#get_interne = null) 
			then begin
					ignore (ierror kSTR_NO_MENU_SCROLL_VIEW);
					raise Break;
				 end;
			true;
		with Break -> false

end

and menuWindow =
	object(self)
	inherit be_window as window

	val m_pFullMenuBar = new be_menuBar
	val m_pHiddenMenuBar = new be_menuBar
	val m_bUsingFullMenuBar = ref true
	val m_pMenuView = new menuView
	val m_testMenuBuilder = new testMenuBuilder
	
(**)	val m_pStatusView = new be_stringview

	method menuWindow ~name =
		window#be_window ~frame:(let r = new be_rect 
								 in r#be_rect ~left:60. 
											  ~top:260. 
									  		  ~right:360. 
											  ~bottom:360.
									   		  ();
								 r) 
						 ~title:name 
						 ~window_type:B_TITLED_WINDOW 
						 ~flags:(Int32.logor kB_NOT_RESIZABLE 
						 					 kB_NOT_ZOOMABLE)
						 ();
	
		m_bUsingFullMenuBar := true;
		
		let dummyFrame = new be_rect 
		in
		dummyFrame#be_rect ~left:0. 
						   ~top:0. 
						   ~right:0. 
						   ~bottom:0. 
						   ();
		m_pFullMenuBar#be_menuBar ~frame:dummyFrame ~name:"Full Menu Bar" ();
		m_pHiddenMenuBar#be_menuBar ~frame:dummyFrame  ~name:"Menu Bar w. Hidden User Menus" ();
		
		let pMenu = ref new be_menu
		in

		pMenu := self#buildFileMenu ();
		if (!pMenu#get_interne != null) 
		then ignore (m_pFullMenuBar#addItem ~submenu:!pMenu ());

		pMenu := self#buildFileMenu ();
		if (!pMenu#get_interne != null) 
		then ignore (m_pHiddenMenuBar#addItem ~submenu:!pMenu ());

		pMenu := m_testMenuBuilder#buildTestMenu B_MINI_ICON;
		if (!pMenu#get_interne != null)
		then ignore (m_pFullMenuBar#addItem ~submenu:!pMenu ());
		
		pMenu := m_testMenuBuilder#buildTestMenu B_MINI_ICON;
		if (!pMenu#get_interne != null)
		then ignore (m_pHiddenMenuBar#addItem ~submenu:!pMenu ());

		self#addChild ~aView:(m_pFullMenuBar :> be_view) ();
		
		let menuHeight = (m_pFullMenuBar#bounds())#height()
		in
		m_pMenuView#menuView kB_FOLLOW_NONE;
		m_pMenuView#moveBy ~dh:0. ~dv:(menuHeight +. 1.);
	
		self#addChild ~aView:(m_pMenuView :> be_view) ();

		Printf.printf "m_pMenuView#frame()#right = %f\n" (m_pMenuView#frame())#right;flush stdout;
	
		let menuViewRect = new be_rect
		in 
		menuViewRect#be_rect ~rect:(m_pMenuView#frame()) ();
		let top = menuViewRect#bottom +. 1.
		in
		let plainHeight = ref { ascent=0.0; 
								 descent=0.0;
								 leading=0.0
							   }
		in
		be_plain_font#getHeight ~height:plainHeight;

		let boxFrame = new be_rect
		in
		boxFrame#be_rect();
		boxFrame#set ~left:(menuViewRect#left -. 2.) 
					 ~top 
					 ~right:(menuViewRect#right +. 2.) 
					 ~bottom:(top +. 
					 		  !plainHeight.ascent +. 
							  !plainHeight.descent +. 
							  !plainHeight.leading +. 
							  4.)
					 ();

		let pStatusBox = new be_box
		in
		pStatusBox#be_box boxFrame ();
		self#addChild ~aView:(pStatusBox :> be_view) ();

		let statusFrame = pStatusBox#bounds()
		in
		statusFrame#insetBy ~x:2. ~y:2. ();
(*		m_pStatusView#be_stringView ~frame:statusFrame 
									~name:"Status View" 
									~text:kSTR_STATUS_DEFAULT 
									~resizing_mode:kB_FOLLOW_ALL
									();
		m_pStatusView#setViewColor ~rgb_color:kBKG_GREY ();
		pStatusBox#addChild ~aView:(m_pStatusView :> be_view);
*)
		let windowWidth = (m_pMenuView#frame())#right
		and windowHeight = boxFrame#bottom -. 4.
		in

		self#resizeTo windowWidth windowHeight;

	method menusBeginning () =
		if ((not (self#valid())) || (not !m_bUsingFullMenuBar))
		then ()
		else begin
				 let len = m_pFullMenuBar#countItems()
				 in
				 for i = 2 to (Int32.to_int len) - 1 do
				 	let pMenu = (m_pFullMenuBar#submenuAt ~index:(Int32.of_int i))
					in
					if (pMenu#get_interne != null) 
					then m_pMenuView#populateUserMenu pMenu (Int32.of_int (i-2))
				 done;
			 end

	method messageReceived ~message =
		match message#what with
		| m when m = kMSG_WIN_ADD_MENU -> self#addMenu ~message
		| m when m = kMSG_WIN_DELETE_MENU -> self#deleteMenu ~message
		| m when m = kMSG_TEST_ITEM -> self#testMenu ~message
		| m when m = kMSG_USER_ITEM -> self#userMenu ~message 
		| m when m = kMSG_WIN_HIDE_USER_MENUS -> self#toggleUserMenus ~message
		| m when m = kMSG_WIN_LARGE_TEST_ICONS -> self#toggleTestIcons ~message
		| _ -> window#messageReceived ~message
	
	method quitRequested () =
		ignore(be_app#postMessage ~command:kB_QUIT_REQUESTED ());
		true
		
	method updateStatus ?(str1="") ~(str2:string) () =
		let len1 = ref 0
		and len2 = ref 0
		in
		if (str1 != "") then len1 := String.length str1;
		if (str2 != "") then len2 := String.length str2;

		let lenTotal = !len1 + !len2
		in
		let updateText = String.create (lenTotal + 1)
		in
		updateText.[0] <- '\000';
		
		if (str1 != "") then String.blit str1 0 updateText 0	 !len1;
		if (str2 != "") then String.blit str2 0 updateText !len1 !len2;

		if ((self#lock()) && (self#valid()))
		then begin
(*					m_pStatusView#setText updateText;
*)					self#unlock();
			 end
		
	method private addMenu ~message =
		if (not (self#valid())) 
		then ()
		else begin
					let menuName = ref ""
					in
					if ((message#findString ~name:"Menu Name" ~string:menuName ()) = kB_OK)
					then begin
							ignore (m_pFullMenuBar#addItem ~item:(let m = new be_menu 
																  in 
																  m#be_menu !menuName (); 
																  m)
														   ());
							self#updateStatus ~str1:kSTR_STATUS_ADD_MENU 
											  ~str2:!menuName
											  ();
						 end
			 end

	method private deleteMenu ~message =
		if (not (self#valid())) 
		then ()
		else begin
					let i = ref Int32.zero
					in
					if ((message#findInt32 ~name:"Menu Index" ~anInt32:i ()) = kB_OK)
					then begin
							let pItem = m_pFullMenuBar#itemAt ~index:(Int32.add !i (Int32.of_int 2))
							in
							ignore (m_pFullMenuBar#removeItem ~item:pItem ());
							self#updateStatus ~str1:kSTR_STATUS_DELETE_MENU 
											  ~str2:(pItem#label())
											  ();
							delete pItem#get_interne;
						 end
			 end

	method private testMenu ~message =
		if (not (self#valid())) 
		then ()
		else begin
					let i = ref Int32.zero
					in
					if ((message#findInt32 ~name:"Item Index" ~anInt32:i ()) = kB_OK)
					then begin
							let numText = Printf.sprintf "%ld" !i 
							in
							self#updateStatus ~str1:kSTR_STATUS_TEST 
											  ~str2:numText
											  ();
						 end
			 end

	method private userMenu ~message =
		if (not (self#valid())) 
		then ()
		else begin
					let itemName = ref ""
					in
					if ((message#findString ~name:"Item Name" ~string:itemName ()) = kB_OK)
					then self#updateStatus ~str1:kSTR_STATUS_USER 
										   ~str2:!itemName
										   ();
			 end

	method private toggleUserMenus ~message =
		if (not (self#valid())) 
		then ()
		else begin
					let pSrc = ref (be())
					and userFullMenus = ref false
					in
					if ((message#findPointer ~name:"source" ~pointer:pSrc ()) = kB_OK)
					then begin
							let pCheckBox = new be_checkBox
							in
							pCheckBox#set_interne !pSrc;
							userFullMenus := ((pCheckBox#value()) = kB_CONTROL_OFF)
						 end;
					if ((not !userFullMenus) && !m_bUsingFullMenuBar)
					then begin
								ignore (self#removeChild (m_pFullMenuBar :> be_view));
								self#addChild ~aView:(m_pHiddenMenuBar :> be_view) ();
								m_bUsingFullMenuBar := false;
						 end
					else if (!userFullMenus && (not !m_bUsingFullMenuBar)) 
					     then begin
						 			ignore (self#removeChild (m_pHiddenMenuBar :> be_view));
									self#addChild ~aView:(m_pFullMenuBar :> be_view) ();
									m_bUsingFullMenuBar := true;

						      end
			 end

	method private toggleTestIcons ~message =
		try 
			if (not (self#valid())) 
			then raise Break;
		
			let pSrc = ref (be())
			and size = ref B_MINI_ICON
			in
			if ((message#findPointer ~name:"source" ~pointer:pSrc ()) = kB_OK)
			then begin
					let pCheckBox = new be_checkBox
					in
					pCheckBox#set_interne !pSrc;
					size := if ((pCheckBox#value()) = kB_CONTROL_ON)
							then B_LARGE_ICON
							else B_MINI_ICON;
				 end;
			self#replaceTestMenu ~pMenuBar:m_pFullMenuBar ~size:!size;
			self#replaceTestMenu ~pMenuBar:m_pHiddenMenuBar ~size:!size;
		with Break -> ()

	method private valid () =
		if (m_pFullMenuBar#get_interne = null)
		then (ignore (ierror kSTR_NO_FULL_MENU_BAR);
			  false
			 )
		else
		if (m_pHiddenMenuBar#get_interne = null)
		then (ignore (ierror kSTR_NO_HIDDEN_MENU_BAR);
			  false;
			 )
		else
		if (m_pMenuView#get_interne = null)
		then (ignore (ierror kSTR_NO_MENU_VIEW);
			  false;
			 )
		else
		if (m_pStatusView#get_interne = null)
		then (ignore (ierror kSTR_NO_STATUS_VIEW);
			  false;
			 )
		else true;		

	method private buildFileMenu () =
		let pMenu = new be_menu
		in
		pMenu#be_menu ~name:kSTR_MNU_FILE ();
		let pAboutItem = new be_menuItem
		in
		pAboutItem#be_menuItem ~label:kSTR_MNU_FILE_ABOUT 
							   ~message:(let m = new be_message 
							   			 in 
										 m#be_message ~command:kB_ABOUT_REQUESTED ();
										 m)
							   ();
		ignore (pAboutItem#setTarget ~handler:(let h = new be_Handler
											   in
											   h#be_Handler ();
											   h#set_interne null;
									   		   h) 
									 ~looper:be_app
							 		 ());
		ignore (pMenu#addItem ~item:pAboutItem ());
		ignore (pMenu#addSeparatorItem ());
		ignore (pMenu#addItem ~item:(let mi = new be_menuItem 
								 in 
								 mi#be_menuItem ~label:kSTR_MNU_FILE_CLOSE 
								 				~message:(let m = new be_message 
														  in 
														  m#be_message ~command:kB_QUIT_REQUESTED ();
														  m) 
												 ~shortcut:kCMD_FILE_CLOSE 
												 ();
								 mi)
						  ());
		pMenu;

		
	method private replaceTestMenu ~pMenuBar ~size =
		if (pMenuBar#get_interne = null)
		then ()
		else begin
				let pTestMenu = m_testMenuBuilder#buildTestMenu size
				in
				if (pTestMenu#get_interne != null)
				then begin
						let pPrevItem = match snd (pMenuBar#removeItem ~index:Int32.one ())
										with Some menuItem -> menuItem
										   | None -> raise Break
						in
						if (pPrevItem#get_interne != null)
						then delete pPrevItem#get_interne;
						ignore (pMenuBar#addItem ~submenu:pTestMenu ~index:Int32.one ())
					 end
				
			 end
	
end
