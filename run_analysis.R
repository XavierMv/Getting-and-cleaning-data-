library(readr)
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
mean_sd <- (grepl("subjectnum", cnames) | grepl("activity", cnames) | grepl("mean..", cnames) | grepl("std..", cnames))
BDFm_sd <- BDF[ , mean_sd == TRUE]

## Activity names (NAMES ARE IN THE LAST COLUMN)
DF <- merge(BDFm_sd, activitylabels, by='subjectnum', all.x = TRUE)

## Creating new tidy data 
DFfinal <- aggregate( .~subjectnum + activity.y, data =  DF, mean)
DFfinal <- DFfinal[order(DFfinal$activity.y, DFfinal$subjectnum),]

## Rename
newnames <- names(DFfinal)
newnames <- sub("^t", "Time", newnames) 
newnames <- sub("^f", "Frequency", newnames)
newnames <- sub("Acc+", "Acceleration", newnames) 
newnames <- sub("Gyro+", "Gyroscope", newnames) 
newnames <- sub("std+", "StandardDeviation", newnames)
colnames(DFfinal) <- newnames
DFfinal <- DFfinal[-c(3)]

## Save in txt file 
write.table(DFfinal, "C:/Users/xavie/OneDrive/Escritorio/data science coursera/New_dataset.txt", row.names = FALSE, col.names = TRUE)








