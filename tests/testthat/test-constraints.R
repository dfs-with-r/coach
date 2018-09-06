context("constraints")

# test data
n <- 5L
data <- data.frame(
  player = c("alice", "bob", "carol", "daniel", "esther"),
  team = c("alpha", "alpha", "beta", "beta", "gamma"),
  position = c("G", "G", "G", "G", "G"),
  fpts_proj = c(10, 20, 30, 20, 5),
  salary = rep(33, n),
  row_id = seq_len(n),
  player_id = seq_len(n),
  stringsAsFactors = FALSE)

test_that("team constraints works", {
  model <- model_generic(data, total_salary = 100, roster_size = 3,
                         max_from_team = 1)
  result <- optimize_generic_one(data, model)
  roster <- result$roster

  expect_equal(sort(roster$team), c("alpha", "beta", "gamma"))
})
