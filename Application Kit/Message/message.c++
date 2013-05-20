#include <stdio.h>


#include "alloc.h"
#include "mlvalues.h"
#include "memory.h"
#include "signals.h"
#include "threads.h"

#include "glue.h"
#include "message.h"

extern "C" 
{
 extern sem_id ocaml_sem;
 value b_message_message(value unit);
 value b_message_message_command(value self, value command);
 value b_message_message_message(value self, value message);
 value b_message_();
 value b_message_countNames();
 value b_message_addSpecifier_message();
 value b_message_addSpecifier_range();
 value b_message_addSpecifier_index();
 value b_message_addSpecifier_name();
 value b_message_addSpecifier_property();
 value b_message_addFlat();
 value b_message_addPointer(value message, value name, value pointer);
 value b_message_addMessenger();
 value b_message_addMessage();
 value b_message_addRef();
 value b_message_addRect();
 value b_message_addPoint();
 value b_message_addString_string();
 value b_message_addString_be_string();
 value b_message_addDouble();
 value b_message_addfloat();
 value b_message_addInt64();
 value b_message_addInt32(value message, value name, value anInt32);
 value b_message_addInt16(value message, value name, value anInt16);
 value b_message_addInt8();
 value b_message_addBool();
/* value b_message_addData(); */
 value b_message_addSpecifier_message();
 value b_message_addSpecifier_range();
 value b_message_countNames();
 value b_message_findInt16(value message, value name, value int16);
 value b_message_findInt16_index(value message, value name, value index, value int16);
 value b_message_findInt32(value message, value name, value int32);
 value b_message_findInt32_index(value message, value name, value index, value int32);
 value b_message_findPointer(value message, value name, value pointer);
 value b_message_findString(value message, value name, value string);
 value b_message_printToStream(value message);
 value b_message_what (value message);
}

OMessage::OMessage(value self) :
	BMessage(), Glue(self) 
{
}

OMessage::OMessage(value self, uint32 command) :
	BMessage(command), Glue(self) 
{
}
/*
OMessage::OMessage(BMessage *message) :
	BMessage(*message), Glue(Val_unit)
{
}
*/
OMessage::OMessage(value self, BMessage *message) :
	BMessage(*message), Glue(self) 
{
}

//------

value b_message_message(value ocaml_objet){
	CAMLparam1(ocaml_objet);
	CAMLlocal1(p_omess);
//	register_global_root(&self);
	OMessage *m;
	caml_release_runtime_system();	
		m = new OMessage(ocaml_objet);
	caml_acquire_runtime_system();
	caml_register_global_root(&(m->interne));
	p_omess = alloc(1,Abstract_tag);
	Field(p_omess,0) = (value)m;
	
	CAMLreturn(p_omess);
}

//*********************
value b_message_message_command(value self, value command){
	CAMLparam2(self, command);
	CAMLlocal1(message);
//	register_global_root(&self);
	OMessage *m;
	uint32 c = Int32_val(command);
	caml_release_runtime_system();
		m = new OMessage(self, c);
	caml_acquire_runtime_system();
//	caml_leave_blocking_section();
		message = alloc_small(1,Abstract_tag);
		Field(message,0) = (value)m;
//	caml_enter_blocking_section();
	
	CAMLreturn(message);
}

//*************************
value b_message_message_message(value self, value mess){
	CAMLparam2(self, mess);
	CAMLlocal1(message);
//	register_global_root(&self);
	OMessage *m;
//TODO fonction a revoir	
	m = new OMessage(self, (BMessage *)Field(mess,0)); 
	
//	caml_leave_blocking_section();
		message = caml_copy_int32((int32)m);
//	caml_enter_blocking_section();	
	
	CAMLreturn(message);
}

value b_message_(){}
value b_message_countNames(){}
value b_message_addSpecifier_message(){}
value b_message_addSpecifier_range(){}
value b_message_addSpecifier_index(){}
value b_message_addSpecifier_name(){}
value b_message_addSpecifier_property(){}
value b_message_addFlat(){}

//**********************************
value b_message_addPointer(value message, value name, value pointer){
	CAMLparam3(message, name, pointer);
	CAMLlocal1(caml_status);
	
//	caml_leave_blocking_section();
		caml_status = caml_copy_int32(((BMessage *)Int32_val(message))->BMessage::AddPointer(String_val(name),(void *)Int32_val(pointer)));
//	caml_enter_blocking_section();
	
	CAMLreturn(caml_status);
					
}

value b_message_addMessenger(){}
value b_message_addMessage(){}
value b_message_addRef(){}
value b_message_addRect(){}
value b_message_addPoint(){}

//**************************
value b_message_addString_string(value message, value name, value chaine){
	CAMLparam3(message, name, chaine);
	CAMLlocal1(caml_status);
	
//	caml_leave_blocking_section();
		caml_status = caml_copy_int32(((BMessage *)Int32_val(message))->BMessage::AddString(String_val(name),String_val(chaine)));
//	caml_enter_blocking_section();
	
	CAMLreturn(caml_status);

}


value b_message_addString_be_string(){}
value b_message_addDouble(){}
value b_message_addfloat(){}
value b_message_addInt64(){}

