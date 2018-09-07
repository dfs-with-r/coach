context("test-read")

test_that("draftkings nfl reader works", {
  df <- read_dk_nfl("data/dk-nfl.csv")

  expect_equal(nrow(df), 685)
  expect_equal(ncol(df), 9)
})

test_that("draftkings mlb reader works", {
  df <- read_dk_mlb("data/dk-mlb.csv")

  expect_equal(nrow(df), 362)
  expect_equal(ncol(df), 9)
})

