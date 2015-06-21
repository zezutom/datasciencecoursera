## Functions 'makeCacheMatrix' and 'cacheSolve' allow to cache the inverse 
## of a matrix which would otherwise be computed repeatedly.

## 'makeCacheMatrix' creates a wrapper around the provided matrix 'x'.
## The wrapper exposes an interface allowing to access and set the cached inverse
## of the provided matrix.
makeCacheMatrix <- function(x = matrix()) {
  ## 'x' is a matrix whose inverse is to be calculated and cached.
  ## For 'x' to be considered invertible, it has to be a square matrix
  
  # Precondition: Is 'x' a square matrix?
  d <- dim(x)
  if (d[1] != d[2]) stop("The matrix is not invertible")  
  
  # Caches the calculated result 
  m <- NULL

  # Provides access to the original matrix
  get <- function() x
  
  # Caches the inverse of 'x'
  setinverse <- function(inverse) m <<- inverse
  
  # Provides access to the cached inverse of 'x'
  getinverse <- function() m
  
  # The wrapper exposing data access and cache interface
  list(get = get,
       setinverse = setinverse,
       getinverse = getinverse)
}

## 'cacheSolve' makes use of the 'solve' function to calculate
## the inverse of the provided matrix. The calculation only happens
## if no cached result is found. The calculated result is put into the cache.
cacheSolve <- function(x, ...) {
  ## 'x' is assumed to be a wrapper returned by 'makeCacheMatrix'
  
  ## Check if the inverse has been cached
  m <- x$getinverse()
  if (!is.null(m)) {
    message("getting cached data")
    return(m)
  }
  
  # Get the original matrix
  data <- x$get()
  
  # Calculate the inverse and put it into the cache
  m <- solve(data, ...)
  x$setinverse(m)
  
  # Return the inverse
  m
}
