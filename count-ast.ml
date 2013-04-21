(*  Copyright 2006-2007, Hendrik Tews, All rights reserved.            *)
(*  See file license.txt for terms of use                              *)
(***********************************************************************)

(* 
 * This program prints useless messages like
 * 
 *     ../elsa/astgen.oast contains 264861 ast nodes with in total:
 * 	    140171 source locations
 * 	    16350 booleans 
 * 	    280342 integers
 * 	    62556 native integers
 * 	    140171 strings
 *     maximal node id: 264861
 *     all node ids from 1 to 264861 present
 * 
 * The main purpose here is to have a simple example for doing something 
 * with a C++ abstract syntax tree.
 * 
 * This is the recursive variant. It uses straightforward tree recursion.
 *)

open Cc_ast_gen_type
open Ml_ctype
open Ast_annotation
open Ast_util


module DS = Dense_set

let visited_nodes = DS.make ()

let count_nodes = ref 0

let max_node_id = ref 0

let visited (annot : annotated) =
  DS.mem (id_annotation annot) visited_nodes

let visit (annot : annotated) =
  (* Printf.eprintf "visit node %d\n%!" (id_annotation annot); *)
  DS.add (id_annotation annot) visited_nodes;
  incr count_nodes;
  if id_annotation annot > !max_node_id then
    max_node_id := id_annotation annot


(**************************************************************************
 *
 * contents of astiter.ml
 *
 **************************************************************************)


(* let annotation_fun ((id, c_addr) : int * int) = () *)

let opt_iter f = function
  | None -> ()
  | Some x -> f x

let count_bool = ref 0
let bool_fun (_b : bool) = incr count_bool

let count_int = ref 0
let int_fun (_i : int) = 
  (* Printf.eprintf "COUNT_INT\n%!"; *)
  incr count_int

let count_nativeint = ref 0
let nativeint_fun (_i : nativeint) = incr count_nativeint

let count_string = ref 0
let string_fun (_s : string) = 
  (* Printf.eprintf "STRING\n%!"; *)
  incr count_string

let count_sourceLoc = ref 0
let sourceLoc_fun((_file : string), (_line : int), (_char : int)) = 
  incr count_sourceLoc;
  (* Printf.eprintf "STRING\n%!"; *)
  incr count_string;
  incr count_int;
  incr count_int

(* 
 * let declFlags_fun(l : declFlag list) = ()
 * 
 * let simpleTypeId_fun(id : simpleTypeId) = ()
 * 
 * let typeIntr_fun(keyword : typeIntr) = ()
 * 
 * let accessKeyword_fun(keyword : accessKeyword) = ()
 * 
 * let cVFlags_fun(fl : cVFlag list) = ()
 * 
 * let overloadableOp_fun(op :overloadableOp) = ()
 * 
 * let unaryOp_fun(op : unaryOp) = ()
 * 
 * let effectOp_fun(op : effectOp) = ()
 * 
 * let binaryOp_fun(op : binaryOp) = ()
 * 
 * let castKeyword_fun(keyword : castKeyword) = ()
 * 
 * let function_flags_fun(flags : function_flags) = ()
 * 
 * let declaratorContext_fun(context : declaratorContext) = ()
 * 
 * let scopeKind_fun(sk : scopeKind) = ()
 * 
 * 
 * let array_size_fun = function
 *   | NO_SIZE -> ()
 *   | DYN_SIZE -> ()
 *   | FIXED_SIZE(int) -> int_fun int
 * 
 * let compoundType_Keyword_fun = function
 *   | K_STRUCT -> ()
 *   | K_CLASS -> ()
 *   | K_UNION -> ()
 *)


(***************** variable ***************************)

let rec variable_fun(v : annotated variable) =
  (* unused record copy to provoke compilation errors for new fields *)
  let _dummy = {			
    poly_var = v.poly_var; loc = v.loc; var_name = v.var_name;
    var_type = v.var_type; flags = v.flags; value = v.value;
    defaultParam = v.defaultParam; funcDefn = v.funcDefn;
    overload = v.overload; virtuallyOverride = v.virtuallyOverride;
    scope = v.scope; templ_info = v.templ_info;
  }
  in
  let annot = variable_annotation v
  in
    if visited annot then ()
    else begin
      visit annot;

      sourceLoc_fun v.loc;
      opt_iter string_fun v.var_name;

      (* POSSIBLY CIRCULAR *)
      opt_iter cType_fun !(v.var_type);
      (* POSSIBLY CIRCULAR *)
      opt_iter expression_fun !(v.value);
      opt_iter cType_fun v.defaultParam;

      (* POSSIBLY CIRCULAR *)
      opt_iter func_fun !(v.funcDefn);
      (* POSSIBLY CIRCULAR *)
      (List.iter variable_fun) !(v.overload);
      List.iter variable_fun v.virtuallyOverride;
      opt_iter scope_fun v.scope;
      opt_iter templ_info_fun v.templ_info;
    end

(**************** templateInfo ************************)

and templ_info_fun ti =
  (* unused record copy to provoke compilation errors for new fields *)
  let _dummy = {
    poly_templ = ti.poly_templ; templ_kind = ti.templ_kind;
    template_params = ti.template_params;
    template_var = ti.template_var; inherited_params = ti.inherited_params; 
    instantiation_of = ti.instantiation_of; 
    instantiations = ti.instantiations; 
    specialization_of = ti.specialization_of; 
    specializations = ti.specializations; arguments = ti.arguments; 
    inst_loc = ti.inst_loc; 
    partial_instantiation_of = ti.partial_instantiation_of; 
    partial_instantiations = ti.partial_instantiations; 
    arguments_to_primary = ti.arguments_to_primary; 
    defn_scope = ti.defn_scope; 
    definition_template_info = ti.definition_template_info; 
    instantiate_body = ti.instantiate_body; 
    instantiation_disallowed = ti.instantiation_disallowed; 
    uninstantiated_default_args = ti.uninstantiated_default_args; 
    dependent_bases = ti.dependent_bases;
  }
  in
  let annot = templ_info_annotation ti
  in
    if visited annot then ()
    else begin
      visit annot;

      List.iter variable_fun ti.template_params;

      (* POSSIBLY CIRCULAR *)
      opt_iter variable_fun !(ti.template_var);
      List.iter inherited_templ_params_fun ti.inherited_params;

      (* POSSIBLY CIRCULAR *)
      opt_iter variable_fun !(ti.instantiation_of);
      List.iter variable_fun ti.instantiations;

      (* POSSIBLY CIRCULAR *)
      opt_iter variable_fun !(ti.specialization_of);
      List.iter variable_fun ti.specializations;
      List.iter sTemplateArgument_fun ti.arguments;
      sourceLoc_fun ti.inst_loc;

      (* POSSIBLY CIRCULAR *)
      opt_iter variable_fun !(ti.partial_instantiation_of);
      List.iter variable_fun ti.partial_instantiations;
      List.iter sTemplateArgument_fun ti.arguments_to_primary;
      opt_iter scope_fun ti.defn_scope;
      opt_iter templ_info_fun ti.definition_template_info;
      bool_fun ti.instantiate_body;
      bool_fun ti.instantiation_disallowed;
      int_fun ti.uninstantiated_default_args;
      List.iter cType_fun ti.dependent_bases;
    end

