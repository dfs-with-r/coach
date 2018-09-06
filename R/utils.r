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
  n <- nrow(df)
  df[[".i"]] <- seq_len(n)

  # unnest column
  df_unnest <- lapply(seq_len(n), function(i) {
    pos <- df[[colname]][[i]]
    d <- data.frame(i, pos, stringsAsFactors = FALSE)
    setNames(d, c(".i", colname))
  })

  df_unnest <- do.call(rbind, df_unnest)

  # remove col from orig data frame
  df <- df[setdiff(colnames(df), colname)]

  # join back to data
  df_merge <- merge(df, df_unnest, by = c(".i"))

  df_merge[setdiff(colnames(df_merge), ".i")]
}
