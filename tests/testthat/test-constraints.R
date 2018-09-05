context("constraints")

# test data
data <- tibble::tibble(player = c("alice", "bob", "carol", "daniel", "esther"),
                       team_id = c("alpha", "alpha", "beta", "beta", "gamma"),
                       position = c("G", "G", "G", "G", "G"),
                       fpts_proj = c(10, 20, 30, 20, 5),
                       salary = rep(33, 5),
                       size = rep(1, 5),
                       rowid = seq_along(player),
                       id = seq_along(player))

test_that("team constraints works", {
  model <- model_generic(data, total_salary = 100, roster_size = 3,
                         max_from_team = 1)
  result <- optimize_generic_one(data, model)
  roster <- result$roster

  expect_equal(sort(roster$team_id), c("alpha", "beta", "gamma"))
})
