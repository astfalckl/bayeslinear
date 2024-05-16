#' Create belief structure object
#'
#' @param exp_x Prior expectation of X. Expects either a numeric vector or 1D
#' matrix.
#' @param exp_d Prior expectation of D. Expects either a numeric vector or 1D
#' matrix.
#' @param cov_xd Prior covariance of X and D
#' @param var_x Prior variance of X
#' @param var_d Prior variance of D
#'
#' @return Returns a belief structure (\code{belief_structure}) object
#' @export
belief_structure <- function(exp_x, exp_d, cov_xd, var_x, var_d) {

  structure(
    list(
        exp_x = as.matrix(exp_x),
        exp_d = as.matrix(exp_d),
        cov_xd = as.matrix(cov_xd),
        var_x = as.matrix(var_x),
        var_d = as.matrix(var_d)
      ),
      class = "belief_structure",
      nx = nrow(as.matrix(exp_x)),
      nd = nrow(as.matrix(exp_d))
  )

}

#' @export
print.belief_structure <- function(x, ...) {
  utils::str(x)
}

#' @export
print.adj_belief_structure <- function(x, ...) {
  utils::str(x)
}

#' Adjust a belief structure with observed data
#'
#' @param obj A belief structure calculated from \code{belief_structure()}.
#' @param d A numerical vecotr of 1D matrix of observed data.
#' @param ... further arguments passed to or from other methods.
#'
#' @return Returns a adjusted belief structure (\code{adj_belief_structure})
#' object
#' @export
adjust <- function(obj, d, ...) {
  UseMethod("adjust")
}

#' @export
adjust.belief_structure <- function(obj, d, ...) {

  d <- as.matrix(d)

  adj_exp <- obj$exp_x + obj$cov_xd %*% mp_inv(obj$var_d) %*% (d - obj$exp_d)
  adj_var <- obj$var_x - obj$cov_xd %*% mp_inv(obj$var_d) %*% t(obj$cov_xd)
  resolved_var <- obj$var_x - adj_var

  adj_obj <- structure(
    list(
      adj_exp = adj_exp,
      adj_var = adj_var,
      resolved_var = resolved_var,
      d = as.matrix(d),
      prior_bs = obj
    ),
    class = "adj_belief_structure",
    nx = attributes(obj)$nx,
    nd = attributes(obj)$nd
  )

  return(adj_obj)

}

#' Calculates the resolution of an adjusted belief structure
#'
#' @param obj An adjusted or standard belief structure object
#' @inheritParams adjust
#'
#' @return Returns a vector of calculated resolutions.
#' @export
resolution <- function(obj, ...) {
  UseMethod("resolution")
}

#' @export
resolution.belief_structure <- function(obj, ...) {
  resolved_var <- obj$cov_XD %*% mp_inv(obj$var_D) %*% t(obj$cov_XD)
  diag(resolved_var) / diag(obj$var_x)
}

#' @export
resolution.adj_belief_structure <- function(obj, ...) {
  diag(obj$resolved_var) / diag(obj$prior_bs$var_x)
}

#' Calculate the canonical directions and resolutions
#'
#' @param obj Either a \code{belief_structure} or an \code{adj_belief_structure}
#' object
#' @inheritParams adjust
#'
#' @return Returns a list of resolution matrix, canonical directions, and
#' canonical resolutions.
#' Note, the symmetric resolution matrix is used herein.
#' @export
canonical <- function(obj, ...) {
  UseMethod("canonical")
}

#' @export
canonical.belief_structure <- function(obj, ...) {

  var_x <- obj$var_x
  resolved_var <- obj$cov_xd %*% mp_inv(obj$var_d) %*% t(obj$cov_xd)

  res_matrix <- mp_inv(var_x) %*% resolved_var

  r <- eigen(res_matrix)$values
  v <- eigen(res_matrix)$vectors

  scales <- 1 / sqrt(diag(t(v) %*% var_x %*% v))
  w <- diag(scales) %*% t(v)
  exp_w <- - w %*% obj$E_X

  return(
    list(
      resolutions = r,
      resolution_matrix = res_matrix,
      directions = t(w),
      directions_prior = exp_w,
      system_resolution = mean(r)
    )
  )
}

#' @export
canonical.adj_belief_structure <- function(obj, ...) {

  var_x <- obj$prior$var_x
  resolved_var <- obj$resolved_var

  res_matrix <- mp_inv(var_x) %*% resolved_var

  r <- eigen(res_matrix)$values
  v <- eigen(res_matrix)$vectors

  scales <- 1 / sqrt(diag(t(v) %*% var_x %*% v))
  w <- diag(scales) %*% t(v)
  exp_w <- - w %*% obj$prior$E_X

  return(
    list(
      resolutions = r,
      resolution_matrix = res_matrix,
      directions = t(w),
      directions_prior = exp_w,
      system_resolution = mean(r)
    )
  )
}