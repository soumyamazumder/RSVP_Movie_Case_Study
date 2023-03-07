USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT count(*) as movie_row_counts
FROM movie
;

SELECT count(*) as director_row_counts
FROM director_mapping
;

SELECT count(*) as genre_row_counts
FROM genre
;

SELECT count(*) as names_row_counts
FROM names
;

SELECT count(*) as ratings_row_counts
FROM ratings
;

SELECT count(*) as role_mapping_row_counts
FROM role_mapping
; 

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS ID_NULL_COUNT,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS title_NULL_COUNT,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS year_NULL_COUNT,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS date_published_NULL_COUNT,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS duration_NULL_COUNT,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS country_NULL_COUNT,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS worlwide_gross_income_NULL_COUNT,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS languages_NULL_COUNT,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS production_company_NULL_COUNT
FROM   movie; 

-- Country, worlwide_gross_income, languages and production_company columns have NULL values

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Number of movies released each year
SELECT year,
       Count(title) AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY year
;

-- Number of movies released each month 
SELECT Month(date_published) AS MONTH_NUM,
       Count(*) AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY month_num
ORDER  BY month_num
; 

-- Highest number of movies were released in 2017
/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT Count(DISTINCT id) AS no_of_movies_in_2019
FROM movie
WHERE country LIKE '%INDIA%'
OR country LIKE '%USA%' 
AND year = 2019; 

-- 1059 movies were produced in the USA or India in the year 2019

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM   genre; 

-- Movies belong to 13 genres in the dataset.

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */


-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT g.genre, 
       COUNT(m.id) AS count_of_movies
FROM movie AS m
INNER JOIN 
genre AS g
ON g.movie_id = m.id
GROUP BY g.genre
ORDER BY COUNT(m.id) desc
LIMIT 1
;

-- 4285 Drama movies were produced in total and are the highest among all genres. 

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH having_one AS
(
SELECT m.id,
       COUNT(g.genre) AS Total_Count
FROM movie AS m 
INNER JOIN 
genre AS g 
ON m.id=g.movie_id
GROUP BY m.id
HAVING COUNT(g.genre)=1
)
SELECT COUNT(*) 
FROM having_one
;

-- 3289 movies belong to only one genre

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
       ROUND((AVG(m.duration)),2) AS avg_duration
FROM movie AS m 
INNER JOIN 
genre AS g 
ON m.id=g.movie_id
GROUP BY genre 
ORDER BY avg_duration DESC
;

-- Action genre has the highest duration of 112.88 seconds followed by romance and crime genres.

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_group_summary as 
(
SELECT genre,
       COUNT(g.movie_id) AS movie_count,
       DENSE_RANK() OVER (ORDER BY COUNT(g.movie_id) DESC) AS genre_rank
FROM movie AS m 
INNER JOIN genre g 
ON m.id=g.movie_id
GROUP BY g.genre
) 
SELECT * 
FROM genre_group_summary
WHERE genre="Thriller"
;

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/



-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:


SELECT MIN(avg_rating) AS min_avg_rating,
       MAX(avg_rating) AS max_avg_rating,
       MIN(total_votes) AS min_total_votes,
       MAX(total_votes) AS max_total_votes,
       MIN(median_rating) AS min_median_rating,
       MAX(median_rating) AS max_median_rating
