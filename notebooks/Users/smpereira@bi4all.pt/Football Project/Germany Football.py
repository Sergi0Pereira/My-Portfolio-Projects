# Databricks notebook source
# MAGIC %md
# MAGIC
# MAGIC # Football Data Analysis Project
# MAGIC
# MAGIC This project involves analyzing football data to gain insights into team performance and scoring patterns. The data includes information about matches, teams, goals, and season details.
# MAGIC
# MAGIC ## Data Description
# MAGIC
# MAGIC The dataset consists of the following columns:
# MAGIC
# MAGIC - **Match_ID**: Unique identifier of the match.
# MAGIC - **Div**: Division of the league in which the match took place.
# MAGIC - **Season**: Season in which the match was played.
# MAGIC - **Date**: Date of the match.
# MAGIC - **HomeTeam**: Home team.
# MAGIC - **AwayTeam**: Away team.
# MAGIC - **FTHG**: Number of goals scored by the home team at the end of the match.
# MAGIC - **FTAG**: Number of goals scored by the away team at the end of the match.
# MAGIC - **FTR**: Final result of the match: 'H' (home team victory), 'A' (away team victory), or 'D' (draw).
# MAGIC
# MAGIC ## Data Analysis Steps
# MAGIC
# MAGIC The analysis is performed using PySpark, a powerful data processing framework. Here are the key steps involved in the analysis:
# MAGIC
# MAGIC 1. **Calculating Home Team Points**: 
# MAGIC    - Filter the matches to select those from Division "D1" and seasons between 2007 and 2016.
# MAGIC    - Group the matches by HomeTeam and Season.
# MAGIC    - Calculate the sum of points based on the match result (H, D, or A).
# MAGIC    - Order the results by Season and points.
# MAGIC
# MAGIC 2. **Calculating Away Team Points**: 
# MAGIC    - Filter the matches to select those from Division "D1" and seasons between 2007 and 2016.
# MAGIC    - Group the matches by AwayTeam and Season.
# MAGIC    - Calculate the sum of points based on the match result (H, D, or A).
# MAGIC    - Order the results by Season and points.
# MAGIC
# MAGIC 3. **Total Points Calculation**: 
# MAGIC    - Combine the home team points and away team points using the union operation to create a unified points table.
# MAGIC
# MAGIC 4. **Classification of Teams**: 
# MAGIC    - Group the total points table by HomeTeam and Season.
# MAGIC    - Calculate the sum of points for each team in each season.
# MAGIC    - Order the results by Season and total points.
# MAGIC
# MAGIC 5. **Adding Position Column**: 
# MAGIC    - Define a window partitioned by Season and ordered by total points.
# MAGIC    - Add the "Position" column to the classification table using the row_number function over the window.
# MAGIC    - Display the classification table, showing the team, season, total points, and position.
# MAGIC
# MAGIC 6. **Selecting Winner Teams**: 
# MAGIC    - Add the "row_number" column to the classification table using the row_number function over the window.
# MAGIC    - Filter the classification table to select the teams with the highest total points in each season (where row_number is equal to 1).
# MAGIC    - Select the team, season, and total points columns.
# MAGIC    - Drop the "row_number" column.
# MAGIC    - Display the winners' table, showing the team, season, and total points.
# MAGIC
# MAGIC 7. **Scoring Goals Analysis**:
# MAGIC    - Calculate the home goals scored by each team in each season.
# MAGIC    - Group the matches by HomeTeam and Season.
# MAGIC    - Calculate the sum of FTHG (home goals).
# MAGIC    - Order the results by home goals in descending order.
# MAGIC    - Calculate the away goals scored by each team in each season.
# MAGIC    - Group the matches by AwayTeam and Season.
# MAGIC    - Calculate the sum of FTAG (away goals).
# MAGIC    - Order the results by away goals in descending order.
# MAGIC
# MAGIC 8. **Total Goals Calculation**:
# MAGIC    - Join the home goals and away goals tables on the team and season columns using an inner join.
# MAGIC    - Add the "Total Goals" column by summing the home goals and away goals.
# MAGIC    - Display the
# MAGIC
# MAGIC  results, showing the team, home goals, away goals, season, and total goals.
# MAGIC
# MAGIC Ps. All the outputs are limited to 40 rows, except for the dtClassification table, to facilitate visualization.
# MAGIC

