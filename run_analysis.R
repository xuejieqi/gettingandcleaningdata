require(dplyr)

############################################################################################################################################################
## Coursera Online Course: Getting and Cleaning Data
## Peer Graded Assignment
##
## Task: create one R script called run_analysis.R that does the following.
## 
## (a) Merges the training and the test sets to create one data set.
## (b) Extracts only the measurements on the mean and standard deviation for each measurement.
## (c) Uses descriptive activity names to name the activities in the data set
## (d) Appropriately labels the data set with descriptive variable names.
## (e) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
## 
#############################################################################################################################################################

## the source file is downloaded earlier and uzipped from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# Declaration of Directories and files
dataset_dir <- "UCI\ HAR\ Dataset"
feature_file <- paste(dataset_dir, "/features.txt", sep = "")
activity_labels_file <- paste(dataset_dir, "/activity_labels.txt", sep = "")
x_train_file <- paste(dataset_dir, "/train/X_train.txt", sep = "")
y_train_file <- paste(dataset_dir, "/train/y_train.txt", sep = "")
subject_train_file <- paste(dataset_dir, "/train/subject_train.txt", sep = "")
x_test_file  <- paste(dataset_dir, "/test/X_test.txt", sep = "")
y_test_file  <- paste(dataset_dir, "/test/y_test.txt", sep = "")
subject_test_file <- paste(dataset_dir, "/test/subject_test.txt", sep = "")

# Loading raw data
features <- read.table(feature_file, colClasses = c("character"))
activity_labels <- read.table(activity_labels_file, col.names = c("ActivityId", "Activity"))
x_train <- read.table(x_train_file)
y_train <- read.table(y_train_file)
subject_train <- read.table(subject_train_file)
x_test <- read.table(x_test_file)
y_test <- read.table(y_test_file)
subject_test <- read.table(subject_test_file)

#########################################################################
# Taks (a): Merges the training and the test sets to create one data set.
#########################################################################

# Binding sensor data
training_sensor_data <- cbind(cbind(x_train, subject_train), y_train)
test_sensor_data <- cbind(cbind(x_test, subject_test), y_test)
sensor_data <- rbind(training_sensor_data, test_sensor_data)

# Label columns
sensor_labels <- rbind(rbind(features, c(562, "Subject")), c(563, "ActivityId"))[,2]
names(sensor_data) <- sensor_labels

####################################################################################################
# Task (b): Extracts only the measurements on the mean and standard deviation for each measurement.
####################################################################################################

sensor_data_mean_std <- sensor_data[,grepl("mean|std|Subject|ActivityId", names(sensor_data))]

###################################################################################
# Task (c); Uses descriptive activity names to name the activities in the data set
###################################################################################

sensor_data_mean_std <- join(sensor_data_mean_std, activity_labels, by = "ActivityId", match = "first")
sensor_data_mean_std <- sensor_data_mean_std[,-1]

#####################################################################
# Task (d): Appropriately labels the data set with descriptive names.
#####################################################################

# Remove parentheses
names(sensor_data_mean_std) <- gsub('\\(|\\)',"",names(sensor_data_mean_std), perl = TRUE)
# Make syntactically valid names
names(sensor_data_mean_std) <- make.names(names(sensor_data_mean_std))
# Make clearer names
names(sensor_data_mean_std) <- gsub('Acc',"Acceleration",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('GyroJerk',"AngularAcceleration",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('Gyro',"AngularSpeed",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('Mag',"Magnitude",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('^t',"TimeDomain.",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('^f',"FrequencyDomain.",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('\\.mean',".Mean",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('\\.std',".StandardDeviation",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('Freq\\.',"Frequency.",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('Freq$',"Frequency",names(sensor_data_mean_std))

##############################################################################################################################
# Task (e): Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##############################################################################################################################


sensor_avg_by_act_sub = ddply(sensor_data_mean_std, c("Subject","Activity"), numcolwise(mean))
write.table(sensor_avg_by_act_sub, file = "tidy_dataset_activity_subject.txt")
