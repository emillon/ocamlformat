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
open Parse_with_comments

type 'a t
(** Operations on translation units. *)

type error

val format :
     'a t
  -> ?output_file:string
  -> input_name:string
  -> source:string
  -> parsed:'a with_comments
  -> Conf.t
  -> Conf.opts
  -> (string, error) Result.t
(** [format xunit conf ?output_file ~input_name ~source ~parsed] formats
    [parsed], using [input_name] for error messages, and referring to
    [source] to improve comment placement. It returns the formatted string or
    an error that prevented formatting. *)

val parse_and_format :
     'a t
  -> ?output_file:string
  -> input_name:string
  -> source:string
  -> Conf.t
  -> Conf.opts
  -> (string, error) Result.t
(** [parse_and_format xunit conf ?output_file ~input_name ~source] is similar
    to [format] but parses the source according to [xunit]. *)

val print_error :
     ?fmt:Format.formatter
  -> debug:bool
  -> quiet:bool
  -> input_name:string
  -> error
  -> unit
(** [print_error conf ?fmt ~input_name e] prints the error message
    corresponding to error [e] on the [fmt] formatter (stderr by default). *)

val impl : Parsetree.toplevel_phrase list t
(** Operations on implementation files. *)

val intf : Parsetree.signature t
(** Operations on interface files. *)

val parse : 'a t -> Lexing.lexbuf -> 'a
