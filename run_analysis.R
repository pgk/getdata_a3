# R script run_analysis.R
# download file if it does not exist and save it in ./data

if (!dir.exists('data')) {
  print("`./data` does not exist. Creating dir")
  dir.create('data')
  print("created dir `./data`")
}


fname <- './data/getdata_projectfiles_UCI_HAR_Dataset.zip'


if (!file.exists(fname)) {
  print("downloading dataset...")
  url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, destfile = fname)
  print("done")
}

dataset_folder <- "./data/UCI HAR DAtaset"

if (!dir.exists(dataset_folder)) {
  print("extracting zipfile")
  unzip(fname, exdir = "./data", overwrite = TRUE)
  print("done")
}


if (require("plyr") == FALSE) { install.packages("plyr") }
if (require("dplyr") == FALSE) { install.packages("dplyr") }
if (require("reshape2") == FALSE) { install.packages("reshape2") }


library(plyr)
library(dplyr)


training_set = paste(dataset_folder, "train", "X_train.txt", sep="/")
print(training_set)

training_labels = paste(dataset_folder, "train", "Y_train.txt", sep="/")
print(training_labels)

test_set = paste(dataset_folder, "test", "X_test.txt", sep="/")
print(test_set)

test_labels = paste(dataset_folder, "test", "Y_test.txt", sep="/")
print(test_labels)



# read feature labels and activity labels

act_labels_file <- paste(dataset_folder, "activity_labels.txt", sep="/")
al_df <- read.table(act_labels_file)

features_file <- paste(dataset_folder, "features.txt", sep="/")
features_df <- read.table(features_file)


# read training_set

tr_x_df <- read.table(training_set)
tr_y_df <- read.table(training_labels)
# tr_x_df$activity <- tr_y_df


te_x_df <- read.table(training_set)
te_y_df <- read.table(training_labels)
# te_x_df$activity = NA
# te_x_df$activity <- as.vector(te_y_df)


features_transposed <- t(features_df[2])

# Merge training and test sets to create one data set.
all_data <- rbind(tr_x_df, te_x_df)
colnames(all_data) <- features_transposed
d <- seq(1, nrow(all_data), by=1)
all_data$id <- d

library(reshape2)


# Extracts only the measurements on the mean and standard deviation for each measurement.

# melt columns
melted_data <- melt(all_data, id=c("id"))


# Uses descriptive activity names to name the activities in the data set
# Appropriatelhy labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
