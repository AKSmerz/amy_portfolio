#World Life Expectancy Project (Data Cleaning)

#Starting code
SELECT *
FROM world_life_expectancy.world_life_expectancy
;

#Combining Country + Year to create a unique row ID to determine if there are duplicates
SELECT County, Year, CONCAT(Country, Year), COUNT(CONCAT(Country,Year))
FROM world_life_expectancy
GROUP BY County, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, YEAR)) > 1
;

#Identify duplicates in row IDs 
SELECT*
FROM (
SELECT Row_ID, 
CONCAT(Country, Year),
ROW_Number() OVER(partition by CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
FROM world_life_expectancy
) AS Row_Table
WHERE Row_Num > 1
;

#Deleting duplicates from these rows
DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN (
    SELECT Row_ID
FROM (
	SELECT Row_ID, 
	CONCAT(Country, Year),
	ROW_Number() OVER(partition by CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
	FROM world_life_expectancy
	) AS Row_Table
WHERE Row_Num > 1
)
;

#Looking for how many blanks we have
SELECT *
FROM world_life_expectancy
WHERE Status = ''
;

#Looking for how many NULLs we have
SELECT *
FROM world_life_expectancy
WHERE Status IS NULL
;	

#Looking for types of status' 
SELECT DISTINCT (Status)
FROM world_life_expectancy
WHERE Status <> ''
;

#All countries that are developing
SELECT DISTINCT (Country)
FROM world_life_expectancy
WHERE Status = 'Developing'
;

#Populate status to developing when it is blank
UPDATE world_life_expectancy
SET status ='Developing'
WHERE Country IN (SELECT DISTINCT(Country)
			FROM world_life_expectancy
			WHERE Status = 'Developing')
;
#Did not work - error - cannot use subquery in FROM clause

#Join table to itself to update developing when it is blank
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = '' 
AND t2.Status <> ''
AND t2.Status = 'Developing'
;


SELECT *
FROM world_life_expectancy
WHERE Country = 'United States of America'
;


UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = '' 
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

#Checking NULLs
SELECT *
FROM world_life_expectancy
WHERE Status is NULL
;

#Looking for blanks in Life Expectancy column
SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = ''
;

#Filling in the blank space for the life expectancy in 2018
SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy
WHERE `Life expectancy` = ''
;

#Populating blank in 2018 with average of 2017 and 2019 with a self join
SELECT t1.Country, t1.Year, t1.`Life expectancy`, 
t2.Country, t2.Year, t2.`Life expectancy`, 
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = ''
;

#Updating table with 2018 input 
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
WHERE t1.`Life expectancy` = ''
;