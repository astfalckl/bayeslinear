################################################################################
##################################    TODO    ##################################
################################################################################

################################################################################

#' Create a GBL belief structure
#' 
#' Similar to a standard belief structure but with the ability to specify a constrained solution space
#'
#' @inheritParams belief_structure
#' @param constraint Constraint expression. See the README for examples on how to specify this. 
#' \code{bayeslinear} currently assumes that constraints are convex and solves using CVXR.
#'
#' @return Returns a GBL belief structure (\code{gbl_bs}) object
#' @export
gbl_bs <- function(E_X, E_D, cov_XD, var_X, var_D, constraint){

  structure(
    list(
        E_X = E_X,
        E_D = E_D,
        cov_XD = cov_XD,
        var_X = var_X,
        var_D = var_D,
        constraint = constraint
    ),
    class = "gbl_bs",
    nx = nrow(as.matrix(E_X)),
    nd = nrow(as.matrix(E_D))
  )

}

#' @export
print.gbl_bs <- function(x, ...){
  utils::str(x)
}

#' @export
print.adj_gbl_bs <- function(x, ...){
  utils::str(x)
}

#' @export
adjust.gbl_bs <- function(obj, D, ...){

    D <- as.matrix(D)

    # ----- Vanilla Update ----- #

    E_adj <- obj$E_X + obj$cov_XD %*% solve(obj$var_D) %*% (D - obj$E_D)
    var_adj <- obj$var_X - obj$cov_XD %*% solve(obj$var_D) %*% t(obj$cov_XD)

    # ----- Constrained Expectation ----- #

    Ec_adj <- solve_constrained_expectation(
        E_adj,
        var_adj,
        obj$constraint
    )

    status <- attributes(Ec_adj)$status
    attributes(Ec_adj)$status <- NULL

     if(status != "optimal") warning('CVXR has not found optimal solution.')

    # ----- Constrained Variance ----- #

    chol_adj <- t(base::chol(var_adj))
    chol_solve <- inv(chol_adj)

    E_adj_rotate <- chol_solve %*% E_adj
    solution_rotate <- chol_solve %*% Ec_adj

    S <- abs(solution_rotate - E_adj_rotate)

    varc_adj <- chol_adj %*% cantelli(S) %*% t(chol_adj) # @astfalckl HACK: change cantelli to user defined function

    # ----- Defining object ----- #

    adj_gbl_bs <- structure(
        list(
            Ec_adj = Ec_adj,
            varc_adj = varc_adj,
            D = as.matrix(D),
            E_adj = as.matrix(E_adj),
            var_adj = as.matrix(var_adj)
        ),
        class = "adj_gbl_bs",
        status = status,
        nx = base::attributes(obj)$nx,
        nd = base::attributes(obj)$nd
    )

    return(adj_gbl_bs)

}

#' GBL Distance
#'
#' @param Ec_adj CVXR Variable object
#' @param E_adj Standard BL adjusted expectation
#' @param var_adj Standard BL adjusted variance
#'
#' @return Returns the distance between \code{Ec_adj} and \code{E_adj} in the inner product space defined by \code{var_adj}
#' @export
gbl_distance <- function(Ec_adj, E_adj, var_adj){
      CVXR::matrix_frac(Ec_adj - E_adj, var_adj)
}

#' Cantelli's inequality for a discrepancy S
#'
#' @param S Discrepancy term that's still to be named. Accepts either a numeric/vector/matrix object
#'
#' @return Returns a diagonal matrix with the Cantelli inequality calculations for each dimension on the diagonal
#' @export
cantelli <- function(S){
  return(diag(1/(1 + as.numeric(S^2))^2))
}

#' Solves for the constrained expectation of a GBL belief structure
#'
#' @inheritParams gbl_distance
#' @inheritParams gbl_bs
#'
#' @return The constrained adjusted expectation
#' @export
solve_constrained_expectation <- function(E_adj, var_adj, constraint){

    Ec_adj <- CVXR::Variable(nrow(E_adj))

    objective <- CVXR::Minimize(
      gbl_distance(Ec_adj, E_adj, var_adj)
    )

    problem <- CVXR::Problem(
    objective, 
    constraints = base::eval(constraint)
    )

    result <- CVXR::solve(problem)

    solution = result[[1]]
    base::attr(solution, "status") <- result$status

    return(solution)

}




