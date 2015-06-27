source("utils.R")
source(getSourceFile("asgmt3", "best.R"))

test_that("an invalid state is rejected", {
  expect_error(best("BB", "heart attack"), regexp = "invalid state")
})

test_that("an invalid outcome is rejected", {
  expect_error(best("NY", "hert attack"), regexp = "invalid outcome")
})

test_that("the best hospital in Texas for heart attacks is found as expected", {
  expect_equal(best("TX", "heart attack"), "CYPRESS FAIRBANKS MEDICAL CENTER")
})

test_that("the best hospital in Texas for heart failures is found as expected", {
  expect_equal(best("TX", "heart failure"), "FORT DUNCAN MEDICAL CENTER")
})

test_that("the best hospital in Maryland for heart attacks is found as expected", {
  expect_equal(best("MD", "heart attack"), "JOHNS HOPKINS HOSPITAL, THE")
})

test_that("the hospital in Maryland for pneumonia is found as expected", {
  expect_equal(best("MD", "pneumonia"), "GREATER BALTIMORE MEDICAL CENTER")
})