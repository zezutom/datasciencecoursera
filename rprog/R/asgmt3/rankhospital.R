source(file.path(PROJHOME, "R", "asgmt3", "best.R"))

rankhospital <- function(state, outcome, num = "best") {
  
  ## Reuse the 'best' function if possible
  if (num == "best" || num == 1) return(best(state, outcome))
  
  ## Check that state and outcome are valid
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
  
  ## Read outcome data
  outcome.data <- read.csv(getResource("outcome-of-care-measures.csv"))
  
  ## Limit scope to the respective state
  outcome.data <- subset(outcome.data, outcome.data[, 7] == state)
  
  ## Return NA if the number given by num is larger than the number of hospitals 
  ## in the respective state
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

is.invalid <- function(value, ...) {
  !(value %in% ...)
}

getResource <- function(filename) {
  file.path(PROJHOME, "resources", "asgmt3", filename)
}