open Ocamlformat_lib

module Parsetree = struct end

let normalize norm c {Parse_with_comments.ast; _} = norm c ast

let equal eq ~ignore_doc_comments c a b =
  eq ~ignore_doc_comments c a.Parse_with_comments.ast
    b.Parse_with_comments.ast

let moved_docstrings f c a b =
  f c a.Parse_with_comments.ast b.Parse_with_comments.ast

let impl : _ Translation_unit.t =
  { parse= Migrate_ast.Parse.use_file
  ; init_cmts= Cmts.init_toplevel
  ; fmt= Fmt_ast.fmt_toplevel
  ; equal= equal Normalize.equal_toplevel
  ; moved_docstrings= moved_docstrings Normalize.moved_docstrings_toplevel
  ; normalize= normalize Normalize.toplevel
  ; printast= Migrate_ast.Printast.use_file }

type outcome = No_error | Parse_error | Format_error

let parse_and_format xunit ?output_file ~input_name ~source conf opts =
  Location.input_name := input_name ;
  match
    Parse_with_comments.parse xunit.Translation_unit.parse conf ~source
  with
  | exception _exn -> Parse_error
  | parsed -> (
    match
      Translation_unit.format xunit ?output_file ~input_name ~source ~parsed
        conf opts
    with
    | Ok _ -> No_error
    | Error _ -> Format_error )

let check_structure structure =
  let source =
    Fuzz_omp.structure_to_string_opt structure |> Crowbar.nonetheless
  in
  let opts = {Conf.debug= false; margin_check= false} in
  let result =
    parse_and_format impl ?output_file:None ~input_name:"input.ml" ~source
      Conf.conventional_profile opts
  in
  match result with
  | No_error | Parse_error -> ()
  | Format_error ->
      print_endline "=======" ;
      print_endline source ;
      print_endline "=======" ;
      Crowbar.fail "error"

let () =
  Crowbar.(
    add_test ~name:"structure"
      [Fuzz_omp.structure_to_crowbar]
      check_structure)
