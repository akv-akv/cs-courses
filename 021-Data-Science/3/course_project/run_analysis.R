## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement.
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names.
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Download data
library(utils)
library(data.table)
library(dplyr)
library(tidyr)
url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
#download.file(url,'data/1.zip')
#unzip('data/1.zip', exdir = 'data')
datapath = 'data/UCI HAR Dataset/'

## Name lists
features_list <- data.table::fread(paste(datapath,'features.txt',sep=''))
activities_List <- data.table::fread(paste(datapath,'activity_labels.txt',sep=''),
                                     col.names = c('activity','activityname'))

# Read data
x_train <- data.table::fread(paste(datapath,'train/X_train.txt',sep=''))
x_test <- data.table::fread(paste(datapath,'test/X_test.txt',sep=''))
y_train <- data.table::fread(paste(datapath,'train/y_train.txt',sep=''), 
                             col.names ='activity')
y_test <- data.table::fread(paste(datapath,'test/y_test.txt',sep=''), 
                            col.names ='activity')
subj_train <- data.table::fread(paste(datapath,'train/subject_train.txt',
                                      sep=''), col.names = 'subject')
subj_test <- data.table::fread(paste(datapath,'test/subject_test.txt',
                                     sep=''), col.names  = 'subject')

# Merge data
x <- rbind(x_train,x_test)
names(x) <- as.character(features_list$V2)
y <- rbind(y_train,y_test)
subj <- rbind(subj_train,subj_test)
y <- left_join(y,activities_List)[,2]
data <- cbind(subj, y, x)

# Tidy data
tidy_data <- select(data, activityname, subject,
                    grep("(mean|std)\\(\\)$",names(data))) %>% as_tibble() %>%
    mutate(activityname = as.factor(activityname),
           subject = as.factor(subject)) %>% 
    pivot_longer(cols=-c('activityname','subject')) %>%
    separate(name, into=c('signal', 'type'), sep='-') %>%
    pivot_wider(names_from = type, values_from = value, values_fn=mean)

                


