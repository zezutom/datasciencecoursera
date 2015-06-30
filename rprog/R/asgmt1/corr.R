# Write a function that takes a directory of data files and a threshold 
# for complete cases and calculates the correlation between sulfate and nitrate 
# for monitor locations where the number of completely observed cases (on all variables) 
# is greater than the threshold. 
#
# The function should return a vector of correlations for the monitors that meet 
# the threshold requirement. If no monitors meet the threshold requirement, then 
# the function should return a numeric vector of length 0.

# Caches results of a potentially expensive 'complete' calculation
cacheComplete <- function(proxy, debug = FALSE) {
  # 'proxy' provides either the chached content or it makes the actual call
  # and caches the results
  
  # Check if the 'complete' result has been cached
  cache <- proxy$get()
  if (!is.null(cache)) {
    if (debug) print("Returning completely observed cases from cache")
    return(cache)
  }
  if (debug) print("Loading completely observed cases")
  
  # Get the input directory
  directory <- proxy$getDirectory()
  
  # Get the completely observed cases (data frame) and put them into the cache
  df <- complete(directory)
  proxy$set(df)
  
  # Return the result
  df  
}

cacheProxy <- function(directory) {

  # Caches the calculated result (data frame)
  df <- NULL
  
  # Provides access to the requested directory
  getDirectory <- function() directory
  
  # Caches the inverse of 'x'
  set <- function(complete_df) df <<- complete_df
  
  # Provides access to the cached inverse of 'x'
  get <- function() df
  
  # The wrapper exposing data access and cache interface
  list(get = get,
       set = set,
       getDirectory = getDirectory)  
}

corr <- function(directory, threshold = 0) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'threshold' is a numeric vector of length 1 indicating the
  ## number of completely observed observations (on all
  ## variables) required to compute the correlation between
  ## nitrate and sulfate; the default is 0
  
  ## Return a numeric vector of correlations
  ## NOTE: Do not round the result!
  
  # Completely observed cases in each data file
  if(is.null(proxy)) proxy <<- cacheProxy(directory)
  df <- cacheComplete(proxy, TRUE)

  # File ids (monitors) where the number of observed cases exceeds the threshold
  ids <- df$id[df$nobs > threshold]
  
  # If no monitors meet the threshold requirement, then return a numeric vector of length 0
  if (length(ids) == 0) return(vector(mode = "numeric", length = 0))
  
  # Files in alphabetical order, full path to each file for an easy access
  files <- list.files(directory, full.names=TRUE)
  
  # Loop over the relevant monitors and return a vector with the captured correlations
  sapply(ids, function(id) {
    file <- read.csv(files[id])
    cor(file$sulfate, file$nitrate, use="complete.obs")    
  })
}

# The shared proxy object
proxy <- NULL
