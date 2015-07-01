# Write a function called rankall that takes two arguments: an outcome name (outcome) and a hospital ranking
# (num). The function reads the outcome-of-care-measures.csv file and returns a 2-column data frame
# containing the hospital in each state that has the ranking specified in num. For example the function call
# rankall("heart attack", "best") would return a data frame containing the names of the hospitals that
# are the best in their respective states for 30-day heart attack death rates. The function should return a value
# for every state (some may be NA). The first column in the data frame is named hospital, which contains
# the hospital name, and the second column is named state, which contains the 2-character abbreviation for
# the state name. Hospitals that do not have data on a particular outcome should be excluded from the set of
# hospitals when deciding the rankings.
#
# Handling ties. The rankall function should handle ties in the 30-day mortality rates in the same way
# that the rankhospital function handles ties.
#
# The function should use the following template.
# rankall <- function(outcome, num = "best") {
#  ## Read outcome data
#  ## Check that state and outcome are valid
#  ## For each state, find the hospital of the given rank
#  ## Return a data frame with the hospital names and the
#  ## (abbreviated) state name
# }
#
# NOTE: For the purpose of this part of the assignment (and for efficiency), your function should NOT call
# the rankhospital function from the previous section.
# 
# The function should check the validity of its arguments. If an invalid outcome value is passed to rankall,
# the function should throw an error via the stop function with the exact message “invalid outcome”. The num
# variable can take values “best”, “worst”, or an integer indicating the ranking (smaller numbers are better).
# If the number given by num is larger than the number of hospitals in that state, then the function should
# return NA.

rankall <- function(outcome, num = "best") {
  
  # Validate input
  outcomes <- c("heart attack" = 11, "heart failure" = 17, "pneumonia" = 23)
  ratings <- c("best", "worst")
  
  if (is.invalid(outcome, names(outcomes)))
    stop("invalid outcome")
  
  if ((is.numeric(num) && num < 1) ||
      (is.character(num) && is.invalid(num, ratings)))
    stop("invalid rating")
  
  # Read outcome data
  data <- read.csv(getResource("outcome-of-care-measures.csv"), colClasses = "character", na.strings = "Not Available")
  
  # Get a list of alphabetically sorted states
  states = sort(unique(data$State))

  # Pull values from the outcome column
  outcomeCol <- outcomes[outcome] 
  
  # For each state, find the hospital of the given rank
  hospitals <- sapply(states, function(state) {
    
    # Filter records for the given state
    state.data <- subset(data, data$State == state)
    
    # Rank the records by outcome and hospital names
    state.data.sorted <- state.data[order(as.numeric(state.data[[outcomeCol]]), state.data[[2]], na.last = NA), ]
    
    # Find the relevant row index
    row <- switch(as.character(num), "best" = 1, "worst" = nrow(state.data.sorted), num)
    
    # Return the hospital name
    state.data.sorted[row, 2]
  })
  
  # Return the resulting 'hospital per state' table
  data.frame(hospital = hospitals, state = states, row.names = states)
}

is.invalid <- function(value, ...) !(value %in% ...)

getResource <- function(filename) {
  file.path(PROJHOME, "resources", "asgmt3", filename)
}