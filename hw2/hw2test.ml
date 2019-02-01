let accept_non_empty string = Some string
let accept_empty = function
   | _::_ -> None
   | x -> Some x

type my_nonterminals =
  | Sentence | Nounphrase | Verbphrase | Noun | Verb | Adj | Adv | Article | Conjunction

let my_grammar =
  (Sentence,
   function
     | Sentence -> [[N Nounphrase; N Verbphrase; N Nounphrase];[N Nounphrase; N Verbphrase]; [N Sentence; N Conjunction; N Sentence]]
     | Nounphrase -> [[N Article; N Adj; N Nounphrase]; [N Article;N Noun]; [N Adj; N Nounphrase]; [N Noun]]
     | Verbphrase -> [[N Adv; N Verbphrase]; [N Verb];]
     | Noun -> [[T "CS Student"];[T "I"]; [T "dog"]; [T "food"]; [T "assignment"]; [T "he"]]
     | Verb -> [[T "fed"];[T "ate"]; [T "programmed"]; [T "wept over"]; [T "slept"]; [T "snored"]]
     | Adj -> [[T "clean"];[T "tasty"]; [T "healthy"]; [T "difficult"]; [T "stressed"]]
     | Adv -> [[T "quickly"]; [T "slowly"]; [T "quietly"]; [T "loudly"]]
     | Article -> [[T "the"]; [T "a"]; [T "his"]; [T "hers"]]
     | Conjunction -> [[T "and"]; [T "while"]; [T "but"]]
  )


let sad_story = ["a";"stressed";"CS Student"; "quietly"; "wept over"; "his"; "difficult"; "assignment"]

let make_matcher_test = (make_matcher my_grammar accept_empty ["the";"clean";"dog";"quickly";"ate";"his";"food"; "and"; "he"; "snored"]) = Some []
let make_parser_test = match 
make_parser my_grammar sad_story with
| Some tree -> parse_tree_leaves tree = sad_story
| _ -> false
