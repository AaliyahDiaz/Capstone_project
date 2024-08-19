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

-- Now it's time for the PROCESS phase 
--   I decided to use SQL to clean and organize the data because there was a large amount and using SQL would be the easiest tool for me.
--     Then I use data cleaning functions like DISTINCT or LENGTH 

-- We can view the entire dataset before we begin using in the Preview Page

--       Will Select all customer id's in the daily_activity table
SELECT id 
FROM capstone-coursera-2024.bellatrix_capstone.daily_activity 
--       we can add DISTINCT to make sure there are no duplicates
SELECT 
    DISTINCT Id 
FROM capstone-coursera-2024.bellatrix_capstone.daily_activity 

--      I will use IS NULL and IS NOT NULL to ensure there are no missing values
SELECTSELECT *
FROM capstone-coursera-2024.bellatrix_capstone.daily_activity 
WHERE TotalDistance IS NULL

SELECT *
FROM capstone-coursera-2024.bellatrix_capstone.daily_activity 
WHERE Calories IS NULL

SELECT *
FROM capstone-coursera-2024.bellatrix_capstone.daily_activity 
WHERE TotalStepsIS NULL
-- I made sure that all the tables I need dont have Null values so I can ensure that my analysis is accurat and reliable
-- Those tables being TotalDistance, TotalSteps,Calories 

--      I will now clean the weight_log_info table 

SELECT 
    DISTINCT Id
     FROM `capstone-coursera-2024.bellatrix_capstone.weight_log_info` 

SELECT * 
 FROM `capstone-coursera-2024.bellatrix_capstone.weight_log_info` 
WHERE WeightPounds IS NULL
-- I can now compare the Id from this table with the ones in the dail_activity table

-- After the Data I need has been cleaned we can get started on the ANALYZE phase 
-- I want to see how TotalDistance, TotalSteps, and Calories affect a customers weight
