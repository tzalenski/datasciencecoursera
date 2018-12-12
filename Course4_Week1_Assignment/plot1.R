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

# 3rd: create histogram of Global_active_power
kilowatts <- as.numeric(df_2days$Global_active_power)
hist( kilowatts, breaks=12, col="red", xlab="Global Active Power (kilowatts)", main="Global Active Power" )

# 4th: Save to plot1.png
dev.copy( png, "plot1.png" )
dev.off()