//*******************************
value b_message_addInt32(value message, value name, value anInt32){
	CAMLparam3(message, name, anInt32);
	CAMLlocal1(caml_status);
	OMessage *omessage = (OMessage *)Field(message,0);
	status_t status;
	char *c_name = String_val(name);
	uint32 c_anInt32 = Int32_val(anInt32);

//	caml_leave_blocking_section();
	caml_release_runtime_system();
		status = omessage->AddInt32(c_name, c_anInt32);
	caml_acquire_runtime_system();

	caml_status =caml_copy_int32(status);
//	caml_enter_blocking_section();
	
	CAMLreturn(caml_status);
}


//***************************
value b_message_findInt16(value message, value name, value anint16) {
	CAMLparam3(message, name, anint16);
	int status;
	int16 int_found;
	
//	caml_leave_blocking_section();
	status = caml_copy_int32(
					((BMessage *)Int32_val(message))
					->FindInt16(String_val(name), 
							    &int_found));
	
	Store_field(anint16, 0, Val_int(int_found));
//	caml_enter_blocking_section();
	
	CAMLreturn(status);
}

//***************************
value b_message_findInt16_index(value message, value name, value index, value anint16) {
	CAMLparam4(message, name, index, anint16);
	int status;
	int16 int_found;
	
//	caml_leave_blocking_section();
	status = caml_copy_int32(
					((BMessage *)Int32_val(message))
					->FindInt16(String_val(name), 
								Int_val(index),
							    &int_found
							   )
					); 
	Store_field(anint16, 0, Val_int(int_found));
//	caml_enter_blocking_section();
	
	CAMLreturn(status);
}

//***************************
value b_message_findInt32(value message, value name, value anint32) {
	CAMLparam3(message, name, anint32);
	CAMLlocal1(ostatus);

	status_t status;
	int32 int_found;
	char *s = String_val(name);
	
	OMessage *omessage = (OMessage *)Field(message,0);

//	caml_leave_blocking_section();
	caml_release_runtime_system();
		status = omessage->FindInt32(s, &int_found); 
		Store_field(anint32, 0, caml_copy_int32(int_found));
		ostatus = caml_copy_int32(status);
	caml_acquire_runtime_system();
//	caml_enter_blocking_section();
	
	CAMLreturn(ostatus);
}

//***************************
value b_message_findInt32_index(value message, value name, value index, value anint32) {
	CAMLparam4(message, name, index, anint32);
	int status;
	int32 int_found;
	char * s = String_val(name);
	
//	caml_leave_blocking_section();
	status = caml_copy_int32(
					((BMessage *)Int32_val(message))
					->FindInt32(s, 
								Int_val(index),
							    &int_found
							   )
					); 
	Store_field(anint32, 0, copy_int32(int_found));
//	caml_enter_blocking_section();
	
	CAMLreturn(status);
}

//**************************** 
value b_message_findPointer(value message, value name, value pointer){
	CAMLparam3(message, name, pointer);
	CAMLlocal1(caml_status);
	
	status_t status;
	void **pointer_found;
	BMessage *m = ((BMessage *)Int32_val(message));
	char *st = String_val(name);

	status = ((BMessage *)Int32_val(message))->FindPointer(String_val(name), 
															pointer_found
														   ); 
	 caml_leave_blocking_section();
		Store_field(pointer, 0, copy_int32((value)*pointer_found));
		caml_status = caml_copy_int32(status);
	caml_enter_blocking_section();
	
	CAMLreturn(caml_status);
}

//****************************
value b_message_findString(value message, value name, value string){
	CAMLparam3(message, name, string);
	CAMLlocal1(caml_status);
	
	int status;
	const char *string_found;
	caml_leave_blocking_section();
		caml_status = caml_copy_int32(
						((BMessage *)Int32_val(message))
						->FindString(String_val(name), 
								     &string_found
									)
						); 
		Store_field(string, 0, copy_string(string_found));
	caml_enter_blocking_section();
	
	CAMLreturn(status);
}

//*******************************
value b_message_addInt16(value message, value name, value anInt16){
	CAMLparam3(message, name, anInt16);
	CAMLlocal1(caml_status);
	
	caml_leave_blocking_section();
	
	caml_status = caml_copy_int32(
		((BMessage *)Int32_val(message))->
			AddInt16(String_val(name), 
					 Int_val(anInt16)));

	caml_enter_blocking_section();

	CAMLreturn(caml_status);
}


value b_message_addInt8(){}
value b_message_addBool(){}
//value b_message_addData(){}

//***********************************
value b_message_printToStream(value message) {
	CAMLparam1(message);

	((BMessage *)Int32_val(message))->PrintToStream();
	
	CAMLreturn(Val_unit);

}

value b_message_what(value p_message) {
	CAMLparam1(p_message);
	CAMLlocal1(caml_res);
	//BMessage *m = new BMessage( *(BMessage *)(Int32_val(message)));
//	caml_leave_blocking_section();
	OMessage *m = (OMessage*)Field(p_message,0);
	
	caml_res = caml_copy_int32(m->what);
//	caml_enter_blocking_section();
	CAMLreturn(caml_res);
}
