
#' Bayes linear update function
#'
#' @param exp_X matrix
#' @param exp_D matrix
#' @param cov_XD matrix
#' @param var_X matrix
#' @param var_D matrix
#' @param D matrix
#'
#' @return list
#' @export
#'
#' @examples
update <- function(exp_X, exp_D, cov_XD, var_X, var_D, D){
	adj_exp <- exp_X + cov_XD %*% solve(var_D) %*% (D - exp_D)
	adj_var <- var_X - cov_XD %*% solve(var_D) %*% t(cov_XD)

	list(
		adj_exp = adj_exp,
		adj_var = adj_var
	)
}
