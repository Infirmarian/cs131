let my_subset_0 = subset [] []
let my_subset_1 = subset [] [1]
let my_subset_2 = subset [1] [1]
let my_subset_3 = subset [1;2] [1;2]
let my_subset_4 = subset [1;2] [1;2;3]
let my_subset_5 = subset [2;1] [1;2]
let my_subset_6 = subset [1;1;1;1] [1;2]
let my_subset_7 = subset ["a"] ["a"]
let my_subset_8 = subset [1.3; 1.4;] [1.3; 1.9; 1.4]

(*Non subsets*)
let my_subset_9 = not (subset [1] [])
let my_subset_10 = not (subset [1;2] [1])
let my_subset_11 = not (subset [1;2;3] [1;2;7])
let my_subset_12 = not (subset [9;3] [9;2;7])


(* Equal sets *)
let my_equal_sets_test0 = equal_sets [] []
let my_equal_sets_test1 = equal_sets [1] [1]
let my_equal_sets_test2 = equal_sets [1;1;1] [1]
let my_equal_sets_test3 = equal_sets [1;2;3] [1;2;3]
let my_equal_sets_test4 = equal_sets [1;2;3;5;5;5] [5;3;2;1]
let my_equal_sets_test5 = equal_sets [9;9;9;1] [9;1;1;1]
(* Not equal sets *)
let my_equal_sets_test6 = not (equal_sets [] [1])
let my_equal_sets_test7 = not (equal_sets [1] [])
let my_equal_sets_test8 = not (equal_sets [1] [2])
let my_equal_sets_test9 = not (equal_sets [1;2;3] [2;3])
let my_equal_sets_test10 = not (equal_sets [1;2;3] [2;3;4])

(* Union of two sets *)
let my_set_union_test0 = equal_sets (set_union [] []) []
let my_set_union_test1 = equal_sets (set_union [1] []) [1]
let my_set_union_test2 = equal_sets (set_union [] [1]) [1]
let my_set_union_test3 = equal_sets (set_union [1] [1]) [1]
let my_set_union_test4 = equal_sets (set_union [1] [2]) [1;2]
let my_set_union_test5 = equal_sets (set_union [1] [1;2]) [1;2]
let my_set_union_test6 = equal_sets (set_union [9;3] [1;2]) [1;2;3;9]

(* Intersection of two sets *)
let my_set_intersection_test0 = equal_sets (set_intersection [] []) []
let my_set_intersection_test1 = equal_sets (set_intersection [1] []) []
let my_set_intersection_test2 = equal_sets (set_intersection [1] [3]) []
let my_set_intersection_test3 = equal_sets (set_intersection [1] [3;1]) [1]
let my_set_intersection_test4 = equal_sets (set_intersection [1;1;5] [3;1]) [1]
let my_set_intersection_test5 = equal_sets (set_intersection [1;2;3] [3;1]) [1;3]
let my_set_intersection_test6 = equal_sets (set_intersection [1;2;3;9] [9;3;2;1]) [1;2;3;9]

(* Difference of two sets (a-b) *)
let my_set_diff_test0 = equal_sets (set_diff [] []) []
let my_set_diff_test1 = equal_sets (set_diff [] [1]) []
let my_set_diff_test2 = equal_sets (set_diff [1] [1]) []
let my_set_diff_test3 = equal_sets (set_diff [1] [1;1]) []
let my_set_diff_test4 = equal_sets (set_diff [1;1;1] [1]) []
let my_set_diff_test5 = equal_sets (set_diff [1] []) [1]
let my_set_diff_test6 = equal_sets (set_diff [1] [3]) [1]
let my_set_diff_test7 = equal_sets (set_diff [1;2] [3]) [1;2]
let my_set_diff_test8 = equal_sets (set_diff [1;2;3] [3]) [1;2]
let my_set_diff_test9 = equal_sets (set_diff [1;2;3] [1;2;3]) []
let my_set_diff_test10 = equal_sets (set_diff [4;3;2;1] [1;2;3;9]) [4]

(* Fixed points of a function *)
let my_computed_fixed_point_test0 = computed_fixed_point (=) (fun x -> x) 10 = 10
let my_computed_fixed_point_test1 = computed_fixed_point (=) (fun x -> x/2) 1000 = 0
let my_computed_fixed_point_test2 = computed_fixed_point (=) (fun x -> x *. 2.) 1000. = infinity
let my_computed_fixed_point_test3 = computed_fixed_point (=) sqrt 9999. = 1.

type extype = |S |A |B |C
let extype_rules = [
  S, [N A; N B;];
  A, [N A; T "a"];
  B, [N B; T "b"; N C];
  C, [T"c"]
]
let extype_gram = S, extype_rules

let my_filter_reachable_test0 = filter_reachable extype_gram = extype_gram
let my_filter_reachable_test1 = filter_reachable (A,extype_rules) = (A, [A, [N A; T "a"];])
let my_filter_reachable_test2 = filter_reachable (C,extype_rules) = (C, [C, [T "c"];])
let my_filter_reachable_test3 = filter_reachable (B,extype_rules) = (B, [B, [N B; T "b"; N C]; C, [T"c"]])

