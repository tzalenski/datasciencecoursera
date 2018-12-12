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

# 3rd: create four plots:
# 1. Global_active_power vs. Time (upper left)
# 2. Voltage vs. Time (upper right)
# 3. Energy sub metering vs. Time (lower left)
# 4. Global_reactive_power vs. Time (lower right)
gbl_actv_pwr <- as.numeric( df_2days$Global_active_power )
sub_mtr_1    <- as.numeric( df_2days$Sub_metering_1 )
sub_mtr_2    <- as.numeric( df_2days$Sub_metering_2 )
sub_mtr_3    <- as.numeric( df_2days$Sub_metering_3 )
voltage      <- as.numeric( df_2days$Voltage )
gbl_rctv_pwr <- as.numeric( df_2days$Global_reactive_power )
date_time    <- dmy_hms(paste(df_2days$Date,df_2days$Time))

par( mfrow = c(2,2) )   # 2 rows and 2 columns

# create plot of Global_active_power vs. time
plot( date_time, gbl_actv_pwr, type="l", xlab="", ylab="Global Active Power" )

# create plot of voltage vs. time
plot( date_time, voltage, type="l", xlab="datetime", ylab="Voltage" )

# create plot of sub metering vs. Time
plot( date_time, sub_mtr_1, type="l", xlab="", ylab="Energy sub metering" )
points( date_time, sub_mtr_2, type="l", col="red" )
points( date_time, sub_mtr_3, type="l", col="blue" )
legend( "topright", # location
         bty="n",                     # no border
         legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), # variable names
         lty=c(1,1,1),                # gives the legend appropriate symbols (lines)
         lwd=c(2.5,2.5,2.5),          # set line width
         col=c("black","red","blue")) # set line colors

# create plot of global reactive power vs time
plot( date_time, gbl_rctv_pwr, type="l", xlab="datetime", ylab="Global_active_power" )



# 4th: Save to plot4.png
dev.copy( png, "plot4.png" )
dev.off()
