
/* Q1  Find the titles of all movies directed by Steven Spielberg. */
SELECT title
FROM Movie
WHERE director LIKE "%Spielberg%"

/* Q2  Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.*/
SELECT DISTINCT year
FROM Movie
INNER JOIN Rating using(mID)
WHERE stars in ('4','5')
ORDER BY year

/* Q3  Find the titles of all movies that have no ratings.*/
SELECT DISTINCT title
FROM Movie
LEFT JOIN Rating using(mID)
WHERE Rating.rID is NULL

/* Q4  Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.*/
SELECT DISTINCT name
FROM Reviewer
INNER JOIN Rating using(rID)
WHERE ratingDate is NULL

/* Q5  Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.*/
SELECT name, title, stars, ratingDate
FROM Movie
INNER JOIN Rating USING(mID)
INNER JOIN Reviewer USING(rID)
ORDER BY name, title, stars

/* Q6  For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.*/
SELECT name, title
FROM Reviewer
INNER JOIN Rating R1 USING(rID)
INNER JOIN Rating R2 USING(rID)
INNER JOIN Movie USING(mID)
WHERE R2.stars > R1.stars AND R2.ratingDate > R1.ratingDate AND R2.mID = R1.mID

/* Q7  For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.*/
SELECT title, MAX(stars)
FROM Movie
INNER JOIN Rating USING(mID)
GROUP BY mID
ORDER BY title

/* Q8  For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.*/
SELECT title, MAX(stars)-MIN(stars) as spread
FROM Movie
INNER JOIN Rating USING(mID)
GROUP BY mID
ORDER BY spread DESC, title

/* Q9  Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)*/
SELECT avg(before1980.avgRate) - avg(after1980.avgRate)
FROM (
	SELECT avg(stars) as avgRate, year
	FROM Movie
	INNER JOIN Rating USING(mID)
	WHERE year < 1980
	GROUP BY mID
) AS before1980, (
	SELECT avg(stars) as avgRate, year
	FROM Movie
	INNER JOIN Rating USING(mID)
	WHERE year > 1980
	GROUP BY mID
) AS after1980;