(************* inheritedTemplateParams ****************)

and inherited_templ_params_fun itp =
  (* unused record copy to provoke compilation errors for new fields *)
  let _dummy = {
    poly_inherited_templ = itp.poly_inherited_templ;
    inherited_template_params = itp.inherited_template_params;
    enclosing = itp.enclosing;
  }
  in
  let annot = inherited_templ_params_annotation itp
  in
    if visited annot then ()
    else begin
      assert(!(itp.enclosing) <> None);

      visit annot;

      List.iter variable_fun itp.inherited_template_params;

      (* POSSIBLY CIRCULAR *)
      opt_iter compound_info_fun !(itp.enclosing);
    end

(***************** cType ******************************)

and baseClass_fun baseClass =
  (* unused record copy to provoke compilation errors for new fields *)
  let _dummy = {
    poly_base = baseClass.poly_base; compound = baseClass.compound;
    bc_access = baseClass.bc_access; is_virtual = baseClass.is_virtual
  }
  in
  let annot = baseClass_annotation baseClass
  in
    if visited annot then ()
    else begin
	visit annot;
      compound_info_fun baseClass.compound;
      bool_fun baseClass.is_virtual
    end


and compound_info_fun i = 
  (* unused record copy to provoke compilation errors for new fields *)
  let _dummy = {
    compound_info_poly = i.compound_info_poly;
    compound_name = i.compound_name; typedef_var = i.typedef_var;
    ci_access = i.ci_access; compound_scope = i.compound_scope;
    is_forward_decl = i.is_forward_decl;
    is_transparent_union = i.is_transparent_union; keyword = i.keyword;
    data_members = i.data_members; bases = i.bases;
    conversion_operators = i.conversion_operators;
    friends = i.friends; inst_name = i.inst_name; syntax = i.syntax;
    self_type = i.self_type;
  }
  in
  let annot = compound_info_annotation i
  in
    if visited annot then ()
    else begin
      visit annot;
      assert(match !(i.syntax) with
	       | None
	       | Some(TS_classSpec _) -> true
	       | _ -> false);
      opt_iter string_fun i.compound_name;
      variable_fun i.typedef_var;
      scope_fun i.compound_scope;
      bool_fun i.is_forward_decl;
      bool_fun i.is_transparent_union;
      List.iter variable_fun i.data_members;
      List.iter baseClass_fun i.bases;
      List.iter variable_fun i.conversion_operators;
      List.iter variable_fun i.friends;
      opt_iter typeSpecifier_fun !(i.syntax);

      (* POSSIBLY CIRCULAR *)
      opt_iter string_fun i.inst_name;

      (* POSSIBLY CIRCULAR *)
      opt_iter cType_fun !(i.self_type)
    end


and enum_value_fun(annot, string, nativeint) =
  if visited annot then ()
  else begin
    visit annot;
    string_fun string;
    nativeint_fun nativeint;
  end


and atomicType_fun x = 
  let annot = atomicType_annotation x
  in
    if visited annot then ()
    else match x with
	(*
	 * put calls to visit here before in each case, except for CompoundType
	 *)

      | SimpleType(annot, _simpleTypeId) ->
	  visit annot;

      | CompoundType(compound_info) ->
	  compound_info_fun compound_info

      | PseudoInstantiation(annot, str, variable_opt, _accessKeyword, 
			    compound_info, sTemplateArgument_list) ->
	  visit annot;
	  string_fun str;
	  opt_iter variable_fun variable_opt;
	  compound_info_fun compound_info;
	  List.iter sTemplateArgument_fun sTemplateArgument_list

      | EnumType(annot, string, variable, _accessKeyword, 
		 enum_value_list, has_negatives) ->
	  visit annot;
	  opt_iter string_fun string;
	  opt_iter variable_fun variable;
	  List.iter enum_value_fun enum_value_list;
	  bool_fun has_negatives

      | TypeVariable(annot, string, variable, _accessKeyword) ->
	  visit annot;
	  string_fun string;
	  variable_fun variable;

      | DependentQType(annot, string, variable, 
		      _accessKeyword, atomic, pq_name) ->
	  visit annot;
	  string_fun string;
	  variable_fun variable;
	  atomicType_fun atomic;
	  pQName_fun pq_name
	    


and cType_fun x = 
  let annot = cType_annotation x
  in
    if visited annot then ()
    else
      let _ = visit annot 
      in match x with
      | CVAtomicType(_annot, _cVFlags, atomicType) ->
	  atomicType_fun atomicType

      | PointerType(_annot, _cVFlags, cType) ->
	  cType_fun cType

      | ReferenceType(_annot, cType) ->
	  cType_fun cType

      | FunctionType(_annot, _function_flags, cType, 
		     variable_list, cType_list_opt) ->
	  cType_fun cType;
	  List.iter variable_fun variable_list;
	  opt_iter (List.iter cType_fun) cType_list_opt

      | ArrayType(_annot, cType, _array_size) ->
	  cType_fun cType;

      | PointerToMemberType(_annot, atomicType (* = NamedAtomicType *), 
			    _cVFlags, cType) ->
	  assert(match atomicType with 
		   | SimpleType _ -> false
		   | CompoundType _
		   | PseudoInstantiation _
		   | EnumType _
		   | TypeVariable _ 
		   | DependentQType _ -> true);
	  atomicType_fun atomicType;
	  cType_fun cType


