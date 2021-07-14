
# ------------------------------------------------------------------------------
# ------------------------------------ TODO ------------------------------------
# ------------------------------------------------------------------------------

# Add in a variable naming option
# Need to check dimensions
# Check dimensions in adjustments as well
# Check eigenvalues of the variance matrix
# Check coherence conditions

# ------------------------------------------------------------------------------

#' Crate a Bayes linear object
#'
#' @param exp_X Prior expectation of X
#' @param exp_D Prior expectation of D
#' @param cov_XD Prior covariance of X and D
#' @param var_X Prior variance of X
#' @param var_D Prior variance of D
#'
#' @return Returns a bl object
#' @export
#'
#' @examples
bl <- function(exp_X, exp_D, cov_XD, var_X, var_D){

  new_bl_output(exp_X, exp_D, cov_XD, var_X, var_D)

}

new_bl_output <- function(exp_X, exp_D, cov_XD, var_X, var_D){
  structure(
    list(
			exp_X = as.matrix(exp_X),
			exp_D = as.matrix(exp_D),
			cov_XD = as.matrix(cov_XD),
			var_X = as.matrix(var_X),
			var_D = as.matrix(var_D),
			n_X = nrow(exp_X),
			n_D = nrow(exp_D)
		),
    class = "bl"
  )
}

print.bl <- function(object){
  utils::str(object)
}

adjust <- function(obj, ...) {
  UseMethod("adjust")
}

#' Adjust a bl object with observed data
#'
#' @param bl_obj A bl object
#' @param D A matrix of observed data
#'
#' @return Returns a bl_adjust object
#' @export
#'
#' @examples
adjust.bl <- function(bl_obj, D){

	D <- as.matrix(D)

	adj_exp <- bl_obj$exp_X + bl_obj$cov_XD %*% inv(bl_obj$var_D) %*% 
		(D - bl_obj$exp_D)
	adj_var <- bl_obj$var_X - bl_obj$cov_XD %*% inv(bl_obj$var_D) %*% 
		t(bl_obj$cov_XD)

	bl_obj$D <- D
	bl_obj$adjusted_exp <- adj_exp
	bl_obj$adjusted_var <- adj_var
	bl_obj$resolved_var <- bl_obj$var_X - adj_var

	if (bl_obj$n_X == 1) {
		bl_obj$resolution <- 1 - diag(adj_var)/diag(bl_obj$var_X)
	} else {
		bl_obj$resolution <- diag(1 - diag(diag(adj_var))/diag(diag(bl_obj$var_X)))	
	}
	
	class(bl_obj) <- "bl_adjust"

	return(bl_obj)
}



















