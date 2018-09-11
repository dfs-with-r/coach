context("test-write")

test_that("position normalization works when all inputs provided", {
  pos <- c("P", "1B", "1B", "2B", "3B", "SS", "OF", "OF", "OF")
  pos_max <- c("P" = 1, "1B" = 1, "2B" = 1, "3B" = 1, "SS" = 1, "OF" = 3)
  wildcard <- "UTIL"

  new_pos <- normalize_positions(pos, pos_max, wildcard)
  expected <- c("P", "1B", "UTIL", "2B", "3B", "SS", "OF", "OF", "OF")
  expect_equal(new_pos, expected)
})

test_that("position normalization works when not all positions provide a max", {
  pos <- c("PG", "PG", "SG", "SF", "PF", "PF", "PF", "C")
  pos_max <- c("PG" = 1, "SG" = 1)
  wildcard <- "G"

  new_pos <- normalize_positions(pos, pos_max, wildcard)
  expected <- c("PG", "G", "SG", "SF", "PF", "PF", "PF", "C")
  expect_equal(new_pos, expected)
})

test_that("dk nfl position normalization works", {
  pos <- c("QB", "RB", "RB", "RB", "WR", "WR", "WR", "TE", "DST")
  actual <- normalize_dk_nfl(pos)

  expected <- c("QB", "RB", "RB", "FLEX", "WR", "WR", "WR", "TE", "DST")
  expect_equal(actual, expected)
})

test_that("dk nba position normalization works", {
  pos <- c("PG", "PG", "SG", "SF", "PF", "PF", "PF", "C")
  actual <- normalize_dk_nba(pos)

  expected <- c("PG", "G", "SG", "SF", "PF", "F", "UTIL", "C")
  expect_equal(actual, expected)
})

test_that("dk nhl position normalization works", {
  pos <- c("C", "C", "LW", "RW", "RW", "D", "D", "C", "G")
  actual <- normalize_dk_nhl(pos)

  expected <- c("C", "C", "W", "W", "W", "D", "D", "UTIL", "G")
  expect_equal(actual, expected)
})

test_that("fd nfl position normalization works", {
  pos <- c("QB", "RB", "RB", "RB", "WR", "WR", "WR", "TE", "DE")
  actual <- normalize_fd_nfl(pos)

  expected <- c("QB", "RB", "RB", "FLEX", "WR", "WR", "WR", "TE", "DE")
  expect_equal(actual, expected)
})

test_that("fd mlb position normalization works", {
  pos <- c("P", "1B", "2B", "2B", "3B", "SS", "OF", "OF", "OF")
  actual <- normalize_fd_mlb(pos)

  expected <- c("P", "C/1B", "2B", "UTIL", "3B", "SS", "OF", "OF", "OF")
  expect_equal(actual, expected)
})


