source("utils.R")
source(getSourceFile("complete.R"))

assert_complete <- function(ids, ids.expected, nobs.expected) {
  # The expected result
  df.expected <- data.frame(id = ids.expected, nobs = nobs.expected)
  
  # The actual result
  df <- complete(getDataDir("specdata"), ids)
  
  expect_equal(df.expected, df)
}

test_that("The number of completely observed cases in the first file is as expected", {
  assert_complete(1, 1, c(117))
})

test_that("The number of completely observed cases in selected files is as expected", {
  assert_complete(c(2, 4, 8, 10, 12), c(2, 4, 8, 10, 12), c(1041, 474, 192, 148, 96))
})

test_that("The number of completely observed cases in a range of files is as expected", {
  assert_complete(30:25, c(30, 29, 28, 27, 26, 25), c(932, 711, 475, 338, 586, 463))
})