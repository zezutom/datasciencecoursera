
best <- function(state, outcome) {

  ## Check that state and outcome are valid
  hospital.data <- read.csv(getResource("hospital-data.csv"))
  
  states <- c(t(unique(hospital.data[7])))
  outcomes <- c("heart attack" = 11, "heart failure" = 17, "pneumonia" = 23)
  
  if (is.invalid(state, states)) stop("invalid state")
  if (is.invalid(outcome, names(outcomes))) stop("invalid outcome")
    
  ## Read outcome data
  outcome.data <- read.csv(getResource("outcome-of-care-measures.csv"))
  
  ## Return hospital name in that state with lowest 30-day death rate
  outcome.data <- subset(outcome.data, outcome.data[, 7] == state)
  
  # There is a problem with factors (data frame's columns)
  # A factor needs to be simplified first by calling as.character
  # Only then it can be coerced to numbers.
  # See: http://stackoverflow.com/questions/20056874/as-numeric-is-rounding-positive-values-outputing-na-for-negative-values
  death.rate <- suppressWarnings(as.numeric(as.character(outcome.data[, outcomes[outcome]])))
  
  ## Find the minimum death rate, disregard hospitals lacking the measure
  death.rate.min <- subset(outcome.data, death.rate == min(death.rate, na.rm = TRUE))
  
  hospitals <- death.rate.min[, 2]
  sort(as.character(hospitals))[1]
}

is.invalid <- function(value, ...) {
  !(value %in% ...)
}

getResource <- function(filename) {
  file.path(PROJHOME, "resources", "asgmt3", filename)
}