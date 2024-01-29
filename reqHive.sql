-- Step 1: Create an external table basics from https://datasets.imdbws.com/title.basics.tsv.gz

CREATE EXTERNAL TABLE IF NOT EXISTS basics (
    tconst STRING,
    titleType STRING,
    primaryTitle STRING,
    originalTitle STRING,
    isAdult STRING,
    startYear STRING,
    endYear STRING,
    runtimeMinutes STRING,
    genres STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/user/hive/data/basics/';

-- Step 2: Create an external table ratings from https://datasets.imdbws.com/title.ratings.tsv.gz

CREATE EXTERNAL TABLE IF NOT EXISTS ratings (
    tconst STRING,
    averageRating FLOAT,
    numVotes INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/user/hive/data/ratings/';

-- Step 3: Create a table movies from the partition basics

CREATE TABLE movies (
  id STRING,
  title STRING,
  year INT,
  genres STRING
);

-- Step 4: Filter and load data into the table movies according to the year and genre

INSERT OVERWRITE TABLE movies
SELECT tconst, primaryTitle, CAST(startYear AS INT), genres
FROM basics
WHERE titleType = 'movie' AND startYear IS NOT NULL AND genres IS NOT NULL;

-- Step 5: Create a table horror10s from the partition movies

CREATE TABLE horror2000s (
  id STRING,
  title STRING,
  year INT,
  genres STRING
);

-- Step 6: Filter and load data into the table horror10s according to the year and genre

INSERT OVERWRITE TABLE horror2000s
SELECT id, title, year, genres
FROM movies
WHERE genres LIKE '%Horror%' AND year >= 2000 AND year <= 2010;

-- Step 7: Create a view final_view that cross data from horror10s and ratings to get the average rating and the number of votes
-- Filter the data to get only the movies with a rating greater than 6 and order the result by rating

CREATE VIEW final_view AS
SELECT
    h.id,
    h.title,
    h.year,
    h.genres,
    r.averageRating AS rating,
    r.numVotes
FROM
    horror2000s h
JOIN
    ratings r
ON
    h.id = r.tconst
WHERE
    r.averageRating >= 6
ORDER BY
    rating ASC;

-- Step 8: Create a directory final_view in hive-server file system and export the data from final_view to the directory

INSERT OVERWRITE LOCAL DIRECTORY '/final_view'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
SELECT * FROM final_view;