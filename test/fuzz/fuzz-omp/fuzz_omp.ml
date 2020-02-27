module Compiler_libs_parsetree = Parsetree
open Migrate_parsetree.Ast_409

let to_current = Migrate_parsetree.Versions.(migrate ocaml_409 ocaml_current)

[@@@ocaml.warning "-39"]

module Longident = struct
  type t = [%import: Longident.t] [@@deriving crowbar]
end

module Location = struct
  type t = Location.t

  let to_crowbar = Crowbar.const Location.none

  type 'a loc = [%import: 'a Location.loc] [@@deriving crowbar]
end

module Asttypes = struct
  type 'a loc = [%import: 'a Asttypes.loc] [@@deriving crowbar]

  type arg_label = [%import: Asttypes.arg_label] [@@deriving crowbar]

  type label = [%import: Asttypes.label] [@@deriving crowbar]

  type closed_flag = [%import: Asttypes.closed_flag] [@@deriving crowbar]

  type rec_flag = [%import: Asttypes.rec_flag] [@@deriving crowbar]

  type direction_flag = [%import: Asttypes.direction_flag]
  [@@deriving crowbar]

  type override_flag = [%import: Asttypes.override_flag] [@@deriving crowbar]

  type variance = [%import: Asttypes.variance] [@@deriving crowbar]

  type private_flag = [%import: Asttypes.private_flag] [@@deriving crowbar]

  type mutable_flag = [%import: Asttypes.mutable_flag] [@@deriving crowbar]

  type virtual_flag = [%import: Asttypes.virtual_flag] [@@deriving crowbar]
end

module Parsetree_crowbar = struct
  type structure = [%import: Parsetree.structure]

  and structure_item = [%import: Parsetree.structure_item]

  and structure_item_desc = [%import: Parsetree.structure_item_desc]

  and type_exception = [%import: Parsetree.type_exception]

  and open_declaration = [%import: Parsetree.open_declaration]

  and 'a open_infos = [%import: 'a Parsetree.open_infos]

  and letop = [%import: Parsetree.letop]

  and binding_op = [%import: Parsetree.binding_op]

  and object_field_desc = [%import: Parsetree.object_field_desc]

  and row_field_desc = [%import: Parsetree.row_field_desc]

  and module_substitution = [%import: Parsetree.module_substitution]

  and expression = [%import: Parsetree.expression]

  and attributes = [%import: Parsetree.attributes]

  and value_binding = [%import: Parsetree.value_binding]

  and value_description = [%import: Parsetree.value_description]

  and type_declaration = [%import: Parsetree.type_declaration]

  and type_extension = [%import: Parsetree.type_extension]

  and module_binding = [%import: Parsetree.module_binding]

  and module_type_declaration = [%import: Parsetree.module_type_declaration]

  and open_description = [%import: Parsetree.open_description]

  and class_declaration = [%import: Parsetree.class_declaration]

  and class_type_declaration = [%import: Parsetree.class_type_declaration]

  and include_declaration = [%import: Parsetree.include_declaration]

  and attribute = [%import: Parsetree.attribute]

  and extension = [%import: Parsetree.extension]

  and expression_desc = [%import: Parsetree.expression_desc]

  and pattern = [%import: Parsetree.pattern]

  and core_type = [%import: Parsetree.core_type]

  and type_kind = [%import: Parsetree.type_kind]

  and module_expr = [%import: Parsetree.module_expr]

  and module_type = [%import: Parsetree.module_type]

  and 'a class_infos = [%import: 'a Parsetree.class_infos]

  and class_expr = [%import: Parsetree.class_expr]

  and class_type = [%import: Parsetree.class_type]

  and 'a include_infos = [%import: 'a Parsetree.include_infos]

  and payload = [%import: Parsetree.payload]

  and constant = [%import: Parsetree.constant]

  and case = [%import: Parsetree.case]

  and class_structure = [%import: Parsetree.class_structure]

  and pattern_desc = [%import: Parsetree.pattern_desc]

  and core_type_desc = [%import: Parsetree.core_type_desc]

  and constructor_declaration = [%import: Parsetree.constructor_declaration]

  and label_declaration = [%import: Parsetree.label_declaration]

  and module_expr_desc = [%import: Parsetree.module_expr_desc]

  and module_type_desc = [%import: Parsetree.module_type_desc]

  and class_type_desc = [%import: Parsetree.class_type_desc]

  and class_expr_desc = [%import: Parsetree.class_expr_desc]

  and signature = [%import: Parsetree.signature]

  and class_field = [%import: Parsetree.class_field]

  and object_field = [%import: Parsetree.object_field]

  and row_field = [%import: Parsetree.row_field]

  and package_type = [%import: Parsetree.package_type]

  and constructor_arguments = [%import: Parsetree.constructor_arguments]

  and with_constraint = [%import: Parsetree.with_constraint]

  and class_signature = [%import: Parsetree.class_signature]

  and signature_item = [%import: Parsetree.signature_item]

  and class_field_desc = [%import: Parsetree.class_field_desc]

  and class_type_field = [%import: Parsetree.class_type_field]

  and signature_item_desc = [%import: Parsetree.signature_item_desc]

  and class_field_kind = [%import: Parsetree.class_field_kind]

  and class_type_field_desc = [%import: Parsetree.class_type_field_desc]

  and module_declaration = [%import: Parsetree.module_declaration]

  and include_description = [%import: Parsetree.include_description]

  and class_description = [%import: Parsetree.class_description]

  and extension_constructor = [%import: Parsetree.extension_constructor]

  and extension_constructor_kind =
    [%import: Parsetree.extension_constructor_kind]
  [@@deriving crowbar]
end

type structure = Compiler_libs_parsetree.structure

let structure_to_crowbar =
  Crowbar.map
    [Parsetree_crowbar.structure_to_crowbar]
    to_current.copy_structure

let structure_to_string_opt s =
  match Format.asprintf "%a" Pprintast.structure s with
  | s -> Some s
  | exception Assert_failure _ -> None
