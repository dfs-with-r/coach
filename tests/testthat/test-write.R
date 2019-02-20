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

test_that("lineup normalization fixes positions and orders rows correctly", {
  d <- data.frame(
    player_id = 1:9,
    position = c("RB", "QB", "RB", "RB", "WR", "WR", "WR", "TE", "DST"),
    stringsAsFactors = FALSE
    )

  actual <- normalize_lineup(d, "draftkings", "nfl")

  expect_equal(actual[["player_id"]], c(2,1,3,5,6,7,8,4,9))
  expect_equal(actual[["position"]], c("QB", "RB", "RB", "WR", "WR", "WR", "TE", "FLEX", "DST"))
})

test_that("write_lineups writes correct results", {
  nhl <- read_fd("data/fd-nhl.csv")
  nhl$fpts_proj <- rnorm(nrow(nhl), nhl$fpts_avg, 3)
  model <- model_fd_nhl(nhl)
  lineups <- optimize_generic(nhl, model)

  actual <- write_lineups(lineups, site = "fanduel", sport = "nhl")
  expect_equal(colnames(actual), c("C", "C", "W", "W", "W", "W", "D", "D", "G"))
  expect_equal(dim(actual), c(3, 9))
})

