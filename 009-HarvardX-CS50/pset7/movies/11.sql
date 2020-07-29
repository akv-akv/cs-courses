SELECT title FROM movies m
JOIN ratings r ON r.movie_id = m.id
WHERE m.id IN 
(SELECT DISTINCT movie_id FROM stars s
JOIN people p ON s.person_id = p.id
WHERE name = 'Chadwick Boseman')
ORDER BY rating DESC
LIMIT 5