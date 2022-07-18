
#' Crate a belief structure
#'
#' @param E_X Prior expectation of X
#' @param E_D Prior expectation of D
#' @param cov_XD Prior covariance of X and D
#' @param var_X Prior variance of X
#' @param var_D Prior variance of D
#'
#' @return Returns a belief structure (bs) object
#' @export
bs <- function(E_X, E_D, cov_XD, var_X, var_D){

  structure(
    list(
			E_X = as.matrix(E_X),
			E_D = as.matrix(E_D),
			cov_XD = as.matrix(cov_XD),
			var_X = as.matrix(var_X),
			var_D = as.matrix(var_D),
			n_X = nrow(as.matrix(E_X)),
			n_D = nrow(as.matrix(E_D))
		),
    class = "bs"
  )

}

print.bs <- function(x, ...){
  utils::str(x)
}

print.adj_bs <- function(x, ...){
  utils::str(x)
}

#' Adjust either a belief structure or adjusted belief structure with observed data
#'
#' @param bs_obj A belief structure
#' @param D A matrix of observed data
#' @param ... further arguments passed to or from other methods.
#'
#' @return Returns a adjusted belief structure (adj_bs) object
#' @export
adjust <- function(bs_obj, D, ...) {
  UseMethod("adjust")
}

adjust.bs <- function(bs_obj, D, ...){

	D <- as.matrix(D)

	E_adj <- bs_obj$E_X + bs_obj$cov_XD %*% inv(bs_obj$var_D) %*% 
		(D - bs_obj$E_D)
	var_adj <- bs_obj$var_X - bs_obj$cov_XD %*% inv(bs_obj$var_D) %*% 
		t(bs_obj$cov_XD)

	adj_bs_obj <- structure(
    list(
			E_adj = as.matrix(E_adj),
			E_D = as.matrix(bs_obj$E_D),
			var_adj = as.matrix(var_adj),
			var_D = as.matrix(bs_obj$var_D),
			D = as.matrix(D),
			n_X = nrow(E_adj),
			n_D = nrow(bs_obj$E_D)
		),
    class = "adj_bs"
  )

	return(adj_bs_obj)

}



















