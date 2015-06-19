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
  df <- complete(directory)

  # Monitors (file ids) where the number of observed cases exceeds the threshold
  ids <- df$id[df$nobs > threshold]
  
  # If no monitors meet the threshold requirement, then return a numeric vector of length 0
  if (length(ids) == 0) return(vector(mode = "numeric", length = 0))
  
  # Files in alphabetical order, full path to each file for an easy access
  files <- list.files(directory, full.names=TRUE)
  
  # Initialize the correlations vector
  corrs <- c()
  
  # Loop over the relevant monitors and update the vector with the captured correlations
  for (id in ids) {
    file <- read.csv(files[id])
    corr <- cor(file$sulfate, file$nitrate, use="complete.obs")
    corrs <- c(corrs, corr)
  }

  corrs
}