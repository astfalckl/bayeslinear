
# ------------------------------------------------------------------------------
# ------------------------------------ TODO ------------------------------------
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------

# print.bl_adjust <- function(object){
#   utils::str(object)
# }

adjust_constrained <- function(obj, ...) {
  UseMethod("adjust_constrained")
}

print.bl_constrained <- function(object){
  utils::str(object)
}

norm_distance <- function(
  X, adj_exp, adj_var
){
  sum((solve(t(chol(adj_var))) %*% (X - adj_exp))^2)
}

#' @title Adjust a bl object with observed data
#' @param bl_obj A bl_adjust object
#' @param D A matrix of observed data
#' @param constraint A list of constraints to be passed to CVXR
#' @return Returns a bl_adjust object
#' @export
#' @examples 
adjust_constrained.bl <- function(
	bl_obj, 
	D, 
	constraint = NULL
){

	D <- as.matrix(D)

	adj_exp <- bl_obj$exp_X + bl_obj$cov_XD %*% inv(bl_obj$var_D) %*% 
		(D - bl_obj$exp_D)
	adj_var <- bl_obj$var_X - bl_obj$cov_XD %*% inv(bl_obj$var_D) %*% 
		t(bl_obj$cov_XD)

	X <- CVXR::Variable(bl_obj$n_X)
	
	objective <- CVXR::Minimize(
	  norm_distance(X, adj_exp, adj_var)
	)

	tmp <- eval(parse(text = constraint))

	problem <- CVXR::Problem(objective)
	CVXR::constraints(problem) <- list(tmp)
	result <- CVXR::solve(problem)

	bl_obj$D <- D
	bl_obj$adjusted_exp <- result[[1]]

	# bl_obj$adjusted_var <- adj_var
	# bl_obj$resolved_var <- bl_obj$var_X - adj_var
	
	class(bl_obj) <- "bl_constrained"

	return(bl_obj)
}
