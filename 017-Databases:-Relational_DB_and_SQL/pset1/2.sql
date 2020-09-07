/* Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. */

select distinct year
from Movie M, Rating R
where M.mID = R.mID and stars in ('4', '5')
order by year
