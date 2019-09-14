# Getting and Cleaning Data - Course Project

This is the course project for the Getting and Cleaning Data Coursera course.
The R script, `run_analysis.R`, does the following:

1. Download the dataset if it does not already exist in the working directory
2. Load the traing and test dataset. Also, activity and feature info
3. Merging Traing and Test dataset.
4. Giving names to column of merged data as per the feature table
5. Subsetting the mean and SD columns
6. Extracts only the measurements on the mean and standard deviation for each measurement.
7. change descriptive activity names to name the activities in the data set.
8. Cleaning Column Names
9.Creating tidy data set with the average of each variable for each activity and each subject.

The end result is saved in the file `tidy.txt`.