and sTemplateArgument_fun ta = 
  let annot = sTemplateArgument_annotation ta
  in
    if visited annot then ()
    else 
      let _ = visit annot 
      in match ta with
	| STA_NONE _annot -> 
	    ()

	| STA_TYPE(_annot, cType) -> 
	    cType_fun cType

	| STA_INT(_annot, int) -> 
	    int_fun int

	| STA_ENUMERATOR(_annot, variable) -> 
	    variable_fun variable

	| STA_REFERENCE(_annot, variable) -> 
	    variable_fun variable

	| STA_POINTER(_annot, variable) -> 
	    variable_fun variable

	| STA_MEMBER(_annot, variable) -> 
	    variable_fun variable

	| STA_DEPEXPR(_annot, expression) -> 
	    expression_fun expression

	| STA_TEMPLATE _annot -> 
	    ()

	| STA_ATOMIC(_annot, atomicType) -> 
	    atomicType_fun atomicType


and scope_fun s = 
  (* unused record copy to provoke compilation errors for new fields *)
  let _dummy = {
    poly_scope = s.poly_scope; variables = s.variables; 
    type_tags = s.type_tags; parent_scope = s.parent_scope;
    scope_kind = s.scope_kind; namespace_var = s.namespace_var;
    scope_template_params = s.scope_template_params; 
    parameterized_entity = s.parameterized_entity
  }
  in
  let annot = scope_annotation s
  in
    if visited annot then ()
    else begin
      visit annot;
      Hashtbl.iter 
	(fun str var -> string_fun str; variable_fun var)
	s.variables;
      Hashtbl.iter
	(fun str var -> string_fun str; variable_fun var)
	s.type_tags;
      opt_iter scope_fun s.parent_scope;
      opt_iter variable_fun !(s.namespace_var);
      List.iter variable_fun s.scope_template_params;
      opt_iter variable_fun s.parameterized_entity;
    end
	


(***************** generated ast nodes ****************)

and translationUnit_fun 
    ((annot, topForm_list, scope_opt)  : annotated translationUnit_type) =
  if visited annot then ()
  else begin
    visit annot;
    List.iter topForm_fun topForm_list;
    opt_iter scope_fun scope_opt      
  end


and topForm_fun x = 
  let annot = topForm_annotation x
  in
    if visited annot then ()
    else
      let _ = visit annot 
      in match x with
	| TF_decl(_annot, sourceLoc, declaration) -> 
	    sourceLoc_fun sourceLoc;
	    declaration_fun declaration

	| TF_func(_annot, sourceLoc, func) -> 
	    sourceLoc_fun sourceLoc;
	    func_fun func

	| TF_template(_annot, sourceLoc, templateDeclaration) -> 
	    sourceLoc_fun sourceLoc;
	    templateDeclaration_fun templateDeclaration

	| TF_explicitInst(_annot, sourceLoc, _declFlags, declaration) -> 
	    sourceLoc_fun sourceLoc;
	    declaration_fun declaration

	| TF_linkage(_annot, sourceLoc, stringRef, translationUnit) -> 
	    sourceLoc_fun sourceLoc;
	    string_fun stringRef;
	    translationUnit_fun translationUnit

	| TF_one_linkage(_annot, sourceLoc, stringRef, topForm) -> 
	    sourceLoc_fun sourceLoc;
	    string_fun stringRef;
	    topForm_fun topForm

	| TF_asm(_annot, sourceLoc, e_stringLit) -> 
	    assert(match e_stringLit with | E_stringLit _ -> true | _ -> false);
	    sourceLoc_fun sourceLoc;
	    expression_fun e_stringLit

	| TF_namespaceDefn(_annot, sourceLoc, stringRef_opt, topForm_list) -> 
	    sourceLoc_fun sourceLoc;
	    opt_iter string_fun stringRef_opt;
	    List.iter topForm_fun topForm_list

	| TF_namespaceDecl(_annot, sourceLoc, namespaceDecl) -> 
	    sourceLoc_fun sourceLoc;
	    namespaceDecl_fun namespaceDecl



and func_fun((annot, _declFlags, typeSpecifier, declarator, memberInit_list, 
	     s_compound_opt, handler_list, func, variable_opt_1, 
	     variable_opt_2, statement_opt, bool) ) =

  if visited annot then ()
  else begin
    assert(match s_compound_opt with
	     | None -> true
	     | Some s_compound ->
		 match s_compound with 
		   | S_compound _ -> true 
		   | _ -> false);
    assert(match func with 
      | FunctionType _ -> true
      | _ -> false);
    visit annot;
    typeSpecifier_fun typeSpecifier;
    declarator_fun declarator;
    List.iter memberInit_fun memberInit_list;
    opt_iter statement_fun s_compound_opt;
    List.iter handler_fun handler_list;
    cType_fun func;
    opt_iter variable_fun variable_opt_1;
    opt_iter variable_fun variable_opt_2;
    opt_iter statement_fun statement_opt;
    bool_fun bool
  end


and memberInit_fun((annot, pQName, argExpression_list, 
		   variable_opt_1, compound_opt, variable_opt_2, 
		   full_expr_annot, statement_opt) ) =

  if visited annot then ()
  else begin
      assert(match compound_opt with
	| None
	| Some(CompoundType _) -> true
	| _ -> false);
    visit annot;
    pQName_fun pQName;
    List.iter argExpression_fun argExpression_list;
    opt_iter variable_fun variable_opt_1;
    opt_iter atomicType_fun compound_opt;
    opt_iter variable_fun variable_opt_2;
    fullExpressionAnnot_fun full_expr_annot;
    opt_iter statement_fun statement_opt
  end


and declaration_fun((annot, _declFlags, typeSpecifier, declarator_list) ) =
  if visited annot then ()
  else begin
    visit annot;
    typeSpecifier_fun typeSpecifier;
    List.iter declarator_fun declarator_list
  end


