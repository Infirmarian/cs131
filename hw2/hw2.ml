(* Declare terminal and non-terminal types *)
type ('nonterminal, 'terminal) symbol = N of 'nonterminal | T of 'terminal ;;

(* declare the nodes and leaves of trees *)
type ('nonterminal, 'terminal) parse_tree =
  | Node of 'nonterminal * ('nonterminal, 'terminal) parse_tree list
  | Leaf of 'terminal


(* Given a type (expr) and a grammar (gram) this function returns a list of the grammars *)
let rec convert_grammar_compile_type expr gram = 
  match gram with 
  | [] -> []
  | h::t -> match h with 
          | s,[] -> convert_grammar_compile_type expr t
          | s,a::b -> if s = expr then [a::b]@(convert_grammar_compile_type expr t)
                      else convert_grammar_compile_type expr t

let rec conv_recursion x =
  match x with
    | [] -> []
    | h::t -> match h with
                | d, _ -> (d, convert_grammar_compile_type d (h::t)) :: conv_recursion (List.filter (fun x -> match x with e,_ -> e <> d) (h::t))

let convert_grammar x =
  match x with
  | s,[] -> s,[]
  | s,h::t -> s,conv_recursion (h::t)

let parse_tree_leaves tree = 
  tree
let make_matcher x =
  x
let make_parser x =
  x