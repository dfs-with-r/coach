#' @rdname model_generic
#' @keywords internal
model_fd_wnba <- function(data, existing_rosters = list()) {

  # params
  total_salary <- 40E3
  roster_size <- 7
  max_from_team <- 4

  # build model
  model_generic(data, total_salary, roster_size, max_from_team, existing_rosters) %>%
    add_fduel_wnba_roster_positions_constraint(data)

  model
}

#' @importFrom ompr add_constraint sum_expr colwise
#' @keywords internal
add_fduel_wnba_roster_positions_constraint <- function(model, wnba) {
  # position constraint helpers
  n <- nrow(wnba)
  is_position <- function(pos) {
    function(i) {
      as.integer(pos == wnba$position[i]) # function needs to be vectorized
    }
  }

  G <- is_position("G")
  FR <- is_position("F")

  model %>%
    # G
    add_constraint(sum_expr(colwise(G(i)) * x[i], i = 1:n) == 3) %>%

    # F
    add_constraint(sum_expr(colwise(FR(i)) * x[i], i = 1:n) == 4)
}

