--Bellabeat Capstone Project
-- This code was used to explore high-tech manufactured products created for women using techniques like:
-- joins, data transformation, aggregate and arithmetic functions, temporary tables and more


-- Let's start with the ASK phase of the data analysis process
--    First identify the problem stakeholders want you to solve:
--     "Analyze current trends in smart device usage to identify how they can be leveraged to enhance 
--      Bellabeat's customer experience and inform strategic marketing initiatives"
 
-- Then we go into the PREPARE phase
--    Decide on where you want  your dataset from,
--   in this case, we are using the Fitbit Fitness Tracker Data found in Kaggle by Mobius.
--    Then make sure that the dataset is reliable to use by checking the author, making sure its up to date, and will actually help you 
--   answer the business task.
--     I then dowloaded the dataset, unzipped the files, made sure they were in .csv format and uploaded them into BiqQuery 
-- I then used the Preview Page to see what exactly kind of data the dataset holds 
--     *Daily Activity 
--     * Calories: Seperated into daily,hourly, and minutes also in both Wide and Narrow format 
--     * Intensitires: Also daily, hourly and minutes (Wide and Narrow) 
--     * Steps: daily, houlry, and minutes (Wide and Narrow)
--     * Heart Rate: Broken down in seconds 
--     * Sleep: Broken down into a daily and minute log 
--     * Weight Log: Has the weight in Kg and Pounds, Fat, and BMI
--     * MET: Standing for Metabolic Equivalents which is the estimated measure of how much energy a given activity requires in the form of calories burned.

-- Now it's time for the PROCESS phase 
--   I decided to use SQL to clean and organize the data because there was a large amount and using SQL would be the easiest tool for me.
--     Then I use data cleaning functions like DISTINCT or LENGTH  
-- I decided to use Daily_calories, Daily_steps. Sleep_day, Weight_log_info, and MET to do my analysis
-- I will now clean each table 


--       I will begin with the Daily_calories Table 

-- First thing I will do is view the data using a basic SELECT statement 
SELECT * 
FROM capstone-coursera-2024.bellatrix_capstone.daily_calories 

-- I will then check for duplicates using DISTINCT
SELECT 
  DISTINCT Id
FROM capstone-coursera-2024.bellatrix_capstone.daily_calories 
-- This shows that I have only 33 distinct Id that I can use for analysis  
-- I will now remove those duplicates. 
-- I will also use TRIM to make sure that there are no extra spaces and CAST to make the Id column string 
SELECT 
  DISTINCT Id,Calories ,
TRIM(CAST(Id AS STRING), " ")
FROM capstone-coursera-2024.bellatrix_capstone.daily_calories 
-- Then I created a new table with the cleaned data 
CREATE OR REPLACE TABLE `capstone-coursera-2024.bellatrix_capstone.calories_cleaned` AS
SELECT 
  DISTINCT
  TRIM(CAST(Id AS STRING)) AS Id,  -- Remove spaces and rename the column
  Calories AS Calories             -- Keep Calories column as is
FROM `capstone-coursera-2024.bellatrix_capstone.daily_calories`; 
-- I then made sure that there were no NULL value in the Calories Column ( There were no NULL Values)
SELECT Calories 
FROM capstone-coursera-2024.bellatrix_capstone.calories_cleaned 
WHERE Calories IS NULL

-- Now I will Clean daily_steps table, following similar steps to the previous table. 
--   I will start by previewing the table 
SELECT * 
 FROM `capstone-coursera-2024.bellatrix_capstone.daily_steps`
  LIMIT 1000  
-- I then clean the data 
CREATE OR REPLACE TABLE `capstone-coursera-2024.bellatrix_capstone.daily_steps_cleaned` AS -- creates a new table
SELECT DISTINCT    -- removes duplicates 
  TRIM(CAST(Id as STRING)) AS Id,
  FORMAT_DATE('%Y-%m-%d', ActivityDay) AS date,  -- formats date the same 
  COALESCE(StepTotal, 0) AS steps  -- replaces Null Values with 0
FROM `capstone-coursera-2024.bellatrix_capstone.daily_steps`; 

-- Cleaning Sleep_day 
CREATE OR REPLACE TABLE `capstone-coursera-2024.bellatrix_capstone.sleep_day_cleaned` AS
SELECT DISTINCT
  Id,
  DATE(SleepDay) AS SleepDay, -- Convert TIMESTAMP to DATE
  COALESCE(TotalSleepRecords, 0) AS TotalSleepRecords, -- Replace NULLs with 0
  COALESCE(TotalMinutesAsleep, 0) AS TotalMinutesAsleep, -- Replace NULLs with 0
  COALESCE(TotalTimeInBed, 0) AS TotalTimeInBed -- Replace NULLs with 0
