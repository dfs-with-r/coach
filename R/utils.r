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
    colnames(d) <- c(".i", colname)
    d
  })

  df_unnest <- do.call(rbind, df_unnest)

  # remove col from orig data frame
  df <- df[setdiff(colnames(df), colname)]

  # join back to data
  df_merge <- merge(df, df_unnest, by = c(".i"))

  df_merge[setdiff(colnames(df_merge), ".i")]
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
