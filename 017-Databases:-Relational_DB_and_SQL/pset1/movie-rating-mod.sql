/* Q1 Add the reviewer Roger Ebert to your database, with an rID of 209. */
INSERT INTO Reviewer VALUES ('209', 'Roger Ebert')

/* Q2 For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.) */
UPDATE Movie
SET year = year + 25
WHERE mID in
	(SELECT mID
	FROM Rating
	GROUP BY mID
	HAVING avg(stars) >= 4)

/* Q3 Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.*/
DELETE FROM Rating
WHERE mID IN
	(SELECT mID
	FROM Movie
	WHERE year < 1970 OR year > 2000)
AND stars < 4
