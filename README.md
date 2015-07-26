# Getting and cleaning Data Assignment 3

## What the code does

* downloads all required libraries
* downloads/saves/unzips all required data files
* read feature labels and activity labels
* read training set, test set and their y axes
* combine the y axes of training and test
* Merge training and test sets to create one data set.
* Extracts measurements for mean and standard deviation by greping the columns with a regex.
* Removes data where subject is Not known
* Uses descriptive activity names to name the activities in the data set
* Creates a second, independent data set
