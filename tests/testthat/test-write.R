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
