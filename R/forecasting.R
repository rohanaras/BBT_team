install.packages("xts")
library("xts")
library("forecast")
time_index <- seq(from = as.POSIXct("2015-05-24 00:00"), to = as.POSIXct("2015-05-24 23:00"), by = "hour")
time_index

data
# associate each data point to the time in time index
delays <- xts(data, order.by=time_index)
delays
plot(delays)
delayscomponents <- decompose(delays)
delayforecasts <- HoltWinters(delays, beta=FALSE, gamma=FALSE)
delayforecasts
delayforecasts$fitted
plot(delayforecasts)
# A measure of the accuracy of the forecasts, we can calculate the sum of squared errors for the in-sample
#  forecast errors, that is, the forecast errors for the time period covered by our original time series. 
delayforecasts$SSE

# Make forecasts for further time points by using the
# “forecast.HoltWinters()” function in the R “forecast” package.  
#  make a forecast of delays for the time 12am-11pm (24 more hours) using forecast.HoltWinters()
delayforecasts2 <- forecast.HoltWinters(delayforecasts, h=4)
plot.forecast(delayforecasts2)

# delays2.csv contains hourly average delay from 2015-05-23 07:00 to 2015-05-28 16:00
delaydata <- read.csv("/Users/zhuqi/Documents/info370/BBT_team/delays2.csv",header=FALSE)
# specify the time range 
time_index <- seq(from = as.POSIXct("2015-05-23 07:00"), to = as.POSIXct("2015-05-28 16:00"), by = "hour")
length(time_index)
length(delaydata)
# put each delay point into the corresponding time it was collected 
delays2 <- xts(delaydata, order.by=time_index)
plot(delays2, main="Average Delay in Minutes Over Time", xlab="Time", ylab="Average Delay in Minutes")

fit <- ets(delays2)
plot(forecast(fit))
plot(fit)

delaytimeseries <- ts(delays2, frequency=24, start=c(0523,7))
plot(delaytimeseries)

# A seasonal time series consists of a trend component, a seasonal component and an irregular component. Decomposing
# the time series means separating the time series into these three components: that is, estimating these three
# components.
delayscomponents2 <- decompose(delaytimeseries)
plot(delayscomponents2)

delayforecasts2 <- HoltWinters(delaytimeseries, beta=FALSE, gamma=FALSE)
delayforecasts2

delayforecasts2$fitted
plot(delayforecasts2)
# A measure of the accuracy of the forecasts, we can calculate the sum of squared errors for the in-sample
#  forecast errors, that is, the forecast errors for the time period covered by our original time series. 
delayforecasts2$SSE

# Make forecasts for further time points by using the
# “forecast.HoltWinters()” function in the R “forecast” package.  
#  make a forecast of delays for the time 12am-11pm (8 more hours) using forecast.HoltWinters()
delayforecasts3 <- forecast.HoltWinters(delayforecasts2, h=8)
plot.forecast(delayforecasts3, main="Forecasting Average Delay In Next 8 Hours", xlab="day (MonthDay)", ylab="Average delay in minutes")
