source("utils.R")
source(getSourceFile("pollutantmean.R"))

test_that("Mean of the 'sulfate' pollutant of the first ten monitors is as expected", {
	expect_that(pollutantmean(getDataDir("specdata"), "sulfate", 1:10), equals(4.064, tolerance = 0.001))
})

test_that("Mean of the 'nitrate' pollutant of three samples is as expected", {
	expect_that(pollutantmean(getDataDir("specdata"), "nitrate", 70:72), equals(1.706, tolerance = 0.001))
})

test_that("Mean of a single sample of the 'nitrate' pollutant is as expected", {
	expect_that(pollutantmean(getDataDir("specdata"), "nitrate", 23), equals(1.281, tolerance = 0.001))
})