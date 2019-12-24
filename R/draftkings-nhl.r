#' @rdname model_generic
#' @export
model_dk_nhl <- function(data, ...) {

  # params
  total_salary <- 50E3
  roster_size <- 9
  max_from_team <- 5

  # build model
  model <- model_generic(data, total_salary, roster_size, max_from_team, ...) %>%
    add_dk_nhl_roster_positions_constraint(data)

  model
}

#' @importFrom ompr add_constraint sum_expr colwise
#' @keywords internal
add_dk_nhl_roster_positions_constraint <- function(model, nhl) {
  # check position names
  assert_has_positions(nhl, c("C", "LW", "RW", "D", "G"))

  # position constraint helpers
  n <- nrow(nhl)
  is_position <- function(pos) {
    function(i) {
      as.integer(pos == nhl$position[i])
    }
  }

  Ctr <- is_position("C")
  LW <- is_position("LW")
  RW <- is_position("RW")
  D <- is_position("D")
  G <- is_position("G")

  model %>%
    # Center
    add_constraint(sum_expr(colwise(Ctr(i)) * x[i], i = 1:n) >= 2) %>%
    add_constraint(sum_expr(colwise(Ctr(i)) * x[i], i = 1:n) <= 3) %>%

    # Wings
    add_constraint(sum_expr(colwise(LW(i) + RW(i)) * x[i], i = 1:n) >= 3) %>%
    add_constraint(sum_expr(colwise(LW(i) + RW(i)) * x[i], i = 1:n) <= 4) %>%

    # Defender
    add_constraint(sum_expr(colwise(D(i)) * x[i], i = 1:n) >= 2) %>%
    add_constraint(sum_expr(colwise(D(i)) * x[i], i = 1:n) <= 3) %>%

    # Goalie
    add_constraint(sum_expr(colwise(G(i)) * x[i], i = 1:n) == 1)
}

