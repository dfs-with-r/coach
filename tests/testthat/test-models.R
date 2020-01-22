context("test-models")

N <- 100
player_names <- as.vector(outer(letters, letters, paste0))
team_names <- as.vector(outer(LETTERS, LETTERS, paste0))

data <- data.frame(
  row_id = seq_len(N),
  player_id = as.character(seq_len(N)),
  player = player_names[seq_len(N)],
  team = team_names[seq_len(N)],
  position = "A",
  salary = as.integer(rnorm(N, 10E3, 1E3)),
  fpts_proj = rnorm(N, 15, 5),
  opp_team = team_names[rev(seq_len(N))],
  stringsAsFactors = FALSE
)

test_that("draftkings mlb model works", {
  positions <- c("P", "C", "1B", "2B", "3B", "SS", "OF")
  data[["position"]] <- sample(positions, nrow(data), replace = TRUE)
  testthat::expect_silent(model <- model_dk_mlb(data))
})

test_that("draftkings pga model works", {
  positions <- c("G")
  data[["position"]] <- sample(positions, nrow(data), replace = TRUE)
  testthat::expect_silent(model <- model_dk_pga(data))
})

test_that("fanduel mlb model works", {
  positions <- c("P", "C", "1B", "2B", "3B", "SS", "OF")
  data[["position"]] <- sample(positions, nrow(data), replace = TRUE)
  testthat::expect_silent(model <- model_fd_mlb(data))
})

test_that("fantasydraft mlb model works", {
  positions <- c("P", "IF", "OF")
  data[["position"]] <- sample(positions, nrow(data), replace = TRUE)
  testthat::expect_silent(model <- model_fdr_mlb(data))
})


test_that("draftkings nba model works", {
  positions <- c("PG", "SG", "SF", "PF", "C")
  data[["position"]] <- sample(positions, nrow(data), replace = TRUE)
  testthat::expect_silent(model <- model_dk_nba(data))
})

test_that("fanduel nba model works", {
  positions <- c("PG", "SG", "SF", "PF", "C")
  data[["position"]] <- sample(positions, nrow(data), replace = TRUE)
  testthat::expect_silent(model <- model_fd_nba(data))
})

test_that("fanduel pga model works", {
  positions <- c("G")
  data[["position"]] <- sample(positions, nrow(data), replace = TRUE)
  testthat::expect_silent(model <- model_fd_pga(data))
})

test_that("fantasydraft nba model works", {
  positions <- c("PG", "SG", "SF", "PF", "C")
  data[["position"]] <- sample(positions, nrow(data), replace = TRUE)
  testthat::expect_silent(model <- model_fdr_nba(data))
})