and aSTTypeId_fun((annot, typeSpecifier, declarator) ) =
  if visited annot then ()
  else begin
    visit annot;
    typeSpecifier_fun typeSpecifier;
    declarator_fun declarator
  end


and pQName_fun x = 
  let annot = pQName_annotation x
  in
    if visited annot then ()
    else
      let _ = visit annot 
      in match x with
	| PQ_qualifier(_annot, sourceLoc, stringRef_opt, 
		       templateArgument_opt, pQName, 
		      variable_opt, s_template_arg_list) -> 
	    sourceLoc_fun sourceLoc;
	    opt_iter string_fun stringRef_opt;
	    opt_iter templateArgument_fun templateArgument_opt;
	    pQName_fun pQName;
	    opt_iter variable_fun variable_opt;
	    List.iter sTemplateArgument_fun s_template_arg_list

	| PQ_name(_annot, sourceLoc, stringRef) -> 
	    sourceLoc_fun sourceLoc;
	    string_fun stringRef

	| PQ_operator(_annot, sourceLoc, operatorName, stringRef) -> 
	    sourceLoc_fun sourceLoc;
	    operatorName_fun operatorName;
	    string_fun stringRef

	| PQ_template(_annot, sourceLoc, stringRef, templateArgument_opt, 
		     s_template_arg_list) -> 
	    sourceLoc_fun sourceLoc;
	    string_fun stringRef;
	    opt_iter templateArgument_fun templateArgument_opt;
	    List.iter sTemplateArgument_fun s_template_arg_list

	| PQ_variable(_annot, sourceLoc, variable) -> 
	    sourceLoc_fun sourceLoc;
	    variable_fun variable



and typeSpecifier_fun x = 
  let annot = typeSpecifier_annotation x
  in
    if visited annot then ()
    else
      let _ = visit annot 
      in match x with
	| TS_name(_annot, sourceLoc, _cVFlags, pQName, bool, 
		 var_opt_1, var_opt_2) -> 
	    sourceLoc_fun sourceLoc;
	    pQName_fun pQName;
	    bool_fun bool;
	    opt_iter variable_fun var_opt_1;
	    opt_iter variable_fun var_opt_2

	| TS_simple(_annot, sourceLoc, _cVFlags, _simpleTypeId) -> 
	    sourceLoc_fun sourceLoc;

	| TS_elaborated(_annot, sourceLoc, _cVFlags, _typeIntr, 
		       pQName, namedAtomicType_opt) -> 
	    assert(match namedAtomicType_opt with
	      | Some(SimpleType _) -> false
	      | _ -> true);
	    sourceLoc_fun sourceLoc;
	    pQName_fun pQName;
	    opt_iter atomicType_fun namedAtomicType_opt

	| TS_classSpec(_annot, sourceLoc, _cVFlags, _typeIntr, pQName_opt, 
		       baseClassSpec_list, memberList, compoundType) -> 
	    assert(match compoundType with
	      | CompoundType _ -> true
	      | _ -> false);
	    sourceLoc_fun sourceLoc;
	    opt_iter pQName_fun pQName_opt;
	    List.iter baseClassSpec_fun baseClassSpec_list;
	    memberList_fun memberList;
	    atomicType_fun compoundType

	| TS_enumSpec(_annot, sourceLoc, _cVFlags, 
		      stringRef_opt, enumerator_list, enumType) -> 
	    assert(match enumType with 
	      | EnumType _ -> true
	      | _ -> false);
	    sourceLoc_fun sourceLoc;
	    opt_iter string_fun stringRef_opt;
	    List.iter enumerator_fun enumerator_list;
	    atomicType_fun enumType

	| TS_type(_annot, sourceLoc, _cVFlags, cType) -> 
	    sourceLoc_fun sourceLoc;
	    cType_fun cType

	| TS_typeof(_annot, sourceLoc, _cVFlags, aSTTypeof) -> 
	    sourceLoc_fun sourceLoc;
	    aSTTypeof_fun aSTTypeof


and baseClassSpec_fun
    ((annot, bool, _accessKeyword, pQName, compoundType_opt) ) =
  if visited annot then ()
  else begin
    assert(match compoundType_opt with
	     | None
	     | Some(CompoundType _ ) -> true
	     | _ -> false);
    visit annot;
    bool_fun bool;
    pQName_fun pQName;
    opt_iter atomicType_fun compoundType_opt
  end


and enumerator_fun((annot, sourceLoc, stringRef, 
		   expression_opt, variable, _int32) ) =
  if visited annot then ()
  else begin
    visit annot;
    sourceLoc_fun sourceLoc;
    string_fun stringRef;
    opt_iter expression_fun expression_opt;
    variable_fun variable;
  end


and memberList_fun((annot, member_list) ) =
  if visited annot then ()
  else begin
    visit annot;
    List.iter member_fun member_list
  end


and member_fun x = 
  let annot = member_annotation x
  in
    if visited annot then ()
    else
      let _ = visit annot 
      in match x with
	| MR_decl(_annot, sourceLoc, declaration) -> 
	    sourceLoc_fun sourceLoc;
	    declaration_fun declaration

	| MR_func(_annot, sourceLoc, func) -> 
	    sourceLoc_fun sourceLoc;
	    func_fun func

	| MR_access(_annot, sourceLoc, _accessKeyword) -> 
	    sourceLoc_fun sourceLoc;

	| MR_usingDecl(_annot, sourceLoc, nd_usingDecl) -> 
	    assert(match nd_usingDecl with ND_usingDecl _ -> true | _ -> false);
	    sourceLoc_fun sourceLoc;
	    namespaceDecl_fun nd_usingDecl

	| MR_template(_annot, sourceLoc, templateDeclaration) -> 
	    sourceLoc_fun sourceLoc;
	    templateDeclaration_fun templateDeclaration


and declarator_fun((annot, iDeclarator, init_opt, 
		   variable_opt, ctype_opt, _declaratorContext,
		   statement_opt_ctor, statement_opt_dtor) ) =
  if visited annot then ()
  else begin
    visit annot;
    iDeclarator_fun iDeclarator;
    opt_iter init_fun init_opt;
    opt_iter variable_fun variable_opt;
    opt_iter cType_fun ctype_opt;
    opt_iter statement_fun statement_opt_ctor;
    opt_iter statement_fun statement_opt_dtor
  end


