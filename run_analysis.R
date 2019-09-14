library(data.table)
library(dplyr)

#Download Dataset

url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
name = "human_activity.zip"

if(!file.exists(name)) {
  download.file(url, name)
}

#Unzip Dataset
if(!file.exists("UCI HAR Dataset")){
  unzip(name)
}

#Reading the files
testsubject <- fread("./UCI HAR Dataset/test/subject_test.txt")
test_X <- fread("./UCI HAR Dataset/test/X_test.txt")
test_Y <- fread("./UCI HAR Dataset/test/Y_test.txt")

trainsubject <- fread("./UCI HAR Dataset/train/subject_train.txt")
train_X <- fread("./UCI HAR Dataset/train/X_train.txt")
train_Y <- fread("./UCI HAR Dataset/train/Y_train.txt")

features <- fread("./UCI HAR Dataset/features.txt")

activity_lables <- fread("./UCI HAR Dataset/activity_labels.txt")

#Merging traing and test dataset
train <- cbind(trainsubject, train_X, train_Y)
test <- cbind(testsubject, test_X,test_Y)

dt_final <- rbind(train, test)

#remove unecessary variable
rm(list = setdiff(ls(), c("activity_lables", "features", "dt_final")))

#Changing column names
names(dt_final) = c("Subjects", features$V2, "activity")

#subsetting mean and sd columns
required_columns <- grep("mean|std", names(dt_final), value = TRUE)

dt_sub <- dt_final[,c(required_columns, "Subjects", "activity"), with = FALSE]



# change descriptive activity names to name the activities in the data set
dt_sub <- merge(dt_sub, activity_lables, by.x = "activity", by.y = "V1")
dt_sub$activity <- dt_sub$V2
dt_sub$V2 <- NULL

#Cleaning Column Names
names(dt_sub)

names(dt_sub) <- gsub("Mag", "Magnitude", names(dt_sub), ignore.case = TRUE)
names(dt_sub) <- gsub("mean", "Mean", names(dt_sub), ignore.case = TRUE)
names(dt_sub) <- gsub("Freq", "Frequency", names(dt_sub), ignore.case = TRUE)
names(dt_sub) <- gsub("^f", "frequencyDomain", names(dt_sub), ignore.case = TRUE)
names(dt_sub) <- gsub("std", "SD", names(dt_sub), ignore.case = TRUE)
names(dt_sub) <- gsub("^t", "timeDomain", names(dt_sub), ignore.case = TRUE)
names(dt_sub) <- gsub("Acc", "Accelerometer", names(dt_sub), ignore.case = TRUE)
names(dt_sub) <- gsub("Gyro", "Gyroscope", names(dt_sub), ignore.case = TRUE)
names(dt_sub) <- gsub("BodyBody", "Body", names(dt_sub), ignore.case = TRUE)

#remove special characters
names(dt_sub)  <- gsub("[^0-9A-Za-z///' ]","" , names(dt_sub) ,ignore.case = TRUE)


#independent tidy data set with the average of each variable for each activity and each subject.
dt_stats <- dt_sub %>% group_by(activity, Subjects) %>%
  summarise_all("mean")

# output to file "tidy_data.txt"
write.table(dt_stats, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)

rm(list = ls())