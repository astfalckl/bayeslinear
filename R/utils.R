
#' Calculates the Moore-Penrose generalized inverse of a matrix X.
#'
#' @param ... Passes on arguments to MASS::ginv
#'
#' @return A MP generalized inverse matrix for X.
#' @export
inv <- function(...) MASS::ginv(...)

#' Calculates uncertainty ellipse of a bivariate random variable
#'
#' @param prob Sets ellipse width proportional to Normal
#' @param mu  Ellipse centre
#' @param sigma Ellipse SD
#'
#' @return A tibble with x and y ellipse coordinates
#' @export
calc_ellipse <- function(prob, mu, sigma) {
  
  theta <- seq(0, 2*pi, length = 360)
  r1 <- sqrt(stats::qchisq(prob, 2))
  pts <- data.frame(x = r1 * cos(theta), y = r1 * sin(theta)) %>% as.matrix()
  ellipse <- pts %*% chol(sigma) + t(matrix(rep(mu, 360), nrow = 2))
  colnames(ellipse) <- c("x", "y")  

  dplyr::as_tibble(ellipse)

}
