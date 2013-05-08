
#include "mlvalues.h"
#include "alloc.h"
#include "memory.h"

#include <PrintJob.h>

extern "C" {
	value b_printJob_printJob(value name);
	value b_printJob_beginJob(value printJob);
	value b_printJob_canContinue(value printJob);
	value b_printJob_commitJob(value printJob);
	value b_printJob_configPage(value printJob);
	value b_printJob_drawView(value printJob, value view, value rect, value point);
	value b_printJob_printableRect(value printJob);
	value b_printJob_settings(value printJob);
	value b_printJob_setSettings(value printJob, value configuration);
	value b_printJob_spoolPage(value printJob);
}

//*********************
value b_printJob_printJob(value name){
	CAMLparam1(name);
	CAMLlocal1(printJob);

	printJob = alloc(1, Abstract_tag);
	Store_field(printJob,0, (value)new BPrintJob(String_val(name)));

	CAMLreturn(printJob);
}

//*****************************
value b_printJob_beginJob(value printJob){
	CAMLparam1(printJob);
	
	CAMLreturn(Val_bool( ((BPrintJob *)Field(printJob, 0))->CanContinue() ));
}

//*****************************
value b_printJob_canContinue(value printJob){
	CAMLparam1(printJob);

	((BPrintJob *)Field(printJob, 0))->BeginJob();
	
	CAMLreturn(Val_unit);
}

//*****************************
value b_printJob_commitJob(value printJob){
	CAMLparam1(printJob);

	((BPrintJob *)Field(printJob, 0))->CommitJob();
	
	CAMLreturn(Val_unit);
}
	
//*****************************
value b_printJob_configPage(value printJob){
	CAMLparam1(printJob);

	CAMLreturn(copy_int32(((BPrintJob *)Field(printJob, 0))->ConfigPage()));
}
	

//***************************
value b_printJob_drawView(value printJob, value view, value rect, value point){
	CAMLparam4(printJob, view, rect, point);

	((BPrintJob *)Field(printJob, 0))->DrawView((BView *)Field(view,0), *(BRect *)Field(rect,0), *(BPoint *)Field(point,0));
	
	CAMLreturn(Val_unit);	
}

//*****************************
value b_printJob_printableRect(value printJob){
	CAMLparam1(printJob);
	CAMLlocal1(rect);
	BRect *rect_c = new BRect(((BPrintJob *)Field(printJob, 0))->PrintableRect());
	
	rect = alloc(1, Abstract_tag);
	Store_field(rect, 0, (value)&rect_c);
	
	CAMLreturn(rect);
}

//****************************
value b_printJob_setSettings(value printJob, value configuration){
	CAMLparam2(printJob, configuration);

	((BPrintJob *)Field(printJob, 0))->SetSettings((BMessage *)Field(configuration, 0));

	CAMLreturn(Val_unit);
}

//****************************
value b_printJob_settings(value printJob){
	CAMLparam1(printJob);
	CAMLlocal1(message);

	message = alloc(1, Abstract_tag);
	Store_field(message, 0, (value)((BPrintJob *)Field(printJob, 0))->Settings());

	CAMLreturn(message);
}

//*****************************
value b_printJob_spoolPage(value printJob){
	CAMLparam1(printJob);

	((BPrintJob *)Field(printJob, 0))->SpoolPage();
	
	CAMLreturn(Val_unit);
}
