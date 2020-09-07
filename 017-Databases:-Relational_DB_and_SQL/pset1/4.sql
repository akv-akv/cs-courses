select distinct name
from Reviewer, Rating
where Reviewer.rID = Rating.rID 
	and 
	Rating.rID in (select rID
		from Rating
		where ratingDate is null);
