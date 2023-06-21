# Databricks notebook source
from pyspark.sql.functions import *
from pyspark.sql import Window

# COMMAND ----------

# Load Data Function
def loadDf(fileName):
    dt = spark.read.format('delta').options(header='true').load(fileName)
    return dt

# COMMAND ----------

# Kiva Loans
dtKivaLoans = loadDf("dbfs:/user/hive/warehouse/kiva_loans_1_csv")

dtKivaLoans.display(n=40)

# - id: Unique ID of the loan
# - funded_amount: Total amount funded for the loan
# - loan_amount: Total amount of the loan requested by borrower
# - activity: The business or economic sector the loan supports
# - sector: Top-level sector the activity belongs to
# - use: The purpose of the loan (e.g. to purchase equipment)
# - country_code: Two-letter ISO country code of country in which loan was disbursed
# - country: Full country name in which loan was disbursed
# - region: Geographic region in which loan was disbursed
# - currency: Original currency of the loan
# - partner_id: ID of the field partner organization
# - posted_time: The date and time at which the loan was posted on Kiva
# - disbursed_time: The date and time at which the loan was disbursed by the field partner
# - funded_time: The date and time at which the loan was fully funded by Kiva lenders
# - term_in_months: Loan term (duration) in months
# - lender_count: The number of Kiva lenders who funded the loan
# - tags: Space-separated list of attributes and characteristics describing the loan
# - borrower_genders: Comma-separated list of genders of the borrowers
# - repayment_interval: Frequency at which the loan is repaid (e.g. monthly)
# - date


# Kiva Mpi Region Locations
dtKivaMpiRegionLocations = loadDf("dbfs:/user/hive/warehouse/kiva_mpi_region_locations")

# LocationName: name of the location
# ISO: ISO code for the location
# country: name of the country
# region: region within the country
# world_region: name of the world region (e.g. "Asia")
# MPI: Multidimensional Poverty Index (MPI) value for the location
# geo: geography of the location
# lat: latitude coordinate of the location
# lon: longitude coordinate of the location

dtKivaMpiRegionLocations.display(n=40)

# Loan Theme Ids
dtLoanThemeIds = loadDf("dbfs:/user/hive/warehouse/loan_theme_ids")

# id: Identifier of the loan (bigint)
# Loan Theme ID: Identifier of the loan theme (string)
# Loan Theme Type: Type of the loan theme (string)
# Partner ID: Identifier of the partner (double)

dtLoanThemeIds.display(n=40)

# Loan Themes By Region 
dtLoanThemesByRegion = loadDf("dbfs:/user/hive/warehouse/loan_themes_by_region")

# Partner ID: Identifier of the partner (bigint)
# Field Partner Name: Name of the field partner (string)
# Sector: Sector of the loan (string)
# Loan Theme ID: Identifier of the loan theme (string)
# Loan Theme Type: Type of the loan theme (string)
# Country: Name of the country (string)
# Forkiva: Forkiva information (string)
# Region: Region of the location (string)
# Geocode Old: Old geocode information (string)
# ISO: ISO code for the location (string)
# Number: Number identifier (bigint)
# Amount: Amount of the loan (bigint)
# LocationName: Name of the location (string)
# Geocode: Geocode information (string)
# Names: Names information (string)
# Geo: Geography information (string)
# Lat: Latitude coordinate of the location (double)
# Lon: Longitude coordinate of the location (double)
# MPI Region: Region of the MPI (string)
# MPI Geo: Geography of the MPI (string)

dtLoanThemesByRegion.display(n=40)

# COMMAND ----------

# For the locations in which Kiva has active loans, your objective is to pair Kiva's 
# data with additional data sources to estimate the welfare level of borrowers in specific
# regions, based on shared economic and demographic characteristics.

# COMMAND ----------

# 1. What is the difference in the distribution of loans and MPI by country for each region?
dtKivaLoansByCountry = dtKivaLoans \
    .join(dtKivaMpiRegionLocations, ["country", "region"], "inner") \
    .groupBy("country","region") \
    .agg(count("id").alias("Number of Loans"),avg("MPI").alias("MPI_avg")) \
    .orderBy(desc("MPI_avg"),desc("Number of Loans")) \
    .select("country", "region","Number of Loans", "MPI_avg")


dtKivaLoansByCountry.display(n=40)



# COMMAND ----------

# 1. What is the difference in the distribution of loans and MPI by gender and sector?
# Explode and split used because one row can have more than one person
dtKivaLoansByCountry = dtKivaLoans \
    .join(dtKivaMpiRegionLocations, ["country", "region"], "inner") \
    .withColumn("gender", explode(split(col("borrower_genders"), ", "))) \
    .groupBy("country") \
    .agg(
        avg("MPI").alias("MPI_avg"),
        count(when(col("gender") == "male", 1)).alias("Male_Count"),
        count(when(col("gender") == "female", 1)).alias("Female_Count")
    ) \
    .select("country", "MPI_avg", "Male_Count", "Female_Count")


dtKivaLoansByCountry.display(n=40)