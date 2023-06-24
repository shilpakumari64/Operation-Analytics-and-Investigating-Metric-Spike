CREATE DATABASE Investigating_metric ;
USE Investigating_metric ;
CREATE TABLE  USERS(
    user_id	INT primary key,
    created_at	timestamp,
    company_id	INT,
    language	VARCHAR(512),
    activated_at	timestamp default null,
    state	VARCHAR(512)
);

SELECT * FROM USERS ;

 
CREATE TABLE EVENTS (
    USER_ID INT,
    OCCURED_AT DATETIME,
    EVENT_TYPE VARCHAR(50),
    EVENT_NAME VARCHAR(50),
    LOCATION VARCHAR(50),
    DEVICE VARCHAR(50),
    USER_TYPE INT DEFAULT NULL,
    FOREIGN KEY (USER_ID)
        REFERENCES USERS (USER_ID)
);


SELECT * FROM EVENTS ;

CREATE TABLE EMAIL_EVENTS (
    USER_ID INT,
    OCCURRED_AT TIMESTAMP,
    ACTION VARCHAR(50),
    USER_TYPE INT,
    FOREIGN KEY (USER_ID)
        REFERENCES USERS (USER_ID)
);



SELECT * FROM USERS ;
SELECT * FROM EVENTS ;
SELECT * FROM EMAIL_EVENTS ;

-- Task 2:
--  Calculate the weekly user engagement?
Select EXTRACT(WEEK FROM OCCURED_AT) AS WEEKLY_NUMBER , COUNT( DISTINCT USER_ID) AS WEEKLY_USERS
FROM EVENTS
WHERE EVENT_TYPE = "ENGAGEMENT" AND  EVENT_NAME = "LOGIN"
GROUP BY 1 
ORDER BY 1;


-- Calculate the user growth for product?
select Month, user_count,
((user_count/LAG(user_count, 1) over (order by Month) - 1)*100) As Growth from 
(select extract(month from users.created_at) as Month, count(*) as user_count from 
users where users.activated_at IS NOT NULL group by 1 order by 1) a;

SELECT MONTH, USER_COUNT,
((USER_COUNT/LAG(USER_COUNT , 1) OVER (ORDER BY MONTH) - 1)*100) AS GROWTH FROM
(SELECT EXTRACT(MONTH FROM USERS.CREATED_AT) AS MONTH , COUNT(*) AS USER_COUNT FROM 
USERS WHERE USERS.ACTIVATED_AT IS NOT NULL 
GROUP BY 1 
ORDER BY 1) A_I ;


-- Weekly Retention: Users getting retained weekly after signing-up for a product.
-- Your task: Calculate the weekly retention of users-sign up cohort?
SELECT FIRST AS "WEEK NUMBERS",
SUM(CASE WHEN WEEK_NUMBER = 0 THEN 1 ELSE 0 END) AS "WEEK 0",
SUM(CASE WHEN WEEK_NUMBER = 1 THEN 1  ELSE 0 END) AS "WEEK 1 " ,
SUM(CASE WHEN WEEK_NUMBER = 2 THEN 1 ELSE 0 END) AS "WEEK 2",
SUM(CASE WHEN WEEK_NUMBER = 3 THEN 1 ELSE 0 END) AS "WEEK 3",
SUM(CASE WHEN week_number = 4 THEN 1 ELSE 0 END) AS "Week 4",
SUM(CASE WHEN week_number = 5 THEN 1 ELSE 0 END) AS "Week 5",
SUM(CASE WHEN week_number = 6 THEN 1 ELSE 0 END) AS "Week 6",
SUM(CASE WHEN week_number = 7 THEN 1 ELSE 0 END) AS "Week 7",
SUM(CASE WHEN week_number = 8 THEN 1 ELSE 0 END) AS "Week 8",
SUM(CASE WHEN week_number = 9 THEN 1 ELSE 0 END) AS "Week 9",
SUM(CASE WHEN week_number = 10 THEN 1 ELSE 0 END) AS "Week 10",
SUM(CASE WHEN week_number = 11 THEN 1 ELSE 0 END) AS "Week 11",
SUM(CASE WHEN week_number = 12 THEN 1 ELSE 0 END) AS "Week 12",
SUM(CASE WHEN week_number = 13 THEN 1 ELSE 0 END) AS "Week 13",
SUM(CASE WHEN week_number = 14 THEN 1 ELSE 0 END) AS "Week 14",
SUM(CASE WHEN week_number = 15 THEN 1 ELSE 0 END) AS "Week 15",
SUM(CASE WHEN week_number = 16 THEN 1 ELSE 0 END) AS "Week 16",
SUM(CASE WHEN week_number = 17 THEN 1 ELSE 0 END) AS "Week 17",
SUM(CASE WHEN week_number = 18 THEN 1 ELSE 0 END) AS "Week 18"
FROM
( SELECT  A.USER_ID, A.LOGIN_WEEK,B.FIRST, A.LOGIN_WEEK - FIRST AS WEEK_NUMBER
FROM
(SELECT USER_ID,EXTRACT(WEEK FROM OCCURED_AT) AS LOGIN_WEEK FROM EVENTS
GROUP  BY 1,2)A,
(SELECT USER_ID ,  MIN(EXTRACT(WEEK FROM OCCURED_AT)) AS FIRST FROM EVENTS
GROUP BY 1)B
WHERE A.USER_ID = B.USER_ID
) SUB 
GROUP BY FIRST
ORDER BY FIRST ;




