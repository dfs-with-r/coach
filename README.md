
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
export the data. For example, for Draftkings you have to goto
<https://www.draftkings.com/lineup/upload> and select the sport and
slate data to export.

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
    #>  1 11191729  Le'Veon Bell    PIT   RB         9400     24.7      24.2
    #>  2 11192254  Todd Gurley II  LAR   RB         9300     26.5      26.1
    #>  3 11191754  David Johnson   ARI   RB         8800     14        14.3
    #>  4 11191533  Antonio Brown   PIT   WR         8600     24.6      25.1
    #>  5 11192632  Alvin Kamara    NO    RB         8500     19.9      19.5
    #>  6 11191840  DeAndre Hopkins HOU   WR         8300     21.7      19.9
    #>  7 11192079  Davante Adams   GB    WR         7800     16.1      15.3
    #>  8 11192140  Michael Thomas  NO    WR         7800     17.6      16.4
    #>  9 11192363  Ezekiel Elliott DAL   RB         7700     21.9      20.6
    #> 10 11193133  Julio Jones     ATL   WR         7600     17.3      15.2
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
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5      26.1 
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6      25.1 
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3      25.0 
    #> 4 11191861  Jarvis Landry    CLE   WR         5500    16.4      18.7 
    #> 5 11191680  Chris Thompson   WAS   RB         4700    15.9      16.9 
    #> 6 11191735  Carlos Hyde      CLE   RB         4500    14.9      16.1 
    #> 7 11192176  Sterling Shepard NYG   WR         4500    14.0      14.5 
    #> 8 11191619  Jack Doyle       IND   TE         3600    11.6      11.3 
    #> 9 11191349  Patriots         NE    DST        2400     7.78      9.85
    #> 
    #> [[2]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300     26.5      26.1
    #> 2 11191533  Antonio Brown    PIT   WR         8600     24.6      25.1
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      25.0
    #> 4 11191861  Jarvis Landry    CLE   WR         5500     16.4      18.7
    #> 5 11191680  Chris Thompson   WAS   RB         4700     15.9      16.9
    #> 6 11192176  Sterling Shepard NYG   WR         4500     14.0      14.5
    #> 7 11191361  Jaguars          JAX   DST        3700     12.3      12.4
    #> 8 11191619  Jack Doyle       IND   TE         3600     11.6      11.3
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      13.5
    #> 
    #> [[3]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5      26.1 
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6      25.1 
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3      25.0 
    #> 4 11191861  Jarvis Landry    CLE   WR         5500    16.4      18.7 
    #> 5 11191680  Chris Thompson   WAS   RB         4700    15.9      16.9 
    #> 6 11191735  Carlos Hyde      CLE   RB         4500    14.9      16.1 
    #> 7 11192176  Sterling Shepard NYG   WR         4500    14.0      14.5 
    #> 8 11191361  Jaguars          JAX   DST        3700    12.3      12.4 
    #> 9 11192493  Hunter Henry     LAC   TE         2500     9.06      8.63

Write these results to a file. This file can be submitted directly to
the DFS
site.

``` r
write_lineups(results, "mylineups.csv", site = "draftkings", sport = "nfl")
```

    #>         QB       RB       RB       WR       WR       WR       TE     FLEX
    #> 1 11192767 11191735 11192254 11191861 11192176 11191533 11191619 11191680
    #> 2 11192767 11192254 11191868 11191861 11192176 11191533 11191619 11191680
    #> 3 11192767 11191735 11192254 11191861 11192176 11191533 11192493 11191680
    #>        DST
    #> 1 11191349
    #> 2 11191361
    #> 3 11191361
