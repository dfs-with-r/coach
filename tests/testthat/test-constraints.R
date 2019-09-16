context("constraints")

# test data
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

test_that("team constraints works", {
  model <- model_generic(data, total_salary = 100, roster_size = 3,
                         max_from_team = 1)
  result <- optimize_generic_one(data, model)
  roster <- result$roster

  expect_equal(sort(roster$player_id), c("2", "3", "5"))
  expect_equal(sort(roster$team), c("alpha", "beta", "gamma"))
})

test_that("generic constraints work", {
  model <- model_generic(data, total_salary = 100, roster_size = 3,
                         max_from_team = 1)
  constraints <- list("G" = 2, "F" = 1)
  model <- add_generic_positions_constraint(model, data, constraints)
  result <- optimize_generic_one(data, model)
  roster <- result$roster

  expect_equal(sort(roster$player_id), c("2", "3", "6"))
  expect_equal(sort(roster$team), c("alpha", "beta", "gamma"))
})
