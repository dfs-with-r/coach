context("stacking")

# test data
n <- 7L
data <- data.frame(
  player = c("alice", "bob", "carol", "dan", "ed", "fiona", "george"),
  team = c("alpha", "beta", "gamma", "gamma", "gamma", "zeta", "zeta"),
  opp_team = c("beta", "alpha", "omega", "omega", "omega", "nu", "nu"),
  position = c("1B", "1B", "1B", "1B", "1B", "1B", "1B"),
  fpts_proj = c(30, 20, 10, 5, 1, 3, 3),
  salary = rep(33, n),
  row_id = seq_len(n),
  player_id = seq_len(n),
  stringsAsFactors = FALSE)

model <- model_generic(data, total_salary = 165, roster_size = 5)

test_that("stacking single team works", {
  results <- optimize_generic(data, model, L = 1L, stack_sizes = c(3))
  res <- results[[1]]

  expect_equal(res[["team"]], c("alpha", "beta", "gamma", "gamma", "gamma"))
})

test_that("stacking multiple teams works", {
  results <- optimize_generic(data, model, L = 1L, stack_sizes = c(3, 2))
  res <- results[[1]]

  expect_equal(res[["team"]], c("gamma", "gamma", "gamma", "zeta", "zeta"))
})
