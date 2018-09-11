context("test-read")

test_that("draftkings reader works", {
  ncols <- 10

  nfl <- read_dk("data/dk-nfl.csv")
  expect_equal(nrow(nfl), 1015)
  expect_equal(ncol(nfl), ncols)

  mlb <- read_dk("data/dk-mlb.csv")
  expect_equal(nrow(mlb), 362)
  expect_equal(ncol(mlb), ncols)
})

test_that("fanduel reader works", {
  ncols <- 11

  nfl <- read_fd("data/fd-nfl.csv")
  expect_equal(nrow(nfl), 715)
  expect_equal(ncol(nfl), ncols)

  mlb <- read_fd("data/fd-mlb.csv")
  expect_equal(nrow(mlb), 806)
  expect_equal(ncol(mlb), ncols)

  nba <- read_fd("data/fd-nba.csv")
  expect_equal(nrow(nba), 413)
  expect_equal(ncol(nba), ncols)

  nhl <- read_fd("data/fd-nhl.csv")
  expect_equal(nrow(nhl), 581)
  expect_equal(ncol(nhl), ncols)

  pga <- read_fd("data/fd-pga.csv")
  expect_equal(nrow(pga), 156)
  expect_equal(ncol(pga), ncols)
})

