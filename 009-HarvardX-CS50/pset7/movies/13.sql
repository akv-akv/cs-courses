SELECT DISTINCT name FROM people p
JOIN stars s ON s.person_id = p.id
JOIN movies m ON m.id = s.movie_id
WHERE m.id IN
(SELECT m.id FROM movies m
JOIN stars s ON s.movie_id = m.id
JOIN people p ON p.id = s.person_id
WHERE name = 'Kevin Bacon' and birth LIKE '%1958%')
AND NOT name = 'Kevin Bacon'
