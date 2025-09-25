#US Household Income Exploratory Data Analysis

#initial tables
SELECT * 
FROM us_project.us_household_income;

SELECT *
FROM us_project.us_household_income_statistics;

#SUM of for each state - will show which state has the largest area and which has the smallest
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 2 DESC;

#Switching it - Looking at the water and which has the most lakes and streams
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 3 DESC;

#top 10 largest states by land
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;

#top 10 largest states by water
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10;

#Tie Tables together (us_project.us_household_income + us_project.us_household_income_statistics) with an inner join
SELECT * 
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
;

#Right join with a filter
SELECT * 
FROM us_project.us_household_income u
RIGHT JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE u.id IS NULL
;

#Inner Join
SELECT * 
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
;


#Pulling out columns that may be interesting to look at
SELECT u.State_Name, County, Type, `Primary`, Mean, Median 
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
;

#Mean and Median #By state, what is their average income and median income #ORDER BY 2 - lowest AVG income
SELECT u.State_Name, ROUND (AVG(Mean),1), ROUND (AVG(Median),1) 
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2
;

#Top 5 states with lowest average income
SELECT u.State_Name, ROUND (AVG(Mean),1), ROUND (AVG(Median),1) 
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2
LIMIT 5
;

#Top 10 states with highest average income
SELECT u.State_Name, ROUND (AVG(Mean),1), ROUND (AVG(Median),1) 
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 10
;

#Highest median incomes
SELECT u.State_Name, ROUND (AVG(Mean),1), ROUND (AVG(Median),1) 
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3 DESC
LIMIT 10
;

#Lowest median incomes
SELECT u.State_Name, ROUND (AVG(Mean),1), ROUND (AVG(Median),1) 
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3 ASC
LIMIT 10
;

#Breaking out by Types - look at average mean
SELECT Type, COUNT(Type), ROUND (AVG(Mean),1), ROUND (AVG(Median),1) 
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY 1
ORDER BY 3 DESC
LIMIT 20
;

#Looking at Median
SELECT Type, COUNT(Type), ROUND (AVG(Mean),1), ROUND (AVG(Median),1) 
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY 1
ORDER BY 4 DESC
LIMIT 20
;

#What type is community referencing (It's Puerto Rico | PR)
SELECT *
FROM us_project.us_household_income
WHERE Type = 'Community'
;

#Filter out Types that are too small
SELECT Type, COUNT(Type), ROUND (AVG(Mean),1), ROUND (AVG(Median),1) 
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY 1
HAVING COUNT(Type) > 100
ORDER BY 4 DESC
LIMIT 20
;

#What salaries look like in big cities - Highest average household income in cities
SELECT u.State_Name, City, ROUND(AVG (Mean),1)
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
GROUP BY u.State_Name, City
ORDER BY ROUND(AVG (Mean),1) DESC
;

#What is the median highest household income in cities
SELECT u.State_Name, City, ROUND(AVG (Mean),1),ROUND(AVG (Median),1)
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
GROUP BY u.State_Name, City
ORDER BY ROUND(AVG (Mean),1) DESC
;

