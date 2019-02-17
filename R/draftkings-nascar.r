#' @rdname model_generic
#' @export
model_dk_nascar <- function(data, ...) {

  # params
  total_salary <- 50E3
  roster_size <- 6
  max_from_team <- 6

  # build model
  model <- model_generic(data, total_salary, roster_size, max_from_team, ...)

  model
}
