library(data.table)
library(lubridate)
library(dplyr)

# 1st: download and read compressed data file
data_file_url <- URLdecode("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip")

zip_filename   <- "household_power_consumption.zip" 
unzip_filename <- "household_power_consumption.txt"

download.file( data_file_url, zip_filename, mode="wb")
df <- read.table( unz(zip_filename, unzip_filename), header=TRUE, sep=";", colClasses="character")


# 2nd: extract data between 2007-02-01 and 2007-02-02
df_2days <- filter( df, dmy(df$Date) >= as.Date("2007-02-01") & dmy(df$Date) <= as.Date("2007-02-02"))

# 3rd: create plot of each sub metering vs. time
sub_mtr_1 <- as.numeric( df_2days$Sub_metering_1 )
sub_mtr_2 <- as.numeric( df_2days$Sub_metering_2 )
sub_mtr_3 <- as.numeric( df_2days$Sub_metering_3 )
date_time <- dmy_hms(paste(df_2days$Date,df_2days$Time))

plot( date_time, sub_mtr_1, type="l", xlab="", ylab="Energy sub metering" )
points( date_time, sub_mtr_2, type="l", col="red" )
points( date_time, sub_mtr_3, type="l", col="blue" )
legend( "topright", # location
         legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), # variable names
         lty=c(1,1,1),                # gives the legend appropriate symbols (lines)
         lwd=c(2.5,2.5,2.5),          # set line width
         col=c("black","red","blue")) # set line colors


# 4th: Save to plot3.png
dev.copy( png, "plot3.png" )
dev.off()
