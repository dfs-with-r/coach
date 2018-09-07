
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
data <- read_dk_nfl("mydata.csv")
print(data)
```

    #> # A tibble: 1,015 x 6
    #>    player_id player          team  position salary fpts_avg
    #>    <chr>     <chr>           <chr> <chr>     <int>    <dbl>
    #>  1 11191729  Le'Veon Bell    PIT   RB         9400     24.7
    #>  2 11192254  Todd Gurley II  LAR   RB         9300     26.5
    #>  3 11191754  David Johnson   ARI   RB         8800     14  
    #>  4 11191533  Antonio Brown   PIT   WR         8600     24.6
    #>  5 11192632  Alvin Kamara    NO    RB         8500     19.9
    #>  6 11191840  DeAndre Hopkins HOU   WR         8300     21.7
    #>  7 11192079  Davante Adams   GB    WR         7800     16.1
    #>  8 11192140  Michael Thomas  NO    WR         7800     17.6
    #>  9 11192363  Ezekiel Elliott DAL   RB         7700     21.9
    #> 10 11193133  Julio Jones     ATL   WR         7600     17.3
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
    #>  1 11191729  Le'Veon Bell    PIT   RB         9400     24.7      24.6
    #>  2 11192254  Todd Gurley II  LAR   RB         9300     26.5      26.8
    #>  3 11191754  David Johnson   ARI   RB         8800     14        13.1
    #>  4 11191533  Antonio Brown   PIT   WR         8600     24.6      25.5
    #>  5 11192632  Alvin Kamara    NO    RB         8500     19.9      19.9
    #>  6 11191840  DeAndre Hopkins HOU   WR         8300     21.7      19.8
    #>  7 11192079  Davante Adams   GB    WR         7800     16.1      15.4
    #>  8 11192140  Michael Thomas  NO    WR         7800     17.6      16.3
    #>  9 11192363  Ezekiel Elliott DAL   RB         7700     21.9      21.5
    #> 10 11193133  Julio Jones     ATL   WR         7600     17.3      17.2
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
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5      26.8 
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6      25.5 
    #> 3 11192749  Tyreek Hill    KC    WR         6500    17.2      19.4 
    #> 4 11191517  Russell Wilson SEA   QB         6200    23.2      24.1 
    #> 5 11191493  LeSean McCoy   BUF   RB         6000    17.3      19.3 
    #> 6 11191861  Jarvis Landry  CLE   WR         5500    16.4      18.3 
    #> 7 11191868  Kapri Bibbs    WAS   RB         3000    13.6      13.6 
    #> 8 11192493  Hunter Henry   LAC   TE         2500     9.06      9.81
    #> 9 11191335  Bears          CHI   DST        2300     8.62     10.4 
    #> 
    #> [[2]]
    #> # A tibble: 9 x 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5       26.8
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6       25.5
    #> 3 11192749  Tyreek Hill    KC    WR         6500    17.2       19.4
    #> 4 11191517  Russell Wilson SEA   QB         6200    23.2       24.1
    #> 5 11191861  Jarvis Landry  CLE   WR         5500    16.4       18.3
    #> 6 11191680  Chris Thompson WAS   RB         4700    15.9       17.2
    #> 7 11191619  Jack Doyle     IND   TE         3600    11.6       11.4
    #> 8 11191868  Kapri Bibbs    WAS   RB         3000    13.6       13.6
    #> 9 11191335  Bears          CHI   DST        2300     8.62      10.4
    #> 
    #> [[3]]
    #> # A tibble: 9 x 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5      26.8 
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6      25.5 
    #> 3 11192749  Tyreek Hill    KC    WR         6500    17.2      19.4 
    #> 4 11191517  Russell Wilson SEA   QB         6200    23.2      24.1 
    #> 5 11191861  Jarvis Landry  CLE   WR         5500    16.4      18.3 
    #> 6 11191680  Chris Thompson WAS   RB         4700    15.9      17.2 
    #> 7 11191346  Rams           LAR   DST        3600    10.3      11.8 
    #> 8 11191868  Kapri Bibbs    WAS   RB         3000    13.6      13.6 
    #> 9 11192493  Hunter Henry   LAC   TE         2500     9.06      9.81
