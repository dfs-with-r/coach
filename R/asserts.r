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

#' Make sure columns in data frame are the right type
#'
#' @param df data frame
#' @param cols column names
#' @param coltypes column types (ex. "integer", "double", "character")
assert_coltypes <- function(df, cols, coltypes) {
  # should I just use an S4 class instead?
  are_correct <- mapply(function(d, dtype) identical(typeof(d), dtype),
                        df[cols], coltypes, SIMPLIFY = FALSE)
  are_correct <- unlist(are_correct)

  if (!all(are_correct)) {
    incorrect_cols <- cols[!are_correct]
    incorrect_types <- vapply(incorrect_cols, function(col) typeof(df[[col]]), character(1L))
    correct_types <- coltypes[!are_correct]

    incorrect_msg <- paste("\t-", incorrect_cols, "is",  incorrect_types, "but should be", correct_types, "\n")
    base_msg <- "The following columns are the wrong type\n"

    stop(paste(base_msg, incorrect_msg, collapse = ""), call. = FALSE)
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