and iDeclarator_fun x = 
  let annot = iDeclarator_annotation x
  in
    if visited annot then ()
    else
      let _ = visit annot 
      in match x with
	| D_name(_annot, sourceLoc, pQName_opt) -> 
	    sourceLoc_fun sourceLoc;
	    opt_iter pQName_fun pQName_opt

	| D_pointer(_annot, sourceLoc, _cVFlags, iDeclarator) -> 
	    sourceLoc_fun sourceLoc;
	    iDeclarator_fun iDeclarator

	| D_reference(_annot, sourceLoc, iDeclarator) -> 
	    sourceLoc_fun sourceLoc;
	    iDeclarator_fun iDeclarator

	| D_func(_annot, sourceLoc, iDeclarator, aSTTypeId_list, _cVFlags, 
		 exceptionSpec_opt, pq_name_list, bool) -> 
	    assert(List.for_all (function | PQ_name _ -> true | _ -> false) 
		     pq_name_list);
	    sourceLoc_fun sourceLoc;
	    iDeclarator_fun iDeclarator;
	    List.iter aSTTypeId_fun aSTTypeId_list;
	    opt_iter exceptionSpec_fun exceptionSpec_opt;
	    List.iter pQName_fun pq_name_list;
	    bool_fun bool

	| D_array(_annot, sourceLoc, iDeclarator, expression_opt, bool) -> 
	    sourceLoc_fun sourceLoc;
	    iDeclarator_fun iDeclarator;
	    opt_iter expression_fun expression_opt;
	    bool_fun bool

	| D_bitfield(_annot, sourceLoc, pQName_opt, expression, int) -> 
	    sourceLoc_fun sourceLoc;
	    opt_iter pQName_fun pQName_opt;
	    expression_fun expression;
	    int_fun int

	| D_ptrToMember(_annot, sourceLoc, pQName, _cVFlags, iDeclarator) -> 
	    sourceLoc_fun sourceLoc;
	    pQName_fun pQName;
	    iDeclarator_fun iDeclarator

	| D_grouping(_annot, sourceLoc, iDeclarator) -> 
	    sourceLoc_fun sourceLoc;
	    iDeclarator_fun iDeclarator

	| D_attribute(_annot, sourceLoc, iDeclarator, attribute_list_list) ->
	    sourceLoc_fun sourceLoc;
	    iDeclarator_fun iDeclarator;
	    List.iter (List.iter attribute_fun) attribute_list_list



and exceptionSpec_fun((annot, aSTTypeId_list) ) =
  if visited annot then ()
  else begin
    visit annot;
    List.iter aSTTypeId_fun aSTTypeId_list
  end


and operatorName_fun x = 
  let annot = operatorName_annotation x
  in
    if visited annot then ()
    else
      let _ = visit annot 
      in match x with
	| ON_newDel(_annot, bool_is_new, bool_is_array) -> 
	    bool_fun bool_is_new;
	    bool_fun bool_is_array

	| ON_operator(_annot, _overloadableOp) -> 
	    ()

	| ON_conversion(_annot, aSTTypeId) -> 
	    aSTTypeId_fun aSTTypeId


and statement_fun x = 
  let annot = statement_annotation x
  in
    if visited annot then ()
    else
      let _ = visit annot 
      in match x with
	| S_skip(_annot, sourceLoc) -> 
	    sourceLoc_fun sourceLoc

	| S_label(_annot, sourceLoc, stringRef, statement) -> 
	    sourceLoc_fun sourceLoc;
	    string_fun stringRef;
	    statement_fun statement

	| S_case(_annot, sourceLoc, expression, statement, _int32) -> 
	    sourceLoc_fun sourceLoc;
	    expression_fun expression;
	    statement_fun statement

	| S_default(_annot, sourceLoc, statement) -> 
	    sourceLoc_fun sourceLoc;
	    statement_fun statement

	| S_expr(_annot, sourceLoc, fullExpression) -> 
	    sourceLoc_fun sourceLoc;
	    fullExpression_fun fullExpression

	| S_compound(_annot, sourceLoc, statement_list) -> 
	    sourceLoc_fun sourceLoc;
	    List.iter statement_fun statement_list

	| S_if(_annot, sourceLoc, condition, statement_then, statement_else) -> 
	    sourceLoc_fun sourceLoc;
	    condition_fun condition;
	    statement_fun statement_then;
	    statement_fun statement_else

	| S_switch(_annot, sourceLoc, condition, statement) -> 
	    sourceLoc_fun sourceLoc;
	    condition_fun condition;
	    statement_fun statement

	| S_while(_annot, sourceLoc, condition, statement) -> 
	    sourceLoc_fun sourceLoc;
	    condition_fun condition;
	    statement_fun statement

	| S_doWhile(_annot, sourceLoc, statement, fullExpression) -> 
	    sourceLoc_fun sourceLoc;
	    statement_fun statement;
	    fullExpression_fun fullExpression

	| S_for(_annot, sourceLoc, statement_init, condition, fullExpression, 
		statement_body) -> 
	    sourceLoc_fun sourceLoc;
	    statement_fun statement_init;
	    condition_fun condition;
	    fullExpression_fun fullExpression;
	    statement_fun statement_body

	| S_break(_annot, sourceLoc) -> 
	    sourceLoc_fun sourceLoc

	| S_continue(_annot, sourceLoc) -> 
	    sourceLoc_fun sourceLoc

	| S_return(_annot, sourceLoc, fullExpression_opt, statement_opt) -> 
	    sourceLoc_fun sourceLoc;
	    opt_iter fullExpression_fun fullExpression_opt;
	    opt_iter statement_fun statement_opt

	| S_goto(_annot, sourceLoc, stringRef) -> 
	    sourceLoc_fun sourceLoc;
	    string_fun stringRef

	| S_decl(_annot, sourceLoc, declaration) -> 
	    sourceLoc_fun sourceLoc;
	    declaration_fun declaration

	| S_try(_annot, sourceLoc, statement, handler_list) -> 
	    sourceLoc_fun sourceLoc;
	    statement_fun statement;
	    List.iter handler_fun handler_list

	| S_asm(_annot, sourceLoc, e_stringLit) -> 
	    assert(match e_stringLit with | E_stringLit _ -> true | _ -> false);
	    sourceLoc_fun sourceLoc;
	    expression_fun e_stringLit

	| S_namespaceDecl(_annot, sourceLoc, namespaceDecl) -> 
	    sourceLoc_fun sourceLoc;
	    namespaceDecl_fun namespaceDecl

	| S_function(_annot, sourceLoc, func) -> 
	    sourceLoc_fun sourceLoc;
	    func_fun func

	| S_rangeCase(_annot, sourceLoc, 
		      expression_lo, expression_hi, statement, 
		     label_lo, label_hi) -> 
	    sourceLoc_fun sourceLoc;
	    expression_fun expression_lo;
	    expression_fun expression_hi;
	    statement_fun statement;
	    int_fun label_lo;
	    int_fun label_hi

	| S_computedGoto(_annot, sourceLoc, expression) -> 
	    sourceLoc_fun sourceLoc;
	    expression_fun expression