# COMMAND ----------

from pyspark.sql.functions import *
from pyspark.sql import Window

# COMMAND ----------

# Load Data Function
def loadDf(fileName):
    dt = spark.read.format('delta').options(header='true').load(fileName)
    return dt


# COMMAND ----------

# Matches

dtMatches = loadDf("dbfs:/user/hive/warehouse/matches")

dtMatches.display()

# Match_ID: Unique identifier of the match.
# Div: Division of the league in which the game took place.
# Season: Season in which the game was held.
# Date: Date of the game.
# HomeTeam: Home team.
# AwayTeam: Away team.
# FTHG: Number of goals scored by the home team (HomeTeam) at the end of the match.
# FTAG: Number of goals scored by the away team (AwayTeam) at the end of the match.
# FTR: Final result of the match. It can be 'H' (home team victory), 'A' (away team victory), or 'D' (draw).



# COMMAND ----------

# Filter matches where "Div" is "D1" and "Season" is between 2007 and 2016
dtHomePoints = (
    dtMatches
    .filter((col("Div") == "D1") & col("Season").between(2007, 2016))
    .groupBy("HomeTeam", "Season")
    .agg(
        sum(when(col("FTR") == "H", 3).when(col("FTR") == "D", 1).otherwise(0)).alias("Points")
    )
    .orderBy("Season", desc("Points"))
    .select("HomeTeam", "Season", "Points")
)

# Display dtHomePoints table
dtHomePoints.show(n=40)



# COMMAND ----------

# Filter matches where "Div" is "D1" and "Season" is between 2007 and 2016
dtAwayPoints = (
    dtMatches
    .filter((col("Div") == "D1") & col("Season").between(2007, 2016))
    .groupBy("AwayTeam", "Season")
    .agg(
        sum(when(col("FTR") == "A", 3).when(col("FTR") == "D", 1).otherwise(0)).alias("Points")
    )
    .orderBy("Season", desc("Points"))
    .select("AwayTeam", "Season", "Points")
)

# Display dtAwayPoints table
dtAwayPoints.show(n=40)



# COMMAND ----------

# Union of the all points made by HomeTeam and AwayTeam
dtTotalPoints = dtHomePoints.unionAll(dtAwayPoints)

# Group by "HomeTeam" and "Season", aggregate sum of "Points" as "Total Points"
# Order by "Season" and "Total Points" in descending order
# Select columns "HomeTeam" as "Team", "Season", and "Total Points"

dtClassification = (
    dtTotalPoints
    .groupBy("HomeTeam", "Season")
    .agg(sum("Points").alias("Total Points"))
    .orderBy("Season", desc("Total Points"))
    .select(col("HomeTeam").alias("Team"), "Season", "Total Points")
)

# Display dtClassification table
dtClassification.show(n=40)

# Defines and order the partition window by "Total Points" and "Season"
window = Window.partitionBy("Season").orderBy(col("Total Points").desc())

# Adds the column "row_number" to dtClassification
winnerDt = dtClassification.withColumn("row_number", row_number().over(window))

# Filters the Winners (where the registry of the line is equal to one)
# Selects columns "Team", "Season", and "Total Points"
# Drops the column "row_number"

winnerDt = (
    dtClassification
    .withColumn("row_number", row_number().over(window))
    .filter(col("row_number") == 1)
    .select("Team", "Season", "Total Points")
    .drop("row_number")
)

# Display winnerDt table without truncating column values
winnerDt.display(truncate=False)


# COMMAND ----------

# Filter dtMatches for Div "D1", group by HomeTeam and Season, and calculate the sum of FTHG as "Home Goals"

dtScoredGoalsHome = (
    dtMatches
    .filter(col("Div") == "D1")
    .groupBy("HomeTeam", "Season")
    .agg(
        sum(col("FTHG")).alias("Home Goals"),
    )
    .select(
        col("HomeTeam").alias("Team"),  # Rename HomeTeam column to Team
        col("Home Goals"),
        col("Season")
    )
    .orderBy(desc("Home Goals"))  # Order by Home Goals in descending order
)

# Display dtScoredGoalsHome table
dtScoredGoalsHome.show(n=40)


# COMMAND ----------

