
<!-- README.md is generated from README.Rmd. Please edit that file -->

# coach

<!-- badges: start -->

[![R-CMD-check](https://github.com/dfs-with-r/coach/workflows/R-CMD-check/badge.svg)](https://github.com/dfs-with-r/coach/actions)
[![Travis build
status](https://travis-ci.org/dfs-with-r/coach.svg?branch=master)](https://travis-ci.org/dfs-with-r/coach)
[![Coverage
status](https://codecov.io/gh/dfs-with-r/coach/branch/master/graph/badge.svg)](https://codecov.io/github/dfs-with-r/coach?branch=master)
<!-- badges: end -->

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

    #> # A tibble: 1,015 × 7
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
very important! If your projections aren’t good then your optimized
lineups won’t be good either. For this example we’ll just add some
random noise to the player’s season average fantasy points.

``` r
set.seed(100)
n <- nrow(data)
data$fpts_proj <- rnorm(n, data$fpts_avg)
print(data)
```

    #> # A tibble: 1,015 × 7
    #>    player_id player          team  position salary fpts_avg fpts_proj
    #>    <chr>     <chr>           <chr> <chr>     <int>    <dbl>     <dbl>
    #>  1 11191729  Le'Veon Bell    PIT   RB         9400     24.7      24.1
    #>  2 11192254  Todd Gurley II  LAR   RB         9300     26.5      28.1
    #>  3 11191754  David Johnson   ARI   RB         8800     14        14.4
    #>  4 11191533  Antonio Brown   PIT   WR         8600     24.6      25.3
    #>  5 11192632  Alvin Kamara    NO    RB         8500     19.9      19.6
    #>  6 11191840  DeAndre Hopkins HOU   WR         8300     21.7      21.2
    #>  7 11192079  Davante Adams   GB    WR         7800     16.1      16.1
    #>  8 11192140  Michael Thomas  NO    WR         7800     17.6      15.9
    #>  9 11192363  Ezekiel Elliott DAL   RB         7700     21.9      21.3
    #> 10 11193133  Julio Jones     ATL   WR         7600     17.3      15.2
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
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       28.1
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.3
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3       25.7
    #> 4 11192749  Tyreek Hill      KC    WR         6500    17.2       19.9
    #> 5 11191680  Chris Thompson   WAS   RB         4700    15.9       15.4
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       15.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       11.9
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       11.5
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      11.4
    #> 
    #> [[2]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       28.1
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.3
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3       25.7
    #> 4 11192749  Tyreek Hill      KC    WR         6500    17.2       19.9
    #> 5 11191624  Dion Lewis       TEN   RB         4900    13.6       14.7
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       15.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       11.9
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       11.5
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      11.4
    #> 
    #> [[3]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       28.1
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.3
    #> 3 11192749  Tyreek Hill      KC    WR         6500    17.2       19.9
    #> 4 11193094  Carson Wentz     PHI   QB         6400    23.4       24.9
    #> 5 11191680  Chris Thompson   WAS   RB         4700    15.9       15.4
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       15.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       11.9
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       11.5
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      11.4

Write these results to a file. This file can be submitted directly to
the DFS site.

``` r
write_lineups(results, "mylineups.csv", site = "draftkings", sport = "nfl")
```

    #>         QB       RB       RB       WR       WR       WR       TE     FLEX
    #> 1 11192767 11192254 11191868 11192749 11192176 11191533 11191619 11191680
    #> 2 11192767 11192254 11191624 11192749 11192176 11191533 11191619 11191868
    #> 3 11193094 11192254 11191868 11192749 11192176 11191533 11191619 11191680
    #>        DST
    #> 1 11191355
    #> 2 11191355
    #> 3 11191355

### Custom Models

You can now build custom models with the functions `model_generic()` and
`add_generic_positions_constraint()`. To start, define a generic model
by providing total salary allowed, roster size, and max number of
players per team allowed. We will use our NFL data from above.

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
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       28.1
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.3
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3       25.7
    #> 4 11192749  Tyreek Hill      KC    WR         6500    17.2       19.9
    #> 5 11191680  Chris Thompson   WAS   RB         4700    15.9       15.4
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       15.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       11.9
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       11.5
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      11.4
    #> 
    #> [[2]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       28.1
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.3
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3       25.7
    #> 4 11192749  Tyreek Hill      KC    WR         6500    17.2       19.9
    #> 5 11191624  Dion Lewis       TEN   RB         4900    13.6       14.7
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       15.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       11.9
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       11.5
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      11.4
    #> 
    #> [[3]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       28.1
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.3
    #> 3 11192749  Tyreek Hill      KC    WR         6500    17.2       19.9
    #> 4 11193094  Carson Wentz     PHI   QB         6400    23.4       24.9
    #> 5 11191680  Chris Thompson   WAS   RB         4700    15.9       15.4
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       15.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       11.9
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       11.5
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      11.4

### Max Exposure

Many times you want to limit the exposure of your lineups to certain
players (due to effects not captured in the model). You can do this by
setting a global `max_exposure` for every player to a constant:

``` r
optimize_generic(data, model, L = 5, max_exposure = 3/5)
```

    #> [[1]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       28.1
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.3
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3       25.7
    #> 4 11192749  Tyreek Hill      KC    WR         6500    17.2       19.9
    #> 5 11191680  Chris Thompson   WAS   RB         4700    15.9       15.4
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       15.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       11.9
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       11.5
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      11.4
    #> 
    #> [[2]]
    #> # A tibble: 9 × 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192722  Leonard Fournette JAX   RB         7100     19.2      19.4
    #> 2 11192543  Kareem Hunt       KC    RB         6900     19.3      20.5
    #> 3 11191538  Travis Kelce      KC    TE         6400     16.4      17.0
    #> 4 11193094  Carson Wentz      PHI   QB         6400     23.4      24.9
    #> 5 11191493  LeSean McCoy      BUF   RB         6000     17.3      17.7
    #> 6 11191861  Jarvis Landry     CLE   WR         5500     16.4      16.6
    #> 7 11191401  Danny Amendola    MIA   WR         4200     11.5      12.9
    #> 8 11193143  Mohamed Sanu      ATL   WR         3800     11.4      12.0
    #> 9 11191361  Jaguars           JAX   DST        3700     12.3      12.4
    #> 
    #> [[3]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       28.1
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.3
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3       25.7
    #> 4 11192749  Tyreek Hill      KC    WR         6500    17.2       19.9
    #> 5 11191624  Dion Lewis       TEN   RB         4900    13.6       14.7
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       15.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       11.9
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       11.5
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      11.4
    #> 
    #> [[4]]
    #> # A tibble: 9 × 7
    #>   player_id player          team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>           <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191840  DeAndre Hopkins HOU   WR         8300    21.7      21.2 
    #> 2 11192363  Ezekiel Elliott DAL   RB         7700    21.9      21.3 
    #> 3 11192543  Kareem Hunt     KC    RB         6900    19.3      20.5 
    #> 4 11193094  Carson Wentz    PHI   QB         6400    23.4      24.9 
    #> 5 11191861  Jarvis Landry   CLE   WR         5500    16.4      16.6 
    #> 6 11191680  Chris Thompson  WAS   RB         4700    15.9      15.4 
    #> 7 11193143  Mohamed Sanu    ATL   WR         3800    11.4      12.0 
    #> 8 11191361  Jaguars         JAX   DST        3700    12.3      12.4 
    #> 9 11191758  Cameron Brate   TB    TE         3000     8.94      9.82
    #> 
    #> [[5]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       28.1
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.3
    #> 3 11192749  Tyreek Hill      KC    WR         6500    17.2       19.9
    #> 4 11193094  Carson Wentz     PHI   QB         6400    23.4       24.9
    #> 5 11191680  Chris Thompson   WAS   RB         4700    15.9       15.4
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       15.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       11.9
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       11.5
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      11.4

You can also provide a vector of individual `max_exposure` for every
player. I find it is typically easiest to add a column to your data
frame that defaults to a global value except for a few specific
instances:

``` r
library(dplyr)

data <- data %>% mutate(
  exposure = case_when(
    player == "LeSean McCoy" ~ 0.4,
    player == "Deshaun Watson" ~ 0.5,
    player == "Alex Smith" ~ 0.2,
    TRUE ~ 1
  )
)
```

You can then reference this column in the optimizer:

``` r
optimize_generic(data, model, L = 5, max_exposure = data$exposure)
```

    #> [[1]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       28.1
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.3
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3       25.7
    #> 4 11192749  Tyreek Hill      KC    WR         6500    17.2       19.9
    #> 5 11191680  Chris Thompson   WAS   RB         4700    15.9       15.4
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       15.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       11.9
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       11.5
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      11.4
    #> 
    #> [[2]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       28.1
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.3
    #> 3 11192749  Tyreek Hill      KC    WR         6500    17.2       19.9
    #> 4 11193094  Carson Wentz     PHI   QB         6400    23.4       24.9
    #> 5 11191680  Chris Thompson   WAS   RB         4700    15.9       15.4
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       15.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       11.9
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       11.5
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      11.4
    #> 
    #> [[3]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       28.1
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.3
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3       25.7
    #> 4 11192749  Tyreek Hill      KC    WR         6500    17.2       19.9
    #> 5 11191624  Dion Lewis       TEN   RB         4900    13.6       14.7
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       15.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       11.9
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       11.5
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      11.4
    #> 
    #> [[4]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       28.1
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.3
    #> 3 11193094  Carson Wentz     PHI   QB         6400    23.4       24.9
    #> 4 11191861  Jarvis Landry    CLE   WR         5500    16.4       16.6
    #> 5 11191680  Chris Thompson   WAS   RB         4700    15.9       15.4
    #> 6 11191735  Carlos Hyde      CLE   RB         4500    14.9       14.6
    #> 7 11192176  Sterling Shepard NYG   WR         4500    14.0       15.0
    #> 8 11191619  Jack Doyle       IND   TE         3600    11.6       11.9
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      11.4
    #> 
    #> [[5]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       28.1
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.3
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3       25.7
    #> 4 11192749  Tyreek Hill      KC    WR         6500    17.2       19.9
    #> 5 11191735  Carlos Hyde      CLE   RB         4500    14.9       14.6
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       15.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       11.9
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       11.5
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      11.4

### Adding Randomness to Projections

You can also now add randomness to your projections by providing a
function. This function will run on `fpts_proj` before each lineup is
generated. For example, to generate projections that are randomly
distributed around a center value with a standard deviation of 10 you
could do this:

``` r
n <- nrow(data)
randomness <- function(x) rnorm(n, x, 10)
```

When you generate the lineups you can see how the `fpts_proj` changes
between samples.

``` r
optimize_generic(data, model, L = 5, randomness = randomness)
```

    #> [[1]]
    #> # A tibble: 9 × 7
    #>   player_id player              team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>               <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II      LAR   RB         9300    26.5       32.7
    #> 2 11191859  Odell Beckham Jr.   NYG   WR         7000    18.5       37.4
    #> 3 11191395  Philip Rivers       LAC   QB         6400    18.7       39.2
    #> 4 11191384  Jordy Nelson        OAK   WR         5100     9.15      34.6
    #> 5 11192997  Chris Carson        SEA   RB         4500     9.92      33.9
    #> 6 11191350  Saints              NO    DST        3600     8.67      28.6
    #> 7 11192048  J.D. McKissic       SEA   RB         3400     7.48      33.3
    #> 8 11192962  Ray-Ray McCloud III BUF   WR         3000     0         46.8
    #> 9 11191733  A.J. Derby          MIA   TE         2500     5.13      29.6
    #> 
    #> [[2]]
    #> # A tibble: 9 × 7
    #>   player_id player          team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>           <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II  LAR   RB         9300    26.5       30.3
    #> 2 11191533  Antonio Brown   PIT   WR         8600    24.6       39.3
    #> 3 11191840  DeAndre Hopkins HOU   WR         8300    21.7       43.2
    #> 4 11192917  DeShone Kizer   GB    QB         4500    13.8       40.2
    #> 5 11191678  Theo Riddick    DET   RB         4200     9.69      29.8
    #> 6 11191928  Martavis Bryant OAK   WR         4200     9.27      40.5
    #> 7 11192380  O.J. Howard     TB    TE         3100     7.37      29.0
    #> 8 11191490  Deonte Thompson DAL   WR         3000     6.66      31.7
    #> 9 11191358  Buccaneers      TB    DST        2000     6.75      26.9
    #> 
    #> [[3]]
    #> # A tibble: 9 × 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191811  Keenan Allen      LAC   WR         7500    19.1       45.3
    #> 2 11192722  Leonard Fournette JAX   RB         7100    19.2       50.3
    #> 3 11192387  Adam Thielen      MIN   WR         6900    15.2       36.4
    #> 4 11191538  Travis Kelce      KC    TE         6400    16.4       32.3
    #> 5 11191395  Philip Rivers     LAC   QB         6400    18.7       40.0
    #> 6 11192276  Devin Funchess    CAR   WR         5200    12.4       38.8
    #> 7 11192401  Trent Taylor      SF    WR         3600     6.47      31.0
    #> 8 11191357  Seahawks          SEA   DST        3100     8.88      25.8
    #> 9 11192339  Justin Davis      LAR   RB         3000     0.02      31.3
    #> 
    #> [[4]]
    #> # A tibble: 9 × 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191729  Le'Veon Bell      PIT   RB         9400    24.7       36.9
    #> 2 11192363  Ezekiel Elliott   DAL   RB         7700    21.9       44.7
    #> 3 11191859  Odell Beckham Jr. NYG   WR         7000    18.5       30.5
    #> 4 11191463  Demaryius Thomas  DEN   WR         5700    13.1       33.5
    #> 5 11192302  Cooper Kupp       LAR   WR         5200    12.8       29.2
    #> 6 11191741  Giovani Bernard   CIN   RB         4400     9.67      37.2
    #> 7 11192200  C.J. Beathard     SF    QB         4400    13.8       39.9
    #> 8 11191350  Saints            NO    DST        3600     8.67      35.0
    #> 9 11193036  Moritz Boehringer CIN   TE         2500     0         31.7
    #> 
    #> [[5]]
    #> # A tibble: 9 × 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II    LAR   RB         9300    26.5       44.1
    #> 2 11191859  Odell Beckham Jr. NYG   WR         7000    18.5       33.5
    #> 3 11192002  Melvin Gordon III LAC   RB         6800    18.4       36.3
    #> 4 11191364  Drew Brees        NO    QB         6800    18.1       35.9
    #> 5 11191500  Doug Baldwin      SEA   WR         6200    14.3       31.7
    #> 6 11191911  Ty Montgomery     GB    RB         3700    11.4       29.4
    #> 7 11191340  Lions             DET   DST        3400     9.94      28.3
    #> 8 11193179  Darius Prince     PHI   WR         3000     0         31.4
    #> 9 11191758  Cameron Brate     TB    TE         3000     8.94      31.7
