
################################################################################
##################################    TODO    ##################################
################################################################################

# Have a think about what information we want to include in adj_bs. If we want
# to able to roll through with sequential adjustments we probably want to
# default assume exchangeability and go from there.

################################################################################

#' Create a belief structure
#'
#' @param E_X Prior expectation of X
#' @param E_D Prior expectation of D
#' @param cov_XD Prior covariance of X and D
#' @param var_X Prior variance of X
#' @param var_D Prior variance of D
#'
#' @return Returns a belief structure (\code{bs}) object
#' @export
bs <- function(E_X, E_D, cov_XD, var_X, var_D){

  structure(
    list(
			E_X = as.matrix(E_X),
			E_D = as.matrix(E_D),
			cov_XD = as.matrix(cov_XD),
			var_X = as.matrix(var_X),
			var_D = as.matrix(var_D)
		),
		class = "bs",
		nx = nrow(as.matrix(E_X)),
		nd = nrow(as.matrix(E_D))
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
#' @param obj A belief structure
#' @param D A matrix of observed data
#' @param ... further arguments passed to or from other methods.
#'
#' @return Returns a adjusted belief structure (\code{adj_bs}) object
#' @export
adjust <- function(obj, D, ...) {
  UseMethod("adjust")
}

adjust.bs <- function(obj, D, ...){

	D <- as.matrix(D)

	E_adj <- obj$E_X + obj$cov_XD %*% inv(obj$var_D) %*% 
		(D - obj$E_D)
	var_adj <- obj$var_X - obj$cov_XD %*% inv(obj$var_D) %*% 
		t(obj$cov_XD)

# Need to have a think about what we want to include in here
	adj_obj <- structure(
    list(
			E_adj = as.matrix(E_adj),
			var_adj = as.matrix(var_adj),
			# prior = obj,
			D = as.matrix(D)
			# E_D = as.matrix(obj$E_D),
			# var_D = as.matrix(obj$var_D),
		),
		class = "adj_bs",
		nx = base::attributes(obj)$nx,
		nd = base::attributes(obj)$nd
  )

	return(adj_obj)

}



















