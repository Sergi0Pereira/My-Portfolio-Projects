# Databricks notebook source
# MAGIC %md
# MAGIC # How can the company improve collaboration?
# MAGIC
# MAGIC ## 📖 Background
# MAGIC You work in the analytics department of a multinational company, and the head of HR wants your help mapping out the company's employee network using message data. 
# MAGIC
# MAGIC They plan to use the network map to understand interdepartmental dynamics better and explore how the company shares information. The ultimate goal of this project is to think of ways to improve collaboration throughout the company. 
# MAGIC
# MAGIC ## 💾 The data
# MAGIC
# MAGIC The company has six months of information on inter-employee communication. For privacy reasons, only sender, receiver, and message length information are available [(source)](https://snap.stanford.edu/data/CollegeMsg.html). 
# MAGIC
# MAGIC #### Messages has information on the sender, receiver, and time.
# MAGIC - "sender" - represents the employee id of the employee sending the message.
# MAGIC - "receiver" - represents the employee id of the employee receiving the message.
# MAGIC - "timestamp" - the date of the message.
# MAGIC - "message_length" - the length in words of the message.
# MAGIC
# MAGIC #### Employees has information on each employee;
# MAGIC - "id" - represents the employee id of the employee.
# MAGIC - "department" - is the department within the company. 
# MAGIC - "location" - is the country where the employee lives.
# MAGIC - "age" - is the age of the employee.
# MAGIC
# MAGIC #### Insights to accomplish:
# MAGIC
# MAGIC - Which departments are the most/least active?
# MAGIC - Which employee has the most connections?
# MAGIC - Identify the most influential departments and employees.
# MAGIC - Using the network analysis, in which departments would you recommend the HR team focus to boost collaboration?
# MAGIC
# MAGIC _**Acknowledgments:** Pietro Panzarasa, Tore Opsahl, and Kathleen M. Carley. "Patterns and dynamics of users' behavior and interaction: Network analysis of an online community." Journal of the American Society for Information Science and Technology 60.5 (2009): 911-932._

# COMMAND ----------

from pyspark.sql.functions import *
from pyspark.sql import Window

# COMMAND ----------

# Load Data Function
def loadDf(fileName):
    dt = spark.read.format('delta').options(header='true').load(fileName)
    return dt

# COMMAND ----------

# employees
dtEmployees = loadDf("dbfs:/user/hive/warehouse/employees")

dtEmployees.show(n=40)

# COMMAND ----------

# employees
dtMessages = loadDf("dbfs:/user/hive/warehouse/messages")

dtMessages.show(40)

# COMMAND ----------

# MAGIC %md
# MAGIC #### Which departments are the most/least active?
# MAGIC #### Identify the most influential departments and employees.
# MAGIC

# COMMAND ----------

# Total Messages Sent by department
dtTMS = dtEmployees.join(dtMessages, dtEmployees.id == dtMessages.sender) \
    .groupBy(dtEmployees.department) \
    .agg(count(dtMessages.sender).alias("Total Messages Sent")) \
    .orderBy("Total Messages Sent",ascending=False)

dtTMS.show()

# COMMAND ----------

# Total Messages Sent by department
dtTMS = dtEmployees.join(dtMessages, dtEmployees.id == dtMessages.sender) \
    .groupBy(dtEmployees.department) \
    .agg(count(dtMessages.sender).alias("Total Messages Sent")) \
    .orderBy("Total Messages Sent",ascending=False)

dtTMS.show()

# COMMAND ----------

# Total Messages Sent by department
dtTMS = dtEmployees.join(dtMessages, dtEmployees.id == dtMessages.sender) \
    .groupBy(dtEmployees.department) \
    .agg(count(dtMessages.sender).alias("Total Messages Sent")) \
    .orderBy("Total Messages Sent",ascending=False)

dtTMS.show()

# COMMAND ----------

# Total Messages Received by department
dtTMR = dtEmployees.join(dtMessages, dtEmployees.id == dtMessages.receiver) \
    .groupBy(dtEmployees.department) \
    .agg(count(dtMessages.receiver).alias("Total Messages Received")) \
    .orderBy("Total Messages Received",ascending=False)

dtTMR.show()


# COMMAND ----------

# Total Messages ( Activity ) by department
dtTM = dtTMS.unionAll(dtTMR)

dtTMF = dtTM\
        .groupBy("department")\
        .agg(sum(col("Total Messages Sent")).alias("Total Messages"))\
        .orderBy("Total Messages",ascending=False)\
        .select("department",(col("Total Messages")))
       
