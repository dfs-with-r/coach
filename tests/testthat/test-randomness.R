context("test-randomness")

n <- 6L
data <- data.frame(
  player = c("alice", "bob", "carol", "daniel", "esther", "frank"),
  team = c("alpha", "alpha", "beta", "beta", "gamma", "gamma"),
  position = c("G", "G", "G", "G", "G", "F"),
  fpts_proj = c(10, 20, 30, 20, 5, 1),
  salary = rep(33L, n),
  row_id = seq_len(n),
  player_id = as.character(seq_len(n)),
  stringsAsFactors = FALSE)

model <- model_generic(data, total_salary = 100, roster_size = 3)

test_that("no randomness when function is null", {
  lineup_1 <- optimize_generic(data, model, L = 1L, randomness = NULL)[[1]]
  lineup_2 <- optimize_generic(data, model, L = 1L, randomness = NULL)[[1]]

  expect_identical(lineup_1, lineup_2)
})

test_that("randomness provides different linueps", {
  randomness <- function(x) rnorm(n, x, 10)
  lineup_1 <- optimize_generic(data, model, L = 1L, randomness = randomness)[[1]]
  lineup_2 <- optimize_generic(data, model, L = 1L, randomness = randomness)[[1]]

  expect_true(!identical(lineup_1, lineup_2))
})
