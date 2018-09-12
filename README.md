
<!-- README.md is generated from README.Rmd. Please edit that file -->
coach
=====

[![Travis build status](https://travis-ci.org/dfs-with-r/coach.svg?branch=master)](https://travis-ci.org/dfs-with-r/coach) [![Coverage status](https://codecov.io/gh/dfs-with-r/coach/branch/master/graph/badge.svg)](https://codecov.io/github/dfs-with-r/coach?branch=master)

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
set.seed(100)
n <- nrow(data)
data$fpts_proj <- rnorm(n, data$fpts_avg)
print(data)
```

    #> # A tibble: 1,015 x 7
    #>    player_id player          team  position salary fpts_avg fpts_proj
    #>    <chr>     <chr>           <chr> <chr>     <int>    <dbl>     <dbl>
    #>  1 11191729  Le'Veon Bell    PIT   RB         9400     24.7      24.9
    #>  2 11192254  Todd Gurley II  LAR   RB         9300     26.5      27.0
    #>  3 11191754  David Johnson   ARI   RB         8800     14        14.9
    #>  4 11191533  Antonio Brown   PIT   WR         8600     24.6      23.1
    #>  5 11192632  Alvin Kamara    NO    RB         8500     19.9      19.8
    #>  6 11191840  DeAndre Hopkins HOU   WR         8300     21.7      21.0
    #>  7 11192079  Davante Adams   GB    WR         7800     16.1      16.4
    #>  8 11192140  Michael Thomas  NO    WR         7800     17.6      17.5
    #>  9 11192363  Ezekiel Elliott DAL   RB         7700     21.9      22.3
    #> 10 11193133  Julio Jones     ATL   WR         7600     17.3      16.8
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
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5       27.0
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6       23.1
    #> 3 11192767  Deshaun Watson HOU   QB         6700    26.3       26.4
    #> 4 11192749  Tyreek Hill    KC    WR         6500    17.2       17.8
    #> 5 11191861  Jarvis Landry  CLE   WR         5500    16.4       17.7
    #> 6 11191680  Chris Thompson WAS   RB         4700    15.9       15.6
    #> 7 11193209  Eagles         PHI   DST        3000    10.8       11.8
    #> 8 11191868  Kapri Bibbs    WAS   RB         3000    13.6       12.1
    #> 9 11192493  Hunter Henry   LAC   TE         2500     9.06      10.2
    #> 
    #> [[2]]
    #> # A tibble: 9 x 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5      27.0 
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6      23.1 
    #> 3 11192767  Deshaun Watson HOU   QB         6700    26.3      26.4 
    #> 4 11192749  Tyreek Hill    KC    WR         6500    17.2      17.8 
    #> 5 11191861  Jarvis Landry  CLE   WR         5500    16.4      17.7 
    #> 6 11191735  Carlos Hyde    CLE   RB         4500    14.9      15.1 
    #> 7 11191619  Jack Doyle     IND   TE         3600    11.6      12.3 
    #> 8 11191868  Kapri Bibbs    WAS   RB         3000    13.6      12.1 
    #> 9 11191335  Bears          CHI   DST        2300     8.62     10.00
    #> 
    #> [[3]]
    #> # A tibble: 9 x 7
    #>   player_id player          team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>           <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II  LAR   RB         9300    26.5      27.0 
    #> 2 11191533  Antonio Brown   PIT   WR         8600    24.6      23.1 
    #> 3 11192363  Ezekiel Elliott DAL   RB         7700    21.9      22.3 
    #> 4 11192767  Deshaun Watson  HOU   QB         6700    26.3      26.4 
    #> 5 11191861  Jarvis Landry   CLE   WR         5500    16.4      17.7 
    #> 6 11191619  Jack Doyle      IND   TE         3600    11.6      12.3 
    #> 7 11191930  Adam Humphries  TB    WR         3200     8.29     10.4 
    #> 8 11191868  Kapri Bibbs     WAS   RB         3000    13.6      12.1 
    #> 9 11191335  Bears           CHI   DST        2300     8.62     10.00
