# Write a function called best that take two arguments: the 2-character abbreviated name 
# of a state and an outcome name. The function reads the outcome-of-care-measures.csv file 
# and returns a character vector with the name of the hospital that has the best (i.e. lowest) 
# 30-day mortality for the specified outcome in that state. 
#
# The hospital name is the name provided in the Hospital.Name variable. The outcomes can
# be one of “heart attack”, “heart failure”, or “pneumonia”. Hospitals that do not have 
# data on a particular outcome should be excluded from the set of hospitals when deciding 
# the rankings.
#
# Handling ties. If there is a tie for the best hospital for a given outcome, then the hospital 
# names should be sorted in alphabetical order and the first hospital in that set should be chosen 
# (i.e. if hospitals “b”, “c”, and “f” are tied for best, then hospital “b” should be returned).
#
# The function should check the validity of its arguments. If an invalid state value is passed 
# to best, the function should throw an error via the stop function with the exact message 
# “invalid state”. If an invalid outcome value is passed to best, the function should throw 
# an error via the stop function with the exact message “invalid outcome”.

best <- function(state, outcome) {

  # Check that state and outcome are valid
  hospital.data <- read.csv(getResource("hospital-data.csv"))
  
  states <- c(t(unique(hospital.data[7])))
  outcomes <- c("heart attack" = 11, "heart failure" = 17, "pneumonia" = 23)
  
  if (is.invalid(state, states)) stop("invalid state")
  if (is.invalid(outcome, names(outcomes))) stop("invalid outcome")
    
  # Read outcome data
  outcome.data <- read.csv(getResource("outcome-of-care-measures.csv"))
  
  # Return hospital name in that state with lowest 30-day death rate
  outcome.data <- subset(outcome.data, outcome.data[, 7] == state)
  
  # There is a problem with factors (data frame's columns)
  # A factor needs to be simplified first by calling as.character
  # Only then it can be coerced to numbers.
  # See: http://stackoverflow.com/questions/20056874/as-numeric-is-rounding-positive-values-outputing-na-for-negative-values
  outcome.column <- outcome.data[, outcomes[outcome]]
  death.rate <- suppressWarnings(as.numeric(as.character(outcome.column)))
  
  # Find the minimum death rate, disregard hospitals lacking the measure
  death.rate.min <- subset(outcome.data, death.rate == min(death.rate, na.rm = TRUE))
  
  # Return an alphabetically sorted list of hospitals
  hospitals <- death.rate.min[, 2]
  sort(as.character(hospitals))[1]
}

is.invalid <- function(value, ...) !(value %in% ...)

getResource <- function(filename) {
  file.path(PROJHOME, "resources", "asgmt3", filename)
}