source("utils.R")
source(getSourceFile("asgmt1", "pollutantmean.R"))

assert_pollutantmean <- function(ids, pollutant, mean) {
  expect_that(pollutantmean(getDataDir("specdata"), pollutant, ids), equals(mean, tolerance = 0.001))
}

test_that("Mean of the 'sulfate' pollutant of the first ten monitors is as expected", {
  assert_pollutantmean(1:10, "sulfate", 4.064)
})

test_that("Mean of the 'nitrate' pollutant of three samples is as expected", {
  assert_pollutantmean(70:72, "nitrate", 1.706)
})

test_that("Mean of a single sample of the 'nitrate' pollutant is as expected", {
  assert_pollutantmean(23, "nitrate", 1.281)
})