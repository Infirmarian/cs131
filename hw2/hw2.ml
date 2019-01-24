(* Declare terminal and non-terminal types *)
type ('nonterminal, 'terminal) symbol = N of 'nonterminal | T of 'terminal ;;

(* declare the nodes and leaves of trees *)
type ('nonterminal, 'terminal) parse_tree =
  | Node of 'nonterminal * ('nonterminal, 'terminal) parse_tree list
  | Leaf of 'terminal

(* Given a type (expr) and rules (gram) this function returns a list of the grammars *)
let rec convert_grammar_compile_type expr gram = 
  match gram with 
  | [] -> []
  | h::t -> match h with 
          | s,[] -> convert_grammar_compile_type expr t
          | s,a::b -> if s = expr then [a::b]@(convert_grammar_compile_type expr t)
                      else convert_grammar_compile_type expr t

let convert_grammar gram1 =
  match gram1 with
  | s,[] -> s,(fun _ -> [])
  | s,h::t -> s,match h with
                | d, _ ->  (function d -> convert_grammar_compile_type d (h::t))

(* This function returns a list of all terminal leaves of a parse tree, using in-order traversal *)
let rec parse_tree_leaves tree = 
  match tree with
  | Leaf p -> [p]
  | Node (n,c) -> let rec helper d = match d with
                    | [] -> []
                    | h::t -> (match h with | Leaf l -> l::(helper t) 
                                            | Node (no,br) -> (parse_tree_leaves (Node(no,br)))@(helper t)) in helper c


let make_matcher x =
  x
let make_parser x =
  x