-- HackerRank: Top Competitors
SELECT S.hacker_id, H.name
FROM Submissions AS S
JOIN Challenges AS C ON S.challenge_id = C.challenge_id
JOIN Difficulty AS D ON C.difficulty_level = D.difficulty_level
JOIN Hackers AS H ON S.hacker_id = H.hacker_id
WHERE S.score = D.score
GROUP BY S.hacker_id, H.name
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC, S.hacker_id ASC;


-- HackerRank: Weather Observation Center 8
-- 정규연산자 사용
-- ^[]: 대괄호 안에 있는 문자로 시작
-- .*: .은 아무 문자, * 0개 이상 반복
-- []&: 대괄호 안에 있는 문자로 마무리
SELECT CITY
FROM STATION
WHERE CITY REGEXP '^[AEIOUaeiou].*[AEIOUaeiou]$';

-- HackerRank: Average Population of Each Continent
-- TRUNCATE: 숫자 내림
SELECT COUNTRY.Continent, TRUNCATE(AVG(CITY.Population),0)
FROM CITY 
JOIN COUNTRY ON CITY.CountryCode = COUNTRY.Code
GROUP BY COUNTRY.Continent