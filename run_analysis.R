library(readr)
library(dplyr)
library(reshape2)
###################################TEST######################################
X_test <- read.table("C:/Users/xavie/OneDrive/Escritorio/data science coursera/UCI HAR Dataset/test/X_test.txt", quote="\"", comment.char="")
y_test <- read.table("C:/Users/xavie/OneDrive/Escritorio/data science coursera/UCI HAR Dataset/test/y_test.txt", quote="\"", comment.char="")
subject_test <- read.table("C:/Users/xavie/OneDrive/Escritorio/data science coursera/UCI HAR Dataset/test/subject_test.txt", quote="\"", comment.char="")
###################################TRAIN######################################
X_train <- read.table("C:/Users/xavie/OneDrive/Escritorio/data science coursera/UCI HAR Dataset/train/X_train.txt", quote="\"", comment.char="")
y_train <- read.table("C:/Users/xavie/OneDrive/Escritorio/data science coursera/UCI HAR Dataset/train/y_train.txt", quote="\"", comment.char="")
subject_train <- read.table("C:/Users/xavie/OneDrive/Escritorio/data science coursera/UCI HAR Dataset/train/subject_train.txt", quote="\"", comment.char="")
#################################MAIN LABELS###########################################
features <- read.table("C:/Users/xavie/OneDrive/Escritorio/data science coursera/UCI HAR Dataset/features.txt")
activitylabels <-read.table("C:/Users/xavie/OneDrive/Escritorio/data science coursera/UCI HAR Dataset/activity_labels.txt")

## Assign names
colnames(X_test) <- features[,2]
colnames(X_train) <- features[,2]

## Assign labels
colnames(y_test) <- "activity"
colnames(y_train) <- "activity"
colnames(subject_test) <- "subjectnum"
colnames(subject_train) <- "subjectnum"
colnames(activitylabels) <- c("subjectnum", "activity")


### Merge data
TRAIN <- cbind(y_train,subject_train, X_train)
TEST <- cbind(y_test,subject_test, X_test)
BDF <- rbind(TRAIN, TEST)

## Getting mean and SD
cnames <- colnames(BDF)
sb <- grep("subjectnum+", cnames, value = TRUE)
a <- grep("activity+", cnames, value=TRUE)
m <- grep("mean+", cnames, value = TRUE)
sd <- grep("std+", cnames, value = TRUE)
v <- c(sb,a,m,sd)
mean_sd <- select(BDF, v)
BDFm_sd <- merge(mean_sd, activitylabels, by.x = "activity", by.y = "subjectnum")

## Activity names (NAMES ARE IN THE LAST COLUMN)
BDFm_sd$activity <- BDFm_sd$activity.y
BDFm_sd <- BDFm_sd[,1:81]

## Rename
newnames <- names(BDFm_sd)
newnames <- sub("^t", "Time", newnames) 
newnames <- sub("^f", "Frequency", newnames)
newnames <- sub("Acc+", "Acceleration", newnames) 
newnames <- sub("Gyro+", "Gyroscope", newnames) 
newnames <- sub("std+", "StandardDeviation", newnames)
colnames(BDFm_sd) <- newnames

## Reshape
DF <- melt(BDFm_sd, id = c("activity", "subjectnum"))
DFfinal <- dcast(DF, activity + subjectnum ~ variable, mean)

## Save in txt file 
write.table(DFfinal, "C:/Users/xavie/OneDrive/Escritorio/data science coursera/New_dataset.txt", row.names = FALSE, col.names = TRUE)








