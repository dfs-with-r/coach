#' @rdname model_generic
#' @export
model_dk_mlb <- function(data, existing_rosters = list()) {

  # params
  total_salary <- 50E3
  roster_size <- 10L
  max_from_team <- 5L

  # build model
  model_generic(data, total_salary, roster_size, max_from_team, existing_rosters) %>%
    add_dk_mlb_roster_positions_constraint(data) %>%
    add_pitcher_hitter_constraint(data)
}

#' @importFrom ompr add_constraint sum_expr
#' @keywords internal
add_dk_mlb_roster_positions_constraint <- function(model, mlb) {
  # check position names
  assert_has_positions(mlb, c("P", "C", "1B", "2B", "3B", "SS", "OF"))

  # position constraint helpers
  n <- nrow(mlb)
  is_position <- function(pos) {
    function(i) {
      # function needs to be vectorized
      # this is wrong. this will count a multi-position player once for each position he is eligible
      #as.integer(grepl(pos, mlb$position[i]))

      # this assumes each player only has one position
      as.integer(pos == mlb$position[i])
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
    # pitcher
    add_constraint(sum_expr(colwise(P(i)) * x[i], i = 1:n) == 2) %>%

    # catcher
    add_constraint(sum_expr(colwise(CR(i)) * x[i], i = 1:n) == 1) %>%

    # First Baseman
    add_constraint(sum_expr(colwise(B1(i)) * x[i], i = 1:n) == 1) %>%

    # Second Baseman
    add_constraint(sum_expr(colwise(B2(i)) * x[i], i = 1:n) == 1) %>%

    # Third Baseman
    add_constraint(sum_expr(colwise(B3(i)) * x[i], i = 1:n) == 1) %>%

    # Shortstop
    add_constraint(sum_expr(colwise(SS(i)) * x[i], i = 1:n) == 1) %>%

    # Outfielder
    add_constraint(sum_expr(colwise(OF(i)) * x[i], i = 1:n) == 3)
}

