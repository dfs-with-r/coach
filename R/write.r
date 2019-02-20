#' Normalize positions by allowed counts
#'
#' Will replace positions with wildcard if their count exceeds the max allowed.
#' This is commonly used to set a player to a utility or flex position.
#'
#' @param pos a character vector of existing positions
#' @param pos_max a named numeric vector giving the max allowed players at that position
#' @param wildcard a string specifying what to replace positions with
#'
#' @keywords internal
#' @examples
#' \dontrun{
#'  pos <- c("P", "1B", "1B", "2B", "3B", "SS", "OF", "OF", "OF")
#'  pos_max <- c("P" = 1, "1B" = 1, "2B" = 1, "3B" = 1, "SS" = 1, "OF" = 3)
#'  wildcard <- "UTIL"
#'
#'  normalize_positions(pos, pos_max, wildcard)
#' }
normalize_positions <- function(pos, pos_max, wildcard) {
  # group by position and rank
  pos_rank <- as.data.frame(pos, stringsAsFactors = FALSE)
  pos_rank[["rank"]] <- stats::ave(pos, pos, FUN = function(x) rank(x, ties.method = "first"))
  pos_rank[["rank"]] <- as.integer(pos_rank[["rank"]])
  pos_rank[["order"]] <- seq_len(nrow(pos_rank))

  # determine max rank available for each position
  pos_max <- data.frame(pos = names(pos_max), max_rank = as.integer(pos_max),
                        stringsAsFactors = FALSE, row.names = NULL)

  # merge actual rank and max rank data frames
  pos_df <- merge(pos_rank, pos_max, "pos", all.x = TRUE)

  # if a max rank wasn't provided then assume it is Inf
  pos_df[["max_rank"]] <- with(pos_df, ifelse(is.na(max_rank), Inf, max_rank))

  # make sure original order is retained
  pos_df <- pos_df[order(pos_df[["order"]]),]

  # assign wildcard position if actual rank exceed max_rank
  pos_df[["new_pos"]] <- with(pos_df, ifelse(rank > max_rank, wildcard, pos))
  pos_df[["new_pos"]]
}

#' @rdname normalize_positions
#' @keywords internal
normalize_dk_nfl <- function(pos) {
  stopifnot(length(pos) == 9L)

  pos_max <- c("QB" = 1, "RB" = 2, "WR" = 3, "TE" = 1, "DST" = 1)
  wildcard <- "FLEX"
  normalize_positions(pos, pos_max, wildcard)
}

#' @rdname normalize_positions
#' @keywords internal
normalize_dk_nba <- function(pos) {
  stopifnot(length(pos) == 8L)

  # normalize guards
  new_pos <- normalize_positions(pos, c("PG" = 1, "SG" = 1), "G")

  # normalize forwards
  new_pos <- normalize_positions(new_pos, c("SF" = 1, "PF" = 1), "F")

  # normalize util
  pos_max <- c("PG" = 1, "SG" = 1, "SF" = 1, "PF" = 1, "C" = 1, "G" = 1, "F" = 1)
  wildcard <- "UTIL"
  normalize_positions(new_pos, pos_max, wildcard)
}

#' @rdname normalize_positions
#' @keywords internal
normalize_dk_nhl <- function(pos) {
  stopifnot(length(pos) == 9L)

  # normalize wings
  new_pos <- gsub("RW|LW|W", "W", pos)

  # noramlize util
  pos_max <- c("C" = 2, "W" = 3, "D" = 2, "G" = 1)
  wildcard <- "UTIL"
  normalize_positions(new_pos, pos_max, wildcard)
}

#' @rdname normalize_positions
#' @keywords internal
normalize_fd_nfl <- function(pos) {
  stopifnot(length(pos) == 9L)

  pos_max <- c("QB" = 1, "RB" = 2, "WR" = 3, "TE" = 1, "D" = 1)
  wildcard <- "FLEX"
  normalize_positions(pos, pos_max, wildcard)
}

#' @rdname normalize_positions
#' @keywords internal
normalize_fd_mlb <- function(pos) {
  stopifnot(length(pos) == 9L)

  # normalize C/1B
  new_pos <- gsub("C|1B", "C/1B", pos)

  # normalize util
  pos_max <- c("P" = 1, "C/1B" = 1, "2B" = 1, "3B" = 1, "SS" = 1, "OF" = 3)
  wildcard <- "UTIL"
  normalize_positions(new_pos, pos_max, wildcard)
}

#' @rdname normalize_positions
#' @keywords internal
normalize_fd_nascar <- function(pos) {
  stopifnot(length(pos) == 5L)

  # normalize D to driver
  new_pos <- gsub("^D$", "Driver", pos)
  new_pos
}

