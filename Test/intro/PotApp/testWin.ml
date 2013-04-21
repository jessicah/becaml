open Locker
open BList
open Window

class testWin =
let s_winListLocker = (let b = new be_locker 
					   in 
					   b#be_locker "testwin list lock";
					   b)

and s_winList = new be_list in
object(self)
	inherit be_window as be_win
	
	method newWindow ~entry_ref:ref =
		let res = ref kB_error in
		let entry = new be_entry
		in 
		entry#be_entry ref;
		if (entry#initCheck() == kB_OK) 
		then begin
				let path = new be_path
				in
				entry#get_path path;
				if (path#initCheck () == kB_OK)
				then begin
						let pBitmap = ref (be_translationUtils.getBitmap (path#path()))
						in
						if (!pBitmap#get_interne() != null)
						then begin
								let pWin = new testWin
								in 
								pWin#testWin ref pBitmap;
								res := pWin#initCheck()
						     end
					 end
				
			 end;
			 !res
			
	
	method countWindows () =
	 	let count = ref Int32.minus_one
		in
		if (s_winListLocker#lock()) then 
			begin 
				count := s_winList#countItems ();
				s_winListLocker#unLock()
			end;
		!count

	method testWin ref pBitmap =
			let r = new be_rect
			in
			r#be_rect 50 50 250 250;
		self#be_window r "" kB_DOCUMENT_WINDOW 0
	
end
