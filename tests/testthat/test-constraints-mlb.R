context("constraints-mlb")

# test data
data_opp_teams <- tibble::tibble(player = c("alice", "bob", "carol", "dan"),
                       team_id = c("alpha", "beta", "gamma", "gamma"),
                       opp_team_id = c("beta", "alpha", "omega", "omega"),
                       position = c("P", "3B", "2B", "3B"),
                       fpts_proj = c(30, 20, 10, 5),
                       salary = rep(33, 4),
                       size = rep(1, 4),
                       rowid = seq_along(player),
                       id = seq_along(player))

data_non_opp_teams <- tibble::tibble(player = c("alice", "bob", "carol", "dan"),
                       team_id = c("alpha", "beta", "gamma", "gamma"),
                       opp_team_id = c("zeta", "garble", "omega", "omega"),
                       position = c("P", "3B", "2B", "3B"),
                       fpts_proj = c(30, 20, 10, 5),
                       salary = rep(33, 4),
                       size = rep(1, 4),
                       rowid = seq_along(player),
                       id = seq_along(player))

test_that("pitcher vs hitter constraint works when we have opposing pitcher/hitters", {
  model <- model_generic(data_opp_teams, total_salary = 100, roster_size = 3, max_from_team = 2) %>%
    add_pitcher_hitter_constraint(data_opp_teams)

  result <- optimize_generic_one(data_opp_teams, model)
  roster <- result$roster

  expect_equal(sort(roster$team_id), c("alpha", "gamma", "gamma"))
})

test_that("pitcher vs hitter constraint works when don't have opposing pitcher/hitters", {
  model <- model_generic(data_non_opp_teams, total_salary = 100, roster_size = 3, max_from_team = 2) %>%
    add_pitcher_hitter_constraint(data_non_opp_teams)

  result <- optimize_generic_one(data_non_opp_teams, model)
  roster <- result$roster

  expect_equal(sort(roster$team_id), c("alpha", "beta", "gamma"))
})

test_that("stacking works", {
  model <- model_generic(data_opp_teams, total_salary = 100, roster_size = 3) %>%
    add_stack_size_constraint(data_opp_teams, stack_sizes = 2)

  result <- optimize_generic_one(data_opp_teams, model)
  roster <- result$roster
  expect_equal(sort(roster$team_id), c("alpha", "gamma", "gamma"))
})
