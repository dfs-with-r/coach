
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

## Usage

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
    #>  1 11191729  Le'Veon Bell    PIT   RB         9400     24.7      24.5
    #>  2 11192254  Todd Gurley II  LAR   RB         9300     26.5      26.6
    #>  3 11191754  David Johnson   ARI   RB         8800     14        12.4
    #>  4 11191533  Antonio Brown   PIT   WR         8600     24.6      23.9
    #>  5 11192632  Alvin Kamara    NO    RB         8500     19.9      20.4
    #>  6 11191840  DeAndre Hopkins HOU   WR         8300     21.7      20.4
    #>  7 11192079  Davante Adams   GB    WR         7800     16.1      17.1
    #>  8 11192140  Michael Thomas  NO    WR         7800     17.6      19.6
    #>  9 11192363  Ezekiel Elliott DAL   RB         7700     21.9      22.0
    #> 10 11193133  Julio Jones     ATL   WR         7600     17.3      17.1
    #> # … with 1,005 more rows

### Built-In Models

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
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II    LAR   RB         9300    26.5      26.6 
    #> 2 11191533  Antonio Brown     PIT   WR         8600    24.6      23.9 
    #> 3 11192002  Melvin Gordon III LAC   RB         6800    18.4      20.6 
    #> 4 11192767  Deshaun Watson    HOU   QB         6700    26.3      26.6 
    #> 5 11191680  Chris Thompson    WAS   RB         4700    15.9      15.6 
    #> 6 11192176  Sterling Shepard  NYG   WR         4500    14.0      13.9 
    #> 7 11193143  Mohamed Sanu      ATL   WR         3800    11.4      12.9 
    #> 8 11193209  Eagles            PHI   DST        3000    10.8      11.5 
    #> 9 11192493  Hunter Henry      LAC   TE         2500     9.06      9.78
    #> 
    #> [[2]]
    #> # A tibble: 9 x 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II    LAR   RB         9300    26.5      26.6 
    #> 2 11191533  Antonio Brown     PIT   WR         8600    24.6      23.9 
    #> 3 11192002  Melvin Gordon III LAC   RB         6800    18.4      20.6 
    #> 4 11192767  Deshaun Watson    HOU   QB         6700    26.3      26.6 
    #> 5 11192038  Brandin Cooks     LAR   WR         5600    14.0      15.8 
    #> 6 11192176  Sterling Shepard  NYG   WR         4500    14.0      13.9 
    #> 7 11193209  Eagles            PHI   DST        3000    10.8      11.5 
    #> 8 11191868  Kapri Bibbs       WAS   RB         3000    13.6      12.6 
    #> 9 11192493  Hunter Henry      LAC   TE         2500     9.06      9.78
    #> 
    #> [[3]]
    #> # A tibble: 9 x 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II    LAR   RB         9300    26.5      26.6 
    #> 2 11191533  Antonio Brown     PIT   WR         8600    24.6      23.9 
    #> 3 11192002  Melvin Gordon III LAC   RB         6800    18.4      20.6 
    #> 4 11192767  Deshaun Watson    HOU   QB         6700    26.3      26.6 
    #> 5 11191861  Jarvis Landry     CLE   WR         5500    16.4      15.8 
    #> 6 11192176  Sterling Shepard  NYG   WR         4500    14.0      13.9 
    #> 7 11193209  Eagles            PHI   DST        3000    10.8      11.5 
    #> 8 11191868  Kapri Bibbs       WAS   RB         3000    13.6      12.6 
    #> 9 11192493  Hunter Henry      LAC   TE         2500     9.06      9.78

Write these results to a file. This file can be submitted directly to
the DFS
site.

