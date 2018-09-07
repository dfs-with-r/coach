
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

    #> # A tibble: 685 x 9
    #>    row_id player_id play… team  opp_team location position salary fpts_avg
    #>     <int> <chr>     <chr> <chr> <chr>    <chr>    <chr>     <int>    <dbl>
    #>  1      1 11192641  Andr… ARI   WAS      ARI      TE         2500     0   
    #>  2      2 11192669  Chad… ARI   WAS      ARI      QB         4000     0   
    #>  3      3 11192672  Chad… ARI   WAS      ARI      WR         3200     1.57
    #>  4      4 11192968  Josh… ARI   WAS      ARI      QB         4700     0   
    #>  5      5 11192349  T.J.… ARI   WAS      ARI      RB         3500     0   
    #>  6      6 11192509  C.J.… ARI   WAS      ARI      WR         3000     0   
    #>  7      7 11192857  Tren… ARI   WAS      ARI      WR         3000     0   
    #>  8      8 11191559  Bric… ARI   WAS      ARI      WR         3600     4.98
    #>  9      9 11191754  Davi… ARI   WAS      ARI      RB         8800    14   
    #> 10     10 11192132  D.J.… ARI   WAS      ARI      RB         3000     4.6 
    #> # ... with 675 more rows

Add your custom projections into a column called `fpts_proj`. This is very important! If your projections aren't good then your optimized lineups won't be good either. For this example we'll just add some random noise to the player's season average fantasy points.

``` r
n <- nrow(data)
data$fpts_proj <- rnorm(n, data$fpts_avg)
print(data)
#> # A tibble: 685 x 10
#>    row_id player_id player team  opp_team location position salary fpts_avg
#>     <int> <chr>     <chr>  <chr> <chr>    <chr>    <chr>     <int>    <dbl>
#>  1      1 11192641  Andre… ARI   WAS      ARI      TE         2500     0   
#>  2      2 11192669  Chad … ARI   WAS      ARI      QB         4000     0   
#>  3      3 11192672  Chad … ARI   WAS      ARI      WR         3200     1.57
#>  4      4 11192968  Josh … ARI   WAS      ARI      QB         4700     0   
#>  5      5 11192349  T.J. … ARI   WAS      ARI      RB         3500     0   
#>  6      6 11192509  C.J. … ARI   WAS      ARI      WR         3000     0   
#>  7      7 11192857  Trent… ARI   WAS      ARI      WR         3000     0   
#>  8      8 11191559  Brice… ARI   WAS      ARI      WR         3600     4.98
#>  9      9 11191754  David… ARI   WAS      ARI      RB         8800    14   
#> 10     10 11192132  D.J. … ARI   WAS      ARI      RB         3000     4.6 
#> # ... with 675 more rows, and 1 more variable: fpts_proj <dbl>
```

Build a fantasy model. This model contains all the constraints imposed by the site and sport.

``` r
model <- model_dk_nfl(data)
```

Generate three optimized lineups using your projections and the fantasy model

``` r
optimize_generic(data, model, L = 3)
```

    #> [[1]]
    #> # A tibble: 9 x 6
    #>   player_id player           team  position salary fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>     <dbl>
    #> 1 11191493  LeSean McCoy     BUF   RB         6000      18.2
    #> 2 11191735  Carlos Hyde      CLE   RB         4500      15.8
    #> 3 11192363  Ezekiel Elliott  DAL   RB         7700      22.1
    #> 4 11191619  Jack Doyle       IND   TE         3600      11.8
    #> 5 11191361  Jaguars          JAX   DST        3700      13.5
    #> 6 11192302  Cooper Kupp      LAR   WR         5200      14.5
    #> 7 11192176  Sterling Shepard NYG   WR         4500      14.6
    #> 8 11191533  Antonio Brown    PIT   WR         8600      23.3
    #> 9 11191517  Russell Wilson   SEA   QB         6200      23.7
    #> 
    #> [[2]]
    #> # A tibble: 9 x 6
    #>   player_id player           team  position salary fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>     <dbl>
    #> 1 11191393  Larry Fitzgerald ARI   WR         6600      16.8
    #> 2 11191735  Carlos Hyde      CLE   RB         4500      15.8
    #> 3 11191619  Jack Doyle       IND   TE         3600      11.8
    #> 4 11191361  Jaguars          JAX   DST        3700      13.5
    #> 5 11192254  Todd Gurley II   LAR   RB         9300      25.1
    #> 6 11192176  Sterling Shepard NYG   WR         4500      14.6
    #> 7 11191533  Antonio Brown    PIT   WR         8600      23.3
    #> 8 11191517  Russell Wilson   SEA   QB         6200      23.7
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000      12.3
    #> 
    #> [[3]]
    #> # A tibble: 9 x 6
    #>   player_id player           team  position salary fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>     <dbl>
    #> 1 11191861  Jarvis Landry    CLE   WR         5500      16.0
    #> 2 11191735  Carlos Hyde      CLE   RB         4500      15.8
    #> 3 11191619  Jack Doyle       IND   TE         3600      11.8
    #> 4 11191361  Jaguars          JAX   DST        3700      13.5
    #> 5 11192254  Todd Gurley II   LAR   RB         9300      25.1
    #> 6 11192176  Sterling Shepard NYG   WR         4500      14.6
    #> 7 11193094  Carson Wentz     PHI   QB         6400      24.2
    #> 8 11191533  Antonio Brown    PIT   WR         8600      23.3
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000      12.3
