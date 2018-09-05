context("generic")

# test data
total_salary <- 100
roster_size <- 2
data <- tibble::tibble(rowid = 1:3,
                       id = 1:3,
                       player = c("alice", "bob", "charlie"),
                       team_id = c("alpha", "alpha", "beta"),
                       position = c("A", "A", "B"),
                       fpts_proj = c(10, 20, 30),
                       salary = c(25, 50, 75),
                       size = c(1L, 1L, 1L))

test_that("generic model builds correctly", {
  model <- model_generic(data, total_salary, roster_size)
  expect_equal(class(model), "milp_model")
})

test_that("generic model is optimized correctly", {
  model <- model_generic(data, total_salary, roster_size)
  result <- optimize_generic_one(data, model)
  roster <- result[["roster"]]

  actual <- sort(roster[["id"]])
  expected <- as.integer(c(1,3))
  expect_equal(actual, expected)
})