``` r
write_lineups(results, "mylineups.csv", site = "draftkings", sport = "nfl")
```

    #>         QB       RB       RB       WR       WR       WR       TE     FLEX
    #> 1 11192767 11192002 11192254 11193143 11192176 11191533 11192493 11191680
    #> 2 11192767 11192002 11192254 11192038 11192176 11191533 11192493 11191868
    #> 3 11192767 11192002 11192254 11191861 11192176 11191533 11192493 11191868
    #>        DST
    #> 1 11193209
    #> 2 11193209
    #> 3 11193209

### Custom Models

You can now build custom models with the functions `model_generic()` and
`add_generic_positions_constraint()`. To start, define a generic model
by providing total salary allowed, roster size, and max number of
players per team allowed. We will use our NFL data from
above.

``` r
model <- model_generic(data, total_salary = 50000, roster_size = 9, max_from_team = 4)
```

Now we can provide custom position constraints. These will be in the
form of a named list, with FLEX or wildcard positions named with a
forward slash (`/`) between positions. In the example below, we have one
FLEX position that allows an RB, WR, or TE.

``` r
constraints <- list(
  "QB" = 1,
  "RB" = 2,
  "WR" = 3,
  "TE" = 1,
  "RB/WR/TE" = 1,
  "DST" = 1
)
model <- add_generic_positions_constraint(model, data, constraints)
```

These contraints are actually the same as the draftkings built-in model
above, so we should get the same results when we optimize:

``` r
optimize_generic(data, model, L = 3)
```

    #> [[1]]
    #> # A tibble: 9 x 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II    LAR   RB         9300    26.5      26.6 
    #> 2 11191533  Antonio Brown     PIT   WR         8600    24.6      23.9 
    #> 3 11192002  Melvin Gordon III LAC   RB         6800    18.4      20.6 
    #> 4 11192767  Deshaun Watson    HOU   QB         6700    26.3      26.6 
    #> 5 11191680  Chris Thompson    WAS   RB         4700    15.9      15.6 
    #> 6 11192176  Sterling Shepard  NYG   WR         4500    14.0      13.9 
    #> 7 11193143  Mohamed Sanu      ATL   WR         3800    11.4      12.9 
    #> 8 11193209  Eagles            PHI   DST        3000    10.8      11.5 
    #> 9 11192493  Hunter Henry      LAC   TE         2500     9.06      9.78
    #> 
    #> [[2]]
    #> # A tibble: 9 x 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II    LAR   RB         9300    26.5      26.6 
    #> 2 11191533  Antonio Brown     PIT   WR         8600    24.6      23.9 
    #> 3 11192002  Melvin Gordon III LAC   RB         6800    18.4      20.6 
    #> 4 11192767  Deshaun Watson    HOU   QB         6700    26.3      26.6 
    #> 5 11192038  Brandin Cooks     LAR   WR         5600    14.0      15.8 
    #> 6 11192176  Sterling Shepard  NYG   WR         4500    14.0      13.9 
    #> 7 11193209  Eagles            PHI   DST        3000    10.8      11.5 
    #> 8 11191868  Kapri Bibbs       WAS   RB         3000    13.6      12.6 
    #> 9 11192493  Hunter Henry      LAC   TE         2500     9.06      9.78
    #> 
    #> [[3]]
    #> # A tibble: 9 x 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II    LAR   RB         9300    26.5      26.6 
    #> 2 11191533  Antonio Brown     PIT   WR         8600    24.6      23.9 
    #> 3 11192002  Melvin Gordon III LAC   RB         6800    18.4      20.6 
    #> 4 11192767  Deshaun Watson    HOU   QB         6700    26.3      26.6 
    #> 5 11191861  Jarvis Landry     CLE   WR         5500    16.4      15.8 
    #> 6 11192176  Sterling Shepard  NYG   WR         4500    14.0      13.9 
    #> 7 11193209  Eagles            PHI   DST        3000    10.8      11.5 
    #> 8 11191868  Kapri Bibbs       WAS   RB         3000    13.6      12.6 
    #> 9 11192493  Hunter Henry      LAC   TE         2500     9.06      9.78
