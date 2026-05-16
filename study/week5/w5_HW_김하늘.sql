-- Q1
SELECT 
    H.hacker_id, 
    H.name
FROM Hackers H
    INNER JOIN Submissions S ON H.hacker_id = S.hacker_id
    INNER JOIN Challenges C ON S.challenge_id = C.challenge_id
    INNER JOIN Difficulty D ON C.difficulty_level = D.difficulty_level
WHERE S.score = D.score
GROUP BY H.hacker_id, H.name
HAVING COUNT(S.challenge_id) >= 2
ORDER BY COUNT(S.challenge_id) DESC, H.hacker_id ASC;

-- Q2
SELECT 
    CITY
FROM STATION
WHERE CITY REGEXP '^[aeiouAEIOU].*[aeiouAEIOU]$';

-- Q3
SELECT
	COUNTRY.CONTINENT,
    Floor(Avg(CITY.POPULATION))
    FROM COUNTRY, CITY
WHERE CITY.COUNTRYCODE = COUNTRY.CODE
GROUP BY COUNTRY.CONTINENT;