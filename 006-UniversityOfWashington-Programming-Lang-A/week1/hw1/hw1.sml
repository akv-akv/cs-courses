(* Write a function is_older that takes two dates and evaluates to true or
* false. It evaluates to true if the first argument is a date that comes before
* the second argument. (If the two dates are the same, the result is false.) *)

fun is_older(d1 : (int*int*int) , d2 : (int*int*int)) = 
  if (#1 d1) < (#1 d2) then true else
    if (#1 d1) > (#1 d2) then false else
      if(#2 d1) < (#2 d2) then true else
        if (#2 d1) > (#2 d2) then false else
          if (#3 d1) < (#3 d2) then true else false;
  
(* Write a function number_in_month that takes a list of dates and a month (i.e., an int) and returns
how many dates in the list are in the given month.)*)

fun number_in_month (lod: (int*int*int) list, month: int)=
   if null lod
   then 0
   else 
     (if (#2 (hd lod))= month then 1 else 0) + number_in_month(tl lod, month) 

(*Write a function number_in_months that takes a list of dates and a list of months (i.e., an int list) and returns the number of dates in the list of dates that are in any of the
months in the list of months. Assume the list of months has no number repeated.
Hint: Use your answer to the previous problem.*)

fun number_in_months (lod: (int*int*int) list, lom: int list) =
  if null lom
  then 0
  else
    number_in_month(lod, hd lom) + number_in_months(lod, tl lom)

(* Write a function dates_in_month that takes a list of dates and a month (i.e., an int) and returns a
list holding the dates from the argument list of dates that are in the month. The returned list should
contain dates in the order they were originally given. *)

fun dates_in_month (lod: (int*int*int) list, month: int)=
if null lod
   then lod
   else 
     if #2 (hd lod) = month then (hd lod) :: dates_in_month(tl lod, month)
      else  dates_in_month(tl lod, month)
     
(*Write a function dates_in_months that takes a list of dates and a list of months (i.e., an int list)
and returns a list holding the dates from the argument list of dates that are in any of the months in
the list of months. Assume the list of months has no number repeated.*)

fun dates_in_months(lod: (int*int*int) list, lom: int list) =
  if null lom
  then []
  else 
   dates_in_month(lod, hd lom) @ dates_in_months(lod, tl lom) 


(* Write a function get_nth that takes a list of strings and an int n and
* returns the n th element of the list where the head of the list is 1 st . Do
* not worry about the case where the list has too few elements: your function
* may apply hd or tl to the empty list in this case, which is okay.*)

fun get_nth (los: string list, n: int) =
 if n = 1
 then hd los
 else get_nth (tl los, n-1)


(* Write a function date_to_string that takes a date and returns a string of the form January 20, 2013
(for example). Use the operator ^ for concatenating strings and the library function Int.toString
for converting an int to a string. For producing the month part, do not use a bunch of conditionals.
Instead, use a list holding 12 strings and your answer to the previous problem. For consistency, put a
comma following the day and use capitalized English month names: January, February, March, April,
May, June, July, August, September, October, November, December.*)

fun date_to_string (d: int*int*int)=
let
val months = ["January", "February", "March", "April",
"May", "June", "July", "August", "September", "October", "November", "December"]
in 
get_nth(months, #2 d)^" "^Int.toString(#3 d)^", "^Int.toString(#1 d)
end


(* Write a function number_before_reaching_sum that takes an int called sum, which you can assume
is positive, and an int list, which you can assume contains all positive numbers, and returns an int.
You should return an int n such that the first n elements of the list add to
less than sum, but the first n + 1 elements of the list add to sum or more. Assume the entire list sums to more than the passed in value; it is okay for an exception to occur if this is not the case.*)

fun number_before_reaching_sum(sum: int, loi: int list) =
  if null loi
  then 0
  else
    if sum <= hd loi
    then 0 
    else 1 + number_before_reaching_sum(sum-(hd loi), tl loi)

(*Write a function what_month that takes a day of year (i.e., an int between 1 and 365) and returns
what month that day is in (1 for January, 2 for February, etc.). 
Use a list holding 12 integers and your answer to the previous problem.*)

fun what_month(day: int) = 
let 
  val months=[31,28,31,30,31,30,31,31,30,31,30,31]
in
  1+ number_before_reaching_sum(day, months)
end


(* Write a function month_range that takes two days of the year day1 and day2 and returns an int list
[m1,m2,...,mn] where m1 is the month of day1, m2 is the month of day1+1, ..., and mn is the month
of day day2. Note the result will have length day2 - day1 + 1 or length 0 if
day1>day2.*)

fun month_range (day1:int, day2:int)=
  if day1>day2
  then []
  else what_month(day1) :: month_range(day1+1,day2)

(*Write a function oldest that takes a list of dates and evaluates to an (int*int*int) option. 
* It evaluates to NONE if the list has no dates and SOME d if the date d is the
* oldest date in the list.*)

fun oldest (lod: (int*int*int) list)=
  if null lod
  then NONE
  else 
    if null (tl lod)
    then SOME (hd lod)
    else  if is_older(hd lod, valOf(oldest(tl lod)))
          then SOME (hd lod)
          else oldest(tl lod)


