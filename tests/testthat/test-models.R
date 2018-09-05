context("test-models")

N <- 100
player_names <- as.vector(outer(letters, letters, paste0))
team_names <- as.vector(outer(LETTERS, LETTERS, paste0))

data <- data.frame(
  rowid = seq_len(N),
  id = seq_len(N),
  player = player_names[seq_len(N)],
  team_id = team_names[seq_len(N)],
  position = "A",
  salary = rnorm(N, 10E3, 1E3),
  fpts_proj = rnorm(N, 15, 5),
  size = 1,
  opp_team_id = team_names[rev(seq_len(N))],
  stringsAsFactors = FALSE
)

test_that("draftkings mlb model works", {
  positions <- c("P", "C", "1B", "2B", "3B", "SS", "OF")
  data[["position"]] <- sample(positions, nrow(data), replace = TRUE)
  testthat::expect_silent(model <- model_dk_mlb(data))
})

test_that("fanduel mlb model works", {
  positions <- c("P", "C", "1B", "2B", "3B", "SS", "OF")
  data[["position"]] <- sample(positions, nrow(data), replace = TRUE)
  testthat::expect_silent(model <- model_fduel_mlb(data))
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
  testthat::expect_silent(model <- model_dk_nba(data))
})

test_that("fantasydraft nba model works", {
  positions <- c("PG", "SG", "SF", "PF", "C")
  data[["position"]] <- sample(positions, nrow(data), replace = TRUE)
  testthat::expect_silent(model <- model_dk_nba(data))
})