FROM `capstone-coursera-2024.bellatrix_capstone.sleep_day`;

--Before I begin the next phase I make sure that I know the data_types for each table 
-- Check the data types in daily_steps_cleaned
SELECT column_name, data_type 
FROM `capstone-coursera-2024.bellatrix_capstone.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'daily_steps_cleaned';
-- Check the data types in calories_cleaned
SELECT column_name, data_type 
FROM `capstone-coursera-2024.bellatrix_capstone.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'calories_cleaned';
-- Check the data types in sleep_day_cleaned
SELECT column_name, data_type 
FROM `capstone-coursera-2024.bellatrix_capstone.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'sleep_day_cleaned';

-- Joining the cleaned tables: daily_steps_cleaned, calories_cleaned, and sleep_day_cleaned
SELECT 
    s.Id AS Steps_Id,
    s.date AS ActivityDate,
    s.steps,
    c.Calories,
    sd.TotalMinutesAsleep,
    sd.TotalTimeInBed
FROM 
    `capstone-coursera-2024.bellatrix_capstone.daily_steps_cleaned` AS s
LEFT JOIN 
    `capstone-coursera-2024.bellatrix_capstone.calories_cleaned` AS c
    ON CAST(s.Id AS STRING) = CAST(c.Id AS STRING)  -- Ensure both Ids are cast to STRING
    AND CAST(s.date AS DATE) = CAST(c.Date AS DATE)  -- Cast STRING dates to DATE
LEFT JOIN 
    `capstone-coursera-2024.bellatrix_capstone.sleep_day_cleaned` AS sd
    ON CAST(s.Id AS STRING) = CAST(sd.Id AS STRING)  -- Ensure both Ids are cast to STRING
    AND CAST(s.date AS DATE) = CAST(sd.SleepDay AS DATE);  -- Cast SleepDay to DATE for comparison

-- After I joined those tables I added a CREATE TABLE clause to create a new table with those results
CREATE TABLE `capstone-coursera-2024.bellatrix_capstone.activity_summary` AS
SELECT 
    s.Id AS Steps_Id,
    s.date AS ActivityDate,
    s.steps,
    c.Calories,
    sd.TotalMinutesAsleep,
    sd.TotalTimeInBed
FROM 
    `capstone-coursera-2024.bellatrix_capstone.daily_steps_cleaned` AS s
LEFT JOIN 
    `capstone-coursera-2024.bellatrix_capstone.calories_cleaned` AS c
    ON CAST(s.Id AS STRING) = CAST(c.Id AS STRING)  -- Ensure both Ids are cast to STRING
    AND CAST(s.date AS DATE) = CAST(c.Date AS DATE)  -- Cast STRING dates to DATE
LEFT JOIN 
    `capstone-coursera-2024.bellatrix_capstone.sleep_day_cleaned` AS sd
    ON CAST(s.Id AS STRING) = CAST(sd.Id AS STRING)  -- Ensure both Ids are cast to STRING
    AND CAST(s.date AS DATE) = CAST(sd.SleepDay AS DATE);  -- Cast SleepDay to DATE for comparison

-- I then calulated the Average steps and calories for each day of the week 
SELECT 
    EXTRACT(DAYOFWEEK FROM CAST(ActivityDate AS DATE)) AS DayOfWeek,  -- 1 = Sunday, 7 = Saturday
    AVG(steps) AS avg_steps,
    AVG(Calories) AS avg_calories
FROM 
    `capstone-coursera-2024.bellatrix_capstone.activity_summary`
GROUP BY 
    DayOfWeek
ORDER BY 
    DayOfWeek 
-- I would then use the INSERT INTO function to insert into the activity_summary, however I did not have the paid option of Biq SQL so I used Create Table instead
CREATE TABLE `capstone-coursera-2024.bellatrix_capstone.daily_averages` AS
SELECT 
    EXTRACT(DAYOFWEEK FROM CAST(ActivityDate AS DATE)) AS DayOfWeek,  -- 1 = Sunday, 7 = Saturday
    AVG(steps) AS avg_steps,
    AVG(Calories) AS avg_calories
FROM 
    `capstone-coursera-2024.bellatrix_capstone.activity_summary`
GROUP BY 
    DayOfWeek;
