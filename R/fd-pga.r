#' @rdname model_generic
#' @export
model_fd_pga <- function(data, ...) {

  # params
  total_salary <- 60E3
  roster_size <- 6
  max_from_team <- 6

  # build model
  model <- model_generic(data, total_salary, roster_size, max_from_team, ...) %>%
    add_fduel_pga_roster_positions_constraint(data)

  model
}

#' @importFrom ompr add_constraint sum_expr colwise
#' @keywords internal
add_fduel_pga_roster_positions_constraint <- function(model, pga) {
  # check position names
  assert_has_positions(pga, "G")

  # position constraint helpers
  n <- nrow(pga)
  is_position <- function(pos) {
    function(i) {
      as.integer(pos == pga$position[i])
    }
  }

  G <- is_position("G")

  model %>%
    # G
    add_constraint(sum_expr(colwise(G(i)) * x[i], i = 1:n) == 6)
}

