/*
This SQL code creates a table named tripdatacleaned_202301 to store cleaned bike-sharing trip data for July 2022. It then loads data from a CSV file located at the
 specified file path into the table, removes any rows containing null or empty values for certain columns, adds a new column to store trip durations, creates an 
 index to improve query performance, and populates the new duration column for each row in the table.

Table Name: tripdatacleaned_202301

Columns:
- ride_id: VARCHAR(50), primary key
- rideable_type: VARCHAR(50)
- started_at: DATETIME
- ended_at: DATETIME
- start_station_name: VARCHAR(100)
- start_station_id: VARCHAR(50)
- end_station_name: VARCHAR(100)
- end_station_id: VARCHAR(50)
- start_lat: FLOAT
- start_lng: FLOAT
- end_lat: FLOAT
- end_lng: FLOAT
- member_casual: CHAR(6)
- duration: VARCHAR(30), not null

Index:
- start_end: (started_at, ended_at)

Data Loading:
- Data is loaded from a CSV file located at 'C:/Users/tpess/OneDrive/Ambiente de Trabalho/Google Data Analyst Docs/Capstone/Data/202202-divvy-tripdata.csv'
- The file is assumed to be comma-delimited with fields enclosed in quotation marks and lines terminated by newlines.
- The first row of the file is ignored as it likely contains headers.

Data Cleaning:
- Any rows containing null or empty values for ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id,
 start_lat, start_lng, end_lat, end_lng, or member_casual are deleted.

Data Transformation:
- A new column named duration of type VARCHAR(30) is added to store the duration of each trip.
- The duration column is populated for each row in the table using the TIMESTAMPDIFF function to calculate the difference between the started_at and ended_at times in
 days, hours, minutes, and seconds.
- The result is concatenated into a single string and stored in the duration column.

All of this procedures have benn done for each tripsdatacleaned table(202202 - 202202).
*/

#SET innodb_lock_wait_timeout = 60;

CREATE DATABASE bike_riding_data;
use bike_riding_data;

CREATE TABLE all_data_clean (
    ride_id VARCHAR(50) PRIMARY KEY,
    rideable_type VARCHAR(50),
    started_at DATETIME,
    ended_at DATETIME,
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

LOAD DATA INFILE 'C:/Users/tpess/OneDrive/Ambiente de Trabalho/Google Data Analyst Docs/Capstone/Data/202209-divvy-tripdata.csv'
INTO TABLE tripdatacleaned_202209
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

INSERT INTO all_data_clean
SELECT * FROM tripdatacleaned_202202 UNION SELECT * FROM tripdatacleaned_202203 UNION SELECT * FROM tripdatacleaned_202204 UNION SELECT * FROM
		      tripdatacleaned_202205 UNION SELECT * FROM tripdatacleaned_202206 UNION SELECT * FROM tripdatacleaned_202207 UNION SELECT * FROM		
			  tripdatacleaned_202208 UNION SELECT * FROM tripdatacleaned_202209 UNION SELECT * FROM tripdatacleaned_202210 UNION SELECT * FROM
			  tripdatacleaned_202211 UNION SELECT * FROM tripdatacleaned_202212 UNION SELECT * FROM tripdatacleaned_202301;
 
ALTER TABLE all_data_clean
DROP COLUMN start_lat, 
DROP COLUMN start_lng, 
DROP COLUMN end_lat, 
DROP COLUMN end_lng;   


DELETE FROM all_data_clean 
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
    OR member_casual IS NULL
    OR member_casual = '';



ALTER TABLE `all_data_clean`
ADD COLUMN `duration` VARCHAR(30) NOT NULL;

UPDATE `all_data_clean` 
SET 
    duration = CONCAT(TIMESTAMPDIFF(DAY, started_at, ended_at),
            'd ',
            MOD(TIMESTAMPDIFF(HOUR,
                    started_at,
                    ended_at),
                24),
            'h ',
            MOD(TIMESTAMPDIFF(MINUTE,
                    started_at,
                    ended_at),
                60),
            'm ',
            MOD(TIMESTAMPDIFF(SECOND,
                    started_at,
                    ended_at),
                60),
            's');

delete from all_data_clean
where member_casual = '"casua';

ALTER TABLE `all_data_clean`
ADD COLUMN `total_hours` VARCHAR(30) NOT NULL;

UPDATE all_data_clean
SET total_hours = TIMEDIFF(ended_at, started_at);
            





            

            
          



