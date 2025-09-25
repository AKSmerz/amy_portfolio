#US Household Income Data Cleaning

SELECT * 
FROM us_project.us_household_income;

SELECT *
FROM us_project.us_household_income_statistics;

ALTER TABLE us_project.us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`;

SELECT COUNT(id)
FROM us_project.us_household_income;

SELECT COUNT(id)
FROM us_project.us_household_income_statistics;

SELECT ID, COUNT(id)
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id) > 1;

#Looking for duplicates
SELECT *
FROM (
SELECT row_id, 
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
FROM us_project.us_household_income
) duplicates
WHERE row_num > 1
;

#deleting duplicates
DELETE FROM us_household_income
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT row_id, 
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
		FROM us_project.us_household_income
		) duplicates
		WHERE row_num > 1)
		;

#Finding mispelled state names
SELECT State_Name, COUNT(State_Name)
FROM us_project.us_household_income
GROUP BY State_Name
;

SELECT DISTINCT State_Name
FROM us_project.us_household_income
ORDER BY 1
;

#Change georia to Georgia as it is misspelled
UPDATE us_project.us_household_income
SET State_Name ='Georgia'
WHERE State_Name = 'georia'
;

#Fix Alabama misspelling (lower case instead of upper case)
UPDATE us_project.us_household_income
SET State_Name ='Alabama'
WHERE State_Name = 'alabama'
;

#Checking for mistakes in state abbreviations
SELECT DISTINCT State_ab
FROM us_project.us_household_income
ORDER BY 1
;

#Checking mistakes/blank values in Place
SELECT *
FROM us_project.us_household_income
WHERE Place = ''
ORDER BY 1
;

#Only 1 blank in Place where it's supposed to say 'Autaugaville'
SELECT *
FROM us_project.us_household_income
WHERE County = 'Autauga County'
ORDER BY 1
;

#Inputting 'Autaugaville' in the blank where the city equals Vinemont
UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont'
;

#Looking for mistakes in 'Type'
SELECT Type, COUNT(Type)
FROM us_project.us_household_income
GROUP BY Type
;

#Changing type from Boroughs to Borough
UPDATE us_project.us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;


#Checking ALand and AWater for mistakes
SELECT ALand, AWater 
FROM us_project.us_household_income
WHERE AWater = 0 OR AWater = '' OR AWater IS NULL
;

#Is it only 0s or are there Nulls/blanks
SELECT DISTINCT AWater 
FROM us_project.us_household_income
WHERE AWater = 0 OR AWater = '' OR AWater IS NULL
;

#Only 0s - Making sure there's no in ALand as well
SELECT ALand, AWater 
FROM us_project.us_household_income
WHERE (ALand = 0 OR ALand = '' OR ALand IS NULL)
;
#There are only 0s - no NULL or Blanks


#Exploratory Data Analysis




