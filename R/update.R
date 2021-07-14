
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

# Add in a variable naming option
# Need to check dimensions
# Check dimensions in adjustments as well

new_bl_output <- function(exp_X, exp_D, cov_XD, var_X, var_D){
  structure(
    list(
			exp_X = exp_X,
			exp_D = exp_D,
			cov_XD = cov_XD,
			var_X = var_X,
			var_D = var_D
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
#' @return Returns a 
#' @export
#'
#' @examples
adjust.bl <- function(bl_obj, D){

	adj_exp <- bl_obj$exp_X + bl_obj$cov_XD %*% solve(bl_obj$var_D) %*% 
		(D - bl_obj$exp_D)
	adj_var <- bl_obj$var_X - bl_obj$cov_XD %*% solve(bl_obj$var_D) %*% 
		t(bl_obj$cov_XD)

	bl_obj$adj_exp <- adj_exp
	bl_obj$adj_var <- adj_var
		
	return(bl_obj)
}



















