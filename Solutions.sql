-- Netflix project
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id VARCHAR(6),
	type  VARCHAR(10),
	title  VARCHAR(150),
	director  VARCHAR(208),
	castS  VARCHAR(1000),
	country VARCHAR(150),
	date_added  VARCHAR(50),
	release_year INT,
	rating  VARCHAR(10),
	duration  VARCHAR(15),
	listed_in  VARCHAR(100),
	description  VARCHAR(250)
);

select * from netflix;


select
	count(*) as total_content
from netflix;

select
	distinct type
from netflix;

select * from netflix

-- 15 business problems

-- 1. Count the number of Movies vs TV Shows

select
	type,
	count(*) as total_content
from netflix
group by type


2. Find the most common rating for movies and TV shows
select
type,
rating
from 

(
	select
		type,
		rating,
		COUNT(*),
		RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS RANKING 
	from netflix
	GROUP BY 1,2
) AS t1
where 	
	ranking = 1


3. List all movies released in a specific year (e.g., 2020)

-- filter 2020
-- movies
select * from netflix
where 
	type = 'movie'
	and
	release_year = 2020


4. Find the top 5 countries with the most content on Netflix

select 
	UNNEST (string_to_ARRAY(country, ',')) AS NEW_COUNTRY,
	count(show_id) as total_CONTENT
from netflix
group by 1
ORDER BY 2 DESC
LIMIT 5


select
	UNNEST (string_to_ARRAY(country, ',')) AS NEW_COUNTRY
from netflix

5. Identify the longest movie

SELECT * FROM NETFLIX
WHERE
	TYPE = 'MOVIE'
	AND
	duration = (SELECT MAX(duration)from netflix)

6. Find content added in the last 5 years

select
*,
TO_DATE(date_added,'month DD, YYYY')
from netflix
where
	TO_DATE(date_added,'month DD, YYYY')>= CURRENT_DATE - INTERVAL '5 YEARS'

SELECT CURRENT_DATE - INTERVAL '5 YEARS'

7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * FROM NETFLIX
WHERE director ILIKE '%Rajiv Chilaka%'

8. List all TV shows with more than 5 seasons

select 
	*
from netflix
where
	type = 'TV shows'
	AND
	split_part(duration,'',1)::numeric > 5 

select * from netflix
9. Count the number of content items in each genre

select 
	UNNEST(STRING_TO_ARRAY(listed_in,',')) AS GENRE,
	COUNT(show_id) AS TOTAL_CONTENT
from netflix
GROUP BY 1

10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

SELECT
	EXTRACT(YEAR FROM TO_DATE(date_added,'month DD,YYYY')) AS YEAR,
	COUNT(*),
	COUNT(*)::numeric/(SELECT count(*) FROM NETFLIX WHERE COUNTRY = 'India')::numeric*100 as avg_content_per_year
FROM NETFLIX 
WHERE COUNTRY = 'INDIA'
GROUP BY 1


11. List all movies that are documentaries

select * from netflix
where
	listed_in ILIKE '%documentaries%'
	
12. Find all content without a director

select * from netflix
where
	director IS NULL

13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix
where
	casts ILIKE '%Salman Khan%'
	and
	release_year > EXTRACT(YEAR FROM CURRENT_DATE)-10

14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT
UNNEST (STRING_TO_ARRAY(CASTS,',')) AS actors,
COUNT(*) AS total_content
from netflix
where country ILIKE '%india'
group by 1
order by 2 desc
limit 10

15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

with new_table
as
(
select
*,
	CASE
	WHEN
		description ILIKE '%KILL%' OR
		description ILIKE '%Violence%' THEN 'Bad_Content'
		ELSE 'Good Content'
	END category
from netflix
)	

select
	category,
	count(*) as total_content
from new_table
group by 1
