(**********************************************************************
 *                                                                    *
 *                            OCamlFormat                             *
 *                                                                    *
 *  Copyright (c) 2017-present, Facebook, Inc.  All rights reserved.  *
 *                                                                    *
 *  This source code is licensed under the MIT license found in the   *
 *  LICENSE file in the root directory of this source tree.           *
 *                                                                    *
 **********************************************************************)

open Migrate_ast

type t

val create : string -> t

val empty_line_between : t -> Location.t -> Location.t -> bool

val string_between : t -> Location.t -> Location.t -> string option

val has_cmt_same_line_after : t -> Location.t -> bool

val string_at : t -> Location.t -> string

val string_literal :
  t -> [`Normalize | `Preserve] -> Location.t -> string option

val char_literal : t -> Location.t -> string option

val tokens_at :
     t
  -> ?filter:(Parser.token -> bool)
  -> Location.t
  -> (Parser.token * Location.t) list

val position_before : t -> Lexing.position -> Lexing.position option
(** [position_before s pos] returns the starting position of the token
    preceding the position [pos]. *)

val loc_between : from:Location.t -> upto:Location.t -> Location.t
(** [loc_between ~from ~upto] returns a location starting from [from] and
    ending before [upto]. *)

val tokens_between :
     t
  -> ?filter:(Parser.token -> bool)
  -> from:Location.t
  -> upto:Location.t
  -> (Parser.token * Location.t) list
(** [tokens_between s ~filter ~from ~upto] returns the list of tokens
    starting from [from] and ending before [upto] and respecting the [filter]
    property. [from] must start before [upto]. *)

val is_long_pexp_open : t -> Parsetree.expression -> bool
(** [is_long_pexp_open source exp] holds if [exp] is a [Pexp_open] expression
    that is expressed in long ('let open') form in source. *)

val is_long_pmod_functor : t -> Parsetree.module_expr -> bool
(** [is_long_pmod_functor source mod_exp] holds if [mod_exp] is a
    [Pmod_functor] expression that is expressed in long ('functor (M) ->')
    form in source. *)

val begins_line : t -> Location.t -> bool

val ends_line : t -> Location.t -> bool

val extension_using_sugar :
  name:string Location.loc -> payload:Parsetree.expression -> bool

val extend_loc_to_include_attributes :
  t -> Location.t -> Parsetree.attributes -> Location.t

val typed_expression :
  Parsetree.core_type -> Parsetree.expression -> [`Type_first | `Expr_first]

val typed_pattern :
  Parsetree.core_type -> Parsetree.pattern -> [`Type_first | `Pat_first]
