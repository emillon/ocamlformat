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

let check_structure structure =
  let source =
    Fuzz_omp.structure_to_string_opt structure |> Crowbar.nonetheless
  in
  let opts = {Conf.debug= false; margin_check= false} in
  let result =
    Translation_unit.parse_and_format impl ?output_file:None
      ~input_name:"input.ml" ~source Conf.conventional_profile opts
  in
  match result with
  | Ok _ -> ()
  | Error e ->
      if Translation_unit.should_crash e then (
        print_endline "=======" ;
        print_endline source ;
        print_endline "=======" ;
        Crowbar.fail (Translation_unit.error_to_string e) )

let () =
  Crowbar.(
    add_test ~name:"structure"
      [Fuzz_omp.structure_to_crowbar]
      check_structure)
