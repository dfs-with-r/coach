#' @rdname model_generic
model_fdr_mlb <- function(data, existing_rosters = list()) {

  # params
  total_salary = 100E3
  roster_size = 10
  max_from_team <- 3

  # build model
  model_generic(data, total_salary, roster_size, max_from_team, existing_rosters) %>%
    add_fdr_mlb_roster_positions_constraint(data) %>%
    add_pitcher_hitter_constraint(data)
}

#' @importFrom ompr add_constraint sum_expr
#' @keywords internal
add_fdr_mlb_roster_positions_constraint <- function(model, mlb) {
  # check position names
  assert_has_positions(mlb, c("P", "IF", "OF"))

  # position constraint helpers
  n <- nrow(mlb)
  is_position <- function(pos) {
    function(i) {
      as.integer(pos == mlb$position[i])
    }
  }

  # position constraint helpers
  n <- nrow(mlb)
  is_position <- function(pos) {
    function(i) {
      as.integer(pos == mlb$position[i]) # function needs to be vectorized
    }
  }

  P <- is_position("P")
  IF <- is_position("IF")
  OF <- is_position("OF")

  model %>%
    # pitcher
    add_constraint(sum_expr(P(i) * x[i], i = 1:n) == 2) %>%

    # infielder
    add_constraint(sum_expr(IF(i) * x[i], i = 1:n) >= 3) %>%
    add_constraint(sum_expr(IF(i) * x[i], i = 1:n) <= 5) %>%

    # outfielder
    add_constraint(sum_expr(OF(i) * x[i], i = 1:n) >= 3) %>%
    add_constraint(sum_expr(OF(i) * x[i], i = 1:n) <= 5)
}

