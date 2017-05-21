library(dplyr)

if(!file.exists("/R/data"))
   {
     dir.create("/R/data")
   }
##Create directory if does't exists
   
   


Url<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile<-"/R/data/Dataset.zip"
## Get Url and named zipfile


if (!file.exists(zipFile)) {
  download.file(Url,destfile=zipFile)
}
##download file if doesnt exist

unzip(zipfile="/R/data/Dataset.zip" ,exdir="/R/data")
##Unzip file 



dataPath <- file.path("/R/data" , "UCI HAR Dataset")
trainSubjects <- read.table(file.path(dataPath, "train", "subject_train.txt"))
trainValues <- read.table(file.path(dataPath, "train", "X_train.txt"))
trainActivity <- read.table(file.path(dataPath, "train", "y_train.txt"))
## Load train data


testSubjects <- read.table(file.path(dataPath, "test", "subject_test.txt"))
testValues <- read.table(file.path(dataPath, "test", "X_test.txt"))
testActivity <- read.table(file.path(dataPath, "test", "y_test.txt"))
##load test data


features <- read.table(file.path(dataPath, "features.txt"), as.is = TRUE)
##load features


activities <- read.table(file.path(dataPath, "activity_labels.txt"))
colnames(activities) <- c("activityId", "activityLabel")
##load labels



humanActivity <- rbind(
  cbind(trainSubjects, trainValues, trainActivity),
  cbind(testSubjects, testValues, testActivity)
)
##Merge data


colnames(humanActivity) <- c("subject", features[, 2], "activity")
#Named columns

columnsToKeep <- grepl("subject|activity|mean|std", colnames(humanActivity))
humanActivity <- humanActivity[, columnsToKeep]

humanActivity$activity <- factor(humanActivity$activity, 
  levels = activities[, 1], labels = activities[, 2])
  
humanActivityCols <- colnames(humanActivity)
humanActivityCols <- gsub("[\\(\\)-]", "", humanActivityCols)
##Split columns


humanActivityCols <- gsub("^f", "frequencyDomain", humanActivityCols)
humanActivityCols <- gsub("^t", "timeDomain", humanActivityCols)
humanActivityCols <- gsub("Acc", "Accelerometer", humanActivityCols)
humanActivityCols <- gsub("Gyro", "Gyroscope", humanActivityCols)
humanActivityCols <- gsub("Mag", "Magnitude", humanActivityCols)
humanActivityCols <- gsub("Freq", "Frequency", humanActivityCols)
humanActivityCols <- gsub("mean", "Mean", humanActivityCols)
humanActivityCols <- gsub("std", "StandardDeviation", humanActivityCols)
##Change abreviations

humanActivityCols <- gsub("BodyBody", "Body", humanActivityCols)

colnames(humanActivity) <- humanActivityCols

humanActivityMeans <- humanActivity %>% 
  group_by(subject, activity) %>%
  summarise_each(funs(mean))
##Calculate mean


write.table(humanActivityMeans, "/R/data/tidy_data.txt", row.names = FALSE, 
write.table(humanActivityMeans, "/R/data/tidy_data.txt", row.names = FALSE, 
            quote = FALSE)
##Write data



