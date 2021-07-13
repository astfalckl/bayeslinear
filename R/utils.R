
#' Calculates the Moore-Penrose generalized inverse of a matrix X.
#'
#' @param ... Passes on arguments to MASS::ginv
#'
#' @return A MP generalized inverse matrix for X.
#' @export
#'
#' @examples
inv <- function(...) MASS::ginv(...)
