
#' Calculates the Moore-Penrose generalized inverse of a matrix X.
#'
#' @param ... Passes on arguments to MASS::ginv
#'
#' @return A MP generalized inverse matrix for X.
#' @export
inv <- function(...) MASS::ginv(...)
