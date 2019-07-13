
<!-- README.md is generated from README.Rmd. Please edit that file -->

# coach

[![Travis build
status](https://travis-ci.org/dfs-with-r/coach.svg?branch=master)](https://travis-ci.org/dfs-with-r/coach)
[![Coverage
status](https://codecov.io/gh/dfs-with-r/coach/branch/master/graph/badge.svg)](https://codecov.io/github/dfs-with-r/coach?branch=master)

The goal of coach is to provide functions to optimize lineups for a
variety of sites (draftkings, fanduel, fantasydraft) and sports (nba,
mlb, nfl, nhl). Not every site/sport combination has been created yet.
If you want something added, file an issue.

## Installation

You can install the released version of coach from
[github](https://github.com/zamorarr/coach) with:

``` r
devtools::install_github("zamorarr/coach")
```

## Example

Load the library.

``` r
library(coach)
```

Load lineup data exported from a fantasy site and read it in. Check the
documention of the `read_*_*` functions for instructions on how to
export the data. For example, for Draftkings you have to goto your
contest page and select *Export to csv*.

``` r
data <- read_dk("mydata.csv")
print(data)
```

    #> # A tibble: 1,015 x 7
    #>    player_id player          team  position salary fpts_avg fpts_proj
    #>    <chr>     <chr>           <chr> <chr>     <int>    <dbl>     <dbl>
    #>  1 11191729  Le'Veon Bell    PIT   RB         9400     24.7        NA
    #>  2 11192254  Todd Gurley II  LAR   RB         9300     26.5        NA
    #>  3 11191754  David Johnson   ARI   RB         8800     14          NA
    #>  4 11191533  Antonio Brown   PIT   WR         8600     24.6        NA
    #>  5 11192632  Alvin Kamara    NO    RB         8500     19.9        NA
    #>  6 11191840  DeAndre Hopkins HOU   WR         8300     21.7        NA
    #>  7 11192079  Davante Adams   GB    WR         7800     16.1        NA
    #>  8 11192140  Michael Thomas  NO    WR         7800     17.6        NA
    #>  9 11192363  Ezekiel Elliott DAL   RB         7700     21.9        NA
    #> 10 11193133  Julio Jones     ATL   WR         7600     17.3        NA
    #> # … with 1,005 more rows

Add your custom projections into a column called `fpts_proj`. This is
very important\! If your projections aren’t good then your optimized
lineups won’t be good either. For this example we’ll just add some
random noise to the player’s season average fantasy points.

``` r
set.seed(100)
n <- nrow(data)
data$fpts_proj <- rnorm(n, data$fpts_avg)
print(data)
```

    #> # A tibble: 1,015 x 7
    #>    player_id player          team  position salary fpts_avg fpts_proj
    #>    <chr>     <chr>           <chr> <chr>     <int>    <dbl>     <dbl>
    #>  1 11191729  Le'Veon Bell    PIT   RB         9400     24.7      25.7
    #>  2 11192254  Todd Gurley II  LAR   RB         9300     26.5      27.6
    #>  3 11191754  David Johnson   ARI   RB         8800     14        14.7
    #>  4 11191533  Antonio Brown   PIT   WR         8600     24.6      25.1
    #>  5 11192632  Alvin Kamara    NO    RB         8500     19.9      20.4
    #>  6 11191840  DeAndre Hopkins HOU   WR         8300     21.7      22.2
    #>  7 11192079  Davante Adams   GB    WR         7800     16.1      16.6
    #>  8 11192140  Michael Thomas  NO    WR         7800     17.6      20.1
    #>  9 11192363  Ezekiel Elliott DAL   RB         7700     21.9      20.7
    #> 10 11193133  Julio Jones     ATL   WR         7600     17.3      16.8
    #> # … with 1,005 more rows

Build a fantasy model. This model contains all the constraints imposed
by the site and sport.

``` r
model <- model_dk_nfl(data)
```

Generate three optimized lineups using your projections and the fantasy
model

``` r
optimize_generic(data, model, L = 3)
```

    #> [[1]]
    #> # A tibble: 9 x 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5       27.6
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6       25.1
    #> 3 11192767  Deshaun Watson HOU   QB         6700    26.3       27.6
    #> 4 11192243  Stefon Diggs   MIN   WR         6300    15.3       17.5
    #> 5 11191680  Chris Thompson WAS   RB         4700    15.9       15.3
    #> 6 11193143  Mohamed Sanu   ATL   WR         3800    11.4       12.3
    #> 7 11191361  Jaguars        JAX   DST        3700    12.3       13.7
    #> 8 11191422  Jared Cook     OAK   TE         3700     8.74      13.6
    #> 9 11191868  Kapri Bibbs    WAS   RB         3000    13.6       14.0
    #> 
    #> [[2]]
    #> # A tibble: 9 x 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5       27.6
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6       25.1
    #> 3 11192767  Deshaun Watson HOU   QB         6700    26.3       27.6
    #> 4 11191547  Mark Ingram    NO    RB         5700    16.7       16.7
    #> 5 11191861  Jarvis Landry  CLE   WR         5500    16.4       15.9
    #> 6 11193143  Mohamed Sanu   ATL   WR         3800    11.4       12.3
    #> 7 11191361  Jaguars        JAX   DST        3700    12.3       13.7
    #> 8 11191422  Jared Cook     OAK   TE         3700     8.74      13.6
    #> 9 11191868  Kapri Bibbs    WAS   RB         3000    13.6       14.0
    #> 
    #> [[3]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       27.6
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.1
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3       27.6
    #> 4 11191393  Larry Fitzgerald ARI   WR         6600    17.2       18.3
    #> 5 11192176  Sterling Shepard NYG   WR         4500    14.0       13.7
    #> 6 11191361  Jaguars          JAX   DST        3700    12.3       13.7
    #> 7 11191367  Frank Gore       MIA   RB         3700    11.2       13.0
    #> 8 11191422  Jared Cook       OAK   TE         3700     8.74      13.6
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000    13.6       14.0

Write these results to a file. This file can be submitted directly to
the DFS
site.

``` r
write_lineups(results, "mylineups.csv", site = "draftkings", sport = "nfl")
```

    #>         QB       RB       RB       WR       WR       WR       TE     FLEX
    #> 1 11192767 11192254 11191868 11193143 11192243 11191533 11191422 11191680
    #> 2 11192767 11192254 11191547 11193143 11191861 11191533 11191422 11191868
    #> 3 11192767 11192254 11191367 11191393 11192176 11191533 11191422 11191868
    #>        DST
    #> 1 11191361
    #> 2 11191361
    #> 3 11191361
