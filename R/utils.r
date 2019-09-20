#' Same as which, but returns NULL instead of empty vector when no match
#' @keywords internal
where <- function(x) {
  result <- which(x)
  if (length(result) == 0) {
    NULL
  } else {
    result
  }
}

#' @export
print.lineup <- function(x, ...) {
  cat("<Lineup - Value: ", x$result$objective_value, ">\n", sep = "")
  print(x$roster)
  invisible(x)
}

#' @keywords internal
file_type <- function(path) {
  filename <- basename(path)
  split <- strsplit(filename, "\\.")
  vapply(split, function(x) x[2], FUN.VALUE = character(1L))
}

`%||%` <- function(x, y) {
  if(is.null(x) || length(x) == 0) y else x
}


unnest_col <- function(df, colname) {
  # original column order
  cnames <- colnames(df)

  # add dummy id
  n <- nrow(df)
  df[[".i"]] <- seq_len(n)

  # unnest column
  df_unnest <- lapply(seq_len(n), function(i) {
    pos <- df[[colname]][[i]]
    d <- data.frame(i, pos, stringsAsFactors = FALSE)
    colnames(d) <- c(".i", colname)
    d
  })

  df_unnest <- do.call(rbind, df_unnest)

  # remove col from orig data frame
  df <- df[setdiff(colnames(df), colname)]

  # join back to data
  df_merge <- merge(df, df_unnest, by = c(".i"))
  df_merge <- df_merge[setdiff(colnames(df_merge), ".i")]

  # use original column order
  df_merge[cnames]
}

#' Parse locations from a string like SAS@GSW
#' @param x vector of strings
#' @keywords internal
parse_locations <- function(x) {
  m <- regexec("([A-Z]{2,3})@([A-Z]{2,3})", x)
  regs <- regmatches(x, m)

  # replace empty vectors with NAs
  regs[] <- lapply(regs, function(r) {
    if (length(r) == 0) {
      rep(NA_character_, 3)
    } else {
      r
    }
  })

  # convert list to matrix
  regs <- matrix(unlist(regs), ncol = 3, byrow = TRUE)
  regs
}

#' Parse custom constraints
#' @param x a list of constraints. See examples
#' @keywords internal
#' @examples
#' \dontrun{
#' x <- list("QB" = 1, "RB" = 2, "WR" = 3, "TE" = 1, "RB/WR/TE" = 1, "DST" = 1)
#' parse_constraints(x)
#' }
parse_constraints <- function(x) {
  # split flex positions (separated by a "/")
  positions_split <- strsplit(names(x), "/")
  positions_count <- vapply(positions_split, length, FUN.VALUE = integer(1L))

  # unique positions
  positions <- unique(unlist(positions_split))

  # min number required for each position
  min_count <- unlist(x[positions])

  # max number allowed for each position
  max_count <- lapply(seq_along(x), function(i) rep.int(x[[i]], positions_count[i]))
  max_count <- tapply(unlist(max_count), unlist(positions_split), FUN = sum, simplify = FALSE)
  max_count <- unlist(max_count[positions])

  # combine into a data frame
  data.frame(pos = positions, min = min_count, max = max_count,
             stringsAsFactors = FALSE, row.names = NULL)
}
