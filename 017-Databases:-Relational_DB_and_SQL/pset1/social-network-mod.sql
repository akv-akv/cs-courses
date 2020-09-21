/* Q1 It's time for the seniors to graduate. Remove all 12th graders from Highschooler. */
DELETE FROM Highschooler
WHERE grade = 12;
	
/* Q2 If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. */
DELETE FROM Likes
WHERE
/* A likes B*/
ID1 IN (SELECT L.ID1
		FROM Likes L, Friend F
		WHERE L.ID1=F.ID1 AND L.ID2 = F.ID2)
AND
/* B doesn't like A*/
ID2 NOT IN (SELECT L.ID1
			FROM Likes L, Friend F
			WHERE L.ID1=F.ID1 AND L.ID2 = F.ID2);

/* Q3 For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.) */
INSERT INTO Friend
SELECT F1.ID1, F2.ID2
FROM Friend F1, Friend F2
WHERE F1.ID2 = F2.ID1 AND F1.ID1 <> F2.ID2
EXCEPT SELECT * FROM Friend
