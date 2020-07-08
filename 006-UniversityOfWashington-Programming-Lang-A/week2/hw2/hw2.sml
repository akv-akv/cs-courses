(* Coursera PL, HW2 *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)

fun all_except_option (s: string, los: string list)=
  case los of
       [] => NONE
     | s'::los' => if same_string(s,s') 
                   then SOME los'
                   else case all_except_option(s,los') of
                             NONE => NONE
                           | SOME s'' => SOME (s'::s'')
                           
fun get_substitutions1 (lolos: string list list, s: string )=
  case lolos of
    [] => []
     | los::lolos' => case all_except_option(s, los) of
                           NONE => get_substitutions1(lolos',s)
                         | SOME losx => losx @ get_substitutions1(lolos',s)

fun get_substitutions2 (lolos: string list list, s: string )=
  let 
    fun f (lolos: string list list, s:string, acc: string list)=
  case lolos of
       [] => acc 
     | los::lolos' => case all_except_option(s, los) of
                           NONE => f(lolos',s,acc)
                         | SOME losx => f(lolos',s,acc@losx)
  in
    f(lolos,s,[])
  end

fun similar_names (lolos: string list list, 
                   fname: {first:string, middle:string, last:string})=
    let fun f(los, acc) = 
              case los of
                   [] => acc
                 | s::los' => f(los', acc @ [{first=s, last=(#last fname),
                 middle=(#middle fname)}])  
    in
      f(get_substitutions2(lolos, #first fname), [fname])
    end


(*you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)

(*Write a function card_color, which takes a card and returns its color (spades
* and clubs are black, diamonds and hearts are red). Note: One case-expression
* is enough.*)
fun card_color c=
  case c of
       (Clubs,_) => Black
     | (Spades,_) => Black
     | (Diamonds,_) => Red 
     | (Hearts,_) => Red

(*Write a function card_value, which takes a card and returns its value
* (numbered cards have their number as the value, aces are 11, everything else
  * is 10). Note: One case-expression is enough.*)
fun card_value(suit, rank)=
  case rank of
       Ace => 11
     | Num i => i
     | Jack => 10
     | Queen =>10  
     | King => 10
 
(*Write a function remove_card, which takes a list of cards cs, a card c, and an
* exception e. It returns a list that has all the elements of cs except c. If c
* is in the list more than once, remove only the first one. If c is not in the
* list, raise the exception e. You can compare cards with =.*)

fun remove_card(loc, c, e)=
  case loc of
       [] => raise e
     | x::xs => case c = x of
                     true => xs
                   | false => case remove_card(xs,c,e) of
                                   [] => [x] 
                                 | y::ys => x::y::ys

(*Write a function all_same_color, which takes a list of cards and returns true
* if all the cards in the list are the same color. Hint: An elegant solution is
* very similar to one of the functions using nested pattern-matching in the
* lectures.*)
fun all_same_color loc =
  case loc of
       [] => true
     | x::[] => true
     | x::y::tail => case card_color x = card_color y of
                          true => all_same_color(y::tail)
                        |false => false

(* Write a function sum_cards, which takes a list of cards and returns the sum
* of their values. Use a locally defined helper function that is tail recursive.
* (Take “calls use a constant amount of stack space” as a requirement for this
* problem.)*)
fun sum_cards loc =
  let fun f(loc,acc)=
    case loc of
         [] => acc
       | x::xs => f(xs,acc + card_value(x))
  in
    f(loc,0)
  end

(* Write a function score, which takes a card list (the held-cards) and an int 
* (the goal) and computes the score as described above.*)
fun score(loc, goal)=
let
    val sum_goal_diff = sum_cards(loc) - goal
    val prescore = if sum_goal_diff>0 then sum_goal_diff*3 else ~ sum_goal_diff
  in
    case all_same_color loc  of
         true => prescore div 2
       | false => prescore
  end

(* Write a function officiate, which “runs a game.” It takes a card list (the
* card-list) a move list (what the player “does” at each point), and an int (the
* goal) and returns the score at the end of the game after processing (some or
* all of) the moves in the move list in order. Use a locally defined recursive
* helper function that takes several arguments that together represent the
* current state of the game. *)
fun officiate(loc, moves, goal) =
let fun process_game(loc, moves, held)=
  case moves of
       [] => held
     | move::moves' => case move of
                    Discard card => process_game(loc, moves', remove_card(held,
                    card, IllegalMove)) 
                  | Draw => case loc of
                                 [] => held
                               | y::_ => case sum_cards(y::held) > goal of
                                             true => y::held
                                            |false =>
                                                process_game(remove_card(loc,y,IllegalMove), moves', y::held)
in
  score(process_game(loc, moves, []), goal)
end
