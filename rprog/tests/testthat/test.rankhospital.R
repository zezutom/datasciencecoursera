source("utils.R")
source(getSourceFile("asgmt3", "rankhospital.R"))

test_that("an invalid state is rejected", {
  expect_error(rankhospital("BB", "heart attack"), regexp = "invalid state")
})

test_that("an invalid outcome is rejected", {
  expect_error(rankhospital("NY", "hert attack"), regexp = "invalid outcome")
})

test_that("the best hospital is returned by default", {
  expect_equal(rankhospital("TX", "heart attack"), "CYPRESS FAIRBANKS MEDICAL CENTER")
  expect_equal(rankhospital("TX", "heart failure"), "FORT DUNCAN MEDICAL CENTER")
  expect_equal(best("MD", "pneumonia"), "GREATER BALTIMORE MEDICAL CENTER")
})

test_that("the 4th top ranked hospital in Texas for heart failures is found as expected", {
  expect_equal(rankhospital("TX", "heart failure", 4), "DETAR HOSPITAL NAVARRO")
})

test_that("the worst hospital in Maryland for heart attacks is found as expected", {
  expect_equal(rankhospital("MD", "heart attack", "worst"), "HARFORD MEMORIAL HOSPITAL")
})

test_that("if the ranking exceeds the number of hospitals in the given state NA is returned", {
  expect_true(is.na(rankhospital("MN", "heart attack", 5000)))
})

