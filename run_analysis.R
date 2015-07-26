# R script run_analysis.R

# require R version >= 3.1.x
r.version <- R.Version()

print(paste("using R version ", r.version$version.string))

# require libraries
if (require("plyr") == FALSE) { install.packages("plyr") }
if (require("dplyr") == FALSE) { install.packages("dplyr") }
if (require("reshape2") == FALSE) { install.packages("reshape2") }
if (require("stringr") == FALSE) { install.packages("stringr") }

library(plyr)
library(dplyr)
library(reshape2)
library(stringr)

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

dataset_folder <- file.path("./data", "UCI HAR Dataset")

if (!dir.exists(dataset_folder)) {
  print("extracting zipfile")
  unzip(fname, exdir = "./data", overwrite = TRUE)
  print("done")
}


training_set = file.path(dataset_folder, "train", "X_train.txt")
print(training_set)

training_labels = file.path(dataset_folder, "train", "y_train.txt")
print(training_labels)

test_set = file.path(dataset_folder, "test", "X_test.txt")
print(test_set)

test_labels = file.path(dataset_folder, "test", "y_test.txt")
print(test_labels)

subject_train_set = file.path(dataset_folder, "train", "subject_train.txt")
subject_test_set = file.path(dataset_folder, "test", "subject_test.txt")


# read feature labels and activity labels

act_labels_file <- file.path(dataset_folder, "activity_labels.txt")
al_df <- read.table(act_labels_file)

features_file <- file.path(dataset_folder, "features.txt")
features_df <- read.table(features_file)

subject_train_df <- read.table(subject_train_set)
# read training_set
subject_test_df <- read.table(subject_test_set)

tr_x_df <- read.table(training_set)
tr_y_df <- read.table(training_labels)
# tr_x_df$subject = subject_train_df
# tr_x_df$activity <- as.vector(tr_y_df)

te_x_df <- read.table(training_set)
te_y_df <- read.table(training_labels)
# te_x_df$subject = subject_test_df
# te_x_df$activity = NA
# te_x_df$activity <- as.vector(te_y_df)
# rownames(te_x_df) <- seq(length(tr_x_df), length(tr_x_df) + length(te_x_df), by=1)

tr_all_y = rbind(tr_y_df, te_y_df)

all_subjects = rbind(subject_train_df, subject_test_df)

features_transposed <- t(features_df[2])

# Merge training and test sets to create one data set.
all_data <- rbind(tr_x_df, te_x_df)


# Extracts only the measurements on the mean and standard deviation for each measurement.
colnames(all_data) <- features_transposed

means <- grep("-mean\\(\\)$", colnames(all_data))
stds <- grep("-std\\(\\)$", colnames(all_data))

all_column_indices = unlist(c(means, stds))

all_data = all_data[all_column_indices]

# set activity numbers
all_data$activity = as.vector(tr_all_y[1])
all_data$activity = all_data$activity$V1
# all_data$subject = NA
# all_data$subject[,0:length(all_subjects)] = all_subjects
# d <- seq(1, nrow(all_data), by=1)
# all_data$id <- d

cutoff <- 0:nrow(all_subjects)

cut_data = all_data[cutoff,]

cut_data$subject = all_subjects


# melt columns
# melted_data <- melt(all_data, id=c("id))

# TODO split column variable into 3 columns

# split_cols <- within(melted_data, variable<-data.frame(do.call('rbind', strsplit(as.character(melted_data$variable),'-',fixed=TRUE))))

# str_split_fixed(melted_data$variable, "-", 2)

# TODO select only columns with means and stddevs



# Uses descriptive activity names to name the activities in the data set

mm = merge(cut_data, al_df, by.x="activity", by.y="V1")

# Appropriatelhy labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
