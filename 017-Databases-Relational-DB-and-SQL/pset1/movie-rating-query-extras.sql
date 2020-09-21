/* Q1 Find the names of all reviewers who rated Gone with the Wind. */
SELECT DISTINCT name
FROM Reviewer
INNER JOIN Rating USING(rID)
INNER JOIN Movie USING(mID)
WHERE title = 'Gone with the Wind'

/* Q2 For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. */
SELECT name, title, stars
FROM Movie
INNER JOIN Rating USING(mID)
INNER JOIN Reviewer USING(rID)
WHERE name = director

/* Q3 Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) */
SELECT name FROM Reviewer
UNION
SELECT title FROM Movie
ORDER BY name, title

/* Q4 Find the titles of all movies not reviewed by Chris Jackson. */
SELECT DISTINCT title
FROM Movie
WHERE title not in
(SELECT DISTINCT title
FROM Movie
INNER JOIN Rating USING(mID)
INNER JOIN Reviewer USING(rID)
WHERE name = 'Chris Jackson')

/* Q5 For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order. */
SELECT DISTINCT Rev1.name, Rev2.name
FROM Rating R1, Reviewer Rev1, Reviewer Rev2, Rating R2
WHERE R1.mID = R2.mID
AND Rev1.name < Rev2.name
AND R1.rID = Rev1.rID
AND R2.rID = Rev2.rID
ORDER BY Rev1.name

/* Q6 For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. */
SELECT name, title, stars
FROM Reviewer
INNER JOIN Rating USING(rID)
INNER JOIN Movie USING(mID)
WHERE stars = 
(SELECT MIN(stars) FROM Rating)

/* Q7 List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. */
SELECT title, avg(stars) as avrRate
FROM Movie
INNER JOIN Rating USING(mID)
GROUP BY title
ORDER BY avrRate DESC, title ASC

/* Q8 Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) */
SELECT DISTINCT name
FROM Reviewer
INNER JOIN Rating USING(rID)
GROUP BY name
HAVING count(*) > 2 

/* Q9 Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) */
/* Solution without COUNT */
SELECT M1.title, M1.director
FROM Movie M1, Movie M2
WHERE M1.director = M2.director AND M1.mID <> M2.mID 
ORDER BY M1.director, M1.title

/* Solution with COUNT */
SELECT title, director
FROM Movie
WHERE director in
	(SELECT director
	FROM Movie
	GROUP BY director
	HAVING count(title) > 1)
ORDER BY director, title

/* Q10 Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) */
SELECT title, avgRate
FROM 
	(SELECT title, avg(stars) as avgRate
	FROM Movie
	INNER JOIN Rating USING(mID)
	GROUP BY title) TEMP
WHERE
	avgRate = 
	(SELECT MAX(avgRate)
	FROM
	(SELECT title, avg(stars) as avgRate
	FROM Movie
	INNER JOIN Rating USING(mID)
	GROUP BY title) AS TEMP)


/* Q11 Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.) */
SELECT title, avgRate
FROM 
	(SELECT title, avg(stars) as avgRate
	FROM Movie
	INNER JOIN Rating USING(mID)
	GROUP BY title)
WHERE
	avgRate = 
	(SELECT MIN(avgRate)
	FROM
	(SELECT title, avg(stars) as avgRate
	FROM Movie
	INNER JOIN Rating USING(mID)
	GROUP BY title))

/* Q12 For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL. */
SELECT director, title, max(stars)
FROM Movie
INNER JOIN Rating USING(mID)
GROUP BY director
HAVING director IS NOT NULL
