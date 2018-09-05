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
