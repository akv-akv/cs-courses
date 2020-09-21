/* Q1 Find the names of all students who are friends with someone named Gabriel.  */
SELECT name 
FROM Highschooler H
INNER JOIN Friend F 
ON F.ID1 = H.ID
AND 
(SELECT name FROM Highschooler WHERE ID = F.ID2) = 'Gabriel'
AND NOT name = 'Gabriel'

/* Q2 For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. */
SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1
INNER JOIN Likes L ON H1.ID = L.ID1
INNER JOIN Highschooler H2 ON H2.ID = L.ID2
AND H2.grade <= H1.grade - 2

/* Q3 For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order. */
SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1
INNER JOIN Likes L ON H1.ID = L.ID1
INNER JOIN Highschooler H2 ON H2.ID = L.ID2
AND H1.name < H2.name
AND NOT (SELECT COUNT(*) 
		 FROM Likes L 
		 WHERE H2.ID = L.ID1 AND H1.ID = L.ID2)
		 = 0

/* Q4 Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade. */
SELECT name, grade
FROM Highschooler H
LEFT JOIN Likes L1 ON H.ID = L1.ID1
LEFT JOIN Likes L2 ON H.ID = L2.ID2
WHERE L1.ID1 IS NULL AND L2.ID2 IS NULL
ORDER BY grade, name

/* Q5 For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. */
SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1
INNER JOIN Likes L ON H1.ID = L.ID1
INNER JOIN Highschooler H2 ON H2.ID = L.ID2
AND H2.ID NOT IN (SELECT ID1 FROM Likes)


/* Q6 Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. */
SELECT name, grade
FROM Highschooler H1
WHERE ID NOT IN
	(SELECT ID1
	FROM Highschooler H2, Friend F
	WHERE H1.ID = F.ID1 AND H2.ID = F.ID2 AND H1.grade <> H2.grade)
ORDER BY H1.grade, H1.name

/* Q7 For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. */
SELECT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
FROM Highschooler H1, Highschooler H2, Highschooler H3, Likes L, Friend F1, Friend F2
WHERE 
	/* A Likes B */
	(L.ID1 = H1.ID AND L.ID2 = H2.ID)
	AND
	/* B is not friend of A */
	H2.ID NOT IN
	(SELECT ID2 FROM Friend F WHERE F.ID1 = H1.ID)
	AND
	/* A has C in friends */
	H1.ID = F1.ID1 AND H3.ID = F1.ID2
	AND
	/* B has C in friends */
	H2.ID = F2.ID1 AND H3.ID = F2.ID2

/* Q8 Find the difference between the number of students in the school and the number of different first names. */
SELECT COUNT(ID)-COUNT(DISTINCT name) FROM Highschooler

/* Q9 Find the name and grade of all students who are liked by more than one other student. */
SELECT name, grade
FROM Highschooler H
WHERE (SELECT COUNT(*) FROM Likes WHERE Likes.ID2 = H.ID) > 1
