
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bayeslinear

<!-- badges: start -->
<!-- badges: end -->

<tt>bayeslinear</tt> provides tools to perform a Bayes Linear analysis.

## Installation

<!-- You can install the released version of bayeslinear from [CRAN](https://CRAN.R-project.org) with:
``` r
install.packages("bayeslinear")
``` -->

<tt>bayeslinear</tt> is currently in development; install the latest
version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("astfalckl/bayeslinear")
library(bayeslinear)
```

# Vanilla Bayes Linear Analysis

## Creating Belief Structures

A belief structure is the fundamental unit of information that we
require to conduct a BL analysis blah blah blah. It requires the
specification of 𝔼(*X*), 𝔼(*D*), var(*X*), var(*D*) and cov(*X*,*D*) to
fully specify the inner product space. The methods in
<tt>bayeslinear</tt> are based on the creation of a belief structure
object through <tt>bs()</tt>. For example the one-dimensional example in
Goldstein and Wooff (2007) is created as

``` r
E_X <- 1
E_D <- 2

var_X <- var_D <- 1
cov_XD <- 0.6

one_dimension <- bs(E_X, E_D, cov_XD, var_X, var_D)
print(one_dimension)
#> List of 5
#>  $ E_X   : num [1, 1] 1
#>  $ E_D   : num [1, 1] 2
#>  $ cov_XD: num [1, 1] 0.6
#>  $ var_X : num [1, 1] 1
#>  $ var_D : num [1, 1] 1
#>  - attr(*, "class")= chr "bs"
#>  - attr(*, "nx")= int 1
#>  - attr(*, "nd")= int 1
```

## Adjusting Belief Structures

A <tt>bs</tt> object is adjusted by some data <tt>D</tt> via the
<tt>adjust</tt> method. An adjusted belief structure <tt>adj_bs</tt> is
returned.

``` r
D <- 0
adjust(one_dimension, D)
#> List of 5
#>  $ E_adj  : num [1, 1] -0.2
#>  $ var_adj: num [1, 1] 0.64
#>  $ Rvar   : num [1, 1] 0.36
#>  $ D      : num [1, 1] 0
#>  $ prior  :List of 5
#>   ..$ E_X   : num [1, 1] 1
#>   ..$ E_D   : num [1, 1] 2
#>   ..$ cov_XD: num [1, 1] 0.6
#>   ..$ var_X : num [1, 1] 1
#>   ..$ var_D : num [1, 1] 1
#>   ..- attr(*, "class")= chr "bs"
#>   ..- attr(*, "nx")= int 1
#>   ..- attr(*, "nd")= int 1
#>  - attr(*, "class")= chr "adj_bs"
#>  - attr(*, "nx")= int 1
#>  - attr(*, "nd")= int 1
```

## Summaries of Adjusted Belief Structures

Methods for calculating the adjustment resolutions and performing a
canonical analysis on either a <tt>bs</tt> or an <tt>adj_bs</tt> object
are <tt>resolution</tt> and <tt>canonical</tt>. For example, calculated
on the oral glucose data (this belief structure ships with the package).

``` r
resolution(oral_glucose)
#> [1] 0.3108514 0.0448334
canonical(oral_glucose)
#> $resolutions
#> [1] 0.31842089 0.02017772
#> 
#> $resolution_matrix
#>             [,1]        [,2]
#> [1,]  0.33360455 0.134457797
#> [2,] -0.03539375 0.004994056
#> 
#> $directions
#>            [,1]       [,2]
#> [1,]  1.0058635 -0.3019600
#> [2,] -0.1135872  0.7038817
#> 
#> $directions_prior
#>           [,1]
#> [1,] -3.474472
#> [2,] -3.143107
#> 
#> $system_resolution
#> [1] 0.1692993
```
