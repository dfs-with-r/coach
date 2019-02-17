#' @rdname model_generic
#' @export
model_fd_nascar <- function(data, ...) {

  # params
  total_salary <- 50E3
  roster_size <- 5
  max_from_team <- 5

  # build model
  model <- model_generic(data, total_salary, roster_size, max_from_team, ...)
  model
}


