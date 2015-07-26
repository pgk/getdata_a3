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


te_x_df <- read.table(training_set)
te_y_df <- read.table(training_labels)

# combine the y axes of training and test
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

all_data$activity = as.vector(tr_all_y[1])
all_data$activity = all_data$activity$V1

# Remove data where subject is Not known
cutoff <- 0:nrow(all_subjects)
cut_data = all_data[cutoff,]
cut_data$subject = all_subjects

# Uses descriptive activity names to name the activities in the data set

mm = merge(cut_data, al_df, by.x="activity", by.y="V1")
mm["subject"] = mm$subject$V1

 
# Create a second, independent tidy data set 
# with the average of each variable for each activity and each subject

melted_data <- melt(mm, id=c("activity", "subject", "V2"))
final <- melted_data[complete.cases(melted_data),]
dd <- ddply(final, c("activity", "subject", "V2", "variable"), function (df) mean(df$value))

write.csv(dd, file = "final.txt")