and condition_fun x = 
  let annot = condition_annotation x
  in
    if visited annot then ()
    else
      let _ = visit annot 
      in match x with
	| CN_expr(_annot, fullExpression) -> 
	    fullExpression_fun fullExpression

	| CN_decl(_annot, aSTTypeId) -> 
	    aSTTypeId_fun aSTTypeId


and handler_fun((annot, aSTTypeId, statement_body, variable_opt, 
		fullExpressionAnnot, expression_opt, statement_gdtor) ) =
  if visited annot then ()
  else begin
    visit annot;
    aSTTypeId_fun aSTTypeId;
    statement_fun statement_body;
    opt_iter variable_fun variable_opt;
    fullExpressionAnnot_fun fullExpressionAnnot;
    opt_iter expression_fun expression_opt;
    opt_iter statement_fun statement_gdtor
  end


and expression_fun x = 
  let annot = expression_annotation x
  in
    if visited annot then ()
    else
      let _ = visit annot 
      in match x with
	| E_boolLit(_annot, type_opt, bool) -> 
	    opt_iter cType_fun type_opt;
	    bool_fun bool

	| E_intLit(_annot, type_opt, stringRef, _ulong) -> 
	    opt_iter cType_fun type_opt;
	    string_fun stringRef;

	| E_floatLit(_annot, type_opt, stringRef, _double) -> 
	    opt_iter cType_fun type_opt;
	    string_fun stringRef;

	| E_stringLit(_annot, type_opt, stringRef, 
		      e_stringLit_opt, stringRef_opt) -> 
	    assert(match e_stringLit_opt with 
		     | Some(E_stringLit _) -> true 
		     | None -> true
		     | _ -> false);
	    opt_iter cType_fun type_opt;
	    string_fun stringRef;
	    opt_iter expression_fun e_stringLit_opt;
	    opt_iter string_fun stringRef_opt

	| E_charLit(_annot, type_opt, stringRef, _int32) -> 
	    opt_iter cType_fun type_opt;
	    string_fun stringRef;

	| E_this(_annot, type_opt, variable) -> 
	    opt_iter cType_fun type_opt;
	    variable_fun variable

	| E_variable(_annot, type_opt, pQName, var_opt, nondep_var_opt) -> 
	    opt_iter cType_fun type_opt;
	    pQName_fun pQName;
	    opt_iter variable_fun var_opt;
	    opt_iter variable_fun nondep_var_opt

	| E_funCall(_annot, type_opt, expression_func, 
		    argExpression_list, expression_retobj_opt) -> 
	    opt_iter cType_fun type_opt;
	    expression_fun expression_func;
	    List.iter argExpression_fun argExpression_list;
	    opt_iter expression_fun expression_retobj_opt

	| E_constructor(_annot, type_opt, typeSpecifier, argExpression_list, 
			var_opt, bool, expression_opt) -> 
	    opt_iter cType_fun type_opt;
	    typeSpecifier_fun typeSpecifier;
	    List.iter argExpression_fun argExpression_list;
	    opt_iter variable_fun var_opt;
	    bool_fun bool;
	    opt_iter expression_fun expression_opt

	| E_fieldAcc(_annot, type_opt, expression, pQName, var_opt) -> 
	    opt_iter cType_fun type_opt;
	    expression_fun expression;
	    pQName_fun pQName;
	    opt_iter variable_fun var_opt

	| E_sizeof(_annot, type_opt, expression, int) -> 
	    opt_iter cType_fun type_opt;
	    expression_fun expression;
	    int_fun int

	| E_unary(_annot, type_opt, _unaryOp, expression) -> 
	    opt_iter cType_fun type_opt;
	    expression_fun expression

	| E_effect(_annot, type_opt, _effectOp, expression) -> 
	    opt_iter cType_fun type_opt;
	    expression_fun expression

	| E_binary(_annot, type_opt, expression_left, _binaryOp, expression_right) -> 
	    opt_iter cType_fun type_opt;
	    expression_fun expression_left;
	    expression_fun expression_right

	| E_addrOf(_annot, type_opt, expression) -> 
	    opt_iter cType_fun type_opt;
	    expression_fun expression

	| E_deref(_annot, type_opt, expression) -> 
	    opt_iter cType_fun type_opt;
	    expression_fun expression

	| E_cast(_annot, type_opt, aSTTypeId, expression, bool) -> 
	    opt_iter cType_fun type_opt;
	    aSTTypeId_fun aSTTypeId;
	    expression_fun expression;
	    bool_fun bool

	| E_cond(_annot, type_opt, expression_cond, expression_true, expression_false) -> 
	    opt_iter cType_fun type_opt;
	    expression_fun expression_cond;
	    expression_fun expression_true;
	    expression_fun expression_false

	| E_sizeofType(_annot, type_opt, aSTTypeId, int, bool) -> 
	    opt_iter cType_fun type_opt;
	    aSTTypeId_fun aSTTypeId;
	    int_fun int;
	    bool_fun bool

	| E_assign(_annot, type_opt, expression_target, _binaryOp, expression_src) -> 
	    opt_iter cType_fun type_opt;
	    expression_fun expression_target;
	    expression_fun expression_src

	| E_new(_annot, type_opt, bool, argExpression_list, aSTTypeId, 
		argExpressionListOpt_opt, array_size_opt, ctor_opt,
	        statement_opt, heep_var) -> 
	    opt_iter cType_fun type_opt;
	    bool_fun bool;
	    List.iter argExpression_fun argExpression_list;
	    aSTTypeId_fun aSTTypeId;
	    opt_iter argExpressionListOpt_fun argExpressionListOpt_opt;
	    opt_iter expression_fun array_size_opt;
	    opt_iter variable_fun ctor_opt;
	    opt_iter statement_fun statement_opt;
	    opt_iter variable_fun heep_var

	| E_delete(_annot, type_opt, bool_colon, bool_array, 
		   expression_opt, statement_opt) -> 
	    opt_iter cType_fun type_opt;
	    bool_fun bool_colon;
	    bool_fun bool_array;
	    opt_iter expression_fun expression_opt;
	    opt_iter statement_fun statement_opt

	| E_throw(_annot, type_opt, expression_opt, var_opt, statement_opt) -> 
	    opt_iter cType_fun type_opt;
	    opt_iter expression_fun expression_opt;
	    opt_iter variable_fun var_opt;
	    opt_iter statement_fun statement_opt

	| E_keywordCast(_annot, type_opt, _castKeyword, aSTTypeId, expression) -> 
	    opt_iter cType_fun type_opt;
	    aSTTypeId_fun aSTTypeId;
	    expression_fun expression

	| E_typeidExpr(_annot, type_opt, expression) -> 
	    opt_iter cType_fun type_opt;
	    expression_fun expression

	| E_typeidType(_annot, type_opt, aSTTypeId) -> 
	    opt_iter cType_fun type_opt;
	    aSTTypeId_fun aSTTypeId

	| E_grouping(_annot, type_opt, expression) -> 
	    opt_iter cType_fun type_opt;
	    expression_fun expression

	| E_arrow(_annot, type_opt, expression, pQName) -> 
	    opt_iter cType_fun type_opt;
	    expression_fun expression;
	    pQName_fun pQName

	| E_statement(_annot, type_opt, s_compound) -> 
	    assert(match s_compound with | S_compound _ -> true | _ -> false);
	    opt_iter cType_fun type_opt;
	    statement_fun s_compound

	| E_compoundLit(_annot, type_opt, aSTTypeId, in_compound) -> 
	    assert(match in_compound with | IN_compound _ -> true | _ -> false);
	    opt_iter cType_fun type_opt;
	    aSTTypeId_fun aSTTypeId;
	    init_fun in_compound

	| E___builtin_constant_p(_annot, type_opt, sourceLoc, expression) -> 
	    opt_iter cType_fun type_opt;
	    sourceLoc_fun sourceLoc;
	    expression_fun expression

	| E___builtin_va_arg(_annot, type_opt, sourceLoc, expression, aSTTypeId) -> 
	    opt_iter cType_fun type_opt;
	    sourceLoc_fun sourceLoc;
	    expression_fun expression;
	    aSTTypeId_fun aSTTypeId

	| E_alignofType(_annot, type_opt, aSTTypeId, int) -> 
	    opt_iter cType_fun type_opt;
	    aSTTypeId_fun aSTTypeId;
	    int_fun int

	| E_alignofExpr(_annot, type_opt, expression, int) -> 
	    opt_iter cType_fun type_opt;
	    expression_fun expression;
	    int_fun int

	| E_gnuCond(_annot, type_opt, expression_cond, expression_false) -> 
	    opt_iter cType_fun type_opt;
	    expression_fun expression_cond;
	    expression_fun expression_false

	| E_addrOfLabel(_annot, type_opt, stringRef) -> 
	    opt_iter cType_fun type_opt;
	    string_fun stringRef


