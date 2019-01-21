
## load the dplyr package
library(dplyr)

## make sure to set your working directory to where the folder with the data is stored
#wd <- 'Your directory'
#setwd(wd)

## load the features and activity labels
source_f <- 'UCI HAR Dataset\\features.txt'
features <- read.table(source_f, sep = ' ', stringsAsFactors = FALSE)

source_a <- 'UCI HAR Dataset\\activity_labels.txt'
activitities <- read.table(source_a, sep = ' ', stringsAsFactors = FALSE)

## load the feature values, activity labels and subject labels for the training set
source_x_train <- 'UCI HAR Dataset\\train\\X_train.txt'
source_y_train <- 'UCI HAR Dataset\\train\\y_train.txt'
source_s_train <- 'UCI HAR Dataset\\train\\subject_train.txt'

x_train <- read.table(source_x_train, header = FALSE, stringsAsFactors = FALSE)
y_train <- read.table(source_y_train, sep = ' ', stringsAsFactors = FALSE)
s_train <- read.table(source_s_train, sep = ' ', stringsAsFactors = FALSE)

## combine X, y, and subject of the training set into one big data.frame
train_set <- cbind(x_train, y_train, s_train)

## load the feature values, activity labels and subject labels for the test set
source_x_test <- 'UCI HAR Dataset\\test\\X_test.txt'
source_y_test <- 'UCI HAR Dataset\\test\\y_test.txt'
source_s_test <- 'UCI HAR Dataset\\test\\subject_test.txt'

x_test <- read.table(source_x_test, header = FALSE, stringsAsFactors = FALSE)
y_test <- read.table(source_y_test, sep = ' ', stringsAsFactors = FALSE)
s_test <- read.table(source_s_test, sep = ' ', stringsAsFactors = FALSE)

## combine X, y, and subject of the test set into one big data.frame
test_set <- cbind(x_test, y_test, s_test)

## combine training and test set
combined_data <- rbind(train_set, test_set)
## get the dimensions of the combined test and training set
dim(combined_data)

## find all measurements that are a mean or standard deviation (std) using the features dataframe
## and reduce the dataframe to these measurements as well as the 
mean_mes <- grep('mean', features$V2)
std_mes <- grep('std', features$V2)
truth <- sort(c(mean_mes, std_mes))
phone_activity_data <- combined_data[, c(truth,562,563)]

## generate descriptive activity names by replacing the integer values with the activity labels 
## stored in the activities dataframe
phone_activity_data$V1.1 <- sapply(phone_activity_data$V1.1, function(x) activitities[x, 2])

## generate descriptive feature names by replacing the column names with the feature labels 
## stored in the features dataframe, and add 'activity' and 'subject' for their label vectors
names(phone_activity_data) <- c(features[truth,2], 'activity', 'subject')

## get the dimensions of the tidy data set
dim(phone_activity_data)

## create a second tidy data set with mean of measured feature for each activity and each subject
phone_activity_data_mean <- phone_activity_data[,1:79] %>% group_by(phone_activity_data$activity,
                                                                    phone_activity_data$subject) %>%
        summarise_all(mean, na.rm = TRUE)

