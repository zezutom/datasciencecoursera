source("utils.R")
source(getSourceFile("asgmt1", "corr.R"))

assert_corr_result <- function(cr, ...) {
  cr.head.expected <- c(...)
  expect_that(head(cr), equals(cr.head.expected, tolerance = 0.001))
}

assert_corr <- function(threshold, ...) {
  cr <- corr(getDataDir("specdata"), threshold)
  assert_corr_result(cr, ...)
}

test_that("Correlations are as expected when the threshold is fairly low", {
  assert_corr(150, -0.01896, -0.14051, -0.04390, -0.06816, -0.12351, -0.07589)
})

test_that("Correlations are as expected when the threshold is reasonably high", {
  assert_corr(400, -0.01896, -0.04390, -0.06816, -0.07589,  0.76313, -0.15783)
})

test_that("If no monitors meet the threshold requirement, then the function should return a numeric vector of length 0", {
  expect_equal(corr(getDataDir("specdata"), 5000), vector(mode = "numeric", length = 0))
})

test_that("Correlations are as expected when no threshold is provided", {
  cr <- corr(getDataDir("specdata"))
  assert_corr_result(cr, -0.22255, -0.01896, -0.14051, -0.04390, -0.06816, -0.12350)
})
