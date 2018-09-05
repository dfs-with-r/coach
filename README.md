# coach
[![Travis build status](https://travis-ci.org/zamorarr/coach.svg?branch=master)](https://travis-ci.org/zamorarr/coach)
[![Coverage status](https://codecov.io/gh/zamorarr/coach/branch/master/graph/badge.svg)](https://codecov.io/github/zamorarr/coach?branch=master)

The goal of coach is to provide functions to optimize lineups for a variety of sites (draftkings, fanduel, fantasydraft) and sports (nba, mlb, nfl, nhl). Not every site/sport combination has been created yet. If you want something added, file an issue.

## Installation

You can install the released version of coach from [github](https://github.com/zamorarr/coach) with:

``` r
devtools::install_github("zamorarr/coach")
```

## Example

``` r
library(coach)

# import data
data <- data.frame(...)

# build model
model <- model_dk_nba(data)

# generate 3 lineups
optimize_generic(data, model, L = 3)
```

