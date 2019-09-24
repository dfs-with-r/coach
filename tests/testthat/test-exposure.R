context("exposure")

# test data
n <- 7L
data <- data.frame(
  player = c("alice", "bob", "carol", "dan", "ed", "fiona", "george"),
  team = c("alpha", "beta", "gamma", "gamma", "gamma", "zeta", "zeta"),
  opp_team = c("beta", "alpha", "omega", "omega", "omega", "nu", "nu"),
  position = c("1B", "1B", "1B", "1B", "1B", "1B", "1B"),
  fpts_proj = c(30, 20, 10, 5, 1, 3, 3),
  salary = rep(33L, n),
  row_id = seq_len(n),
  player_id = as.character(seq_len(n)),
  stringsAsFactors = FALSE)

model <- model_generic(data, total_salary = 165, roster_size = 3)

test_that("max exposure works", {
  results <- optimize_generic(data, model, L = 4L, max_exposure = 0.5)
  results <- do.call(rbind, results)

  player_table <- table(results$player)
  player_count <- as.integer(player_table)
  names(player_count) <- dimnames(player_table)[[1]]

  expected <-  c("alice" = 2, "bob" = 2, "carol" = 2,
                 "dan" = 2, "fiona" = 2, "george" = 2)

  expect_equal(player_count, expected)
  expect_true(all(player_count <= 2))
})

test_that("locked players get excluded from max_exposure constraint", {
  locks <- c(1, 2)
  results <- optimize_generic(data, model, L = 4L, locks = locks, max_exposure = 0.5)
  results <- do.call(rbind, results)

  player_table <- table(results$player)
  player_count <- as.integer(player_table)
  names(player_count) <- dimnames(player_table)[[1]]

  expected <- c("alice" = 4, "bob" = 4, "carol" = 1, "dan" = 1, "fiona" = 1, "george" = 1)

  expect_equal(player_count, expected)
  expect_true(all(player_count[-locks] <= 2))
  expect_true(all(player_count[locks] == 4L))
})
