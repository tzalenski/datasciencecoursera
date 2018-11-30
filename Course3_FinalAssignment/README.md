# datasciencecoursera
Repository for week 4 of course #3, "Getting and Cleaning Data"

==================================================================
Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================

The experiments have been carried out with a group of 30 volunteers within an age 
bracket of 19-48 years. Each person performed six activities 
(WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) 
wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded 
accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial 
angular velocity at a constant rate of 50Hz. The experiments have been 
video-recorded to label the data manually. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying 
noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 
50% overlap (128 readings/window). The sensor acceleration signal, which has 
gravitational and body motion components, was separated using a Butterworth 
low-pass filter into body acceleration and gravity. The gravitational force is 
assumed to have only low frequency components, therefore a filter with 0.3 Hz 
cutoff frequency was used. From each window, a vector of features was obtained 
by calculating variables from the time and frequency domain. 
See 'features_info.txt' for more details. 

The dataset includes the following files:
=========================================
1. AverageMeasurementsByUserActivity.csv - tidy data setcodebook
2. codebook.txt - describes each variable in tidy data set
3. run_analysis.R - script used to generate tidy data set from files in
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 