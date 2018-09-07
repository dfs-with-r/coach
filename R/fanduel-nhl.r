#' @rdname model_generic
#' @export
model_fd_nhl <- function(data, existing_rosters = list()) {

  # params
  total_salary <- 55E3
  roster_size <- 9
  max_from_team <- 4

  # build model
  model_generic(data, total_salary, roster_size, max_from_team, existing_rosters) %>%
    add_fduel_nhl_roster_positions_constraint(data)
  # need to add constraint to avoid having skaters and opposing goalie on same team?

  model
}

#' @importFrom ompr add_constraint sum_expr colwise
#' @keywords internal
add_fduel_nhl_roster_positions_constraint <- function(model, nhl) {
  # position constraint helpers
  n <- nrow(nhl)
  is_position <- function(pos) {
    function(i) {
      as.integer(pos == nhl$position[i]) # function needs to be vectorized
    }
  }

  Ctr <- is_position("C")
  W <- is_position("W")
  D <- is_position("D")
  G <- is_position("G")

  model %>%
    # Center
    add_constraint(sum_expr(colwise(Ctr(i)) * x[i], i = 1:n) == 2) %>%

    # Wing
    add_constraint(sum_expr(colwise(W(i)) * x[i], i = 1:n) == 4) %>%

    # Defender
    add_constraint(sum_expr(colwise(D(i)) * x[i], i = 1:n) == 2) %>%

    # Goalie
    add_constraint(sum_expr(colwise(G(i)) * x[i], i = 1:n) == 1)
}

