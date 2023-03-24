# Users number of Trips
SELECT 
    COUNT(*) AS Members_Trips,
    (SELECT 
            COUNT(member_casual = 'casual')
        FROM
            bike_riding_data.all_data_clean) AS Casuals_Trips
FROM
    bike_riding_data.all_data_clean
WHERE
    member_casual = 'member';
	
# Users number of Trips Sorted per Bike Type

SELECT 
    rideable_type,member_casual As Users, COUNT(*) AS Trips
FROM
    bike_riding_data.all_data_clean
WHERE
    member_casual IN ('member' , 'casual')
GROUP BY member_casual,rideable_type;
    
 # Users most used Starting Station 
SELECT 
    start_station_name,member_casual As Users, COUNT(*) AS Trips
FROM
    bike_riding_data.all_data_clean
WHERE
    member_casual IN ('member' , 'casual')
GROUP BY member_casual,start_station_name
order by trips desc
limit 1;

 # Users most used Ending Station 
SELECT 
    end_station_name,member_casual As Users, COUNT(*) AS Trips
FROM
    bike_riding_data.all_data_clean
WHERE
    member_casual IN ('member' , 'casual')
GROUP BY member_casual,end_station_name
order by trips desc
limit 1;
    

