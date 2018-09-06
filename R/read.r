#' Read Draftkings Draftable Players
#'
#' Expects a draftable csv type from \url{https://www.draftkings.com/lineup/upload}
#'
#' @param path path to csv file
#' @param colnums columns that contain the roster data
#' @keywords internal
read_dk_raw <- function(path, colnums) {
  # read lines
  lines <- readLines(path)

  # keep only relevant rows
  lines <- lines[8:length(lines)]

  # split lines by comma
  split_lines <- strsplit(lines, ",")

  # keep only relevant columns
  players <- lapply(split_lines, function(x) x[colnums])

  # the first row is the header
  header <- trimws(tolower(players[[1]]))
  header <- gsub(" \\+ | ", "_", header)

  # the rest of the rows are the data
  players <- players[-1]

  # transpose and flatten the list
  m <- length(header)
  x <- vector("list", m)
  names(x) <- header
  x[] <- lapply(seq_len(m), function(j) vapply(players, function(p) p[j], character(1L)))

  # build data frame
  df <- as.data.frame(x, stringsAsFactors = FALSE)

  # add opp team
  add_dk_opp_team(df)
}

read_dk <- function(path, colnums) {
  df <- read_dk_raw(path, colnums)

  # fix column types
  df[["salary"]] <- as.integer(df[["salary"]])
  df[["avgpointspergame"]] <- as.double(df[["avgpointspergame"]])

  # split positions for players that can play multiple, ex. 1B/3B -> c("1B", "3B")
  df[["position"]] <- strsplit(df[["roster_position"]], "/")

  # prepare for model
  df_model <- df[c("id", "name", "teamabbrev", "opp_team", "location",
                   "position", "salary", "avgpointspergame")]
  colnames(df_model) <- c("player_id", "player", "team", "opp_team", "location",
                          "position", "salary", "fpts_proj")

  # expand multiple position players
  # equivalent of tidyr::unnest(df_model, "position")
  df_tidy <- unnest_col(df_model, "position")

  # select cols
  df_tidy[c("player_id", "player", "team", "opp_team", "location",
            "position", "salary", "fpts_proj")]
}

#' Add a row id column to the data frame
#'
#' @param df data frame
#' @keywords internal
add_row_id <- function(df) {
  row.names(df) <- NULL
  orig_colnames <- colnames(df)
  df[["row_id"]] <- seq_len(nrow(df))
  df[c("row_id", orig_colnames)]
}

#' Add opposing team
#' @keywords internal
add_dk_opp_team <- function(df) {
  game_info <- unique(df[["game_info"]])

  m <- regexec("([A-Z]{3})@([A-Z]{3})", game_info)
  regs <- regmatches(game_info, m)
  regs <- matrix(unlist(regs), ncol = 3, byrow = TRUE)

  away_team <- regs[,2]
  home_team <- regs[,3]
  teams <- data.frame(
    team = c(away_team, home_team),
    opp_team = c(home_team, away_team),
    location = rep(home_team, 2),
    stringsAsFactors = FALSE)

  merge(df, teams, by.x = "teamabbrev", by.y = "team")
}

#' Read Draftkings Player Pool
#'
#' Expects a draftable csv type from \url{https://www.draftkings.com/lineup/upload}
#' @param path path to csv file
#' @export
read_dk_nfl <- function(path) {
  df <- read_dk(path, 11:19)
  # filter out FLEX position
  df <- df[df[["position"]] != "FLEX", ]
  add_row_id(df)
}

#' @export
#' @rdname read_dk_nfl
read_dk_mlb <- function(path) {
  df <- read_dk(path, 12:20)
  add_row_id(df)
}


