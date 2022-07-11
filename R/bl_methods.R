
# ------------------------------------------------------------------------------
# ------------------------------------ TODO ------------------------------------
# ------------------------------------------------------------------------------

# Add in a variable naming option
# Need to check dimensions
# Check dimensions in adjustments as well
# Check eigenvalues of the variance matrix
# Check coherence conditions

# ------------------------------------------------------------------------------

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

  new_bs_output(E_X, E_D, cov_XD, var_X, var_D)

}

#' @export
new_bs_output <- function(E_X, E_D, cov_XD, var_X, var_D){
  structure(
    list(
			E_X = as.matrix(E_X),
			E_D = as.matrix(E_D),
			cov_XD = as.matrix(cov_XD),
			var_X = as.matrix(var_X),
			var_D = as.matrix(var_D),
			n_X = nrow(E_X),
			n_D = nrow(E_D)
		),
    class = "bs"
  )
}

#' @export
new_adj_bs_output <- function(E_adj, E_D, cov_adj, var_adj, var_D, D){
  structure(
    list(
			E_adj = as.matrix(E_adj),
			E_D = as.matrix(E_D),
			cov_adj = as.matrix(cov_adj),
			var_adj = as.matrix(var_adj),
			var_D = as.matrix(var_D),
			D = list(D),
			n_X = nrow(E_adj),
			n_D = nrow(E_D)
		),
    class = "adj_bs"
  )
}

#' @export
print.bs <- function(object){
  utils::str(object)
}

#' @export
adjust <- function(obj, ...) {
  UseMethod("adjust")
}

#' Adjust a belief structure with observed data
#'
#' @param bs_obj A belief structure
#' @param D A matrix of observed data
#'
#' @return Returns a adjusted belief structure (adj_bs) object
#' @export
adjust.bs <- function(bs_obj, D){

	D <- as.matrix(D)

	E_adj <- bs_obj$E_X + bs_obj$cov_XD %*% inv(bs_obj$var_D) %*% 
		(D - bs_obj$E_D)
	var_adj <- bs_obj$var_X - bs_obj$cov_XD %*% inv(bs_obj$var_D) %*% 
		t(bs_obj$cov_XD)

	bs_obj$D <- D
	bs_obj$adj_exp <- E_adj
	bs_obj$adj_var <- var_adj
	# ADJUSTED COVARIANCE
	bs_obj$res_var <- bs_obj$var_X - var_adj

	# if (bs_obj$n_X == 1) {
	# 	bs_obj$resolution <- 1 - diag(adj_var)/diag(bs_obj$var_X)
	# } else {
	# 	bs_obj$resolution <- diag(1 - diag(diag(adj_var))/diag(diag(bs_obj$var_X)))	
	# }
	
	class(bs_obj) <- "adj_bs"

	return(bs_obj)
}



