and fullExpression_fun((annot, expression_opt, fullExpressionAnnot) ) =
  if visited annot then ()
  else begin
    visit annot;
    opt_iter expression_fun expression_opt;
    fullExpressionAnnot_fun fullExpressionAnnot
  end


and argExpression_fun((annot, expression) ) =
  if visited annot then ()
  else begin
    visit annot;
    expression_fun expression
  end


and argExpressionListOpt_fun((annot, argExpression_list) ) =
  if visited annot then ()
  else begin
    visit annot;
    List.iter argExpression_fun argExpression_list
  end


and init_fun x = 
  let annot = init_annotation x
  in
    if visited annot then ()
    else
      let _ = visit annot 
      in match x with
	| IN_expr(_annot, sourceLoc, fullExpressionAnnot, expression_opt) -> 
	    sourceLoc_fun sourceLoc;
	    fullExpressionAnnot_fun fullExpressionAnnot;
	    opt_iter expression_fun expression_opt

	| IN_compound(_annot, sourceLoc, fullExpressionAnnot, init_list) -> 
	    sourceLoc_fun sourceLoc;
	    fullExpressionAnnot_fun fullExpressionAnnot;
	    List.iter init_fun init_list

	| IN_ctor(_annot, sourceLoc, fullExpressionAnnot, 
		 argExpression_list, var_opt, bool) -> 
	    sourceLoc_fun sourceLoc;
	    fullExpressionAnnot_fun fullExpressionAnnot;
	    List.iter argExpression_fun argExpression_list;
	    opt_iter variable_fun var_opt;
	    bool_fun bool

	| IN_designated(_annot, sourceLoc, fullExpressionAnnot, 
		       designator_list, init) -> 
	    sourceLoc_fun sourceLoc;
	    fullExpressionAnnot_fun fullExpressionAnnot;
	    List.iter designator_fun designator_list;
	    init_fun init


and templateDeclaration_fun x = 
  let annot = templateDeclaration_annotation x
  in
    if visited annot then ()
    else
      let _ = visit annot 
      in match x with
	| TD_func(_annot, templateParameter_opt, func) -> 
	    opt_iter templateParameter_fun templateParameter_opt;
	    func_fun func

	| TD_decl(_annot, templateParameter_opt, declaration) -> 
	    opt_iter templateParameter_fun templateParameter_opt;
	    declaration_fun declaration

	| TD_tmember(_annot, templateParameter_opt, templateDeclaration) -> 
	    opt_iter templateParameter_fun templateParameter_opt;
	    templateDeclaration_fun templateDeclaration


