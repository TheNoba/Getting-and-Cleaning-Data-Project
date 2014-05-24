Getting and Cleaning Data Project
==================================================================
Human Activity Recognition Using Smartphones Dataset
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. 
Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) 
wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 
we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 
The experiments have been video-recorded to label the data manually. 
The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:
=========================================

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws

License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.

==================================================================
R script details (run_analysis)
==================================================================

# Read Train Data 
trainData <- read.table("./UCI_HAR_Dataset/train/X_train.txt",header=FALSE)
trainData_sub <- read.table("./UCI_HAR_Dataset/train/subject_train.txt",header=FALSE)
trainData_y <- read.table("./UCI_HAR_Dataset/train/y_train.txt",header=FALSE)
# Read Test Data 
testData <- read.table("./UCI_HAR_Dataset/test/X_test.txt",header=FALSE)
testData_sub <- read.table("./UCI_HAR_Dataset/test/subject_test.txt",header=FALSE)
testData_y <- read.table("./UCI_HAR_Dataset/test/y_test.txt",header=FALSE)


##Read activities 
activities <- read.table("./UCI_HAR_Dataset/activity_labels.txt",header=FALSE,colClasses="character")
## Replace the IDs with the descrptions in the activities file for Train Data
trainData_y$V1 <- factor(trainData_y$V1,levels=activities$V1,labels=activities$V2)
## Replace the IDs with the descrptions in the activities file for Test Data
testData_y$V1 <- factor(testData_y$V1,levels=activities$V1,labels=activities$V2)


#Read features 
features <- read.table("./UCI_HAR_Dataset/features.txt",header=FALSE,colClasses="character")
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
