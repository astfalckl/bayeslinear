
################################################################################
##################################    TODO    ##################################
################################################################################

# Have a think about what information we want to include in adj_bs. If we want
# to able to roll through with sequential adjustments we probably want to
# default assume exchangeability and go from there.

# Have calc_inverse option

# Check non-negative definiteness and the other algebraic stuff

# Are resolution and canonical a function of bs or adj_bs??

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
	Rvar <- obj$var_X - var_adj

# Need to have a think about what we want to include in here
	adj_obj <- structure(
    list(
			E_adj = as.matrix(E_adj),
			var_adj = as.matrix(var_adj),
			Rvar = Rvar,
			D = as.matrix(D),
			prior = obj
			# E_D = as.matrix(obj$E_D),
			# var_D = as.matrix(obj$var_D),
		),
		class = "adj_bs",
		nx = base::attributes(obj)$nx,
		nd = base::attributes(obj)$nd
  )

	return(adj_obj)

}

#' Calculates the resolution of an adjusted belief structure
#'
#' @param obj An adjusted belief structure object
#' @inheritParams adjust
#'
#' @return Returns a vector of calculated resolutions.
#' @export
resolution <- function(obj, ...) {
  UseMethod("resolution")
}

resolution.bs <- function(obj, ...){
	var_X <- obj$var_X
	Rvar <- obj$cov_XD %*% inv(obj$var_D) %*% t(obj$cov_XD)

	diag(Rvar)/diag(var_X)
}

resolution.adj_bs <- function(obj, ...){
	var_X <- obj$prior$var_X
	Rvar <- obj$Rvar

	diag(Rvar)/diag(var_X)
}

# Add this back in if/when we ever need it
#' Calculates the canonical directions and resolutions of either a belief structure or an adjusted belief structure
#'
#' @param obj Either a \code{bs} or an \code{adj_bs} object
#' @inheritParams adjust
#'
#' @return Returns a list of resolution matrix, canonical directions, and canonical resolutions. 
#' Note, the symmetric resolution matrix is used herein.
#' @export
canonical <- function(obj, ...) {
  UseMethod("canonical")
}

canonical.bs <- function(obj, ...){

	var_X <- obj$var_X
	Rvar <- obj$cov_XD %*% inv(obj$var_D) %*% t(obj$cov_XD)

	Td <- solve(var_X) %*% Rvar

	r <- eigen(Td)$values
	E <- eigen(Td)$vectors

	scales <- 1/sqrt(diag(t(E) %*% var_X %*% E))
	W <- diag(scales) %*% t(E)
	E_W <- - W %*% obj$E_X

	return(
		list(
			resolutions = r,
			resolution_matrix = Td,
			directions = t(W),
			directions_prior = E_W,
			system_resolution = mean(r)
		)
	)
}

canonical.adj_bs <- function(obj, ...){

	var_X <- obj$prior$var_X
	Rvar <- obj$Rvar

	Td <- solve(var_X) %*% Rvar

	r <- eigen(Td)$values
	E <- eigen(Td)$vectors

	scales <- 1/sqrt(diag(t(E) %*% var_X %*% E))
	W <- diag(scales) %*% t(E)
	E_W <- - W %*% obj$prior$E_X

	return(
		list(
			resolutions = r,
			resolution_matrix = Td,
			directions = t(W),
			directions_prior = E_W,
			system_resolution = mean(r)
		)
	)
}

















