
(* Function returns true if value a is in list b, and false otherwise 
 * This is a helper function for subset *)
let rec lcontains a b = 
  if List.length b = 0 then false 
  else if List.hd b = a then true else lcontains a (List.tl b);;
(*Returns true iff a is a subset of b, and false otherwise*)
let rec subset a b = 
  if List.length a = 0 then true 
  else if lcontains (List.hd a) b then subset (List.tl a) b 
      else false;;
(* Returns true if two SORTED, UNIQUE lists are equivelant*)
let rec e_s_u a b = 
  if List.length a <> List.length b then false 
  else if List.length a = 0 && List.length b = 0 then true
  else if List.hd a = List.hd b then e_s_u (List.tl a) (List.tl b) else false;;
(*Returns true if two sets are equal, including duplicates, and false otherwise *)
let equal_sets a b =
  e_s_u (List.sort_uniq (fun x y -> x-y) a) (List.sort_uniq (fun x y -> x-y) b);;

(* Joins two lists (including repeats) *)
let set_union a b =
  List.append a b;;

let rec set_intersection a b = 
  if List.length a = 0 then [] 
  else if List.exists (fun x -> x=(List.hd a)) b then List.cons (List.hd a) (set_intersection (List.tl a) b)
        else set_intersection (List.tl a) b;;

