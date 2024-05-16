
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bayeslinear

<!-- badges: start -->
<!-- badges: end -->

<tt>bayeslinear</tt> provides tools to perform a Bayes Linear analysis
as well as generalising the solution space to convex subsets. For
overview of these methodologies see HERE.

## Installation

<tt>bayeslinear</tt> is currently in development; install the latest
version from [GitHub](https://github.com/) with:

``` r
install.packages("devtools")
devtools::install_github("astfalckl/bayeslinear")
```

Also, call in some other packages we need for the README

``` r
library(bayeslinear)
library(ggplot2)
library(CVXR)
library(dplyr)
library(patchwork)
library(latex2exp)

theme_set(theme_bw())
```

# Standard and Generalised Bayes Linear Analysis

We demonstrate the code by repeating the example given in PAPER.

## Creating Belief Structures

A belief structure is the fundamental unit of information that specifies
the geometry of a Bayes linear analysis. We are required to specify
$\mathbb{E}(X)$, $\mathbb{E}(D)$, $\mathrm{var}(X)$, $\mathrm{var}(D)$
and $\mathrm{cov}(X,D)$. The methods in <tt>bayeslinear</tt> are based
on the creation of a belief structure object through the function
<tt>belief_structure()</tt>.

``` r
nx <- 2
nd <- 2

exp_x <- matrix(c(1, 1))
exp_d <- matrix(c(1, 1))
var_x <- matrix(c(0.54, 0.09, 0.09, 0.54), nrow = nx)
cov_xd <- matrix(c(0.4, -0.1, -.1, -.3), nrow = nx)
var_d <- matrix(c(1, -0.2, -0.2, 1), nrow = nd)

bivariate_bs <- belief_structure(exp_x, exp_d, cov_xd, var_x, var_d)
bivariate_bs
#> List of 5
#>  $ exp_x : num [1:2, 1] 1 1
#>  $ exp_d : num [1:2, 1] 1 1
#>  $ cov_xd: num [1:2, 1:2] 0.4 -0.1 -0.1 -0.3
#>  $ var_x : num [1:2, 1:2] 0.54 0.09 0.09 0.54
#>  $ var_d : num [1:2, 1:2] 1 -0.2 -0.2 1
#>  - attr(*, "class")= chr "belief_structure"
#>  - attr(*, "nx")= int 2
#>  - attr(*, "nd")= int 2
```

## Adjusting Belief Structures

A <tt>belief_structure</tt> object is adjusted by some data <tt>d</tt>
via the <tt>adjust</tt> method. An adjusted belief structure
<tt>adj_belief_structure</tt> is returned. Note that the initial belief
structure is always stored in <tt>prior_bs</tt>.

``` r
d <- c(3, 6.5)
bivariate_adj_bs <- adjust(bivariate_bs, d)
bivariate_adj_bs
#> List of 5
#>  $ adj_exp     : num [1:2, 1] 1.68 -1.17
#>  $ adj_var     : num [1:2, 1:2] 0.38 0.123 0.123 0.423
#>  $ resolved_var: num [1:2, 1:2] 0.1604 -0.0333 -0.0333 0.1167
#>  $ d           : num [1:2, 1] 3 6.5
#>  $ prior_bs    :List of 5
#>   ..$ exp_x : num [1:2, 1] 1 1
#>   ..$ exp_d : num [1:2, 1] 1 1
#>   ..$ cov_xd: num [1:2, 1:2] 0.4 -0.1 -0.1 -0.3
#>   ..$ var_x : num [1:2, 1:2] 0.54 0.09 0.09 0.54
#>   ..$ var_d : num [1:2, 1:2] 1 -0.2 -0.2 1
#>   ..- attr(*, "class")= chr "belief_structure"
#>   ..- attr(*, "nx")= int 2
#>   ..- attr(*, "nd")= int 2
#>  - attr(*, "class")= chr "adj_belief_structure"
#>  - attr(*, "nx")= int 2
#>  - attr(*, "nd")= int 2
```

## Creating Generalised Belief Structures

We may augment a belief structure with a solution constraint by using
the <tt>gen_belief_structure</tt> method. This is similar to above
however with the inclusion of a quoted constraint that gets passed to
<tt>CVXR</tt>. We demonstrate what some of these constraints look like
here, and point towards [here](https://cvxr.rbind.io) for a
comprehensive list of examples.

``` r
bivariate_gbs <- gen_belief_structure(
  exp_x, exp_d, cov_xd, var_x, var_d,
  quote(list(gen_adj_exp >= 0))
)
bivariate_gbs
#> List of 6
#>  $ exp_x     : num [1:2, 1] 1 1
#>  $ exp_d     : num [1:2, 1] 1 1
#>  $ cov_xd    : num [1:2, 1:2] 0.4 -0.1 -0.1 -0.3
#>  $ var_x     : num [1:2, 1:2] 0.54 0.09 0.09 0.54
#>  $ var_d     : num [1:2, 1:2] 1 -0.2 -0.2 1
#>  $ constraint: language list(gen_adj_exp >= 0)
#>  - attr(*, "class")= chr "gen_belief_structure"
#>  - attr(*, "nx")= int 2
#>  - attr(*, "nd")= int 2
```

## Adjusting Generalised Belief Structures

This happens with the same <tt>adjust</tt> method as before, but returns
the generalised adjusted expectation and variance according to the
specified constraint.

``` r
bivariate_adj_gbs <- adjust(bivariate_gbs, d)
#> CVXR returned with status: optimal
bivariate_adj_gbs
#> List of 5
#>  $ gen_adj_exp: num [1:2, 1] 2.02 -2.18e-21
#>  $ gen_adj_var: num [1:2, 1:2] 0.2231 0.0725 0.0725 0.0486
#>  $ d          : num [1:2, 1] 3 6.5
#>  $ adj_exp    : num [1:2, 1] 1.68 -1.17
#>  $ adj_var    : num [1:2, 1:2] 0.38 0.123 0.123 0.423
#>  - attr(*, "class")= chr "adj_gen_belief_structure"
#>  - attr(*, "CVXR_status")= chr "optimal"
#>  - attr(*, "nx")= int 2
#>  - attr(*, "nd")= int 2
```

## Plotting the results

We recreate Figure 1 from PAPER using the results above. We note that
<tt>ggplot</tt> has a habit of being very verbose, and so we have hidden
the code from the displayed <tt>README</tt> on GitHub. Please consult
the source file for all plotting code used.

<img src="man/figures/README-unnamed-chunk-7-1.png" width="80%" />
