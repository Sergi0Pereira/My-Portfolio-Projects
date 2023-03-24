R Documentation for the Case Study: How Does a Bike-Share Navigate Speedy Success?

First, the tidyverse, skimr, and dplyr packages are loaded.

The working directory is set to "C:/Users/tpess/OneDrive/Ambiente de Trabalho/Google Data Analyst Docs/Capstone/Data".

Data is then imported from CSV files for each month from February to January using read.csv() function and stored in separate data frames.

All the data frames are then combined into one using rbind() function, creating a single data frame all_data.

Next, any blank values in the data frame are converted to missing values using all_data[all_data == ""] <- NA.

Missing values are then removed from the data frame using na.omit(), creating a new data frame all_data_clean.

Columns that will not be used in analysis are removed from all_data_clean using select() and rename() functions is used to change the names of variables.

The date and time variables in the all_data_clean data frame are converted from character strings to date-time format using as.POSIXct() function.

The day, month, year, and day_of_week variables are created by extracting the corresponding values from the started_at variable using format() function.

The duration of each trip is calculated in seconds using difftime() function and then converted to hours and minutes.

Finally, any negative or zero trip durations are removed, and the resulting data frame is analyzed using skim() function from skimr package.