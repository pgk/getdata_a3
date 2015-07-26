## Variables

* activity: the activity code
* subject: the subject id for this entry
* V1: the name of the activity
* variable: the name of the measurement source 
* V1 the averaged values for this `variable`

## Data

obtained from dataset at [this](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

## Transformations

* did not consider any data with no subjects
* melted the data from the columns into a long data set
* wanted to rename the measurements by splitting and manipulating the string values
