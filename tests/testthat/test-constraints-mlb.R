context("constraints-mlb")

# test data
n <- 4
data_opp_teams <- data.frame(
  player = c("alice", "bob", "carol", "dan"),
  team = c("alpha", "beta", "gamma", "gamma"),
  opp_team = c("beta", "alpha", "omega", "omega"),
  position = c("P", "3B", "2B", "3B"),
  fpts_proj = c(30, 20, 10, 5),
  salary = rep(33L, n),
  row_id = seq_len(n),
  player_id = as.character(seq_len(n)),
  stringsAsFactors = FALSE)

data_non_opp_teams <- data.frame(
  player = c("alice", "bob", "carol", "dan"),
  team = c("alpha", "beta", "gamma", "gamma"),
  opp_team = c("zeta", "garble", "omega", "omega"),
  position = c("P", "3B", "2B", "3B"),
  fpts_proj = c(30, 20, 10, 5),
  salary = rep(33L, n),
  size = rep(1, n),
  row_id = seq_len(n),
  player_id = as.character(seq_len(n)),
  stringsAsFactors = FALSE)

test_that("pitcher vs hitter constraint works when we have opposing pitcher/hitters", {
  model <- model_generic(data_opp_teams, total_salary = 100, roster_size = 3, max_from_team = 2) %>%
    add_pitcher_hitter_constraint(data_opp_teams)

  result <- optimize_generic_one(data_opp_teams, model)
  roster <- result$roster

  expect_equal(sort(roster$team), c("alpha", "gamma", "gamma"))
})

test_that("pitcher vs hitter constraint works when don't have opposing pitcher/hitters", {
  model <- model_generic(data_non_opp_teams, total_salary = 100, roster_size = 3, max_from_team = 2) %>%
    add_pitcher_hitter_constraint(data_non_opp_teams)

  result <- optimize_generic_one(data_non_opp_teams, model)
  roster <- result$roster

  expect_equal(sort(roster$team), c("alpha", "beta", "gamma"))
})

test_that("stacking works", {
  model <- model_generic(data_opp_teams, total_salary = 100, roster_size = 3) %>%
    add_stack_size_constraint(data_opp_teams, stack_sizes = 2)

  result <- optimize_generic_one(data_opp_teams, model)
  roster <- result$roster
  expect_equal(sort(roster$team), c("alpha", "gamma", "gamma"))
})
