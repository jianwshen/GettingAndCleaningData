#########################################
##Begin
#########################################
##1.
##Merges the training and the test sets to create one data set.
trainYData <- read.table("./data/train/y_train.txt",header=F, sep="\t")
testYData <- read.table("./data/test/y_test.txt",header=F, sep="\t")
trainYDf <- data.frame(Activity = trainYData$V1)
testYDf <- data.frame(Activity = testYData$V1)
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

#########################################
##2.
##Extracts only the measurements on the mean and standard deviation for each measurement. 
XDfSplit <- strsplit(as.character(XDF$V1), " ")
dfX <- do.call(rbind, XDfSplit)
k <- nrow(dfX)
XDfSplit2 = NULL
for (i in 1:k) {
	line <- XDfSplit[[i]]
	XDfSplit2[[i]] <- line[!(line=="")]
}
DF <- do.call(rbind, XDfSplit2)

#########################################

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

##next step is to get dataset from step 4 for mean & std

#########################################
##3.
##Uses descriptive activity names to name the activities in the data set
activityName <- c("Walking","WalkingUpstairs","WalkingDownstairs","Sitting","Standing","Laying")
m <- nrow(YDF)
activity <- NULL
for(i in 1:m) {
	activity[i] = activityName[as.numeric(YDF[i,])]
}
activityDF <- cbind(YDF, activity)
colnames(activityDF)[2]<-c("ActivityName")

#########################################
##4.
##Appropriately labels the data set with descriptive variable names
dfData <- as.data.frame(DF)
m <- ncol(dfData)
for(i in 1:m){
	colnames(dfData)[i] <- c(colName[i])
}

##2.
##Extracts only the measurements on the mean and standard deviation for each measurement. 

meanStdDF <- dfData[,cMeanStd]
meanDF <- dfData[, cMean]

#########################################
$$5.
##From the data set in step 4, creates a second, independent 
##tidy data set with the average of each variable for each activity and each subject.

newDF <- cbind(subjectDF, activityDF, meanDF)

write.table(newDF, file = "SubActivityAverage.txt", 
append = FALSE, sep = " ", na = "NA", dec = ".", 
row.names = FALSE, col.names = TRUE)

#########################################
##End 
#########################################