FROM ratings
;  


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH top_10_ranks AS
(
SELECT title,
       avg_rating,
       DENSE_RANK() OVER(ORDER BY avg_rating DESC) AS ranks
FROM movie AS m
INNER JOIN 
ratings AS r
ON m.id = r.movie_id
)
SELECT *
FROM top_10_ranks
WHERE ranks <= 10
;

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
       count(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY count(movie_id) DESC
;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH temp_sumry as
(
SELECT *
FROM movie
WHERE id IN (SELECT movie_id
			 FROM ratings
			 WHERE avg_rating > 8 )
AND production_company IS NOT NULL
),
temp_sumry2 AS
(
SELECT production_company,
       count(id) AS movie_count,
	   DENSE_RANK() OVER(ORDER BY count(id) DESC) AS movie_ranks
FROM temp_sumry
GROUP BY production_company
)
SELECT *
FROM temp_sumry2
WHERE movie_ranks = 1
;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH enhanced as 
(
SELECT * 
FROM genre 
WHERE movie_id IN ( SELECT id
                    FROM movie
                    WHERE year=2017 AND MONTH(date_published)=3 AND country LIKE "%USA%"  
                    AND id IN ( SELECT movie_id 
                                FROM ratings 
                                WHERE total_votes>1000) )
) 
SELECT genre, 
       COUNT(movie_id) as movie_count
FROM enhanced
GROUP BY genre
ORDER BY COUNT(movie_id) desc
;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title,
       avg_rating,
       genre
FROM movie AS m 
INNER JOIN 
ratings AS r 
ON m.id = r.movie_id
INNER JOIN
genre AS g
ON r.movie_id = g.movie_id
WHERE m.title LIKE 'The%'
AND r.avg_rating > 8
ORDER BY r.avg_rating DESC
;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

WITH median_rating_sumry AS
(
SELECT r.median_rating, 
       m.id
FROM movie AS m
INNER JOIN 
ratings AS r
ON m.id = r.movie_id
WHERE r.median_rating = 8
AND (m.date_published BETWEEN '2018-04-01' AND '2019-04-01')
)
SELECT median_rating,
       COUNT(*) AS movie_count
FROM median_rating_sumry
GROUP BY median_rating
;


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

DROP PROCEDURE movie_info;
DELIMITER $$

CREATE PROCEDURE movie_info(OUT res VARCHAR(5))
BEGIN

DECLARE sum1 INT;
DECLARE sum2 INT;
SET sum1 = ( WITH cte1 AS
              (
                 SELECT *
                 FROM ratings
                 WHERE movie_id in(SELECT id
                                   FROM movie
                                   WHERE country LIKE '%Germany%')
			  )
              SELECT SUM(total_votes) AS votes_german
              FROM cte1
			)
;

SET sum2 = ( WITH cte2 AS
              (
                 SELECT *
                 FROM ratings
                 WHERE movie_id in(SELECT id
                                   FROM movie
                                   WHERE country LIKE '%Italy%')
			  )
              SELECT SUM(total_votes) AS votes_german
              FROM cte2
			)
;

IF sum1 > sum2 THEN
   SET res = 'yes';
ELSE 
   SET res = 'no';
END IF; 


END $$

DELIMITER ;

CALL movie_info(@temp);
SELECT @temp AS result;

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


SELECT SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
	   SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
	   SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
	   SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;

-- Height, date_of_birth, known_for_movies columns contain NULLS

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
DROP PROCEDURE movie_sumry;

DELIMITER $$

CREATE PROCEDURE movie_sumry()
BEGIN

DROP VIEW view_name1;

CREATE VIEW view_name1 AS
   SELECT genre
   FROM movie AS m
   INNER JOIN genre AS g
   ON g.movie_id = m.id
   INNER JOIN ratings AS r
   ON r.movie_id = m.id
   WHERE avg_rating > 8
   GROUP BY genre
   ORDER BY COUNT(m.id) DESC
   LIMIT 3
;

WITH cte_d AS
(
SELECT m.id,
       genre,
       name
FROM genre AS g
INNER JOIN 
movie AS m
ON g.movie_id = m.id
INNER JOIN director_mapping AS d
ON m.id = d.movie_id
INNER JOIN names AS n
ON d.name_id = n.id
),
cte_dir_cnt AS
(
SELECT genre,
       name,
       COUNT(id) as movie_count1
FROM cte_d AS x
INNER JOIN 
ratings AS r
ON x.id = r.movie_id
WHERE r.avg_rating > 8
AND genre IN (SELECT * FROM view_name1)
GROUP BY genre,
         name 
ORDER BY COUNT(id) DESC
)
SELECT name,
       sum(movie_count1) AS movie_Sum
FROM cte_dir_cnt
GROUP BY name
ORDER BY sum(movie_count1) DESC
LIMIT 3
;

END $$

DELIMITER ;

CALL movie_sumry;

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH actor_sumry AS
(
SELECT mo.id AS mov_cnt,
       nm.id AS name_cnt,
       name
FROM movie AS mo
INNER JOIN 
role_mapping AS rm
ON mo.id = rm.movie_id
INNER JOIN 
names AS nm
ON rm.name_id = nm.id
WHERE category = 'actor'
AND mo.id IN (SELECT m.id
			  FROM movie AS m
              INNER JOIN 
			  ratings AS r
              ON m.id = r.movie_id
              WHERE median_rating >= 8)
)
SELECT name as Actor_name,
       COUNT(mov_cnt) AS movie_count
FROM actor_sumry
GROUP BY name
ORDER BY COUNT(mov_cnt) DESC
LIMIT 2
;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH prod_com_sumry AS
(
SELECT m.id,
       m.production_company,
       r.total_votes
FROM movie AS m
INNER JOIN
ratings AS r
ON m.id = r.movie_id
WHERE m.production_company IS NOT NULL
)
SELECT production_company,
       SUM(total_votes) AS vote_count,
       DENSE_RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM prod_com_sumry
GROUP BY production_company
LIMIT 3
;

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actor_sumry AS
(
SELECT m.id,
       nm.name
FROM movie AS m
INNER JOIN 
role_mapping AS rm
ON m.id = rm.movie_id
INNER JOIN 
names AS nm
ON rm.name_id = nm.id
WHERE m.country = 'India'
AND rm.category = 'Actor'
),
rating_sumry AS
(
SELECT ac.name,
       SUM(r.total_votes) AS total_votes,
       COUNT(r.movie_id) AS movie_counts,
       Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating
FROM actor_sumry AS ac
INNER JOIN
ratings r
ON ac.id = r.movie_id
GROUP BY ac.name
HAVING COUNT(r.movie_id) >=5
ORDER BY Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) DESC
)
SELECT *,
       DENSE_RANK() OVER(ORDER BY actor_avg_rating DESC) AS actor_rank
