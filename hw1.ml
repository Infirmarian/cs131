(*Returns true iff a is a subset of b, and false otherwise*)
let rec subset a b = 
  match a with
  | [] -> true
  | h::t -> List.exists (fun x -> x=h) b && subset t b;;
(* Returns true if two SORTED, UNIQUE lists are equivelant*)
let rec e_s_u a b = 
  if List.length a <> List.length b then false 
  else if List.length a = 0 && List.length b = 0 then true
  else if List.hd a = List.hd b then e_s_u (List.tl a) (List.tl b) else false;;
(*Returns true if two sets are equal, including duplicates, and false otherwise *)
let equal_sets a b =
  e_s_u (List.sort_uniq (fun x y -> x-y) a) (List.sort_uniq (fun x y -> x-y) b);;

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

(*let rec filter_reachable g =*)
