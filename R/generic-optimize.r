#' Optimize a fantasy Model
#' @param data projected fantasy points
#' @param model optimization model
#' @param L total number of lineups
#' @param solver ROI solver to use
#' @param bans row_ids of players to exclude from all lineups
#' @param locks row_ids or players to include in all lineups
#' @param stack_sizes size of each stack
#' @param stack_teams subset of teams to use to generate stacks. NULL will use all teams.
#' @param min_salary minimum salary to use
#' @export
optimize_generic <- function(data, model, L = 3L,
                             solver = c("glpk", "symphony", "cbc"),
                             bans = NULL,
                             locks = NULL,
                             stack_sizes = NULL,
                             stack_teams = NULL,
                             min_salary = NULL) {
  # check inputs
  results <- vector("list", L)
  solver <- match.arg(solver)

  # add bans/locks
  model <- add_player_lock_constraint(model, locks)
  model <- add_player_ban_constraint(model, bans)

  # add stacking
  if (length(stack_sizes) > 0) {
    model <- add_stack_size_constraint(model, data, stack_sizes, stack_teams)
  }

  # add min salary
  if (!is.null(min_salary)) {
    model <- add_min_salary_constraint(model, data, min_salary)
  }

  # optimize
  for (i in 1:L) {
    # solve
    result <- optimize_generic_one(data, model, solver)

    # get results
    results[[i]] <- result$roster
    roster_rowids <- result[["roster"]][["row_id"]]

    # add constraint to not generate same lineup again
    model <- add_existing_roster_constraint(model, roster_rowids)
  }

  results
}

#' Optimize fantasy lineups
#' @importFrom ompr solve_model get_solution
#' @importFrom ompr.roi with_ROI
#' @keywords internal
optimize_generic_one <- function(data, model, solver = c("glpk", "symphony", "cbc")) {
  # set objective
  n <- nrow(data)
  fpts <- function(i) data[["fpts_proj"]][i]
  model <- set_generic_objective(model, n, fpts)

  # solve model
  solver <- match.arg(solver)
  result <- solve_model(model, with_ROI(solver = solver))

  # extract selected
  solution <- get_solution(result, x[i])
  matches <- solution[solution[["value"]] == 1,]
  matches <- matches$i

  # optimal lineup
  lineup <- data[matches, ]

  structure(
    list(
      result = result,
      roster = lineup
    ),
    class = "lineup"
  )
}



