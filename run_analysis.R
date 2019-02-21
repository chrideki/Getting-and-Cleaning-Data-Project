library(dplyr)

## read list of all features and class labels linked with their activity name
featureNames <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "name"))
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("n", "name"))

## read test data
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
Xtest <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = featureNames$name)
Ytest <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity")

## read train data
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
Xtrain <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = featureNames$name)
Ytrain <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity")

## merge test and train data
Xdata <- rbind(Xtest, Xtrain)
Ydata <- rbind(Ytest, Ytrain)
subjectData <- rbind(subjectTest, subjectTrain)
mergeData <- cbind(subjectData, Ydata, Xdata)

## extracts measurements on the mean and std
dataMeanAndStd <- select(mergeData, subject, activity, contains("mean"), contains("std"))

## replace activity code with descriptive activity names in the tidy data set
dataMeanAndStd$activity <- activityLabels[dataMeanAndStd$activity, "name"]

## appropriately labels the data set with descriptive variable names 
names(dataMeanAndStd) <- gsub("Acc", "Accelerometer", names(dataMeanAndStd))
names(dataMeanAndStd) <- gsub("Gyro", "Gyroscope", names(dataMeanAndStd))
names(dataMeanAndStd) <- gsub("^t", "Time", names(dataMeanAndStd))
names(dataMeanAndStd) <- gsub("\\.t", "Time", names(dataMeanAndStd))
names(dataMeanAndStd) <- gsub("^f", "Frequency", names(dataMeanAndStd))
names(dataMeanAndStd) <- gsub("Mag", "Magnitude", names(dataMeanAndStd))

## data set with the average of each variable for each activity and each subject
newData <- group_by(dataMeanAndStd, subject, activity)
newData <- summarize_all(newData, funs(mean))
write.table(newData, "newData.txt", row.name=FALSE)