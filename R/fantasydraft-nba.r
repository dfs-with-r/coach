#' @rdname model_generic
#' @export
model_fdr_nba <- function(data, ...) {

  # params
  total_salary <- 100E3
  roster_size <- 8
  max_from_team <- 4

  # build model
  model <- model_generic(data, total_salary, roster_size, max_from_team, ...) %>%
    add_fdr_nba_roster_positions_constraint(data)

  model
}

#' @importFrom ompr add_constraint sum_expr
#' @keywords internal
add_fdr_nba_roster_positions_constraint <- function(model, nba) {
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
    # guards
    add_constraint(sum_expr((colwise(PG(i)) + colwise(SG(i))) * x[i], i = 1:n) >= 3) %>%
    add_constraint(sum_expr((colwise(PG(i)) + colwise(SG(i))) * x[i], i = 1:n) <= 5) %>%

    # forwards and centers
    add_constraint(sum_expr((colwise(SF(i)) + colwise(PF(i)) + colwise(CR(i))) * x[i], i = 1:n) >= 3) %>%
    add_constraint(sum_expr((colwise(SF(i)) + colwise(PF(i)) + colwise(CR(i))) * x[i], i = 1:n) <= 5)
}