-- Weekly Engagement: To measure the activeness of a user. Measuring if the user finds quality in a product/service weekly.
-- Your task: Calculate the weekly engagement per device?
SELECT 
    EXTRACT(WEEK FROM OCCURED_AT) AS 'WEEK',
    COUNT(DISTINCT CASE
           WHEN e.device IN ('macbook pro') THEN e.user_id
            ELSE NULL
        END) AS macbook_pro,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('iphone 5') THEN e.user_id
            ELSE NULL
        END) AS iphone_5,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('samsung galaxy s4') THEN e.user_id
            ELSE NULL
        END) AS samsung_galaxy_s4,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('lenovo thinkpad') THEN e.user_id
            ELSE NULL
        END) AS lenovo_thinkpad,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('macbook air') THEN e.user_id
            ELSE NULL
        END) AS macbook_air,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('nexus 5') THEN e.user_id
            ELSE NULL
        END) AS nexus_5,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('iphone 5s') THEN e.user_id
            ELSE NULL
        END) AS iphone_5s,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('dell inspiron notebook') THEN e.user_id
            ELSE NULL
        END) AS dell_inspiron_notebook,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('asus chromebook') THEN e.user_id
            ELSE NULL
        END) AS asus_chromebook,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('dell inspiron desktop') THEN e.user_id
            ELSE NULL
        END) AS dell_inspiron_desktop,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('iphone 4s') THEN e.user_id
            ELSE NULL
        END) AS iphone_4s,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('nokia lumia 635') THEN e.user_id
            ELSE NULL
        END) AS nokia_lumia_635,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('acer aspire notebook') THEN e.user_id
            ELSE NULL
        END) AS acer_aspire_notebook,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('hp pavilion desktop') THEN e.user_id
            ELSE NULL
        END) AS hp_pavilion_desktop,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('htc one') THEN e.user_id
            ELSE NULL
        END) AS htc_one,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('acer aspire desktop') THEN e.user_id
            ELSE NULL
        END) AS acer_aspire_desktop,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('mac mini') THEN e.user_id
            ELSE NULL
        END) AS mac_mini,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('samsung galaxy note') THEN e.user_id
            ELSE NULL
        END) AS samsung_galaxy_note,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('amazon fire phone') THEN e.user_id
            ELSE NULL
        END) AS amazon_fire_phone,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('ipad air') THEN e.user_id
            ELSE NULL
        END) AS ipad_air,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('nexus 7') THEN e.user_id
            ELSE NULL
        END) AS nexus_7,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('ipad mini') THEN e.user_id
            ELSE NULL
        END) AS ipad_mini,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('nexus 10') THEN e.user_id
            ELSE NULL
        END) AS nexus_10,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('kindle fire') THEN e.user_id
            ELSE NULL
        END) AS kindle_fire,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('windows surface') THEN e.user_id
            ELSE NULL
        END) AS windows_surface,
    COUNT(DISTINCT CASE
            WHEN e.device IN ('samsumg galaxy tablet') THEN e.user_id
            ELSE NULL
        END) AS samsung_galaxy_tablet
FROM
    events e
WHERE
    e.event_type = 'engagement'
GROUP BY 1
ORDER BY 1
LIMIT 100;

SELECT * FROM EMAIL_EVENTS ;

-- Email Engagement: Users engaging with the email service.
-- Your task: Calculate the email engagement metrics?
SELECT WEEK,
ROUND((weekly_digest/total * 100),2) AS " Weekly Digest Rate",
ROUND((email_open/total*100),2) as "Email Open Rate",
Round((email_clickthrough/total*100),2) AS " Email Clickthrough Rate",
round((reengagement_email/total * 100),2) AS " Reengagement Email Rate"
FROM
(SELECT EXTRACT(WEEK FROM OCCURRED_AT) AS WEEK,
COUNT(CASE WHEN ACTION = "sent_weekly_digest" THEN USER_ID ELSE NULL END) AS 
WEEKLY_DIGEST,
COUNT(CASE WHEN ACTION = "email_open" THEN USER_ID ELSE NULL END) AS 
EMAIL_OPEN,
COUNT(CASE WHEN ACTION = "email_clickthrough" THEN USER_ID ELSE NULL END) AS 
EMAIL_CLICKTHROUGH,
COUNT(CASE WHEN ACTION = "sent_reengagement_email" THEN USER_ID ELSE NULL END) AS 
REENGAGEMENT_EMAIL,
COUNT(USER_ID) AS TOTAL
FROM EMAIL_EVENTS
GROUP BY 1)SUB
GROUP BY 1
ORDER BY 1;

