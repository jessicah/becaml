#include <Archivable.h>
#define BEOS

#include "alloc.h"
#include "memory.h"

extern "C" 
{
// value alloc (mlsize_t, tag_t); 
 value b_archivable0(value u);
 value b_archivable1(value archive); //archive est un BMessage
 value b_archivable_(value archivable);
 value b_archive(value archivable, value archive, value deep); //archive est un BMessage
 value b_instantiate(value archive); // archive est un BMessage
 
}


value b_archivable0(value unit) 
{
 CAMLparam1(unit);
 CAMLlocal1(archivable);
 
 archivable = alloc(1, Abstract_tag); 
 Store_field(archivable,0 , (value) new BArchivable());
 
 CAMLreturn(archivable);
}

value b_archivable1(value archive) 
{
 CAMLparam1(archive);
 CAMLlocal1(archivable);
 
 archivable = alloc(1, Abstract_tag);
 Store_field(archivable,0 , (value) new BArchivable ((BMessage *)Field(archive,1)));
 
 CAMLreturn(archivable);
}

value b_archivable_(value archivable)
{
 CAMLparam1(archivable);
 
 ((BArchivable *)Field(archivable,1))->~BArchivable();
 
 CAMLreturn(Val_unit);
}

value b_archive(value archivable, value archive, value deep)
{
 CAMLparam3(archivable, archive, deep);
 CAMLlocal1(status);
 
 status = alloc(1, Abstract_tag);
 Store_field(status, 1, ((BArchivable *)Field(archivable, 1))->Archive((BMessage *)(Field(archive,1)), Bool_val(deep)));

 CAMLreturn(status);
}

value b_instantiate(value archive)
{
 CAMLparam1(archive);
 CAMLlocal1(archivable);
 
 archivable = alloc(1, Abstract_tag);
 Store_field(archivable,0, (value)BArchivable::Instantiate((BMessage *)(Int32_val(archive))));

 CAMLreturn(archivable);
}
