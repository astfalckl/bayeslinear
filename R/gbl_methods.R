#' Create a Generalised Bayes Linear belief structure
#'
#' Similar to a standard belief structure but with the ability to specify a
#' constrained solution space
#'
#' @inheritParams belief_structure
#' @param constraint Quoted constraint expression to be passed to \code{CVXR}.
#' See the README for examples on how to specify this.
#'
#' @return Returns a GBL belief structure (\code{gen_belief_structure}) object
#' @export
gen_belief_structure <- function(
  exp_x, exp_d, cov_xd, var_x, var_d,
  constraint
) {

  structure(
    list(
        exp_x = as.matrix(exp_x),
        exp_d = as.matrix(exp_d),
        cov_xd = as.matrix(cov_xd),
        var_x = as.matrix(var_x),
        var_d = as.matrix(var_d),
        constraint = constraint
    ),
    class = "gen_belief_structure",
    nx = nrow(as.matrix(exp_x)),
    nd = nrow(as.matrix(exp_d))
  )

}

#' @export
print.gen_belief_structure <- function(x, ...) {
  utils::str(x)
}

#' @export
print.adj_gen_belief_structure <- function(x, ...) {
  utils::str(x)
}

#' @export
adjust.gen_belief_structure <- function(obj, d, ...) {

  d <- as.matrix(d)

  # ----- Vanilla Update ----- #

  adj_exp <- obj$exp_x + obj$cov_xd %*% mp_inv(obj$var_d) %*% (d - obj$exp_d)
  adj_var <- obj$var_x - obj$cov_xd %*% mp_inv(obj$var_d) %*% t(obj$cov_xd)

  # ----- Constrained Expectation ----- #

  gen_adj_exp <- solve_constrained_expectation(
      adj_exp,
      adj_var,
      obj$constraint
  )

  status <- attributes(gen_adj_exp)$status
  attributes(gen_adj_exp)$status <- NULL

  cat(paste("CVXR returned with status:", status))

  # ----- Constrained Variance ----- #

  chol_adj <- t(base::chol(adj_var))
  chol_solve <- solve(chol_adj)

  rotated_adj_exp <- chol_solve %*% adj_exp
  rotated_gen_adj_exp <- chol_solve %*% gen_adj_exp

  s <- abs(rotated_gen_adj_exp - rotated_adj_exp)

  gen_adj_var <- chol_adj %*% cantelli(s) %*% t(chol_adj)

  # ----- Return object ----- #

  adj_gen_belief_structure <- structure(
      list(
          gen_adj_exp = gen_adj_exp,
          gen_adj_var = gen_adj_var,
          d = d,
          adj_exp = as.matrix(adj_exp),
          adj_var = as.matrix(adj_var)
      ),
      class = "adj_gen_belief_structure",
      CVXR_status = status,
      nx = base::attributes(obj)$nx,
      nd = base::attributes(obj)$nd
  )

  return(adj_gen_belief_structure)

}

#' GBL Distance
#'
#' @param Ec_adj CVXR Variable object
#' @param E_adj Standard BL adjusted expectation
#' @param var_adj Standard BL adjusted variance
#'
#' @return Returns the distance between \code{Ec_adj} and \code{E_adj} in the inner product space defined by \code{var_adj}
#' @export
gbl_distance <- function(gen_adj_exp, adj_exp, adj_var) {
      CVXR::matrix_frac(gen_adj_exp - adj_exp, adj_var)
}

#' Solves for the constrained expectation of a GBL belief structure
#'
#' @inheritParams gbl_distance
#' @inheritParams gen_belief_structure
#'
#' @return The constrained adjusted expectation
#' @export
solve_constrained_expectation <- function(adj_exp, adj_var, constraint) {

    gen_adj_exp <- CVXR::Variable(nrow(adj_exp))

    objective <- CVXR::Minimize(
      gbl_distance(gen_adj_exp, adj_exp, adj_var)
    )

    problem <- CVXR::Problem(objective, constraints = base::eval(constraint))

    result <- CVXR::solve(problem)

    solution <- result[[1]]
    base::attr(solution, "status") <- result$status

    return(solution)

}