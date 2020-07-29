SELECT name FROM people
WHERE people.id IN
(SELECT DISTINCT person_id FROM directors d
JOIN movies ON d.movie_id = movies.id
JOIN ratings r ON r.movie_id = movies.id
WHERE rating >= 9.0)
ORDER BY birth