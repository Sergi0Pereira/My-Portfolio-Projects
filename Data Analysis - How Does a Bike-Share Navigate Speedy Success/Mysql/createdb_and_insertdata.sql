/*
This SQL script is designed to modify the tripdatacleaned_202202 table by adding and removing columns and updating existing data. The script achieves the following:

1) Adds a new column started_at_ to the tripdatacleaned_202202 table of type DATETIME.
2) Converts the data in the started_at column to a DATETIME format and updates the new started_at_ column with the converted data.
3) Removes the original started_at column.
4) Adds a new column ended_at_ to the tripdatacleaned_202202 table of type DATETIME.
5) Converts the data in the ended_at column to a DATETIME format and updates the new ended_at_ column with the converted data.
6) Removes the original ended_at column.
7) Adds a new column duration to the tripdatacleaned_202202 table of type VARCHAR(30).
8)Calculates the duration of each trip in days, hours, minutes, and seconds using the TIMESTAMPDIFF function, and stores the result as a formatted string in the new 
duration column.

This script is useful for data cleaning and processing, particularly when dealing with datetime data in a non-standard format. The STR_TO_DATE function allows for 
conversion of the datetime strings to a MySQL-compatible format, which can then be used to perform calculations and other operations on the data.

All of this procedures have benn done for each tripsdatacleaned table(202202 - 202301).
*/

CREATE TABLE tripdatacleaned_202202 (
    ride_id VARCHAR(50) PRIMARY KEY,
    rideable_type VARCHAR(50),
    started_at VARCHAR(50),
    ended_at VARCHAR(50),
    start_station_name VARCHAR(100),
    start_station_id VARCHAR(50),
    end_station_name VARCHAR(100),
    end_station_id VARCHAR(50),
    start_lat FLOAT,
    start_lng FLOAT,
    end_lat FLOAT,
    end_lng FLOAT,
    member_casual CHAR(6)
);


LOAD DATA INFILE 'C:/Users/tpess/OneDrive/Ambiente de Trabalho/Google Data Analyst Docs/Capstone/Data/202202-divvy-tripdata.csv'
INTO TABLE tripdatacleaned_202202
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


DELETE FROM tripdatacleaned_202202 
WHERE
    ride_id IS NULL OR ride_id = ''
    OR rideable_type IS NULL
    OR rideable_type = ''
    OR started_at IS NULL
    OR started_at = ''
    OR ended_at IS NULL
    OR ended_at = ''
    OR start_station_name IS NULL
    OR start_station_name = ''
    OR start_station_id IS NULL
    OR start_station_id = ''
    OR end_station_name IS NULL
    OR end_station_name = ''
    OR end_station_id IS NULL
    OR end_station_id = ''
    OR start_lat IS NULL
    OR start_lng IS NULL
    OR end_lat IS NULL
    OR end_lng IS NULL
    OR member_casual IS NULL
    OR member_casual = '';


ALTER TABLE `tripdatacleaned_202202`
ADD COLUMN started_at_ DATETIME;

UPDATE `tripdatacleaned_202202` 
SET 
    started_at_ = STR_TO_DATE(started_at, '%d/%m/%Y %H:%i:%s');

ALTER TABLE `tripdatacleaned_202202`
DROP COLUMN started_at;



ALTER TABLE `tripdatacleaned_202202`
ADD COLUMN ended_at_ DATETIME;

UPDATE `tripdatacleaned_202202` 
SET 
    ended_at_ = STR_TO_DATE(ended_at, '%d/%m/%Y %H:%i:%s');

ALTER TABLE `tripdatacleaned_202202`
DROP COLUMN ended_at;



ALTER TABLE `tripdatacleaned_202202`
ADD COLUMN duration varchar(30);

UPDATE `tripdatacleaned_202202` 
SET 
    duration = CONCAT(TIMESTAMPDIFF(DAY,
                started_at_,
                ended_at_),
            'd ',
            MOD(TIMESTAMPDIFF(HOUR,
                    started_at_,
                    ended_at_),
                24),
            'h ',
            MOD(TIMESTAMPDIFF(MINUTE,
                    started_at_,
                    ended_at_),
                60),
            'm ',
            MOD(TIMESTAMPDIFF(SECOND,
                    started_at_,
                    ended_at_),
                60),
            's');

