--find category names that need cleaning
SELECT DISTINCT(Category)
FROM Content

--remove " from beginning and end of category naames, make all lowercase
SELECT DISTINCT(LOWER(TRIM(Category, '"')))
FROM Content

--find columns qith missing data
SELECT *
FROM Reactions
WHERE TYPE IS NULL

--delete rows with missing data
DELETE 
FROM Reactions
WHERE TYPE IS NULL

--find total posts, total points and average score for each category
SELECT DISTINCT(LOWER(TRIM(Category, '"'))) AS clean_category,
COUNT(r.Reaction_ID)                        AS total_posts,
SUM(t.Score)                                AS total_score,
SUM(t.Score) / COUNT(r.Reaction_ID)         AS avg_Score
FROM Content    AS c
JOIN Reactions  AS r
ON r.Content_ID  = c.Content_ID
JOIN ReactionTypes AS t
ON r.Type = t.Type
GROUP BY 1
ORDER BY 2 DESC;

--find totla reactions per month
SELECT 
	DISTINCT strftime('%m', Datetime) AS month,
	COUNT(Reaction_ID)                AS total_reactions
FROM Reactions
GROUP BY 1
ORDER BY 1

--DEC and JAN had higher than avg reactions.  Find which categories excelled here
SELECT DISTINCT(LOWER(TRIM(Category, '"'))) AS clean_category,
COUNT(r.Reaction_ID)                        AS DEC_JAN_posts,
SUM(t.Score)                                AS total_score
FROM Content    AS c
JOIN Reactions  AS r
ON r.Content_ID  = c.Content_ID
JOIN ReactionTypes AS t
ON r.Type = t.Type
WHERE strftime('%m', Datetime) IN ('12', '01')
GROUP BY 1
ORDER BY 2 DESC;
