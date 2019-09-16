#' Generic fantasy model
#' @param data data frame
#' @param total_salary maximum salary available for each lineup
#' @param roster_size number of players on each lineup
#' @param max_from_team maximum number of players allowed from each team
#' @param existing_rosters list of integer vectors specifying rosters to exclude
#' @param type binary or continuous optimization
#' @param ... extra arguments passed to \code{\link{model_generic}}
#' @importFrom ompr MIPModel MILPModel add_variable
#'
#' @export
model_generic <- function(data, total_salary, roster_size,
                          max_from_team = 4,
                          existing_rosters = list(),
                          type = c("binary", "continuous")) {
  # check cols
  needed_cols <- c("row_id", "player_id", "player", "team", "position",
                   "salary", "fpts_proj")
  needed_types <- c("integer", "character", "character", "character",
                    "character", "integer", "double")

  assert_has_cols(data, needed_cols)
  assert_coltypes(data, needed_cols, needed_types)

  # arrange data
  data <- data[order(data[["row_id"]]),]
  n <- nrow(data)

  # helper functions
  salary <- function(i) data[["salary"]][i]

  team_int <- as.integer(as.factor(data[["team"]]))
  total_teams <- length(unique(team_int))
  is_team <- function(j, i) as.integer(team_int[i] == j)

  # base model. continuous vs binary
  type <- match.arg(type)
  if (type == "binary") {
    base_model <- MILPModel() %>%
      add_variable(x[i], i = 1:n, type = "binary")
  } else {
    base_model <- MILPModel() %>%
      add_variable(x[i], i = 1:n, type = "continuous", lb = 0, ub = 1)
  }

  # base model
  base_model %>%
    add_salary_contraint(n, salary, total_salary) %>%
    add_existing_rosters_constraint(existing_rosters) %>%
    add_roster_size_constraint(n, roster_size) %>%
    add_max_from_team_constraint(n, max_from_team, total_teams, is_team) %>%
    add_unique_id_constraint(data)
}

#' @importFrom ompr set_objective sum_expr colwise
#' @keywords internal
set_generic_objective <- function(model, n, fpts) {
  set_objective(model, sum_expr(colwise(fpts(i)) * x[i], i = 1:n))
}

#' @importFrom ompr add_constraint sum_expr colwise
#' @keywords internal
add_salary_contraint <- function(model, n, salary, total_salary) {
  add_constraint(model, sum_expr(colwise(salary(i)) * x[i], i = 1:n) <= total_salary)
}

#' @importFrom ompr add_constraint sum_expr colwise
#' @keywords internal
add_roster_size_constraint <- function(model, n, roster_size) {
  add_constraint(model, sum_expr(x[i], i = 1:n) == roster_size)
}

#' @importFrom ompr add_constraint sum_expr colwise
#' @keywords internal
add_max_from_team_constraint <- function(model, n, max_from_team, total_teams, is_team) {
  # only allow max_from_team players from each team
  for (j in 1:total_teams) {
    model <- add_constraint(model, sum_expr(colwise(is_team(j, i))*x[i], i = 1:n) <= max_from_team)
  }
  model
}

#' @importFrom ompr add_constraint sum_expr
#' @keywords internal
add_existing_rosters_constraint <- function(model, rosters) {
  for (roster in rosters) {
    model <- add_existing_roster_constraint(model, roster)
  }

  model
}

#' @importFrom ompr add_constraint sum_expr
#' @keywords internal
add_existing_roster_constraint <- function(model, roster) {
  m <- length(roster) - 1L
  add_constraint(model, sum_expr(x[i], i = roster) <= m)
}

#' @importFrom ompr add_constraint sum_expr
#' @keywords internal
add_player_lock_constraint <- function(model, locks) {
  if (!is.null(locks)) {
    add_constraint(model, x[i] == 1, i = locks)
  } else {
    model
  }
}

#' @importFrom ompr add_constraint sum_expr
#' @keywords internal
add_player_ban_constraint <- function(model, bans) {
  if (!is.null(bans)) {
    add_constraint(model, x[i] == 0, i = bans)
  } else {
    model
  }
}

