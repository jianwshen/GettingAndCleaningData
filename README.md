## This is a README.md file for the project of course "Getting and Cleaning Data"

by James Shen

January 19, 2015

There are five sections for the project. Each section is to write R fuction 
for the following purpose. 

* Merges the training and the test sets to create one data set.
*	Extracts only the measurements on the mean and standard deviation for each measurement.
*	Uses descriptive activity names to name the activities in the data set
*	Appropriately labels the data set with descriptive variable names.
*	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Step I.

1. Combine training dataset and testing dataset to one dataset;

2. There are three part of this task. The outcomes are YDF, XDF, and subjectDF.

trainYData <- read.table("./data/train/y_train.txt",header=F, sep="\t")
testYData <- read.table("./data/test/y_test.txt",header=F, sep="\t")
trainYDf <- data.frame(X5 = trainYData$V1)
testYDf <- data.frame(X5 = testYData$V1)
YDF <- rbind(trainYDf, testYDf)

trainXData <- read.table("./data/train/X_train.txt", header=F, sep="\t")
testXData <- read.table("./data/test/X_test.txt",header=F, sep="\t")
trainXDf <- data.frame(V1 = trainXData$V1)
testXDf <- data.frame(V1 = testXData$V1)
XDF <- rbind(trainXDf, testXDf)

trainSubjectData <- read.table("./data/train/subject_train.txt",header=F, sep="\t")
testSubjectData <- read.table("./data/test/subject_test.txt",header=F, sep="\t")
trainSubjectDf <- data.frame(Subject = trainSubjectData$V1)
testSubjectDf <- data.frame(Subject = testSubjectData$V1)
subjectDF <- rbind(trainSubjectDf, testSubjectDf)

Step II.

1. First is to split XDF by space " " for each row;

2. Remove empty value "" from each row. This is the key part of this project;

3. Combine the clen data set to a Data Frame as DF.

XDfSplit <- strsplit(as.character(XDF$V1), " ")
dfX <- do.call(rbind, XDfSplit)
k <- nrow(dfX)
XDfSplit2 = NULL
for (i in 1:k) {
  line <- XDfSplit[[i]]
	XDfSplit2[[i]] <- line[!(line=="")]
}
DF <- do.call(rbind, XDfSplit2)

Step III.

1. Input features.txt data for column names;

2. Get mean coloum ID list as cMean;

3. Get standard deviation column ID list as cStd

4. Make column names descriptive:

   a. replace tBody as timeBody;

   b. replace tGravity as timeGravity;

   c. replace fBody as freqBoy;

   d. replace Acc as Acce;

   e. replace "," with "_";

   f. remove () as a whole;

   g. replace "(" with "_" at the line middle;

   h. remove extra ")" at the line end;
   
features <- read.table("./data/features.txt", header=F, sep=" ")
featureName <- features$V2
cMean <- grep("mean()", featureName)
cStd <- grep("std()", featureName)
cMeanStd <- c(cMean, cStd)

colName <- gsub("tBody","timeBody", featureName,)
colName <- gsub("tGravity","timeGravity", colName,)
colName <- gsub("fBody","freqBody", colName,)
colName <- gsub("Acc","Acce", colName,)
colName <- gsub(",", "_", colName,)
colName <- gsub("\\()", "", colName,)
colName <- gsub("\\(", "-", colName,)
colName <- gsub(")", "", colName,)

Step IV.

1. Create an activity name list for the six activities;

2. Create a new dataset for activity with activity name as activityDF;

3. Setup the column name for activityDF.

activityName <- c("Walking","WalkingUpstairs","WalkingDownstairs","Sitting","Standing","Laying")
m <- nrow(YDF)
activity <- NULL
for(i in 1:m) {
	activity[i] = activityName[as.numeric(YDF[i,])]
}
activityDF <- cbind(YDF, activity)
colnames(activityDF)[2]<-c("ActivityName")

Step V.

1. Get the data frame from X with the descriptive column names as dfData;

2. Get the mean and standard deviation data set by using column ID cMeanStd as meanStdDF;

3. Get the mean data set by using column ID cMean ad meanDF.

dfData <- as.data.frame(DF)
m <- ncol(dfData)
for(i in 1:m){
	colnames(dfData)[i] <- c(colName[i])
}

meanStdDF <- dfData[,cMeanStd]
meanDF <- dfData[, cMean]

Step VI.

1. Create a new data frame from subjectDF, activityDF, and meanDF with descriptive column names;

2. Write the new data frame to a file as SubActivityAverage.txt.

newDF <- cbind(subjectDF, activityDF, meanDF)
write.table(newDF, file = "SubActivityAverage.txt", 
append = FALSE, sep = " ", na = "NA", dec = ".", 
row.names = FALSE, col.names = TRUE)
