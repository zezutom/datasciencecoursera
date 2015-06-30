# Write a function called rankhospital that takes three arguments: the 2-character abbreviated name 
# of a state (state), an outcome (outcome), and the ranking of a hospital in that state for that outcome (num).
# The function reads the outcome-of-care-measures.csv file and returns a character vector with the name
# of the hospital that has the ranking specified by the num argument. For example, the call 
# rankhospital("MD", "heart failure", 5) would return a character vector containing the name of the hospital 
# with the 5th lowest 30-day death rate for heart failure. The num argument can take values “best”, “worst”, 
# or an integer indicating the ranking (smaller numbers are better). If the number given by num is larger than 
# the number of hospitals in that state, then the function should return NA. Hospitals that do not have data 
# on a particular outcome should be excluded from the set of hospitals when deciding the rankings.
#
# Handling ties. It may occur that multiple hospitals have the same 30-day mortality rate for a given cause
# of death. In those cases ties should be broken by using the hospital name. For example, in Texas (“TX”), 
# the hospitals with lowest 30-day mortality rate for heart failure are shown here.
#
# > head(texas)
# Hospital.Name Rate Rank
# 3935 FORT DUNCAN MEDICAL CENTER 8.1 1
# 4085 TOMBALL REGIONAL MEDICAL CENTER 8.5 2
# 4103 CYPRESS FAIRBANKS MEDICAL CENTER 8.7 3
# 3954 DETAR HOSPITAL NAVARRO 8.7 4
# 4010 METHODIST HOSPITAL,THE 8.8 5
# 3962 MISSION REGIONAL MEDICAL CENTER 8.8 6
#
# Note that Cypress Fairbanks Medical Center and Detar Hospital Navarro both have the same 30-day rate
# (8.7). However, because Cypress comes before Detar alphabetically, Cypress is ranked number 3 in this
# scheme and Detar is ranked number 4. One can use the order function to sort multiple vectors in this
# manner (i.e. where one vector is used to break ties in another vector).
#
# The function should check the validity of its arguments. If an invalid state value is passed to best, the
# function should throw an error via the stop function with the exact message “invalid state”. If an invalid
# outcome value is passed to best, the function should throw an error via the stop function with the exact
# message “invalid outcome”.

source(file.path(PROJHOME, "R", "asgmt3", "best.R"))

rankhospital <- function(state, outcome, num = "best") {
  
  # Reuse the 'best' function if possible
  if (num == "best" || num == 1) return(best(state, outcome))
  
  # Check that state and outcome are valid
  hospital.data <- read.csv(getResource("hospital-data.csv"))
  
  states <- c(t(unique(hospital.data[7])))
  outcomes <- c("heart attack" = 11, "heart failure" = 17, "pneumonia" = 23)
  ratings <- c("best", "worst")
  
  if (is.invalid(state, states)) stop("invalid state")
  if (is.invalid(outcome, names(outcomes))) stop("invalid outcome")
  
  if (
      (is.numeric(num) && num < 1) ||
      (is.character(num) && is.invalid(num, ratings))
      ) 
    stop("invalid rating")
  
  # Read outcome data
  outcome.data <- read.csv(getResource("outcome-of-care-measures.csv"))
  
  # Limit scope to the respective state
  outcome.data <- subset(outcome.data, outcome.data[, 7] == state)
  
  # Return NA if the number given by num is larger than the number of hospitals 
  # in the respective state
  if (is.numeric(num) && num > length(outcome.data)) return(NA)
  
  outcomeCol <- outcomes[outcome]  
  # There is a problem with factors (data frame's columns)
  # A factor needs to be simplified first by calling as.character
  # Only then it can be coerced to numbers.
  # See: http://stackoverflow.com/questions/20056874/as-numeric-is-rounding-positive-values-outputing-na-for-negative-values
  outcome.data[, outcomeCol] <- suppressWarnings(as.numeric(as.character(outcome.data[, outcomeCol])))
  outcome.data <- subset(outcome.data, !is.na(outcome.data[, outcomeCol]))
  hospitals <- outcome.data[order(outcome.data[, outcomeCol], outcome.data[, 2]),]
  
  hospitals <- as.character(hospitals[, 2])
  if (num == "worst") num = length(hospitals)
  hospitals[num]
}

is.invalid <- function(value, ...) !(value %in% ...)

getResource <- function(filename) {
  file.path(PROJHOME, "resources", "asgmt3", filename)
}