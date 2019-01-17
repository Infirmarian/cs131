type ('nonterminal, 'terminal) symbol = N of 'nonterminal | T of 'terminal ;;
(*I guess this is necessary??*)


(*Returns true iff a is a subset of b, and false otherwise*)
let rec subset a b = 
  match a with
  | [] -> true
  | h::t -> List.exists (fun x -> x=h) b && subset t b;;
(* Returns true if two SORTED, UNIQUE lists are equivelant*)
let rec e_s_u a b = 
  match (a,b) with
  | [],[] -> true
  | [],_ -> false
  | _,[] -> false
  | h::t,h1::t1 -> if h=h1 then e_s_u t t1 else false;;
(*Returns true if two sets are equal, including duplicates, and false otherwise *)
let equal_sets a b =
  e_s_u (List.sort_uniq compare a) (List.sort_uniq compare b);;

(* Joins two lists (including repeats) *)
let set_union a b = a @ b;;

(* Give the intersection of two lists *)
let rec set_intersection a b = 
  match a with
  | [] -> []
  | h::t -> if List.exists (fun x -> x=h) b then h::set_intersection t b else set_intersection t b;;

(* Give the difference of two lists, eg all elements in a that don't appear in b *)
let rec set_diff a b = 
  match a with
  | [] -> []
  | h::t -> if List.exists(fun x -> x=h) b then set_diff t b else h::set_diff t b;;

(* Return the fixed point of a function if one exists, and otherwise loop (forever...) *)
let rec computed_fixed_point eq f x = 
  if eq (f x) x then x else computed_fixed_point eq f (f x);;




let rec follow_individual lis = 
match lis with
| [] -> []
| h::t -> match h with
          | N(n) -> n::follow_individual t
          | T(n) -> follow_individual t;;

let rec access_rules g = 
  match g with
  | s,[] -> [] (*Empty set of rules passed in *)
  | s,h::t -> match h with (* h type of TYPE, List *)
              | ty, [] -> if ty = s then ty::access_rules (s,t) else access_rules(s,t)
              | ty, r1::rn -> if ty = s then ty::access_rules(s,t) @ follow_individual (r1::rn) else access_rules(s,t);;

let rec getem lis g = 
  match lis with
  | [] -> []
  | h::t -> access_rules (h,g) @ getem t g;;

let rec bigboy og g =
  if equal_sets og (getem og g) then og else bigboy (getem og g) g;;

(* Builds the rules back from an accumulated reachable-rules list *)
let rec build_list rules a =
  match a with
  | [] -> []
  | h::t -> match h with
            | ty, _ -> if List.exists (fun x -> x=ty) rules then h::build_list rules t else build_list rules t;; 

let filter_reachable g = 
  match g with
  | s,[] -> s,[]
  | s,a::f -> s,build_list (bigboy [s] (a::f)) (a::f);;