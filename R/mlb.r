#' Don't let us build lineups with pitchers and hitters facing each other
#'
#' @param model ompr model
#' @param mlb data frame of mlb data
#' @keywords internal
add_pitcher_hitter_constraint <- function(model, mlb) {
  assert_has_cols(mlb, "opp_team_id")

  # helper funcs
  n <- nrow(mlb)
  P <- function(i) as.integer("P" == mlb$position[i])
  notP <- function(i) as.integer("P" != mlb$position[i])

  teams <- unique(c(mlb[["team_id"]], mlb[["opp_team_id"]]))
  team_int <- as.integer(factor(mlb[["team_id"]], levels = teams))
  opp_team_int <- as.integer(factor(mlb[["opp_team_id"]], levels = teams))

  is_team <- function(j, i) as.integer(team_int[i] == j)
  is_opp_team <- function(j, i) as.integer(opp_team_int[i] == j)
  total_teams <- length(teams)

  # create constraint for every team
  # if we have a pitcher opposing that team, we can't have hitters from that team
  penalty <- 1000
  for (j in 1:total_teams) {
    expr <- substitute(colwise(is_opp_team(j, i)*P(i)*penalty +  is_team(j, i)*notP(i)) * x[i])
    model <- add_constraint(
      model,
      # num_pitchers_facing_team*penalty + num_hitters_team <= penalty
      sum_expr(eval(expr), i = 1:n) <= penalty)
  }

  model
}
