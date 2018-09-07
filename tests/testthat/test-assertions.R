context("assertions")

df <- data.frame(a = 1:10, b = 101:110)

test_that("assert_has_cols is silent when columns are in data frame", {
  expect_silent(assert_has_cols(df, colnames(df)))
})

test_that("assert_has_cols throws error when any columns are not in data frame", {
  expect_error(assert_has_cols(df, c("a", "z")))
})

test_that("assert_coltypes throws error when any columns are not the right type", {
  expect_error(assert_has_cols(df, c("a", "b"), c("double", "character")))
})
