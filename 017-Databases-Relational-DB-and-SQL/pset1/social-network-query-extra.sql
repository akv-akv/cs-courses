
/* Q1 For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C. */
SELECT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
FROM Highschooler H1, Highschooler H2, Highschooler H3, Likes L1, Likes L2
WHERE
	/* A likes B */
	H1.ID = L1.ID1 AND H2.ID = L1.ID2
	AND
	/* B likes C, not equal to A */
	H2.ID = L2.ID1 AND H3.ID = L2.ID2
	AND NOT H1.ID = H3.ID

/* Q2 Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades. */
SELECT name, grade
FROM Highschooler H1
WHERE grade NOT IN
	(SELECT H2.grade
	 FROM Highschooler H2, Friend F
	 WHERE F.ID1 = H1.ID AND F.ID2 = H2.ID)

/* Q3 What is the average number of friends per student? (Your result should be just one number.) */
SELECT AVG(cntFriends)
FROM
	(SELECT COUNT(*) as cntFriends
	FROM Friend F
	GROUP BY F.ID1) 

/* Q4 Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend. */
SELECT COUNT(*)
FROM Friend
WHERE ID1 IN 
	(SELECT ID2
	FROM Friend
	WHERE ID1 in	
		(SELECT ID
		FROM Highschooler
		WHERE name = 'Cassandra'));


/* Q5 Find the name and grade of the student(s) with the greatest number of friends. */
SELECT name, grade
FROM Highschooler H
INNER JOIN Friend F ON F.ID1 = H.ID
GROUP BY F.ID1
HAVING COUNT(*) = 
	(SELECT MAX(cntFriends) 
	FROM
		(SELECT COUNT(*) as cntFriends
		FROM Friend
		GROUP BY Friend.ID1))
