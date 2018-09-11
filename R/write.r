#' Normalize positions by allowed counts
#'
#' Will replace positions with wildcard if their count exceeds the number
#' defined by pos_max. This is commonly used to set a player to a UTIL or FLEX
#' position.
#'
#' @param pos a character vector of existing positions
#' @param pos_max a named numeric vector giving the max allowed players at that position
#' @param wildcard a string specifying what to replace postions with
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
