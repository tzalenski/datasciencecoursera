# One of the most exciting areas in all of data science right now is wearable
# computing - see for example this article . Companies like Fitbit, Nike, and
# Jawbone Up are racing to develop the most advanced algorithms to attract new
# users. The data linked to from the course website represent data collected from
# the accelerometers from the Samsung Galaxy S II smartphone. 
# 
# The experiments have been carried out with a group of 30 volunteers within an
# age bracket of 19-48 years. Each person performed six activities 
# (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) 
# wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded 
# accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial 
# angular velocity at a constant rate of 50Hz. The experiments have been 
# video-recorded to label the data manually. The obtained dataset has been 
# randomly partitioned into two sets, where 70% of the volunteers was selected for 
# generating the training data and 30% the test data. 
# 
# The sensor signals (accelerometer and gyroscope) were pre-processed by applying 
# noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 
# 50% overlap (128 readings/window). The sensor acceleration signal, which has 
# gravitational and body motion components, was separated using a Butterworth 
# low-pass filter into body acceleration and gravity. The gravitational force is 
# assumed to have only low frequency components, therefore a filter with 0.3 Hz 
# cutoff frequency was used. From each window, a vector of features was obtained 
# by calculating variables from the time and frequency domain. 
# See 'features_info.txt' for more details. 
# 
# For each record it is provided:
# ======================================
#     
# - Triaxial acceleration from the accelerometer (total acceleration) and the 
#   estimated body acceleration.
# - Triaxial Angular velocity from the gyroscope. 
# - A 561-feature vector with time and frequency domain variables. 
# - Its activity label. 
# - An identifier of the subject who carried out the experiment.
# 
# The dataset includes the following files:
# =========================================
#     
# - 'features_info.txt': Shows information about the variables used on the feature vector.
# 
# - 'features.txt': List of all features.
# 
# - 'activity_labels.txt': Links the class labels with their activity name.
# 
# - 'train/X_train.txt': Training set.
# 
# - 'train/y_train.txt': Training labels.
# 
# - 'test/X_test.txt': Test set.
# 
# - 'test/y_test.txt': Test labels.
# 
# The following files are available for the train and test data. Their
# descriptions are equivalent. 
# 
# - 'train/subject_train.txt': Each row identifies the subject who performed the 
#    activity for each window sample. Its range is from 1 to 30. 
# 
# - 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from 
#    the smartphone accelerometer X axis in standard gravity units 'g'. Every row 
#    shows a 128 element vector. The same description applies for the 
#    'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
# 
# - 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal 
#    obtained by subtracting the gravity from the total acceleration. 
# 
# - 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector 
#    measured by the gyroscope for each window sample. The units are radians/second. 
# 
# You should create one R script called run_analysis.R that does the following.
# 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, create a second, independent tidy data set
#    with the average of each variable for each activity-subject combination.

library("tidyverse")
library("data.table")

#-------------------------------------------------------------------------------
# This function builds and returns a complete table for the specified category
# (i.e. train, test)
buildTable <- function( category )
{
    # read all files into separate data frames
    # Note: read.table() works much better than read.csv() because there are a
    #       variable number of spaces between the variables instead of commas
    data_tbl     <- read.table( sprintf("%s/X_%s.txt",       category, category))
    activity_tbl <- read.table( sprintf("%s/y_%s.txt",       category, category))
    subject_tbl  <- read.table( sprintf("%s/subject_%s.txt", category, category))

    # verify number of rows in each table match
    if( nrow(data_tbl) == nrow(activity_tbl) & nrow(data_tbl) == nrow(subject_tbl) )
    {
        # add y and subject columns to x table
        data_tbl <- cbind( data_tbl, subject_tbl, activity_tbl )
    }
    
    # return new data_tbl
    data_tbl
}

#-------------------------------------------------------------------------------
# This function returns the string name for the specified activity level
activityLevelToName <- function( level, activity_labels )
{
    activity_labels[level,2]
}    

#-------------------------------------------------------------------------------
setwd("C:/DataScience/Course_03/FinalProject/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")

# build test and train tables
test_tbl  <- buildTable("test")
train_tbl <- buildTable("train")

dim(test_tbl) 
dim(train_tbl) 

# merge both test and train tables
full_tbl <- rbind( train_tbl, test_tbl )
dim(full_tbl)

# add "subject" and "activity" column names to complete table
features <- read.table("features.txt", stringsAsFactors=FALSE)
names( full_tbl ) <- c( features$V2, "subject", "activity" )

# replace activity factors with descriptive labels
activity_labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
full_tbl$activity <- sapply( full_tbl$activity, activityLevelToName, activity_labels )

# Extracts only the measurements on the mean and standard deviation for each measurement.
meanStdColNames <- grep("-mean\\(\\)|-std\\(\\)", features$V2, value = TRUE)
subsetColNames  <- c( meanStdColNames, "subject", "activity" )
subset_tbl      <- full_tbl[,subsetColNames]
head(subset_tbl)

# create a tidy data set with the average of each variable for each activity
# and each subject
s <- split( subset_tbl, subset_tbl[,c("subject", "activity")] )
averages <- lapply( s, function(x){ colMeans( x[,meanStdColNames] ) } )

# transpose rows and columns so variables are columns and observations are rows
averages <- as.data.frame(averages)
averages <- t(averages)

# add descriptive row names as a proper first column 
averages <- cbind( "subject.activity" = rownames(averages), averages)
averages[,"subject.activity"] <- gsub( "X", "subject", averages[,"subject.activity"] )

# save tidy data to csv file
write.csv( averages, file = "AverageMeasurementsByUserActivity.csv", row.names = FALSE )

