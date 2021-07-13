
#' Calculates the Moore-Penrose generalized inverse of a matrix X.
#'
#' @param x Matrix for which the Moore-Penrose inverse is required.
#'
#' @return A MP generalized inverse matrix for X.
#' @export
#'
#' @examples
inv <- function(x){
	MASS::ginv(x)
}
