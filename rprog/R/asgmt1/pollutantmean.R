# Write a function named 'pollutantmean' that calculates the mean 
# of a pollutant (sulfate or nitrate) across a specified list of monitors. 
#
# The function 'pollutantmean' takes three arguments: 'directory', 'pollutant', and 'id'. 
# 
# Given a vector monitor ID numbers, 'pollutantmean' reads that monitors' particulate 
# matter data from the directory specified in the 'directory' argument and returns 
# the mean of the pollutant across all of the monitors, ignoring any missing values 
# coded as NA.

pollutantmean <- function(directory, pollutant, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'pollutant' is a character vector of length 1 indicating
  ## the name of the pollutant for which we will calculate the
  ## mean; either "sulfate" or "nitrate".
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return the mean of the pollutant across all monitors list
  ## in the 'id' vector (ignoring NA values)
  ## NOTE: Do not round the result!
  
  # Files in alphabetical order, full path to each file for an easy access
  files <- list.files(directory, full.names=TRUE)
  
  # A new data frame
  df <- data.frame()
  
  # Loop over the given range of ID numbers and
  # append the content of the respective file
  # to the data frame.
  for (i in id) {
    df <- rbind(df, read.csv(files[i]))
  }
  
  # Calculate the mean, ignore NA values
  mean(df[, pollutant], na.rm=TRUE)
}