#' @rdname normalize_positions
#' @keywords internal
normalize_fdr_nba <- function(pos) {
  stopifnot(length(pos) == 8L)

  # normalize guards
  new_pos <- gsub("PG|SG", "G", pos)

  # normalize forwards
  new_pos <- gsub("SF|PF|C", "F/C", new_pos)

  # normalize util
  pos_max <- c("G" = 3, "F/C" = 3)
  wildcard <- "UTIL"
  normalize_positions(new_pos, pos_max, wildcard)

}


#' Normalize a lineup based on position
#'
#' Applies a utility or flex tag to appropriate lineup positions
#'
#' @param lineup a data frame lineup
#' @param site string
#' @param sport string
#' @param colname default column to apply normalization to
#' @export
normalize_lineup <- function(lineup, site = c("draftkings", "fanduel", "fantasydraft"),
                             sport = c("nfl", "mlb", "nba", "nhl", "nascar"),
                             colname = "position") {
  site <- match.arg(site)
  sport <- match.arg(sport)

  # choose normalization function
  if (site == "draftkings") {
    if (sport == "nfl") {
      f <- normalize_dk_nfl
      pos_levels <- c("QB", "RB", "WR", "TE", "FLEX", "DST")
    }
    else if (sport == "mlb") {
      f <- NULL
      pos_levels <- c("P", "C", "1B", "2B", "3B", "SS", "OF")
    }
    else if (sport == "nba") {
      f <- normalize_dk_nba
      pos_levels <- c("PG", "SG", "SF", "PF", "C", "G", "F", "UTIL")
    }
    else if (sport == "nhl") {
      f <- normalize_dk_nhl
      pos_levels <- c("C", "W", "D", "G")
    }
    else if (sport == "nascar") {
      f <- NULL
      pos_levels <- "D"
    }
  } else if (site == "fanduel") {
    if (sport == "nfl") {
      f <- normalize_fd_nfl
      pos_levels <- c("QB", "RB", "WR", "TE", "FLEX", "D")
    }
    else if (sport == "mlb") {
      f <- normalize_fd_mlb
      pos_levels <- c("P", "C/1B", "1B", "2B", "3B", "SS", "OF", "UTIL")
    }
    else if(sport == "nba") {
      f <- NULL
      pos_levels <- c("PG", "SG", "SF", "PF", "C")
    }
    else if (sport == "nhl") {
      f <- NULL
      pos_levels <- c("C", "W", "D", "G")
    }
    else if (sport == "nascar") {
      f <- normalize_fd_nascar
      pos_levels <- "Driver"
    }
  } else if (site == "fantasydraft") {
    if (sport == "nba") {
      f <- normalize_fdr_nba
      pos_levels <- c("G", "F/C", "UTIL")
    } else {
      stop(sprintf("position normalizer for %s/%s not implemented yet!", site, sport),
           call. = FALSE)
    }
  }

  # apply normalization
  if (!is.null(f)) {
    lineup[[colname]] <- f(lineup[[colname]])
  }

  # order by position
  pos2 <- factor(lineup[[colname]], levels = pos_levels)
  lineup[order(pos2),]
}

#' Convert lineup to submission format
#'
#' @param lineup a normalized lineup
#' @param site name of DFS site
#' @param sport name of sport
#' @param ... additional arguments passed to \code{\link{normalize_lineup}}
#' @keywords internal
convert_lineup <- function(lineup,
                           site = c("draftkings", "fanduel", "fantasydraft"),
                           sport = c("nfl", "mlb", "nba", "nhl", "nascar"), ...) {
  new_lineup <- normalize_lineup(lineup, site, sport, ...)
  player_ids <- as.list(new_lineup[["player_id"]])

  x <- as.data.frame(player_ids, stringsAsFactors = FALSE)
  colnames(x) <- new_lineup[["position"]]
  x
}

#' Write lineups for submission
#'
#' @param lineups a normalized lineup
#' @param path local disk path
#' @param site name of DFS site
#' @param sport name of sport
#' @param ... additional arguments passed to \code{\link{normalize_lineup}}
#' @export
#'
#' @examples
#' \dontrun{
#' lineups <- optimize_generic(nhl, model)
#' write_lineups(lineups, "mylineups.csv", site = "fanduel", sport = "nhl")
#' }
write_lineups <- function(lineups, path = NULL,
                          site = c("draftkings", "fanduel", "fantasydraft"),
                          sport = c("nfl", "mlb", "nba", "nhl", "nascar"), ...) {
  converted_lineups <- lapply(lineups, convert_lineup, site, sport, ...)
  df <- do.call(rbind, converted_lineups)

  if (!is.null(path)) {
    utils::write.csv(df, file = path, row.names = FALSE, quote = FALSE)
  }

  df
}
