open Bitmap
open Font
open Glue
open GraphicsDefs
open Menu
open MenuItem
open Message
open Mime
open Rect
open String

open Constants
open TestIcons
open BitmapMenuItem

let kTEST_NAME_LENGTH = 20;;

class testMenuBuilder =
	object(self)

	method buildTestMenu ~size =
		let pItemArray = Array.make_matrix kNUM_TEST_ITEMS_DOWN 
										   kNUM_TEST_ITEMS_ACROSS 
										   (new bitmapMenuItem)
		and pTypicalItem = ref new bitmapMenuItem
		in
		for i = 0 to kNUM_TEST_ITEMS_DOWN - 1 do
			for j = 0 to kNUM_TEST_ITEMS_ACROSS - 1 do
				let pBitmap = self#loadTestBitmap ~i ~j ~size
				in
				if (pBitmap#get_interne() = null) 
				then pItemArray.(i).(j) <- (new bitmapMenuItem)
				else begin
						let itemIndex = kNUM_TEST_ITEMS_ACROSS * i + j + 1
						in
						let name = Printf.sprintf "%s %d" kSTR_MNU_TEST_ITEM itemIndex
						and pTestMsg = new be_message
						in
						pTestMsg#be_message ~command:kMSG_TEST_ITEM ();
						ignore (pTestMsg#addInt32 "Item Index" (Int32.of_int itemIndex));
						let shortcut = Char.chr  ((Char.code '0') + itemIndex)
						in
						let pItem = new bitmapMenuItem
						in
						pItem#bitmapMenuItem ~name ~bitmap:pBitmap ~message:pTestMsg ~shortcut ~modifiers:0 ();
						pItemArray.(i).(j) <- pItem;
						pTypicalItem := pItem
					 end;
					 (*delete pBitmap;*)
			done
		done;
		let menuHeight = ref 0.0
		and menuWidth  = ref 0.0
		in
		try 
			if (!pTypicalItem#get_interne() = null)
			then raise Break;
			let itemHeight = ref 0.0
			and itemWidth  = ref 0.0
			in
			!pTypicalItem#getBitmapSize itemWidth itemHeight;
			itemWidth := !itemWidth +. 1.;
			itemHeight := !itemHeight +. 1.;

			menuWidth := (float kNUM_TEST_ITEMS_ACROSS) *. !itemWidth;
			menuHeight := (float kNUM_TEST_ITEMS_DOWN)  *. !itemHeight;
			
			let left = ref 0.0
			and top  = ref 0.0
			and frame = new be_rect
			in
			frame#be_rect ();
			let pMenu = new be_menu
			in
			pMenu#be_menu ~name:kSTR_MNU_TEST ~width:!menuWidth ~height:!menuHeight ();
			for i = 0 to kNUM_TEST_ITEMS_DOWN - 1 do
				for j = 0 to kNUM_TEST_ITEMS_ACROSS - 1 do
					let pItem = pItemArray.(i).(j)
					in
					Printf.printf "pItemArray.(%d).(%d) = %lx\n" i j (pItem#get_interne());flush stdout;
					if (pItem#get_interne() != null)
					then begin
							left := (float j) *. !itemWidth;
							top := (float i) *. !itemHeight;
							frame#set ~left:!left 
									  ~top:!top 
									  ~right:(!left +. !itemWidth -. 1.) 
									  ~bottom:(!top +. !itemHeight -. 1.)
									  ();
							ignore(pMenu#addItem ~item:pItem ~frame ());
						end
				done
			done;
			pMenu
		with Break -> let pMenu = new be_menu 
					  in
					  pMenu#set_interne null;
					  pMenu
		
		method loadTestBitmap ~i ~j ~size =
			let pBitmap = new be_Bitmap
			and bits = ref [||]
			and byteLen = ref 0
			and iconColorSpace = ref B_NO_COLOR_SPACE
			and iconBounds = new be_rect
			in
			iconBounds#be_rect ~left:0. ~top:0. ~right:0. ~bottom:0. ();

			try
				if ((i < 0) || (j < 0))
				then raise Break;
				
				if ((i >= kNUM_TEST_ITEMS_DOWN) || (j >= kNUM_TEST_ITEMS_ACROSS))
				then raise Break;

				if (size = B_LARGE_ICON)
				then begin
						bits := kLargeTestIcons.(i).(j);
						byteLen := kLARGE_ICON_BYTES;
						iconBounds#set ~right:(float (kLargeIconWidth - 1)) ();
						iconBounds#set ~bottom:(float (kLargeIconHeight - 1)) ();
						iconColorSpace := kLargeIconColorSpace;
					 end
				else begin
						bits := kMiniTestIcons.(i).(j);
						byteLen := kMINI_ICON_BYTES;
						iconBounds#set ~right:(float (kMiniIconWidth - 1)) ();
						iconBounds#set ~bottom:(float (kMiniIconHeight - 1)) ();
						iconColorSpace := kMiniIconColorSpace;
					 end;
				
				pBitmap#be_Bitmap ~bounds:iconBounds ~space:!iconColorSpace ();
				let destBits = pBitmap#bits()
				in
				ignore (Posix.String.memcpy ~dst:destBits 
											~src:(int8_array_to_be !bits) 
											~len:(Int32.of_int !byteLen));
				pBitmap;
			with Break -> let pBitmap = new be_Bitmap
						  in
						  pBitmap#set_interne null;
						  pBitmap
		
end	