and templateParameter_fun x = 
  let annot = templateParameter_annotation x
  in
    if visited annot then ()
    else
      let _ = visit annot 
      in match x with
	| TP_type(_annot, sourceLoc, variable, stringRef, 
		  aSTTypeId_opt, templateParameter_opt) -> 
	    sourceLoc_fun sourceLoc;
	    variable_fun variable;
	    string_fun stringRef;
	    opt_iter aSTTypeId_fun aSTTypeId_opt;
	    opt_iter templateParameter_fun templateParameter_opt

	| TP_nontype(_annot, sourceLoc, variable,
		    aSTTypeId, templateParameter_opt) -> 
	    sourceLoc_fun sourceLoc;
	    variable_fun variable;
	    aSTTypeId_fun aSTTypeId;
	    opt_iter templateParameter_fun templateParameter_opt


and templateArgument_fun x = 
  let annot = templateArgument_annotation x
  in
    if visited annot then ()
    else
      let _ = visit annot 
      in match x with
	| TA_type(_annot, aSTTypeId, templateArgument_opt) -> 
	    aSTTypeId_fun aSTTypeId;
	    opt_iter templateArgument_fun templateArgument_opt

	| TA_nontype(_annot, expression, templateArgument_opt) -> 
	    expression_fun expression;
	    opt_iter templateArgument_fun templateArgument_opt

	| TA_templateUsed(_annot, templateArgument_opt) -> 
	    opt_iter templateArgument_fun templateArgument_opt


and namespaceDecl_fun x = 
  let annot = namespaceDecl_annotation x
  in
    if visited annot then ()
    else
      let _ = visit annot 
      in match x with
	| ND_alias(_annot, stringRef, pQName) -> 
	    string_fun stringRef;
	    pQName_fun pQName

	| ND_usingDecl(_annot, pQName) -> 
	    pQName_fun pQName

	| ND_usingDir(_annot, pQName) -> 
	    pQName_fun pQName


and fullExpressionAnnot_fun((annot, declaration_list) ) =
  if visited annot then ()
  else begin
    visit annot;
    List.iter declaration_fun declaration_list
  end


and aSTTypeof_fun x = 
  let annot = aSTTypeof_annotation x
  in
    if visited annot then ()
    else
      let _ = visit annot 
      in match x with
	| TS_typeof_expr(_annot, ctype, fullExpression) -> 
	    cType_fun ctype;
	    fullExpression_fun fullExpression

	| TS_typeof_type(_annot, ctype, aSTTypeId) -> 
	    cType_fun ctype;
	    aSTTypeId_fun aSTTypeId


and designator_fun x = 
  let annot = designator_annotation x
  in
    if visited annot then ()
    else
      let _ = visit annot 
      in match x with
	| FieldDesignator(_annot, sourceLoc, stringRef) -> 
	    sourceLoc_fun sourceLoc;
	    string_fun stringRef

	| SubscriptDesignator(_annot, sourceLoc, expression, expression_opt, 
			     idx_start, idx_end) -> 
	    sourceLoc_fun sourceLoc;
	    expression_fun expression;
	    opt_iter expression_fun expression_opt;
	    int_fun idx_start;
	    int_fun idx_end


and attribute_fun x = 
  let annot = attribute_annotation x
  in
    if visited annot then ()
    else
      let _ = visit annot 
      in match x with
	| AT_empty(_annot, sourceLoc) -> 
	    sourceLoc_fun sourceLoc

	| AT_word(_annot, sourceLoc, stringRef) -> 
	    sourceLoc_fun sourceLoc;
	    string_fun stringRef

	| AT_func(_annot, sourceLoc, stringRef, argExpression_list) -> 
	    sourceLoc_fun sourceLoc;
	    string_fun stringRef;
	    List.iter argExpression_fun argExpression_list


(**************************************************************************
 *
 * end of astiter.ml 
 *
 **************************************************************************)


let file = ref ""

let file_set = ref false


let print_stats o_max_node =
  let missing_ids = ref []
  in
    Printf.printf "%s contains %d ast nodes with in total:\n" 
      !file !count_nodes;
    Printf.printf 
      "\t%d source locations\n\
       \t%d booleans \n\
       \t%d integers\n\
       \t%d native integers\n\
       \t%d strings\n"
      !count_sourceLoc
      !count_bool
      !count_int
      !count_nativeint
      !count_string;
    Printf.printf "maximal node id: %d (oast header %d)\n" 
      !max_node_id o_max_node;
    for i = 1 to !max_node_id do
      if not (DS.mem i visited_nodes) then
	missing_ids := i :: !missing_ids
    done;
    missing_ids := List.rev !missing_ids;
    if !missing_ids = [] then
      Printf.printf "all node ids from 1 to %d present\n" !max_node_id
    else begin
	Printf.printf "missing node ids: %d" (List.hd !missing_ids);
	List.iter
	  (fun i -> Printf.printf ", %d" i)
	  (List.tl !missing_ids);
	print_endline "";
    end;
    if o_max_node <> !count_nodes or o_max_node <> !max_node_id then
      print_endline "node counts differ!"




let arguments = Arg.align
  [
  ]

let usage_msg = 
  "usage: count-ast [options...] <file>\n\
   recognized options are:"

let usage () =
  Arg.usage arguments usage_msg;  
  exit(1)
  
let anonfun fn = 
  if !file_set 
  then
    begin
      Printf.eprintf "don't know what to do with %s\n" fn;
      usage()
    end
  else
    begin
      file := fn;
      file_set := true
    end

let main () =
  Arg.parse arguments anonfun usage_msg;
  if not !file_set then
    usage();				(* does not return *)
  let ic = open_in !file in
  let o_max_node = Oast_header.read_header ic in
  let ast = (Marshal.from_channel ic : annotated translationUnit_type)
  in
    translationUnit_fun ast;
    print_stats o_max_node;
    ast
;;


Printexc.catch main ()


