library(tidyr)
library(dplyr)
library(ggplot2)
library(readr)
library(gridExtra)
library(scales)

#Number of Users
ggplot(all_data_clean_fv) +
  geom_bar(mapping = aes(x = user_type, fill = user_type),
           size = 100000) +
  scale_y_continuous(n.breaks = 10) +
  labs(fill = "User Type Colors") +
  xlab("User Type") +
  ylab("Counter") +
  theme(axis.title.x = element_text(hjust = 0.5),
        axis.title.y = element_text(hjust = 0.5))

ggsave("Number_of_Users.png")

#Bike Type Counter

ggplot(all_data_clean_fv) +
  geom_bar(mapping = aes(x = bike_type, fill = bike_type),
           size = 100000) +
  scale_y_continuous(n.breaks = 10) +
  xlab("Bike Type") +
  ylab("Total Number of Bikes") +
  theme(axis.title.x = element_text(hjust = 0.5),
        axis.title.y = element_text(hjust = 0.5))
ggsave("Total_Bikes.png")

#Bike Type Counter per User

ggplot(data = all_data_clean_fv) +
  geom_bar(mapping = aes(x = bike_type, fill = bike_type)) +
  facet_wrap( ~ user_type) +
  theme(axis.text.x = element_text(angle = 0, size = 9))
ggsave("Bikes_Per_User.png")

#Trips Length Hours per user
ggplot(all_data_clean_fv, aes(x = user_type)) +
  geom_col(aes(y =  trip_length_hours, fill = user_type), size = 10000000) +
  scale_y_continuous(labels = comma, n.breaks = 10) +
  xlab("User Type") +
  ylab("Trip Length Hours") +
  labs(fill = "User Type Colors") +
  theme(axis.title.x = element_text(hjust = 0.5),
        axis.title.y = element_text(hjust = 0.5))

ggsave("Users_Trips_Length.png")

#Average duration of the trips sorted by users
ggplot(all_data_clean_fv,
       aes(x = user_type, y = trip_length_hours, fill = user_type)) +
  stat_summary(fun = "mean", geom = "bar", size = 10) +
  scale_y_continuous(labels = comma, n.breaks = 10) +
  xlab("User Type") +
  ylab("Average Trip Length Hours") +
  labs(fill = "User Type Colors") +
  theme(axis.title.x = element_text(hjust = 0.5),
        axis.title.y = element_text(hjust = 0.5))
ggsave("Avg_Trips_Duration_Per_User.png")

# Definition of days of the week order
dias_ordem <-
  c(
    "segunda-feira",
    "terça-feira",
    "quarta-feira",
    "quinta-feira",
    "sexta-feira",
    "sábado",
    "domingo"
  )

# Converter the column day_of_week to right order
all_data_clean_fv$day_of_week <-
  factor(all_data_clean_fv$day_of_week, levels = dias_ordem)

#Days of the week use per User Type
ggplot(data = all_data_clean_fv) +
  geom_bar(mapping = aes(x = day_of_week, fill = user_type)) +
  scale_y_continuous(labels = comma, n.breaks = 10) +
  xlab("Days of the Week") +
  ylab("Uses") +
  facet_wrap(~ user_type) +
  theme(axis.text.x = element_text(angle = 90, size = 8))

ggsave("Days_Of_The_Week_Use_Per_User.png")