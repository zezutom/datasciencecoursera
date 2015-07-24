## Ensures the required libraries are installed
ensureInstalled <- function(...) {
  lapply(list(...), function(lib) {
    if (!lib %in% installed.packages()) 
      install.packages(lib)
  })
}
## ensureInstalled("data.table")
## Load the dependencies
## library("data.table")

## The main data directory
dsDir <- "UCI HAR Dataset"

## Loads a file
## Params:
##  fileName .. name of the file to load
##  ellipsis .. a comma delimited list of directories
loadFile <- function(fileName, ...) {
  file.path(..., fileName) %>%
  read.table  
}

## Loads a training file
loadTrainFile <- function(fileName) {
  loadFile(fileName, dsDir, "train")
}

## Loads a test file
loadTestFile <- function(fileName) {
  loadFile(fileName, dsDir, "test")
}

## Download and extract a zip file with datasets
if (!file.exists(dsDir)) {
  sourceUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  destFile <- "Dataset.zip"
  download.file(sourceUrl, destfile = destFile, method = "curl")
  unzip(destFile)
  if (!file.exists(dsDir)) 
    stop("The downloaded dataset doesn't have the expected structure!")
}

## Load features
features <- loadFile("features.txt", dsDir)[,2]

## Load activity labels
activity_lbl <- loadFile("activity_labels.txt", dsDir)[,2]

## Load training data
train_set <- loadTrainFile("X_train.txt")
train_lbl <- loadTrainFile("y_train.txt")
train_sub <- loadTrainFile("subject_train.txt")

## Load test data
test_set <- loadTestFile("X_test.txt")
test_lbl <- loadTestFile("y_test.txt")
test_sub <- loadTestFile("subject_test.txt")

## Merge the training and the test sets to create one dataset
train_data <- cbind(test_set, test_lbl, test_sub)
test_data <- cbind(train_set, train_lbl, train_sub)
merge_data <- rbind(train_data, test_data)

## Extract only the measurements on the mean and standard deviation for each measurement

