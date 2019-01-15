let subset_0 = subset [] []
let subset_1 = subset [] [1]
let subset_2 = subset [1] [1]
let subset_3 = subset [1;2] [1;2]
let subset_4 = subset [1;2] [1;2;3]
let subset_5 = subset [2;1] [1;2]
let subset_6 = subset [1;1;1;1] [1;2]
let subset_7 = subset ["a"] ["a"]
let subset_8 = subset [1.3; 1.4;] [1.3; 1.9; 1.4]

(*Non subsets*)
let subset_9 = not (subset [1] [])
let subset_10 = not (subset [1;2] [1])
let subset_11 = not (subset [1;2;3] [1;2;7])
let subset_12 = not (subset [9;3] [9;2;7])


(* Equal sets *)
let eq_set_test0 = equal_sets [] []
let eq_set_test1 = equal_sets [1] [1]
let eq_set_test2 = equal_sets [1;1;1] [1]
let eq_set_test3 = equal_sets [1;2;3] [1;2;3]
let eq_set_test4 = equal_sets [1;2;3;5;5;5] [5;3;2;1]
let eq_set_test5 = equal_sets [9;9;9;1] [9;1;1;1]
(* Not equal sets *)
let eq_set_test6 = not (equal_sets [] [1])
let eq_set_test7 = not (equal_sets [1] [])
let eq_set_test8 = not (equal_sets [1] [2])
let eq_set_test9 = not (equal_sets [1;2;3] [2;3])
let eq_set_test10 = not (equal_sets [1;2;3] [2;3;4])

(* Union of two sets *)
let union_test0 = equal_sets (set_union [] []) []
let union_test1 = equal_sets (set_union [1] []) [1]
let union_test2 = equal_sets (set_union [] [1]) [1]
let union_test3 = equal_sets (set_union [1] [1]) [1]
let union_test4 = equal_sets (set_union [1] [2]) [1;2]
let union_test5 = equal_sets (set_union [1] [1;2]) [1;2]
let union_test6 = equal_sets (set_union [9;3] [1;2]) [1;2;3;9]

(* Intersection of two sets *)
let intersect_test0 = equal_sets (set_intersection [] []) []
let intersect_test1 = equal_sets (set_intersection [1] []) []
let intersect_test2 = equal_sets (set_intersection [1] [3]) []
let intersect_test3 = equal_sets (set_intersection [1] [3;1]) [1]
let intersect_test4 = equal_sets (set_intersection [1;1;5] [3;1]) [1]
let intersect_test5 = equal_sets (set_intersection [1;2;3] [3;1]) [1;3]
let intersect_test6= equal_sets (set_intersection [1;2;3;9] [9;3;2;1]) [1;2;3;9]