dtTMF.show()

# COMMAND ----------

# MAGIC %md
# MAGIC #### Answer: The most active department is the Sales and the least is the Marketing
# MAGIC
# MAGIC

# COMMAND ----------

# MAGIC %md
# MAGIC #### Which employee has the most connections?

# COMMAND ----------

# Employees with more Emails sent to different employees
dtTmsId = dtEmployees.join(dtMessages, dtEmployees.id == dtMessages.sender) \
    .groupBy(dtEmployees.department,dtEmployees.id) \
    .agg(count(dtMessages.sender).alias("Emails_Sent"),
         countDistinct(dtMessages.receiver).alias("Unique_Emails_Adresses_Sent")) \
    .orderBy(col("Unique_Emails_Adresses_Sent").desc(),(col("Emails_sent").desc()))
    
dtTmsId.show()

# COMMAND ----------

# Employees with more Emails received from different employees
dtTmrId = dtEmployees.join(dtMessages, dtEmployees.id == dtMessages.receiver) \
    .groupBy(dtEmployees.department,dtEmployees.id) \
    .agg(count(dtMessages.receiver).alias("Emails_Received"),
         countDistinct(dtMessages.sender).alias("Unique_Emails_Adresses_Received")) \
    .orderBy(col("Unique_Emails_Adresses_Received").desc(),(col("Emails_Received").desc()))
    
dtTmrId.show()

# COMMAND ----------

# The Employees Connections
dtTmFId = dtTmrId.join(dtTmsId, dtTmsId.id == dtTmrId.id)\
        .groupBy(dtTmrId.id, dtTmrId.department,\
                dtTmsId.Emails_Sent,dtTmsId.Unique_Emails_Adresses_Sent,\
                dtTmrId.Emails_Received,dtTmrId.Unique_Emails_Adresses_Received) \
        .agg((dtTmsId.Unique_Emails_Adresses_Sent+dtTmrId.Unique_Emails_Adresses_Received).alias("Connections"))\
        .select(dtTmrId.id, dtTmrId.department,\
                dtTmsId.Emails_Sent,dtTmsId.Unique_Emails_Adresses_Sent,\
                dtTmrId.Emails_Received,dtTmrId.Unique_Emails_Adresses_Received,\
                col("Connections"))\
        .orderBy(col("Connections").desc())
        
dtTmFId.display()

# COMMAND ----------

# MAGIC %md
# MAGIC #### The employee that has the most connections (Sum of sent and received emails for different employees) is 598.
# MAGIC

# COMMAND ----------

# MAGIC %md
# MAGIC #### Identify the most influential departments and employees.

# COMMAND ----------

#Most influential departments (top 3)
dtMid = dtTmrId.join(dtTmsId, dtTmsId.id == dtTmrId.id)\
        .groupBy(dtTmrId.department)\
        .agg(sum(dtTmsId.Unique_Emails_Adresses_Sent+dtTmrId.Unique_Emails_Adresses_Received).alias("Connections"))\
        .orderBy(col("Connections").desc())\
        .limit(3)

dtMid.display()

# COMMAND ----------

#Most influential employees (top 3)
dtMie = dtTmrId.join(dtTmsId, dtTmsId.id == dtTmrId.id)\
        .groupBy(dtTmrId.id)\
        .agg(sum(dtTmsId.Unique_Emails_Adresses_Sent+dtTmrId.Unique_Emails_Adresses_Received).alias("Connections"))\
        .orderBy(col("Connections").desc())\
        .limit(3)

dtMie.display()

# COMMAND ----------

# MAGIC %md
# MAGIC #### The top 3 employees that have more influence on the company are 598,144,128.
# MAGIC #### The top 3 departments that have more influence on the company are Sales, Operations and Admin.

# COMMAND ----------

#Less influential departments (top 3)
dtMid = dtTmrId.join(dtTmsId, dtTmsId.id == dtTmrId.id)\
        .groupBy(dtTmrId.department)\
        .agg(sum(dtTmsId.Unique_Emails_Adresses_Sent+dtTmrId.Unique_Emails_Adresses_Received).alias("Connections"))\
        .orderBy(col("Connections").asc())\
        .limit(3)

dtMid.display()

# COMMAND ----------

# MAGIC %md
# MAGIC #### The departments that I recommend the HR team focus to boost collaboration are Enginnering,Marketing and IT.