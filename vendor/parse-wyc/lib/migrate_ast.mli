module Selected_version = Ppxlib_ast__Versions.OCaml_408
module Parsetree = Selected_version.Ast.Parsetree
module Asttypes = Selected_version.Ast.Asttypes

module Mapper : sig
  type ('omp, 'ppxlib) fragment =
    | Structure
        : ( Selected_version.Ast.Parsetree.structure,
            Ppxlib.Parsetree.structure )
          fragment
    | Signature
        : ( Selected_version.Ast.Parsetree.signature,
            Ppxlib.Parsetree.signature )
          fragment
    | Use_file
        : ( Selected_version.Ast.Parsetree.toplevel_phrase list,
            Ppxlib.Parsetree.toplevel_phrase list )
          fragment

  val fold_ast : (_, 'ppxlib) fragment -> 'a Ppxlib.Ast_traverse.fold -> 'a -> 'ppxlib -> 'a

  val to_ppxlib : ('omp, 'ppxlib) fragment -> 'omp -> 'ppxlib
end

module Location : sig
  include module type of Ppxlib.Location

  val curr : Lexing.lexbuf -> t

  val merge : t -> t -> t option
end