FROM rating_sumry
;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_sumry AS
(
SELECT m.id,
       nm.name
FROM movie AS m
INNER JOIN 
role_mapping AS rm
ON m.id = rm.movie_id
INNER JOIN 
names AS nm
ON rm.name_id = nm.id
WHERE m.country = 'India'
AND m.languages = 'Hindi'
AND rm.category = 'Actress'
),
rating_sumry AS
(
SELECT ac.name,
       SUM(r.total_votes) AS total_votes,
       COUNT(r.movie_id) AS movie_counts,
       Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actress_avg_rating
FROM actress_sumry AS ac
INNER JOIN
ratings r
ON ac.id = r.movie_id
GROUP BY ac.name
HAVING COUNT(r.movie_id) >=3
ORDER BY Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) DESC
),
ranking_actresses AS
(
SELECT *,
       DENSE_RANK() OVER(ORDER BY actress_avg_rating DESC) AS actress_rank	
FROM rating_sumry
)
SELECT *
FROM ranking_actresses
WHERE actress_rank <=3
;

/* Taapsee Pannu tops with average rating 7.74. 

Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH thriller_movies AS (
  SELECT 
    DISTINCT title, 
    avg_rating 
  FROM 
    movie AS M 
    INNER JOIN ratings AS r ON r.movie_id = m.id 
    INNER JOIN genre AS g using(movie_id) 
  WHERE 
    genre LIKE 'THRILLER'
) 
SELECT 
  *, 
  CASE 
  WHEN avg_rating > 8 THEN 'Superhit movies' 
  WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies' 
  WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies' 
  ELSE 'Flop movies' END AS avg_rating_category 
FROM 
  thriller_movies 
ORDER BY 
  avg_rating DESC
;

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH genre_summary AS
(
SELECT g.genre,
       round(avg(m.duration),2) as avg_duration
FROM movie AS m
INNER JOIN
genre AS g
ON m.id = g.movie_id
GROUP BY g.genre
)
SELECT *,
       SUM(avg_duration) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
	   AVG(avg_duration) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM genre_summary
; 

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

DROP PROCEDURE gross_income_ranks_sumry;

DELIMITER $$

CREATE PROCEDURE gross_income_ranks_sumry()
BEGIN

DROP VIEW top_3_genre;

CREATE VIEW top_3_genre AS
   SELECT genre
   FROM movie AS m
   INNER JOIN genre AS g
   ON g.movie_id = m.id
   INNER JOIN ratings AS r
   ON r.movie_id = m.id
   WHERE avg_rating > 8
   GROUP BY genre
   ORDER BY COUNT(m.id) DESC
   LIMIT 3
;

WITH high_gross_sumry AS
(
SELECT g.genre,
       m.year,
	   m.title AS movie_name,
	   CAST(replace(replace(ifnull(m.worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) AS worlwide_gross_income 
FROM movie AS m
INNER JOIN 
genre AS g
ON m.id = g.movie_id
WHERE g.genre IN (SELECT genre 
                  FROM top_3_genre)
ORDER BY worlwide_gross_income DESC
),
gross_income_ranking AS
(
SELECT *,
       DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
FROM high_gross_sumry
ORDER BY year
)
SELECT *
FROM gross_income_ranking
WHERE year IN (SELECT DISTINCT year
               FROM movie)
AND movie_rank <=5
;

END $$

DELIMITER ;

CALL gross_income_ranks_sumry();

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH top_prod_companies AS
(
SELECT m.id,
       m.production_company,
       r.movie_id,
       r.median_rating
FROM movie AS m
INNER JOIN
ratings AS r
ON m.id = r.movie_id
WHERE r.median_rating >=8
AND m.production_company IS NOT NULL
AND POSITION(',' IN languages)>0
),
movie_count_sumry AS
(
SELECT production_company,
	   COUNT(id) AS movie_count
FROM top_prod_companies
GROUP BY production_company
ORDER BY COUNT(id) DESC
),
ranking_sumry AS
(
SELECT *,
       DENSE_RANK() OVER(ORDER BY movie_count DESC) as rankings
FROM movie_count_sumry
)
SELECT *
FROM ranking_sumry
WHERE rankings <= 2
;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_name_sumry AS
(
SELECT m.id,
       nm.name
FROM genre AS g
INNER JOIN 
movie AS m
ON g.movie_id = m.id
INNER JOIN 
role_mapping AS rm
ON m.id = rm.movie_id
INNER JOIN 
names AS nm
On rm.name_id = nm.id
WHERE rm.category = 'actress'
AND g.genre = 'Drama'
),
actress_group_wise_rating AS 
(
SELECT x.name,
       SUM(r.total_votes) AS total_votes,
       COUNT(x.id) AS movie_counts,
       Round(Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes), 2) AS actress_avg_rating
FROM actress_name_sumry AS x
INNER JOIN 
ratings AS r
ON x.id = r.movie_id
WHERE r.avg_rating>8
GROUP BY x.name
)
SELECT *,
       DENSE_RANK() OVER(ORDER BY movie_counts DESC) AS actress_rank
FROM actress_group_wise_rating
LIMIT 3
;

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH ctf_date_summary AS
(
SELECT d.name_id,
NAME,
d.movie_id,
duration,
r.avg_rating,
total_votes,
m.date_published,
Lead(date_published,1) OVER(PARTITION BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
FROM director_mapping AS d
INNER JOIN names AS n ON n.id = d.name_id
INNER JOIN movie AS m ON m.id = d.movie_id
INNER JOIN ratings AS r ON r.movie_id = m.id ),
top_director_summary AS
(
SELECT *,
Datediff(next_date_published, date_published) AS date_difference
FROM ctf_date_summary
)
SELECT name_id AS director_id,
NAME AS director_name,
COUNT(movie_id) AS number_of_movies,
ROUND(AVG(date_difference),2) AS avg_inter_movie_days,
ROUND(AVG(avg_rating),2) AS avg_rating,
SUM(total_votes) AS total_votes,
MIN(avg_rating) AS min_rating,
MAX(avg_rating) AS max_rating,
SUM(duration) AS total_duration
FROM top_director_summary
GROUP BY director_id
ORDER BY COUNT(movie_id) DESC
limit 9;









