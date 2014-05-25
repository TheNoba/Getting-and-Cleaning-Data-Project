
## Call Library "data.table"
library(data.table)

##Donwload the file from the URL & unzip the file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "Dataset.zip", method = "curl")
unzip("Dataset.zip")

# Read Train Data 
trainData <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
trainData_sub <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)
trainData_y <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
# Read Test Data 
testData <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
testData_sub <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
testData_y <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)


##Read activities 
activities <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")
## Replace the IDs with the descrptions in the activities file for Train Data
trainData_y$V1 <- factor(trainData_y$V1,levels=activities$V1,labels=activities$V2)
## Replace the IDs with the descrptions in the activities file for Test Data
testData_y$V1 <- factor(testData_y$V1,levels=activities$V1,labels=activities$V2)


#Read features 
features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")
# Modify columns names Train Data
colnames(trainData_y)<-c("Activity")
colnames(trainData_sub)<-c("Subject")
colnames(trainData)<-features$V2

# Modify columns names Test Data
colnames(testData_y)<-c("Activity")
colnames(testData_sub)<-c("Subject")
colnames(testData)<-features$V2



# merge Train and Test Data in one Data set
testData<-cbind(testData,testData_y)
testData<-cbind(testData,testData_sub)
trainData<-cbind(trainData,trainData_y)
trainData<-cbind(trainData,trainData_sub)
bigData<-rbind(testData,trainData)

# Calculatethe mean and SD for each column
bigData_sd<-sapply(bigData,sd,na.rm=TRUE)
bigData_mean<-sapply(bigData,mean,na.rm=TRUE)


# Create the Tidy Data set 
DT <- data.table(bigData)
tidy<-DT[,lapply(.SD,mean),by="Activity,Subject"]
write.table(tidy,file="tidy.csv",sep=",",row.names = FALSE)
