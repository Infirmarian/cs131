
(* Test parse_tree_leaves function *)
let my_parse_tree_leaves_test0 = parse_tree_leaves (Leaf "1") = ["1"]
let my_parse_tree_leaves_test1 = parse_tree_leaves (Node (".",[])) = []
let my_parse_tree_leaves_test2 = parse_tree_leaves (Node (".", [Leaf "1"])) = ["1"]
let my_parse_tree_leaves_test3 = parse_tree_leaves (Node (".", [Node (".", [Leaf "9"])])) = ["9"]
let my_parse_tree_leaves_test4 = parse_tree_leaves (Node (".", [Node (".", [Leaf "9";Leaf "8"; Leaf "7"]); Leaf "1"])) = ["9"; "8"; "7"; "1"]
let my_parse_tree_leaves_test5 = parse_tree_leaves (Node (".", [Node ("-", [Node ("*", [Node ("+", [Leaf 1]); Leaf 2]); Leaf 3]); Leaf 4])) = [1; 2; 3; 4]
