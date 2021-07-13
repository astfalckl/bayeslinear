
#' Crate a Bayes linear object
#'
#' @param exp_X matrix
#' @param exp_D matrix
#' @param cov_XD matrix
#' @param var_X matrix
#' @param var_D matrix
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
adjust.bl <- function(exp_X, exp_D, cov_XD, var_X, var_D, D){
	adj_exp <- exp_X + cov_XD %*% solve(var_D) %*% (D - exp_D)
	adj_var <- var_X - cov_XD %*% solve(var_D) %*% t(cov_XD)

	list(
		adj_exp = adj_exp,
		adj_var = adj_var
	)
}
