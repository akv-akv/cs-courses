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
fun card_color(suit, rank)=
  case suit of
       Clubs => Black
     | Spades => Black
     | Diamonds => Red 
     | Hearts => Red

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
fun remove_card(cs: card list, c:card, e:exception)=NONE
