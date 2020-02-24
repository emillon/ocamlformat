open Ocamlformat_lib

module Parsetree = struct end

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
  let opts =
    {Conf.debug= false; margin_check= false; format_invalid_files= false}
  in
  let result =
    parse_and_format Translation_unit.impl ?output_file:None
      ~input_name:"input.ml" ~source Conf.conventional_profile opts
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
