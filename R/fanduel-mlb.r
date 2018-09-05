#' @rdname model_generic
#' @export
model_fduel_mlb <- function(data, existing_rosters = list()) {

  # params
  total_salary <- 35E3
  roster_size <- 9L
  max_from_team = 4L

  # build model
  model_generic(data, total_salary, roster_size, max_from_team, existing_rosters) %>%
    add_fduel_mlb_roster_positions_constraint(data) %>%
    add_pitcher_hitter_constraint(data)
}

#' @importFrom ompr add_constraint sum_expr colwise
#' @keywords internal
add_fduel_mlb_roster_positions_constraint <- function(model, mlb) {
  # check position names
  assert_has_positions(mlb, c("P", "C", "1B", "2B", "3B", "SS", "OF"))

  # position constraint helpers
  n <- nrow(mlb)
  is_position <- function(pos) {
    function(i) {
      as.integer(pos == mlb$position[i]) # function needs to be vectorized
    }
  }

  P <- is_position("P")
  CR <- is_position("C")
  B1 <- is_position("1B")
  B2 <- is_position("2B")
  B3 <- is_position("3B")
  SS <- is_position("SS")
  OF <- is_position("OF")

  model %>%
    # Pitcher
    add_constraint(sum_expr(colwise(P(i)) * x[i], i = 1:n) == 1) %>%

    # Catcher and 1B
    add_constraint(sum_expr((colwise(CR(i)) + colwise(B1(i))) * x[i], i = 1:n) >= 1) %>%
    add_constraint(sum_expr((colwise(CR(i)) + colwise(B1(i))) * x[i], i = 1:n) <= 2) %>%

    # 2B
    add_constraint(sum_expr(colwise(B2(i)) * x[i], i = 1:n) >= 1) %>%
    add_constraint(sum_expr(colwise(B2(i)) * x[i], i = 1:n) <= 2) %>%

    # 3B
    add_constraint(sum_expr(colwise(B3(i)) * x[i], i = 1:n) >= 1) %>%
    add_constraint(sum_expr(colwise(B3(i)) * x[i], i = 1:n) <= 2) %>%

    # SS
    add_constraint(sum_expr(colwise(SS(i)) * x[i], i = 1:n) >= 1) %>%
    add_constraint(sum_expr(colwise(SS(i)) * x[i], i = 1:n) <= 2) %>%

    # OF
    add_constraint(sum_expr(colwise(OF(i)) * x[i], i = 1:n) >= 3) %>%
    add_constraint(sum_expr(colwise(OF(i)) * x[i], i = 1:n) <= 4)
}

add_min_salary_constraint <- function(model, data, min_salary) {
  n <- nrow(data)
  salary <- function(i) data[["salary"]][i]

  add_constraint(model, sum_expr(colwise(salary(i)) * x[i], i = 1:n) >= min_salary)
}
