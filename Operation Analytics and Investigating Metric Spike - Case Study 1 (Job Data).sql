-- create Database
create database operation_analytics ;

-- Use Operation_analytics
use operation_analytics ;





-- Create table
CREATE TABLE JOB_DATA(
    DS DATE,
    JOB_ID INT,
    ACTOR_ID INT,
    EVENT VARCHAR(20),
    LANGUAGE VARCHAR(20),
    TIME_SPENT INT,
    ORG VARCHAR(20)
);


-- Insert Values

INSERT INTO JOB_DATA(DS,JOB_ID,ACTOR_ID,EVENT,
LANGUAGE, TIME_SPENT ,ORG) 
VALUES
('2020-11-30', 21, 1001, 'skip', 'English', 15, 'A'),
       ('2020-11-30', 22, 1006, 'transfer', 'Arabic', 25, 'B'),
       ('2020-11-29', 23, 1003, 'decision', 'Persian', 20, 'C'),
       ('2020-11-28', 23, 1005,'transfer', 'Persian', 22, 'D'),
       ('2020-11-28', 25, 1002, 'decision', 'Hindi', 11, 'B'),
       ('2020-11-27', 11, 1007, 'decision', 'French', 104, 'D'),
       ('2020-11-26', 23, 1004, 'skip', 'Persian', 56, 'A'),
       ('2020-11-25', 20, 1004, 'transfer', 'Italian', 45, 'C');



SELECT * FROM JOB_DATA ;




-- Case Study 1 (Job Data):
--  Calculate the number of jobs reviewed per hour per day for November 2020?

SELECT DS, COUNT(DISTINCT JOB_ID)AS JOB_REVIEWED,
SUM(TIME_SPENT)/(60*60) AS PER_HOUR_TIME_SPEND
FROM JOB_DATA 
WHERE DS >= "2020-11-01" AND DS <= "2020-11-30" 
GROUP BY  DS
ORDER BY DS DESC  ;



-- Let’s say the above metric is called throughput.
--  Calculate 7 day rolling average of throughput? 
-- For throughput, do you prefer daily metric or 7-day rolling and why?

WITH DAILY_METRIC AS ( SELECT DS,COUNT(JOB_ID) AS JOB_REVIEW FROM JOB_DATA
GROUP BY DS) 
SELECT DS, JOB_REVIEW,
AVG(JOB_REVIEW) OVER (ORDER BY DS ROWS BETWEEN  6 PRECEDING AND CURRENT ROW ) AS THROUGHPUT
FROM DAILY_METRIC ORDER BY THROUGHPUT DESC ;

-- Calculate the percentage share of each language in the last 30 days?

SELECT 
 LANGUAGE,
COUNT(LANGUAGE) AS LANGUAGE_COUNT,
(COUNT(LANGUAGE)/ (SELECT COUNT(*) FROM JOB_DATA)) * 100 AS Percentage_Share
FROM JOB_DATA
GROUP BY LANGUAGE
ORDER BY LANGUAGE DESC ;

 -- Let’s say you see some duplicate rows in the data.
 -- How will you display duplicates from the table?

SELECT * 
FROM 
(SELECT *,
ROW_NUMBER() OVER (PARTITION BY JOB_ID) AS DUPLICATE_ROWS
FROM JOB_DATA ) A_R
WHERE DUPLICATE_ROWS > 1;
