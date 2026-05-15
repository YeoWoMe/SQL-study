SELECT h.hacker_id, h.name 
FROM Submissions s 
JOIN Challenges c ON s.challenge_id = c.challenge_id 
JOIN Difficulty d ON c.difficulty_level = d.difficulty_level 
JOIN Hackers h ON s.hacker_id = h.hacker_id 
WHERE s.score = d.score 
GROUP BY h.hacker_id, h.name 
HAVING COUNT(s.challenge_id) > 1 
ORDER BY COUNT(s.challenge_id) DESC, h.hacker_id ASC;


SELECT DISTINCT CITY
FROM STATION
WHERE LEFT(CITY, 1) IN ('a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U')
  AND RIGHT(CITY, 1) IN ('a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U');
  
  
SELECT COUNTRY.Continent, FLOOR(AVG(CITY.Population))
FROM CITY
JOIN COUNTRY ON CITY.CountryCode = COUNTRY.Code
GROUP BY COUNTRY.Continent;