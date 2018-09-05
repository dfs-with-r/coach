#' @rdname model_generic
#' @export
model_fdr_nfl <- function(data, existing_rosters = list()) {
  # params
  total_salary <- 100E3
  roster_size <- 9L
  max_from_team <- 4L

  # build model
  model_generic(data, total_salary, roster_size, max_from_team, existing_rosters) %>%
    add_fdr_nfl_roster_positions_constraint(data)

  model
}

#' @importFrom ompr add_constraint sum_expr
#' @keywords internal
add_fdr_nfl_roster_positions_constraint <- function(model, nfl) {
  # position constraint helpers
  n <- nrow(nfl)
  is_position <- function(pos) {
    function(i) {
      # change `==` to `%in%`?
      # as.integer(nfl$position[i] == pos)
      as.integer(pos %in% unlist(nfl$position[i]))
    }
  }

  QB <- is_position("QB")
  RB <- is_position("RB")
  WR <- is_position("WR")
  TE <- is_position("TE")
  DST <- is_position("DST")

  model %>%
    # pitcher
    add_constraint(sum_expr(QB(i) * x[i], i = 1:n) == 1) %>%

    # running back
    add_constraint(sum_expr(RB(i) * x[i], i = 1:n) >= 2) %>%
    add_constraint(sum_expr(RB(i) * x[i], i = 1:n) <= 4) %>%

    # wide receiver
    add_constraint(sum_expr(WR(i) * x[i], i = 1:n) >= 2) %>%
    add_constraint(sum_expr(WR(i) * x[i], i = 1:n) <= 4) %>%

    # tight end
    add_constraint(sum_expr(TE(i) * x[i], i = 1:n) >= 1) %>%
    add_constraint(sum_expr(TE(i) * x[i], i = 1:n) <= 3) %>%

    # defense
    add_constraint(sum_expr(DST(i) * x[i], i = 1:n) == 1)

}

