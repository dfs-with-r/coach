
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

    #> # A tibble: 685 x 6
    #>    player_id player            team  position salary fpts_avg
    #>    <chr>     <chr>             <chr> <chr>     <int>    <dbl>
    #>  1 11191729  Le'Veon Bell      PIT   RB         9400     24.7
    #>  2 11192254  Todd Gurley II    LAR   RB         9300     26.5
    #>  3 11191754  David Johnson     ARI   RB         8800     14  
    #>  4 11191533  Antonio Brown     PIT   WR         8600     24.6
    #>  5 11192363  Ezekiel Elliott   DAL   RB         7700     21.9
    #>  6 11193133  Julio Jones       ATL   WR         7600     17.3
    #>  7 11191553  A.J. Green        CIN   WR         7300     14.9
    #>  8 11192722  Leonard Fournette JAX   RB         7100     19.2
    #>  9 11192103  Amari Cooper      OAK   WR         7100     11.7
    #> 10 11191859  Odell Beckham Jr. NYG   WR         7000     18.5
    #> # ... with 675 more rows

Add your custom projections into a column called `fpts_proj`. This is very important! If your projections aren't good then your optimized lineups won't be good either. For this example we'll just add some random noise to the player's season average fantasy points.

``` r
n <- nrow(data)
data$fpts_proj <- rnorm(n, data$fpts_avg)
print(data)
```

    #> # A tibble: 685 x 7
    #>    player_id player            team  position salary fpts_avg fpts_proj
    #>    <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #>  1 11191729  Le'Veon Bell      PIT   RB         9400     24.7      23.4
    #>  2 11192254  Todd Gurley II    LAR   RB         9300     26.5      27.0
    #>  3 11191754  David Johnson     ARI   RB         8800     14        14.1
    #>  4 11191533  Antonio Brown     PIT   WR         8600     24.6      24.3
    #>  5 11192363  Ezekiel Elliott   DAL   RB         7700     21.9      21.8
    #>  6 11193133  Julio Jones       ATL   WR         7600     17.3      16.4
    #>  7 11191553  A.J. Green        CIN   WR         7300     14.9      14.4
    #>  8 11192722  Leonard Fournette JAX   RB         7100     19.2      19.3
    #>  9 11192103  Amari Cooper      OAK   WR         7100     11.7      11.8
    #> 10 11191859  Odell Beckham Jr. NYG   WR         7000     18.5      20.4
    #> # ... with 675 more rows

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
    #> 1 11191533  Antonio Brown     PIT   WR         8600     24.6      24.3
    #> 2 11192363  Ezekiel Elliott   DAL   RB         7700     21.9      21.8
    #> 3 11191859  Odell Beckham Jr. NYG   WR         7000     18.5      20.4
    #> 4 11193094  Carson Wentz      PHI   QB         6400     23.4      24.1
    #> 5 11191861  Jarvis Landry     CLE   WR         5500     16.4      16.6
    #> 6 11191735  Carlos Hyde       CLE   RB         4500     14.9      15.4
    #> 7 11191361  Jaguars           JAX   DST        3700     12.3      13.8
    #> 8 11191619  Jack Doyle        IND   TE         3600     11.6      11.2
    #> 9 11191868  Kapri Bibbs       WAS   RB         3000     13.6      13.6
    #> 
    #> [[2]]
    #> # A tibble: 9 x 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II    LAR   RB         9300     26.5      27.0
    #> 2 11191533  Antonio Brown     PIT   WR         8600     24.6      24.3
    #> 3 11191859  Odell Beckham Jr. NYG   WR         7000     18.5      20.4
    #> 4 11193094  Carson Wentz      PHI   QB         6400     23.4      24.1
    #> 5 11191735  Carlos Hyde       CLE   RB         4500     14.9      15.4
    #> 6 11193143  Mohamed Sanu      ATL   WR         3800     11.4      11.0
    #> 7 11191361  Jaguars           JAX   DST        3700     12.3      13.8
    #> 8 11191619  Jack Doyle        IND   TE         3600     11.6      11.2
    #> 9 11191868  Kapri Bibbs       WAS   RB         3000     13.6      13.6
    #> 
    #> [[3]]
    #> # A tibble: 9 x 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II    LAR   RB         9300     26.5      27.0
    #> 2 11191533  Antonio Brown     PIT   WR         8600     24.6      24.3
    #> 3 11191859  Odell Beckham Jr. NYG   WR         7000     18.5      20.4
    #> 4 11191861  Jarvis Landry     CLE   WR         5500     16.4      16.6
    #> 5 11191365  Josh McCown       NYJ   QB         4800     17.5      18.4
    #> 6 11191735  Carlos Hyde       CLE   RB         4500     14.9      15.4
    #> 7 11191361  Jaguars           JAX   DST        3700     12.3      13.8
    #> 8 11191619  Jack Doyle        IND   TE         3600     11.6      11.2
    #> 9 11191868  Kapri Bibbs       WAS   RB         3000     13.6      13.6
