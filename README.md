
<!-- README.md is generated from README.Rmd. Please edit that file -->
coach
=====

[![Travis build status](https://travis-ci.org/zamorarr/coach.svg?branch=master)](https://travis-ci.org/zamorarr/coach) [![Coverage status](https://codecov.io/gh/zamorarr/coach/branch/master/graph/badge.svg)](https://codecov.io/github/zamorarr/coach?branch=master)

The goal of coach is to provide functions to optimize lineups for a variety of sites (draftkings, fanduel, fantasydraft) and sports (nba, mlb, nfl, nhl). Not every site/sport combination has been created yet. If you want something added, file an issue.

Installation
------------

You can install the released version of coach from [github](https://github.com/zamorarr/coach) with:

``` r
devtools::install_github("zamorarr/coach")
```

Example
-------

Load the library.

``` r
library(coach)
```

Load lineup data exported from a fantasy site and read it in. Check the documention of the `read_*_*` functions for instructions on how to export the data. For example, for Draftkings you have to goto <https://www.draftkings.com/lineup/upload> and select the sport and slate data to export.

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
    #> # ... with 1,005 more rows

Add your custom projections into a column called `fpts_proj`. This is very important! If your projections aren't good then your optimized lineups won't be good either. For this example we'll just add some random noise to the player's season average fantasy points.

``` r
n <- nrow(data)
data$fpts_proj <- rnorm(n, data$fpts_avg)
print(data)
```

    #> # A tibble: 1,015 x 7
    #>    player_id player          team  position salary fpts_avg fpts_proj
    #>    <chr>     <chr>           <chr> <chr>     <int>    <dbl>     <dbl>
    #>  1 11191729  Le'Veon Bell    PIT   RB         9400     24.7      23.4
    #>  2 11192254  Todd Gurley II  LAR   RB         9300     26.5      26.9
    #>  3 11191754  David Johnson   ARI   RB         8800     14        12.4
    #>  4 11191533  Antonio Brown   PIT   WR         8600     24.6      24.5
    #>  5 11192632  Alvin Kamara    NO    RB         8500     19.9      21.2
    #>  6 11191840  DeAndre Hopkins HOU   WR         8300     21.7      20.8
    #>  7 11192079  Davante Adams   GB    WR         7800     16.1      15.9
    #>  8 11192140  Michael Thomas  NO    WR         7800     17.6      17.9
    #>  9 11192363  Ezekiel Elliott DAL   RB         7700     21.9      20.9
    #> 10 11193133  Julio Jones     ATL   WR         7600     17.3      18.7
    #> # ... with 1,005 more rows

Build a fantasy model. This model contains all the constraints imposed by the site and sport.

``` r
model <- model_dk_nfl(data)
```

Generate three optimized lineups using your projections and the fantasy model

``` r
optimize_generic(data, model, L = 3)
```

    #> [[1]]
    #> # A tibble: 9 x 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II    LAR   RB         9300    26.5       26.9
    #> 2 11191533  Antonio Brown     PIT   WR         8600    24.6       24.5
    #> 3 11191859  Odell Beckham Jr. NYG   WR         7000    18.5       19.5
    #> 4 11192767  Deshaun Watson    HOU   QB         6700    26.3       28.7
    #> 5 11191735  Carlos Hyde       CLE   RB         4500    14.9       16.1
    #> 6 11192176  Sterling Shepard  NYG   WR         4500    14.0       14.9
    #> 7 11191619  Jack Doyle        IND   TE         3600    11.6       11.8
    #> 8 11191868  Kapri Bibbs       WAS   RB         3000    13.6       14.3
    #> 9 11191355  Chargers          LAC   DST        2800     9.94      11.5
    #> 
    #> [[2]]
    #> # A tibble: 9 x 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II    LAR   RB         9300    26.5       26.9
    #> 2 11191533  Antonio Brown     PIT   WR         8600    24.6       24.5
    #> 3 11191859  Odell Beckham Jr. NYG   WR         7000    18.5       19.5
    #> 4 11192767  Deshaun Watson    HOU   QB         6700    26.3       28.7
    #> 5 11191735  Carlos Hyde       CLE   RB         4500    14.9       16.1
    #> 6 11192176  Sterling Shepard  NYG   WR         4500    14.0       14.9
    #> 7 11191619  Jack Doyle        IND   TE         3600    11.6       11.8
    #> 8 11191868  Kapri Bibbs       WAS   RB         3000    13.6       14.3
    #> 9 11191335  Bears             CHI   DST        2300     8.62      10.6
    #> 
    #> [[3]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       26.9
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       24.5
    #> 3 11191811  Keenan Allen     LAC   WR         7500    19.1       19.4
    #> 4 11192767  Deshaun Watson   HOU   QB         6700    26.3       28.7
    #> 5 11191735  Carlos Hyde      CLE   RB         4500    14.9       16.1
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       14.9
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       11.8
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       14.3
    #> 9 11191335  Bears            CHI   DST        2300     8.62      10.6
