context("test-read")

test_that("draftkings reader works", {
  ncols <- 10

  nfl <- read_dk("data/dk-nfl.csv")
  expect_equal(nrow(nfl), 1015)
  expect_equal(ncol(nfl), ncols)

  mlb <- read_dk("data/dk-mlb.csv")
  expect_equal(nrow(mlb), 362)
  expect_equal(ncol(mlb), ncols)

  nascar <- read_dk("data/dk-nascar.csv")
  expect_equal(nrow(nascar), 42)
  expect_equal(ncol(nascar), 10)
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

test_that("adding an opp team works for non-team sport", {
  df <- data.frame(name = c("Alice", "Bob"),
                   teamabbrev = c("ATEAM", "BTEAM"),
                   game_info = c("DAYTONA 500", "DAYTONA 500"),
                   stringsAsFactors = FALSE)

  actual <- add_dk_opp_team(df)
  expect_equal(nrow(actual), nrow(df))
  expect_equal(ncol(actual), ncol(df) + 2)
  expect_true(all(is.na(actual$opp_team)))
  expect_true(all(is.na(actual$location)))
})

