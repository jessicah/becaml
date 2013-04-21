open Bitmap
open GraphicsDefs
open MenuItem
open View

open Constants

class bitmapMenuItem =
	object(self)
	inherit be_menuItem as menuItem

	val m_bitmap = new be_Bitmap

	method bitmapMenuItem ~name ~(bitmap: be_Bitmap) ~message ?(shortcut = '\000') ?(modifiers = 0) () =
		menuItem#be_menuItem ~label:name ~message ~shortcut ~modifiers ();
		m_bitmap#be_Bitmap ~bounds:(bitmap#bounds ()) ~space:(bitmap#colorSpace ()) ();
		m_bitmap#setBits (bitmap#bits ()) (bitmap#bitsLength ()) Int32.zero (bitmap#colorSpace())

	method draw () =
		let menu = self#menu ()
		in
		if (menu#get_interne() != Glue.null)
		then begin 
				let itemFrame = self#frame ()
				in
				let bitmapFrame = itemFrame
				in
				bitmapFrame#insetBy ~x:2. ~y:2. ();
				menu#setDrawingMode B_OP_COPY;
				menu#setHighColor ~rgb_color:kBKG_GREY ();
				menu#fillRect ~rect:itemFrame ();
				menu#drawBitmap ~image:m_bitmap ~destination:bitmapFrame ();
				if (self#isSelected ())
				then begin
						menu#setDrawingMode B_OP_INVERT;
						menu#setHighColor ~red:0 ~green:0 ~blue:0 ();
						menu#fillRect itemFrame ();
					 end
			 end
				
	method private getContentSize ~width ~height =
		self#getBitmapSize ~width ~height
			
	method getBitmapSize ~width ~height =
		let r = m_bitmap#bounds ()
		in
		width  := (r#width  ()) +. 4.;
		height := (r#height ()) +. 4.;
end
