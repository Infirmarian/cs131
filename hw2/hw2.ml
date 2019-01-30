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


let rec mmm gram frag0 = 
match gram with root,rules -> 
	match (rules root) with 
	| [] -> false
	| h::t -> (match h with 
		| [] -> false 
		| r1::rn -> let rec matchboi hd tl = 
			(match hd with 
			| N non -> mmm (non,rules) frag0
			| T term -> (term = frag0) || (match tl with [] -> false | ra::rb -> matchboi ra rb)) in matchboi r1 rn);;


let rec make_matcher gram frag = 
	match gram with e,f -> let tail = match_sub f (f e) frag in tail

and match_sub rules li frag = 
	match li with a::b -> let cv = match_list rules a frag in (match cv with | None -> match_sub rules b frag | Some x -> Some x)
				| [] -> None

and match_list rules list frag =
	match frag with 
		| first::last -> (
		match list with | h::t -> (match h with | T term -> if term = first then match_list rules t last else None
												| N non -> let finished = make_matcher (non,rules) frag in (match finished with None -> None | Some x -> match_list rules t x))
						| [] -> Some frag)
		| [] -> match list with [] -> Some[] | _ -> None




let make_parser x =
  x
