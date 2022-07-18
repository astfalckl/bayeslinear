
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bayeslinear

<!-- badges: start -->
<!-- badges: end -->

<tt> bayeslinear </tt> provides tools to perform a Bayes Linear
analysis.

## Installation

<!-- You can install the released version of bayeslinear from [CRAN](https://CRAN.R-project.org) with:
``` r
install.packages("bayeslinear")
``` -->

<tt> bayeslinear </tt> is currently in development; install the latest
version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("astfalckl/bayeslinear")
```

## Creating Belief Structures

A belief structure is the fundamental unit of information that we
require to conduct a BL analysis blah blah blah. It requires the
specification of 𝔼(*X*), 𝔼(*D*), var(*X*), var(*D*) and cov(*X*,*D*) to
fully specify the inner product space. The methods in <tt> bayeslinear
</tt> are based on the creation of a belief structure object through
<tt> bs() </tt>. For example the one-dimensional example in Goldstein
and Wooff (2007) is created as

``` r
library(bayeslinear)

E_X <- 1
E_D <- 2

var_X <- var_D <- 1
cov_XD <- 0.6

one_dimension <- bs(E_X, E_D, cov_XD, var_X, var_D)
print(one_dimension)
#> $E_X
#>      [,1]
#> [1,]    1
#> 
#> $E_D
#>      [,1]
#> [1,]    2
#> 
#> $cov_XD
#>      [,1]
#> [1,]  0.6
#> 
#> $var_X
#>      [,1]
#> [1,]    1
#> 
#> $var_D
#>      [,1]
#> [1,]    1
#> 
#> $n_X
#> NULL
#> 
#> $n_D
#> [1] 1
#> 
#> attr(,"class")
#> [1] "bs"
```

## Adjusting Belief Structures

A <tt> bs </tt> object is adjusted by some data <tt> D </tt> via the
<tt> adjust </tt> method. An adjusted belief structure <tt> adj_bs </tt>
is returned.

``` r
D <- 0
# adjust(one_dimension, D)
```
