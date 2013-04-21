#include <View.h>

#include "memory.h"
#include "mlvalues.h"

class OView : public Glue, public BView {
		public :
				OView(value objet, BRect frame, const char *name, uint32 resizingMode, uint32 flags);
				void Draw(BRect updateRect);
				void MessageReceived(BMessage *message);
				void MouseDown(BPoint where);
				virtual void MouseMoved(BPoint where, uint32 code, const BMessage *a_message);
				
#ifdef __HAIKU__	
				 void InvalidLayout(bool);
				 BSize MinSize(void);
				 BSize MaxSize(void);
 				 BSize PreferredSize(void);
 				 BAlignment LayoutAlignment(void);
 				 void SetLayout(BLayout *layout);
 				 void InvalidateLayout(bool descendants);
				 void DoLayout();
 				 bool HasHeightForWidth(void);
				 bool GetToolTipAt(BPoint point, BToolTip** _tip);
#endif
};

