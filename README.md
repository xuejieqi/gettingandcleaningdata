# Getting and Cleaning Data

## Course Project

Requirements: to create an R script called ```run_analysis.R```

### How the script works:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Description of main variables:

* dataset_dir: directory of the data sets
* *_file:  filename of related files
* *_train, *_test: raw data
* *_sensor_data: merged sensor data
* sensor_data_mean_std: mean and standard deviation for each measurement
* sensor_avg_by_act_sub: a tidy data set with the average of each variable for each activity and each subject
