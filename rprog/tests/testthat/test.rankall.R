source("utils.R")
source(getSourceFile("asgmt3", "rankall.R"))

assert_result <- function(df, hospitals, states) {
  expect_false(is.null(df))
  # Flatten the data frame into character vectors
  # see: http://stackoverflow.com/questions/2851015/convert-data-frame-columns-from-factors-to-characters
  df <- data.frame(lapply(df, as.character), stringsAsFactors=FALSE)
  
  # Verify the content
  expect_equal(df$hospital, hospitals)
  expect_equal(df$state, states)
}

test_that("an invalid outcome is rejected", {
  expect_error(rankall("hert attack"), regexp = "invalid outcome")
})

test_that("an invalid rating is rejected", {
  expect_error(rankall("heart attack", -1), regexp = "invalid rating")
})

test_that("The head of the list of hospitals ranked at 20th place for heart attack is as expected", {
  assert_result(head(rankall("heart attack", 20), 10), 
                c(NA, "D W MCMILLAN MEMORIAL HOSPITAL", "ARKANSAS METHODIST MEDICAL CENTER", 
                      "JOHN C LINCOLN DEER VALLEY HOSPITAL", "SHERMAN OAKS HOSPITAL", 
                      "SKY RIDGE MEDICAL CENTER", "MIDSTATE MEDICAL CENTER", NA, NA, 
                      "SOUTH FLORIDA BAPTIST HOSPITAL"), 
                c("AK", "AL", "AR", "AZ", "CA", "CO", "CT", "DC", "DE", "FL"))
})

test_that("The tail of the list of hospitals ranked as worst for pneumonia is as expected", {
  assert_result(tail(rankall("pneumonia", "worst"), 3), 
                c("MAYO CLINIC HEALTH SYSTEM - NORTHLAND, INC", "PLATEAU MEDICAL CENTER", "NORTH BIG HORN HOSPITAL DISTRICT"), 
                c("WI", "WV", "WY"))
})

test_that("The head of the list of the best hospitals for heart failure is as expected", {
  assert_result(tail(rankall("pneumonia", "worst"), 3), 
                c("WELLMONT HAWKINS COUNTY MEMORIAL HOSPITAL", "FORT DUNCAN MEDICAL CENTER", 
                  "VA SALT LAKE CITY HEALTHCARE - GEORGE E. WAHLEN VA MEDICAL CENTER",
                  " SENTARA POTOMAC HOSPITAL", "GOV JUAN F LUIS HOSPITAL & MEDICAL CTR",
                  "SPRINGFIELD HOSPITAL", "HARBORVIEW MEDICAL CENTER", "AURORA ST LUKES MEDICAL CENTER",
                  "FAIRMONT GENERAL HOSPITAL", "CHEYENNE VA MEDICAL CENTER"), 
                c("TN", "TX", "UT", "VA", "VI", "VT", "WA", "WI", "WV", "WY"))
})