# Filter dtMatches for Div equal to "D1", group by "AwayTeam" and "Season", aggregate sum of "FTAG" as "Away Goals"
# Select columns "AwayTeam" as "Team", "Away Goals", and alias "Season" as "Season"
# Order by "Away Goals" in descending order

dtScoredGoalsAway = (
    dtMatches
    .filter(col("Div") == "D1")
    .groupBy("AwayTeam", "Season")
    .agg(
        sum(col("FTAG")).alias("Away Goals"),
    )
    .select(
        col("AwayTeam").alias("Team"),
        col("Away Goals"),
        col("Season").alias("Season")
    )
    .orderBy(desc("Away Goals"))
)

# Display dtScoredGoalsAway table
dtScoredGoalsAway.show(n=40)


# COMMAND ----------

# Filter dtMatches for Div "D1", group by HomeTeam and Season, and calculate the sum of FTHG as "Home Goals"
dtConcededGoalsHome = (
    dtMatches
    .filter(col("Div") == "D1")
    .groupBy("HomeTeam", "Season")
    .agg(
        sum(col("FTAG")).alias("Home Conceded Goals"),
    )
    .select(
        col("HomeTeam").alias("Team"),  # Rename HomeTeam column to Team
        col("Home Conceded Goals"),
        col("Season")
    )
    .orderBy(desc("Home Conceded Goals"))  # Order by Home Goals in descending order
)

# Display dtScoredGoalsHome table
dtConcededGoalsHome.show(n=40)

# COMMAND ----------

# Filter dtMatches for Div equal to "D1", group by "AwayTeam" and "Season", aggregate sum of "FTAG" as "Away Goals"
# Select columns "AwayTeam" as "Team", "Away Goals", and alias "Season" as "Season"
# Order by "Away Goals" in descending order

dtConcededGoalsAway = (
    dtMatches
    .filter(col("Div") == "D1")
    .groupBy("AwayTeam", "Season")
    .agg(
        sum(col("FTHG")).alias("Away Conceded Goals"),
    )
    .select(
        col("AwayTeam").alias("Team"),
        col("Away Conceded Goals"),
        col("Season").alias("Season")
    )
    .orderBy(desc("Away Conceded Goals"))
)

# Display dtScoredGoalsAway table
dtConcededGoalsAway.show(n=40)

# COMMAND ----------

# Filter dtScoredGoalsHome for Season not equal to 2017, select columns "Team", "Home Goals", "Season"
# Join with dtScoredGoalsAway on columns "Team" and "Season" using inner join
# Add a new column "Total Goals" by summing "Home Goals" and "Away Goals"

dtScoredGoals = (
                dtScoredGoalsHome
                .filter(col("Season") != 2017)
                .select("Team", "Home Goals", "Season")
                .join(dtScoredGoalsAway, ["Team", "Season"], "inner")
                .withColumn("Total Goals", col("Home Goals") + col("Away Goals"))
        )

# Display dtScoredGoals table
dtScoredGoals.show(n=40)


# COMMAND ----------

dtConcededGoals = (
    dtConcededGoalsHome
    .filter(col("Season") != 2017)
    .join(dtConcededGoalsAway, ["Team", "Season"], "inner")
    .withColumn("Total Conceded Goals", col("Home Conceded Goals") + col("Away Conceded Goals"))
    .select("Team", "Home Conceded Goals", "Away Conceded Goals","Total Conceded Goals","Season")
)
# Display dtScoredGoals table
dtConcededGoals.show(n=40)

# COMMAND ----------

# Defines and orders the partition window by the Total Points and Season
window = Window.partitionBy("Season").orderBy(col("Total Points").desc())

# Adds the Column "Position" to dtClassification
dtClassification = dtClassification.withColumn("Position", row_number().over(window))

# Joins dtScoredGoals with dtClassification and orders by Season and Total Points in descending order
dtFinalTable = dtScoredGoals.join(dtClassification, ["Team", "Season"])\
                .join(dtConcededGoals,["Team", "Season"])\
                .orderBy("Season", desc("Total Points"))

# Selects all columns from dtFinalTable except 'Position'
columns = [c for c in dtFinalTable.columns if c != 'Position']

# Reorders the columns with 'Position' as the first column
dtFinalTable = dtFinalTable.select(col('Position'), *columns)

# Displays the final table
dtFinalTable.show(n=40)
