#' Create a GBL belief structure
#' 
#' Similar to a standard belief structure but with the ability to specify a constrained solution space
#'
#' @inheritParams bs
#' @param constraint Constraint expression. See the README for examples on how to specify this. 
#' \code{bayeslinear} currently assumes that constraints are convex and solves using CVXR.
#'
#' @return Returns a GBL belief structure (\code{gbl_bs}) object
#' @export
gbl_bs <- function(E_X, E_D, cov_XD, var_X, var_D, constraint){

  structure(
    list(
        E_X = as.matrix(E_X),
        E_D = as.matrix(E_D),
        cov_XD = as.matrix(cov_XD),
        var_X = as.matrix(var_X),
        var_D = as.matrix(var_D),
        constraint = constraint
    ),
    class = "gbl_bs",
    nx = nrow(as.matrix(E_X)),
    nd = nrow(as.matrix(E_D))
  )

}

print.gbl_bs <- function(x, ...){
  utils::str(x)
}

print.adj_gbl_bs <- function(x, ...){
  utils::str(x)
}

adjust.gbl_bs <- function(obj, D, ...){

    D <- as.matrix(D)

    E_adj <- obj$E_X + obj$cov_XD %*% inv(obj$var_D) %*% 
        (D - obj$E_D)
    var_adj <- obj$var_X - obj$cov_XD %*% inv(obj$var_D) %*% 
        t(obj$cov_XD)

    Ec_adj <- solve_constrained_expectation(
        E_adj,
        var_adj,
        obj$constraint
    )

    adj_gbl_bs <- structure(
        list(
            Ec_adj = Ec_adj,
            D = as.matrix(D),
            E_adj = as.matrix(E_adj),
            var_adj = as.matrix(var_adj)
        ),
        class = "adj_gbl_bs",
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




