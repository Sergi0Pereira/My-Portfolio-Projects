%md

# Football Data Analysis Project

This project involves analyzing football data to gain insights into team performance and scoring patterns. The data includes information about matches, teams, goals, and season details.

## Data Description

The dataset consists of the following columns:

- **Match_ID**: Unique identifier of the match.
- **Div**: Division of the league in which the match took place.
- **Season**: Season in which the match was played.
- **Date**: Date of the match.
- **HomeTeam**: Home team.
- **AwayTeam**: Away team.
- **FTHG**: Number of goals scored by the home team at the end of the match.
- **FTAG**: Number of goals scored by the away team at the end of the match.
- **FTR**: Final result of the match: 'H' (home team victory), 'A' (away team victory), or 'D' (draw).

## Data Analysis Steps

The analysis is performed using PySpark, a powerful data processing framework. Here are the key steps involved in the analysis:

1. **Calculating Home Team Points**: 
   - Filter the matches to select those from Division "D1" and seasons between 2007 and 2016.
   - Group the matches by HomeTeam and Season.
   - Calculate the sum of points based on the match result (H, D, or A).
   - Order the results by Season and points.

2. **Calculating Away Team Points**: 
   - Filter the matches to select those from Division "D1" and seasons between 2007 and 2016.
   - Group the matches by AwayTeam and Season.
   - Calculate the sum of points based on the match result (H, D, or A).
   - Order the results by Season and points.

3. **Total Points Calculation**: 
   - Combine the home team points and away team points using the union operation to create a unified points table.

4. **Classification of Teams**: 
   - Group the total points table by HomeTeam and Season.
   - Calculate the sum of points for each team in each season.
   - Order the results by Season and total points.

5. **Adding Position Column**: 
   - Define a window partitioned by Season and ordered by total points.
   - Add the "Position" column to the classification table using the row_number function over the window.
   - Display the classification table, showing the team, season, total points, and position.

6. **Selecting Winner Teams**: 
   - Add the "row_number" column to the classification table using the row_number function over the window.
   - Filter the classification table to select the teams with the highest total points in each season (where row_number is equal to 1).
   - Select the team, season, and total points columns.
   - Drop the "row_number" column.
   - Display the winners' table, showing the team, season, and total points.

7. **Scoring Goals Analysis**:
   - Calculate the home goals scored by each team in each season.
   - Group the matches by HomeTeam and Season.
   - Calculate the sum of FTHG (home goals).
   - Order the results by home goals in descending order.
   - Calculate the away goals scored by each team in each season.
   - Group the matches by AwayTeam and Season.
   - Calculate the sum of FTAG (away goals).
   - Order the results by away goals in descending order.

8. **Total Goals Calculation**:
   - Join the home goals and away goals tables on the team and season columns using an inner join.
   - Add the "Total Goals" column by summing the home goals and away goals.
   - Display the

 results, showing the team, home goals, away goals, season, and total goals.
