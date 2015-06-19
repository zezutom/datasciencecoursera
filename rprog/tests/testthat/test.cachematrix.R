source("utils.R")
source(getSourceFile("asgmt2", "cachematrix.R"))

test_that("The inverse is calculated as expected and cached", {
  # The (square) matrix to be inversed
  m <- matrix(c(1, 1, 1, 3, 4, 3, 3, 3, 4), nrow = 3, ncol = 3)
  
  # The expected inverse
  im.expected = matrix(c(7, -1, -1, -3, 1, 0, -3, 0, 1), nrow = 3, ncol = 3)
  
  # The pair of 'makeCacheMatrix' and 'cacheSolve' 
  # should yield and cache the expected result
  cm <- makeCacheMatrix(m)
  expect_equal(cacheSolve(cm), im.expected)
  
  # The same results should be found in the cache
  expect_equal(cm$getinverse(), im.expected)
  
  # Repeated calls to 'cacheSolve' should hit the cache
  expect_identical(cacheSolve(cm), cm$getinverse())
})

test_that("A non-square matrix is rejected", {
  m <- matrix(c(1, 1, 1, 3, 4, 3, 3, 3, 4, 4), nrow = 2, ncol = 5)
  expect_error(makeCacheMatrix(m))
})
