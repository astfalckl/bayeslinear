
#' Calculates the Moore-Penrose generalized inverse of a matrix X.
#'
#' @param ... Passes on arguments to MASS::ginv
#'
#' @return A MP generalized inverse matrix for X.
#' @export
mp_inv <- function(...) MASS::ginv(...)

#' Calculates uncertainty ellipse of a bivariate random variable
#'
#' @param prob Sets ellipse width proportional to Normal
#' @param mu  Ellipse centre
#' @param sigma Ellipse SD
#'
#' @return A tibble with x and y ellipse coordinates
#' @export
calc_ellipse <- function(sd, mu, sigma) {

  theta <- seq(0, 2 * pi, length = 360)
  r1 <- sd
  pts <- data.frame(x = r1 * cos(theta), y = r1 * sin(theta)) %>% as.matrix()
  ellipse <- pts %*% chol(sigma) + t(matrix(rep(mu, 360), nrow = 2))
  colnames(ellipse) <- c("x", "y")

  dplyr::as_tibble(ellipse)

}

#' Cantelli's inequality
#'
#' @param s constraint discrepancy vector. Expects a numeric vector.
#'
#' @return Returns a diagonal matrix with the inequality calculations on the
#' diagonals
#' @export
cantelli <- function(s) {
  diag(1 / (1 + as.numeric(s^2))^2)
}
