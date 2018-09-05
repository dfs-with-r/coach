assert_is_length_one_or_n <- function(x, n) {
  stopifnot(length(x) == 1L | length(x) == n)
}

#' Assert that the dataframe has certain columns
#'
#' @param df a data frame
#' @param cols column names
assert_has_cols <- function(df, cols) {
  is_in_df <- cols %in% colnames(df)
  has_all_cols <- all(is_in_df)
  if (!has_all_cols) {
    missing <- paste0(cols[!is_in_df], collapse = ", ")
    stop(paste("missing columns", missing), call. = FALSE)
  }
}

assert_has_positions <- function(df, allowed_positions) {
  # split multi-positions
  positions <- unlist(strsplit(df[["position"]], "/"))

  # distinct positions
  positions <- sort(unique(positions))

  extra_positions <- setdiff(positions, allowed_positions)
  missing_positions <- setdiff(allowed_positions, positions)

  if (length(extra_positions) > 0) {
    extra <- paste(extra_positions, collapse = ",")
    stop(paste("invalid positions:", extra), call. = FALSE)
  }

  if (length(missing_positions) > 0) {
    missing <- paste(missing_positions, collapse = ",")
    stop(paste("missing positions:", missing), call. = FALSE)
  }
}
