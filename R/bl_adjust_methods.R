
# ------------------------------------------------------------------------------
# ------------------------------------ TODO ------------------------------------
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------

print.bl_adjust <- function(object){
  utils::str(object)
}

adjust <- function(obj, ...) {
  UseMethod("adjust")
}

#' Adjust a bl object with observed data
#'
#' @param bl_obj A bl_adjust object
#' @param D A matrix of observed data
#' @param sequential Update beliefs sequentially using existing data?
#'
#' @return Returns a bl_adjust object
#' @export
#'
#' @examples
adjust.bl_adjust <- function(
	bl_obj, 
	D, 
	sequential = TRUE
){

	# THIS STILL NEEDS TO BE FILLED IN

	# D <- as.matrix(D)

	# adj_exp <- bl_obj$exp_X + bl_obj$cov_XD %*% inv(bl_obj$var_D) %*% 
	# 	(D - bl_obj$exp_D)
	# adj_var <- bl_obj$var_X - bl_obj$cov_XD %*% inv(bl_obj$var_D) %*% 
	# 	t(bl_obj$cov_XD)

	# bl_obj$D <- D
	# bl_obj$adjusted_exp <- adj_exp
	# bl_obj$adjusted_var <- adj_var
	# bl_obj$resolved_var <- bl_obj$var_X - adj_var

	# if (bl_obj$n_X == 1) {
	# 	bl_obj$resolution <- 1 - diag(adj_var)/diag(bl_obj$var_X)
	# } else {
	# 	bl_obj$resolution <- diag(1 - diag(diag(adj_var))/diag(diag(bl_obj$var_X)))	
	# }
	
	# class(bl_obj) <- "bl_adjust"

	# return(bl_obj)
}



















