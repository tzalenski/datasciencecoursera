# Fine particulate matter (PM2.5) is an ambient air pollutant for which there is
# strong evidence that it is harmful to human health. In the United States, the 
# Environmental Protection Agency (EPA) is tasked with setting national ambient air 
# quality standards for fine PM and for tracking the emissions of this pollutant 
# into the atmosphere. Approximatly every 3 years, the EPA releases its database 
# on emissions of PM2.5. This database is known as the National Emissions Inventory 
# (NEI). You can read more information about the NEI at the EPA National Emissions 
# Inventory web site.
# 
#      http://www.epa.gov/ttn/chief/eiinformation.html
# 
# For each year and for each type of PM source, the NEI records how many tons of 
# PM2.5 were emitted from that source over the course of the entire year. The data 
# that you will use for this assignment are for 1999, 2002, 2005, and 2008.
# Review criteria
# 
# Data
# 
# The data for this assignment are available from the course web site as a single zip file:
# 
#     Data for Peer Assessment [29Mb]  
# 
# The zip file contains two files:
# 
# PM2.5 Emissions Data (summarySCC_PM25.rds): 
# This file contains a data frame with all of the PM2.5 emissions data for 1999, 
# 2002, 2005, and 2008. For each year, the table contains number of tons of PM2.5 
# emitted from a specific type of source for the entire year. Here are the first 
# few rows.
# 
# ##     fips      SCC Pollutant Emissions  type year
# ## 4  09001 10100401  PM25-PRI    15.714 POINT 1999
# ## 8  09001 10100404  PM25-PRI   234.178 POINT 1999
# ## 12 09001 10100501  PM25-PRI     0.128 POINT 1999
# ## 16 09001 10200401  PM25-PRI     2.036 POINT 1999
# ## 20 09001 10200504  PM25-PRI     0.388 POINT 1999
# ## 24 09001 10200602  PM25-PRI     1.490 POINT 1999
# 
#     fips:      A five-digit number (represented as a string) indicating the U.S. county
#     SCC:       The name of the source as indicated by a digit string (see source code classification table)
#     Pollutant: A string indicating the pollutant
#     Emissions: Amount of PM2.5 emitted, in tons
#     type:      The type of source (point, non-point, on-road, or non-road)
#     year:      The year of emissions recorded
# 
# Source Classification Code Table (Source_Classification_Code.rds): 
# This table provides a mapping from the SCC digit strings in the Emissions table 
# to the actual name of the PM2.5 source. The sources are categorized in a few 
# different ways from more general to more specific and you may choose to explore 
# whatever categories you think are most useful. For example, source "10100101" is 
# known as "Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal".
# 
#  Question being asked: 
#  6. Compare emissions from motor vehicle sources in Baltimore City with emissions 
#     from motor vehicle sources in Los Angeles County, California (fips == "06037").
#     Which city has seen greater changes over time in motor vehicle emissions?
    
    
library(data.table)
library(lubridate)
library(dplyr)
library(ggplot2)

# 1st: download and unzip data file
data_file_url   <- URLdecode("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip")
download.file( data_file_url, zip_filename, mode="wb")
unzip("exdata_data_NEI_data.zip")

# 2nd: read both files into data frames
NEI_df <- readRDS("summarySCC_PM25.rds")
SCC_df <- readRDS("Source_Classification_Code.rds")

# 3rd: Find subset of classification codes for motor vehicle emissions
motorVeicles <- filter( SCC_df, grepl( "Vehicles", EI.Sector))

# 4th: create subset for motor vehicle emissions in:
# 1. Baltimore City, Maryland (fips == "24510") 
# 2. Los Angeles County, California (fips == "06037")
motorVehicleSubset <- filter( NEI_df, (fips == "24510" | fips == "06037") & SCC %in% motorVeicles$SCC )

# 5th: sum PM2.5 per year
total_PM25_per_year <- with( motorVehicleSubset, aggregate( x=Emissions, by=list(year,fips), FUN=sum ))

# 6th:: plot totals (y-axis) by year (x-axis)
ggplot( data=total_PM25_per_year, aes(x = Group.1, y = x, group=Group.2)) +
    geom_line(  aes(color=Group.2) ) +
    geom_point( aes(color=Group.2) ) +   
    ylab("Total PM2.5 per year") + 
    xlab("Year") +
    ggtitle("Motor Vehicle Emissions") +
    scale_colour_discrete( name  ="City",
                           breaks=c("24510", "06037"),
                           labels=c("Baltimore, Maryland", "Los Angeles, California"))

# 7th: Save to plot6.png
dev.copy( png, "plot6.png" )
dev.off()