#' Stack best available teams with variable sizes
#' @param model model
#' @param mlb data
#' @param stack_sizes size of each stack
#' @param stack_teams subset of teams to select for stacking. leave NULL to allow any team
#' @keywords internal
add_stack_size_constraint <- function(model, mlb, stack_sizes, stack_teams = NULL) {
  n <- nrow(mlb)
  notP <- function(i) as.integer("P" != mlb$position[i])

  # all team names to int
  teams <- unique(c(mlb[["team"]], mlb[["opp_team"]]))
  m <- length(teams)
  team_int <- as.integer(factor(mlb[["team"]], levels = teams))
  is_team <- function(j, i) as.integer(team_int[i] == j)

  # available teams to stack
  if (!is.null(stack_teams)) {
    stack_ids <- as.integer(factor(stack_teams, levels = teams))
  } else {
    stack_ids <- 1:m
  }

  # calculate stack sizes
  sizes <- unique(stack_sizes)
  num_size <- vapply(sizes, function(z) sum(stack_sizes >= z), integer(1L))
  s <- length(sizes)

  # indicator variable
  # u[j] = 1 if num_players[j] - stack_size >= 0
  # u[j] = 0 otherwise
  model <- add_variable(model, u[j,k], j = 1:m, k = 1:s, type = "binary")
  penalty <- 100

  for (k in 1:s) {
    stack_size <- sizes[k]
    for (j in stack_ids) {
      model <- add_constraint(model, u[j,k]*penalty - sum_expr(colwise(is_team(j, i))*notP(i)*x[i], i = 1:n)  + stack_size >= 1)
      model <- add_constraint(model, (1-u[j,k])*penalty + sum_expr(colwise(is_team(j, i))*notP(i)*x[i], i = 1:n) - stack_size >= 0)
    }

    # contraint that we must have at least num_stacks
    model <- add_constraint(model, sum_expr(u[j,k], j = stack_ids) >= num_size[k])
  }

  model
}

#' Unique ID constraint
#'
#' On sites with multi-position eligibility, players will show up once for every
#' position they are eligible. We want to ensure a player is not selected more than
#' once on the same lineup
#' @keywords internal
add_unique_id_constraint <- function(model, data) {
  n <- nrow(data)
  ids <- unique(data[["player_id"]])

  has_id <- function(i, id) as.integer(data[["player_id"]][i] == id)

  # only need to apply this constraint to players that appear more than once
  multi_players <- names(which(table(data[["player_id"]]) > 1))

  for (id in multi_players) {
    model <- add_constraint(model, sum_expr(colwise(has_id(i, id)) * x[i], i = 1:n) <= 1)
  }

  model
}

add_min_salary_constraint <- function(model, data, min_salary) {
  n <- nrow(data)
  salary <- function(i) data[["salary"]][i]

  add_constraint(model, sum_expr(colwise(salary(i)) * x[i], i = 1:n) >= min_salary)
}

#' Add custom position constraints
#'
#' @param model a coach model
#' @param data data frame with fpts projections
#' @param constraints a named list with constraints. Flex or Wildcard positions should be named with a / between positions. See examples.
#' @importFrom ompr add_constraint sum_expr
#' @export
#'
#' @examples
#' \dontrun{
#' data <- read_dk("yourfilenamehere.csv")
#' constraints <- list("QB" = 1, "RB" = 2, "WR" = 3, "TE" = 1, "RB/WR/TE" = 1, "DST" = 1)
#' model <- model_generic(data, total_salary = 50E3, roster_size = 9, max_from_team = 4)
#' model <- add_generic_positions_constraint(model, data, constraints)
#' }
add_generic_positions_constraint <- function(model, data, constraints) {
  # check position names
  constraints <- parse_constraints(constraints)
  unique_pos <- constraints$pos
  assert_has_positions(data, constraints$pos)

  # position constraint helpers
  n <- nrow(data)
  is_position <- function(pos) {
    function(i) {
      as.integer(pos == data$position[i])
    }
  }

  # loop over every position constraint
  k <- nrow(constraints)
  for(ki in seq_len(k)) {
    # params
    pos <- constraints$pos[ki]
    min_count <- constraints$min[ki]
    max_count <- constraints$max[ki]
    f <- is_position(pos)

    # minimum constraint
    model <- add_constraint(model, sum_expr(colwise(f(i)) * x[i], i = 1:n) >= min_count)

    # maximum constraint
    model <- add_constraint(model, sum_expr(colwise(f(i)) * x[i], i = 1:n) <= max_count)
  }

  # return model
  model
}
