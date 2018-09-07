context("generic")

# test data
total_salary <- 100
roster_size <- 2
data <- data.frame(
  row_id = 1:3,
  player_id = as.character(1:3),
  player = c("alice", "bob", "charlie"),
  team = c("alpha", "alpha", "beta"),
  position = c("A", "A", "B"),
  fpts_proj = c(10, 20, 30),
  salary = c(25L, 50L, 75L),
  stringsAsFactors = FALSE)

test_that("generic model builds correctly", {
  model <- model_generic(data, total_salary, roster_size)
  expect_equal(class(model), "milp_model")
})

test_that("generic model is optimized correctly", {
  model <- model_generic(data, total_salary, roster_size)
  result <- optimize_generic_one(data, model)
  roster <- result[["roster"]]

  actual <- sort(roster[["player_id"]])
  expected <- as.character(c(1,3))
  expect_equal(actual, expected)
})
