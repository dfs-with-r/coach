#' Read Fanduel Players
#'
#' Expects a csv from \url{https://www.fanduel.com/} obtained by clicking
#' "Download Players List" for your contest page.
#'
#' @param path path to csv file
#' @export
read_fd <- function(path) {
  df <- utils::read.csv(path, stringsAsFactors = FALSE)

  # keep only first columns
  df <- df[1:12]

  # extract location
  locations <- parse_locations(df[["Game"]])
  df[["location"]] <- locations[,3]

  # select columns
  df_tidy <- df[c("Id", "Nickname", "Team", "Opponent", "location", "Position",
                  "Salary", "FPPG", "Injury.Indicator")]
  colnames(df_tidy) <- c("player_id", "player", "team", "opp_team", "location",
                         "position", "salary", "fpts_avg", "injury")

  # fix injury NAs
  df_tidy[["injury"]] <- with(df_tidy, ifelse(nchar(injury) == 0, NA_character_, injury))

  # add row ids
  df_tidy <- add_row_id(df_tidy)

  # tibble
  tibble::as_tibble(df_tidy)
}
