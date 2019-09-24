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
#' @param max_exposure max exposure for all players or a vector of exposures for each player
#' @export
optimize_generic <- function(data, model, L = 3L,
                             solver = c("glpk", "symphony", "cbc"),
                             bans = NULL,
                             locks = NULL,
                             stack_sizes = NULL,
                             stack_teams = NULL,
                             min_salary = NULL,
                             max_exposure = 1) {
  # check inputs
  if (any(is.na(data[["fpts_proj"]]))) {
    stop("fpts_proj can't have NAs", call. = FALSE)
  }

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

  # add exposure
  n <- nrow(data)
  nx <- length(max_exposure)
  if (!(identical(nx, 1L) || identical(nx, n))) {
    stop("exposure must be a single number or a vector with a number for each player", call. = FALSE)
  }

  if (any(max_exposure < 0) || any(max_exposure > 1)) {
    stop("all exposure values must be between 0 and 1", call. = FALSE)
  }

  # if there are locked players, they need to have a max_exposure of 100%
  if (identical(nx, 1L)) max_exposure <- rep(max_exposure, n)
  if (!is.null(locks)) {
    max_exposure[locks] <- 1
  }

  current_exposure <- vector("integer", n)
  exposure_bans <- NULL

  # optimize
  results <- vector("list", L)
  solver <- match.arg(solver)
  for (i in 1:L) {
    # create a temporary model to hold current exposure bans
    model_tmp <- add_player_ban_constraint(model, bans = exposure_bans)

    # solve
    result <- optimize_generic_one(data, model_tmp, solver)

    # get results
    roster <- result$roster
    results[[i]] <- roster
    roster_rowids <- roster$row_id
    roster_ids <- roster$player_id

    # add constraint to not generate same lineup again
    model <- add_existing_roster_constraint(model, roster_rowids)

    # add constraint to ban players from too much exposure
    selected_players <- data$row_id[data$player_id %in% roster_ids]
    current_exposure[selected_players] <- current_exposure[selected_players] + 1L
    exposure_bans <- where(current_exposure/i > max_exposure)
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

  # determine if continuous or binary optimization
  type <- model$variables$x$type

  # extract selected
  solution <- get_solution(result, x[i])

  if (type == "binary") {
    matches <- solution[solution[["value"]] == 1,]
    matches <- matches$i
    lineup <- tibble::as_tibble(data[matches, ])
  } else {
    lineup <- data
    lineup[["x"]] <- solution[["value"]]
  }

  structure(
    list(
      result = result,
      roster = lineup
    ),
    class = "lineup"
  )
}



