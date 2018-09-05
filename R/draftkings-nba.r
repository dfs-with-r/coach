#' @rdname model_generic
#' @export
model_dk_nba <- function(data, existing_rosters = list()) {

  # params
  total_salary <- 50E3
  roster_size <- 8
  max_from_team <- 5

  # build model
  model <- model_generic(data, total_salary, roster_size, max_from_team, existing_rosters) %>%
    add_dk_nba_roster_positions_constraint(data) %>%
    add_unique_id_constraint(data)

  model
}

#' @importFrom ompr add_constraint sum_expr colwise
#' @keywords internal
add_dk_nba_roster_positions_constraint <- function(model, nba) {
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
    # point guard
    add_constraint(sum_expr(colwise(PG(i)) * x[i], i = 1:n) >= 1) %>%
    add_constraint(sum_expr(colwise(PG(i)) * x[i], i = 1:n) <= 3) %>%

    # shooting guard
    add_constraint(sum_expr(colwise(SG(i)) * x[i], i = 1:n) >= 1) %>%
    add_constraint(sum_expr(colwise(SG(i)) * x[i], i = 1:n) <= 3) %>%

    # guards
    add_constraint(sum_expr(colwise(PG(i) + SG(i)) * x[i], i = 1:n) >= 3) %>%
    add_constraint(sum_expr(colwise(PG(i) + SG(i)) * x[i], i = 1:n) <= 4) %>%

    # small forward
    add_constraint(sum_expr(colwise(SF(i)) * x[i], i = 1:n) >= 1) %>%
    add_constraint(sum_expr(colwise(SF(i)) * x[i], i = 1:n) <= 3) %>%

    # power forward
    add_constraint(sum_expr(colwise(PF(i)) * x[i], i = 1:n) >= 1) %>%
    add_constraint(sum_expr(colwise(PF(i)) * x[i], i = 1:n) <= 3) %>%

    # forwards
    add_constraint(sum_expr(colwise(SF(i) + PF(i)) * x[i], i = 1:n) >= 3) %>%
    add_constraint(sum_expr(colwise(SF(i) + PF(i)) * x[i], i = 1:n) <= 4) %>%

    # center
    add_constraint(sum_expr(colwise(CR(i)) * x[i], i = 1:n) >= 1) %>%
    add_constraint(sum_expr(colwise(CR(i)) * x[i], i = 1:n) <= 2)
}

