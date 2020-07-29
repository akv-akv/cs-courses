SELECT title FROM movies m
WHERE m.id IN (
SELECT DISTINCT movie_id FROM stars s
JOIN people p ON s.person_id = p.id
WHERE name ='Johnny Depp'
INTERSECT
SELECT DISTINCT movie_id FROM stars s
JOIN people p ON s.person_id = p.id
WHERE name ='Helena Bonham Carter')
