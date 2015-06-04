install.packages("lubridate")
install.packages("ggplot2")
#Connect to libraries
library("sqldf")
library("RPostgreSQL")
# a library that is convenient for data time convertion   
library("lubridate")
#Set options -- This might be redundant with the dbConnect function below
options(sqldf.RPostgreSQL.user ="member", 
        sqldf.RPostgreSQL.password ="lovepg",
        sqldf.RPostgreSQL.dbname ="postgres",
        sqldf.RPostgreSQL.host ="localhost", 
        sqldf.RPostgreSQL.port =5432)
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host='localhost', port='5432', dbname="postgres",user="member",password="lovepg")

# Returns a list of column names in the table 
dbListFields(con,"arrival")

#Simple Query
myTable <- sqldf("SELECT * FROM arrival LIMIT 10")

# dbGetQuery function is from RPostgreSQL package
# detailed documentation can be found from here: 
#   https://code.google.com/p/rpostgresql/
test <- dbGetQuery(con,"select * from arrival LIMIT 10")
# convert epoch time to Data-Time Classes (POSIXct) at time zone Pacific daylight Time for predicted_arrival 
# List of valid time zone to use: http://en.wikipedia.org/wiki/List_of_tz_database_time_zones
test$predicted_arrival <- format(as.POSIXct(test$predicted_arrival*0.001, origin="1970-01-01"), tz="America/Los_Angeles",usetz=TRUE)
test$scheduled_arrival <- format(as.POSIXct(test$scheduled_arrival*0.001, origin="1970-01-01"), tz="America/Los_Angeles",usetz=TRUE)
test$timestamp <- format(as.POSIXct(test$timestamp*0.001, origin="1970-01-01"), tz="America/Los_Angeles",usetz=TRUE)
# get hour from the timestamp when we collected the data 
test$timehourly <- hour(test$timestamp)

########## Initial Statistic Analysis ##############
# eliminated space that caused error, space might be due to copy and past
# SQL Statement extract hour in the day and standard deviation of delays and average delay 
mydata <- dbGetQuery(con, "SELECT EXTRACT(HOUR FROM TIMESTAMP WITH TIME ZONE 'epoch' + timestamp * INTERVAL '1 millisecond' - interval '7 hour'), count(*), TO_CHAR((stddev_samp(predicted_arrival - scheduled_arrival) || 'millisecond')::interval, 'HH24:MI:SS') AS STDDEV_DELAY, TO_CHAR((avg(predicted_arrival - scheduled_arrival) || 'millisecond')::interval, 'HH24:MI:SS') AS AVG_DELAY FROM arrival AS a, weather AS w WHERE a.weather_id = w.weather_id AND predicted_arrival - scheduled_arrival > 0 GROUP BY EXTRACT(HOUR FROM TIMESTAMP WITH TIME ZONE 'epoch' + timestamp * INTERVAL '1 millisecond' - interval '7 hour')")

# pull raw data on the every late arrivals: stopid, routeid, route_name, trip_id, predicted_arrival, scheduled_arrival, timestamp
data <- dbGetQuery(con, "SELECT stopid, routeid, route_name, timestamp, predicted_arrival, scheduled_arrival, predicted_arrival - scheduled_arrival as delay FROM arrival WHERE predicted_arrival - scheduled_arrival > 0")
head(data)
# all time variables are numeric 
class(data$delay)
class(data$timestamp)

# convert timestamp to a actual time in a day for chi squred test 
data$timestamp <- format(as.POSIXct(data$timestamp*0.001, origin="1970-01-01"), tz="America/Los_Angeles",usetz=TRUE)
# extract hour from time we collected data and saved in timehourly column 
data$timehourly <- hour(data$timestamp)

# calculate delay in minutes from millisecond and save it as delay_minutes
data$delay_minutes <- format(round(data$delay/1000/60, 2), nsmall = 2)
# convert delay_minutes from character to numeric 
data$delay_minutes <- as.numeric(data$delay_minutes)
# histogram of the delay frequency 
hist(data$delay_minutes)

# max delay in minutes is 160 minutes, it causes the histogram skewed to the right 
summary(data$delay_minutes)
# limit the delay minutes range to 0 to 10 minutes for a close up look into the data distribution 
hist(data$delay_minutes, breaks = 200, xlab="Delay in Minutes", ylab="Frequency", main="Delay Frequency Histogram", xlim=c(0,50))
boxplot(data$delay_minutes ~ data$timehourly, data=data, ylim=c(0,15), xlab="Time in Hour", ylab="Delay in Minutes", main="Hourly ")
# get average delay in minutes for each hour 
means <- tapply(data$delay_minutes, data$timehourly,mean)
# plot the mean for each hour on the boxplot marked red 
points(means,col="red",pch=18)

# analysis on time series: https://media.readthedocs.org/pdf/a-little-book-of-r-for-time-series/latest/a-little-book-of-r-for-time-series.pdf


# class of average delay is character, and need to convert to date time in R 
class(mydata$avg_delay)
mydata$avg_delay <- strptime(mydata$avg_delay, "%H:%M:%S")
class(mydata$date_part)
plot(mydata$date_part,mydata$avg_delay)
hoursOfDay <- mydata$date_part
avg_delay <- mydata$avg_delay
# Error: is.atomic(x) is not TRUE
t.test(mydata$date_part, mydata$avg_delay)

########## Testing code to convert epoch time (in millisecond) to Data #########
val <- test$predicted_arrival[1]
# convert epoch time to human readable Data Time 
testTime <- as.POSIXct(val*0.001, origin="1970-01-01", tz="UTC")
# convert UTC to Pacific Time 
testTimePDT <- format(testTime, tz="America/Los_Angeles",usetz=TRUE)
# get hour 
hour(testTimePDT)

###### REFERENCE SQL CODE #####
# SQL that groups by Pacific time and gives us STD, Mean from arrivals
# SELECT EXTRACT(HOUR FROM TIMESTAMP WITH TIME ZONE 'epoch' + timestamp * INTERVAL '1 millisecond' - interval '7 hour'), count(*), TO_CHAR((stddev_samp(predicted_arrival - scheduled_arrival) || 'millisecond')::i nterval, 'HH24:MI:SS') AS STDDEV_DELAY, TO_CHAR((avg(predicted_arrival - scheduled_arrival) || 'millisecond'): :interval, 'HH24:MI:SS') AS AVG_DELAY FROM arrival AS a, weather AS w WHERE a.weather_id = w.weather_id AND pr edicted_arrival - scheduled_arrival > 0 GROUP BY EXTRACT(HOUR FROM TIMESTAMP WITH TIME ZONE 'epoch' + timestam p * INTERVAL '1 millisecond' - interval '7 hour');
#
#

############ Close PostgreSQL Connection ############
# Close PostgreSQL connection 
# PLEASE PLEASE DO NOT SKIP THIS!
dbDisconnect(con)
