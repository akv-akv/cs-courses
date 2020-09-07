/* Find the titles of all movies that have no ratings. */

select distinct title
from Movie, Rating
where Movie.mID not in (select mID from Rating)
