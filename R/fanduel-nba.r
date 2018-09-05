#' @rdname model_generic
#' @export
model_fduel_nba <- function(data, existing_rosters = list()) {

  # params
  total_salary <- 60E3
  roster_size <- 9
  max_from_team <- 4

  # build model
  model <- model_generic(data, total_salary, roster_size, max_from_team, existing_rosters) %>%
    add_fduel_nba_roster_positions_constraint(data)

  model
}

#' @importFrom ompr add_constraint sum_expr colwise
#' @keywords internal
add_fduel_nba_roster_positions_constraint <- function(model, nba) {
  # check position names
  assert_has_positions(nba, c("PG", "SG", "SF", "PF", "C"))

  # position constraint helpers
  n <- nrow(nba)
  is_position <- function(pos) {
    function(i) {
      as.integer(pos == nba$position[i])
    }
  }

  PG <- is_position("PG")
  SG <- is_position("SG")
  SF <- is_position("SF")
  PF <- is_position("PF")
  CR <- is_position("C")

  model %>%
    # PG
    add_constraint(sum_expr(colwise(PG(i)) * x[i], i = 1:n) == 2) %>%

    # SG
    add_constraint(sum_expr(colwise(SG(i)) * x[i], i = 1:n) == 2) %>%

    # SF
    add_constraint(sum_expr(colwise(SF(i)) * x[i], i = 1:n) == 2) %>%

    # PF
    add_constraint(sum_expr(colwise(PF(i)) * x[i], i = 1:n) == 2) %>%

    # C
    add_constraint(sum_expr(colwise(CR(i)) * x[i], i = 1:n) == 1)
}

