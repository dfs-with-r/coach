
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
    #>  1 11191729  Le'Veon Bell    PIT   RB         9400     24.7      23.5
    #>  2 11192254  Todd Gurley II  LAR   RB         9300     26.5      26.3
    #>  3 11191754  David Johnson   ARI   RB         8800     14        13.7
    #>  4 11191533  Antonio Brown   PIT   WR         8600     24.6      25.2
    #>  5 11192632  Alvin Kamara    NO    RB         8500     19.9      21.5
    #>  6 11191840  DeAndre Hopkins HOU   WR         8300     21.7      21.3
    #>  7 11192079  Davante Adams   GB    WR         7800     16.1      17.6
    #>  8 11192140  Michael Thomas  NO    WR         7800     17.6      17.5
    #>  9 11192363  Ezekiel Elliott DAL   RB         7700     21.9      23.9
    #> 10 11193133  Julio Jones     ATL   WR         7600     17.3      17.9
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
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       26.3
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.2
    #> 3 11192363  Ezekiel Elliott  DAL   RB         7700    21.9       23.9
    #> 4 11192767  Deshaun Watson   HOU   QB         6700    26.3       27.5
    #> 5 11192176  Sterling Shepard NYG   WR         4500    14.0       14.0
    #> 6 11193143  Mohamed Sanu     ATL   WR         3800    11.4       12.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       13.2
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       14.4
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      12.4
    #> 
    #> [[2]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown    PIT   WR         8600    24.6       25.2
    #> 2 11192363  Ezekiel Elliott  DAL   RB         7700    21.9       23.9
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3       27.5
    #> 4 11192749  Tyreek Hill      KC    WR         6500    17.2       18.4
    #> 5 11192758  Dalvin Cook      MIN   RB         6200    17.4       19.2
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       14.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       13.2
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       14.4
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      12.4
    #> 
    #> [[3]]
    #> # A tibble: 9 x 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown     PIT   WR         8600    24.6       25.2
    #> 2 11192363  Ezekiel Elliott   DAL   RB         7700    21.9       23.9
    #> 3 11192722  Leonard Fournette JAX   RB         7100    19.2       20.7
    #> 4 11192767  Deshaun Watson    HOU   QB         6700    26.3       27.5
    #> 5 11192749  Tyreek Hill       KC    WR         6500    17.2       18.4
    #> 6 11193143  Mohamed Sanu      ATL   WR         3800    11.4       12.0
    #> 7 11191619  Jack Doyle        IND   TE         3600    11.6       13.2
    #> 8 11191868  Kapri Bibbs       WAS   RB         3000    13.6       14.4
    #> 9 11191355  Chargers          LAC   DST        2800     9.94      12.4

Write these results to a file. This file can be submitted directly to
the DFS
site.

``` r
write_lineups(results, "mylineups.csv", site = "draftkings", sport = "nfl")
```

    #>         QB       RB       RB       WR       WR       WR       TE     FLEX
    #> 1 11192767 11192363 11192254 11193143 11192176 11191533 11191619 11191868
    #> 2 11192767 11192363 11192758 11192749 11192176 11191533 11191619 11191868
    #> 3 11192767 11192363 11192722 11193143 11192749 11191533 11191619 11191868
    #>        DST
    #> 1 11191355
    #> 2 11191355
    #> 3 11191355

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
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       26.3
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.2
    #> 3 11192363  Ezekiel Elliott  DAL   RB         7700    21.9       23.9
    #> 4 11192767  Deshaun Watson   HOU   QB         6700    26.3       27.5
    #> 5 11192176  Sterling Shepard NYG   WR         4500    14.0       14.0
    #> 6 11193143  Mohamed Sanu     ATL   WR         3800    11.4       12.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       13.2
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       14.4
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      12.4
    #> 
    #> [[2]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown    PIT   WR         8600    24.6       25.2
    #> 2 11192363  Ezekiel Elliott  DAL   RB         7700    21.9       23.9
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3       27.5
    #> 4 11192749  Tyreek Hill      KC    WR         6500    17.2       18.4
    #> 5 11192758  Dalvin Cook      MIN   RB         6200    17.4       19.2
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       14.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       13.2
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       14.4
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      12.4
    #> 
    #> [[3]]
    #> # A tibble: 9 x 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown     PIT   WR         8600    24.6       25.2
    #> 2 11192363  Ezekiel Elliott   DAL   RB         7700    21.9       23.9
    #> 3 11192722  Leonard Fournette JAX   RB         7100    19.2       20.7
    #> 4 11192767  Deshaun Watson    HOU   QB         6700    26.3       27.5
    #> 5 11192749  Tyreek Hill       KC    WR         6500    17.2       18.4
    #> 6 11193143  Mohamed Sanu      ATL   WR         3800    11.4       12.0
    #> 7 11191619  Jack Doyle        IND   TE         3600    11.6       13.2
    #> 8 11191868  Kapri Bibbs       WAS   RB         3000    13.6       14.4
    #> 9 11191355  Chargers          LAC   DST        2800     9.94      12.4

### Max Exposure

Many times you want to limit the exposure of your lineups to certain
players (due to effects not captured in the model). You can do this by
setting a global `max_exposure` for every player to a constant:

``` r
optimize_generic(data, model, L = 5, max_exposure = 3/5)
```

    #> [[1]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       26.3
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.2
    #> 3 11192363  Ezekiel Elliott  DAL   RB         7700    21.9       23.9
    #> 4 11192767  Deshaun Watson   HOU   QB         6700    26.3       27.5
    #> 5 11192176  Sterling Shepard NYG   WR         4500    14.0       14.0
    #> 6 11193143  Mohamed Sanu     ATL   WR         3800    11.4       12.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       13.2
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       14.4
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      12.4
    #> 
    #> [[2]]
    #> # A tibble: 9 x 7
    #>   player_id player          team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>           <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191840  DeAndre Hopkins HOU   WR         8300    21.7      21.3 
    #> 2 11192543  Kareem Hunt     KC    RB         6900    19.3      20.5 
    #> 3 11192749  Tyreek Hill     KC    WR         6500    17.2      18.4 
    #> 4 11193094  Carson Wentz    PHI   QB         6400    23.4      24.0 
    #> 5 11192758  Dalvin Cook     MIN   RB         6200    17.4      19.2 
    #> 6 11191493  LeSean McCoy    BUF   RB         6000    17.3      18.5 
    #> 7 11191401  Danny Amendola  MIA   WR         4200    11.5      11.5 
    #> 8 11193209  Eagles          PHI   DST        3000    10.8      11.1 
    #> 9 11192493  Hunter Henry    LAC   TE         2500     9.06      8.63
    #> 
    #> [[3]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown    PIT   WR         8600    24.6       25.2
    #> 2 11192363  Ezekiel Elliott  DAL   RB         7700    21.9       23.9
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3       27.5
    #> 4 11192749  Tyreek Hill      KC    WR         6500    17.2       18.4
    #> 5 11192758  Dalvin Cook      MIN   RB         6200    17.4       19.2
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       14.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       13.2
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       14.4
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      12.4
    #> 
    #> [[4]]
    #> # A tibble: 9 x 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II    LAR   RB         9300    26.5       26.3
    #> 2 11191859  Odell Beckham Jr. NYG   WR         7000    18.5       18.2
    #> 3 11192543  Kareem Hunt       KC    RB         6900    19.3       20.5
    #> 4 11193094  Carson Wentz      PHI   QB         6400    23.4       24.0
    #> 5 11191493  LeSean McCoy      BUF   RB         6000    17.3       18.5
    #> 6 11191399  Ted Ginn Jr.      NO    WR         4300    12.0       12.1
    #> 7 11193143  Mohamed Sanu      ATL   WR         3800    11.4       12.0
    #> 8 11191985  Eric Ebron        IND   TE         3300     8.34      10.3
    #> 9 11193209  Eagles            PHI   DST        3000    10.8       11.1
    #> 
    #> [[5]]
    #> # A tibble: 9 x 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown     PIT   WR         8600    24.6       25.2
    #> 2 11192363  Ezekiel Elliott   DAL   RB         7700    21.9       23.9
    #> 3 11192722  Leonard Fournette JAX   RB         7100    19.2       20.7
    #> 4 11192767  Deshaun Watson    HOU   QB         6700    26.3       27.5
    #> 5 11192749  Tyreek Hill       KC    WR         6500    17.2       18.4
    #> 6 11193143  Mohamed Sanu      ATL   WR         3800    11.4       12.0
    #> 7 11191619  Jack Doyle        IND   TE         3600    11.6       13.2
    #> 8 11191868  Kapri Bibbs       WAS   RB         3000    13.6       14.4
    #> 9 11191355  Chargers          LAC   DST        2800     9.94      12.4

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
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       26.3
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.2
    #> 3 11192363  Ezekiel Elliott  DAL   RB         7700    21.9       23.9
    #> 4 11192767  Deshaun Watson   HOU   QB         6700    26.3       27.5
    #> 5 11192176  Sterling Shepard NYG   WR         4500    14.0       14.0
    #> 6 11193143  Mohamed Sanu     ATL   WR         3800    11.4       12.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       13.2
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       14.4
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      12.4
    #> 
    #> [[2]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown    PIT   WR         8600    24.6       25.2
    #> 2 11192363  Ezekiel Elliott  DAL   RB         7700    21.9       23.9
    #> 3 11192543  Kareem Hunt      KC    RB         6900    19.3       20.5
    #> 4 11192749  Tyreek Hill      KC    WR         6500    17.2       18.4
    #> 5 11193094  Carson Wentz     PHI   QB         6400    23.4       24.0
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       14.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       13.2
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       14.4
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      12.4
    #> 
    #> [[3]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown    PIT   WR         8600    24.6       25.2
    #> 2 11192363  Ezekiel Elliott  DAL   RB         7700    21.9       23.9
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3       27.5
    #> 4 11192749  Tyreek Hill      KC    WR         6500    17.2       18.4
    #> 5 11192758  Dalvin Cook      MIN   RB         6200    17.4       19.2
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       14.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       13.2
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       14.4
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      12.4
    #> 
    #> [[4]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       26.3
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.2
    #> 3 11192363  Ezekiel Elliott  DAL   RB         7700    21.9       23.9
    #> 4 11193094  Carson Wentz     PHI   QB         6400    23.4       24.0
    #> 5 11192176  Sterling Shepard NYG   WR         4500    14.0       14.0
    #> 6 11193143  Mohamed Sanu     ATL   WR         3800    11.4       12.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       13.2
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       14.4
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      12.4
    #> 
    #> [[5]]
    #> # A tibble: 9 x 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown     PIT   WR         8600    24.6       25.2
    #> 2 11192363  Ezekiel Elliott   DAL   RB         7700    21.9       23.9
    #> 3 11192722  Leonard Fournette JAX   RB         7100    19.2       20.7
    #> 4 11192767  Deshaun Watson    HOU   QB         6700    26.3       27.5
    #> 5 11192749  Tyreek Hill       KC    WR         6500    17.2       18.4
    #> 6 11193143  Mohamed Sanu      ATL   WR         3800    11.4       12.0
    #> 7 11191619  Jack Doyle        IND   TE         3600    11.6       13.2
    #> 8 11191868  Kapri Bibbs       WAS   RB         3000    13.6       14.4
    #> 9 11191355  Chargers          LAC   DST        2800     9.94      12.4

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
    #> # A tibble: 9 x 7
    #>   player_id player                 team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>                  <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II         LAR   RB         9300    26.5       33.6
    #> 2 11192387  Adam Thielen           MIN   WR         6900    15.2       40.4
    #> 3 11192767  Deshaun Watson         HOU   QB         6700    26.3       35.7
    #> 4 11192050  Robby Anderson         NYJ   WR         5700    13.1       36.4
    #> 5 11191735  Carlos Hyde            CLE   RB         4500    14.9       36.1
    #> 6 11191559  Brice Butler           ARI   WR         3600     4.98      36.7
    #> 7 11191890  Austin Seferian-Jenki… JAX   TE         3200     7.9       29.6
    #> 8 11192040  Jamaal Jones           CAR   WR         3000     0         32.8
    #> 9 11193209  Eagles                 PHI   DST        3000    10.8       25.0
    #> 
    #> [[2]]
    #> # A tibble: 9 x 7
    #>   player_id player              team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>               <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192387  Adam Thielen        MIN   WR         6900    15.2       46.4
    #> 2 11192035  Marcus Mariota      TEN   QB         6300    16.6       47.0
    #> 3 11193135  Alshon Jeffery      PHI   WR         6000    12.9       58.0
    #> 4 11191674  Lamar Miller        HOU   RB         5200    12.1       40.9
    #> 5 11191735  Carlos Hyde         CLE   RB         4500    14.9       38.6
    #> 6 11192997  Chris Carson        SEA   RB         4500     9.92      38.6
    #> 7 11191559  Brice Butler        ARI   WR         3600     4.98      51.8
    #> 8 11193209  Eagles              PHI   DST        3000    10.8       41.8
    #> 9 11192076  Henry Krieger-Coble LAR   TE         2500     0         38.0
    #> 
    #> [[3]]
    #> # A tibble: 9 x 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191859  Odell Beckham Jr. NYG   WR         7000    18.5       50.9
    #> 2 11193094  Carson Wentz      PHI   QB         6400    23.4       43.3
    #> 3 11193135  Alshon Jeffery    PHI   WR         6000    12.9       64.3
    #> 4 11191680  Chris Thompson    WAS   RB         4700    15.9       47.6
    #> 5 11191735  Carlos Hyde       CLE   RB         4500    14.9       47.6
    #> 6 11191559  Brice Butler      ARI   WR         3600     4.98      50.4
    #> 7 11193209  Eagles            PHI   DST        3000    10.8       39.9
    #> 8 11192712  Jarvion Franklin  PIT   RB         3000     0         48.8
    #> 9 11192326  Mo Alie-Cox       IND   TE         2500     0         42.5
    #> 
    #> [[4]]
    #> # A tibble: 9 x 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191859  Odell Beckham Jr. NYG   WR         7000    18.5       56.5
    #> 2 11192767  Deshaun Watson    HOU   QB         6700    26.3       53.0
    #> 3 11192376  Corey Davis       TEN   WR         5600     7.79      56.6
    #> 4 11191680  Chris Thompson    WAS   RB         4700    15.9       51.4
    #> 5 11191735  Carlos Hyde       CLE   RB         4500    14.9       58.7
    #> 6 11191559  Brice Butler      ARI   WR         3600     4.98      59.3
    #> 7 11191333  Bills             BUF   DST        3000     6.47      49.5
    #> 8 11192712  Jarvion Franklin  PIT   RB         3000     0         52.4
    #> 9 11192326  Mo Alie-Cox       IND   TE         2500     0         61.3
    #> 
    #> [[5]]
    #> # A tibble: 9 x 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192387  Adam Thielen   MIN   WR         6900    15.2       58.6
    #> 2 11192376  Corey Davis    TEN   WR         5600     7.79      73.1
    #> 3 11191680  Chris Thompson WAS   RB         4700    15.9       63.6
    #> 4 11191735  Carlos Hyde    CLE   RB         4500    14.9       63.6
    #> 5 11191950  Brandon Allen  LAR   QB         4000     0         64.9
    #> 6 11191559  Brice Butler   ARI   WR         3600     4.98      66.8
    #> 7 11193209  Eagles         PHI   DST        3000    10.8       31.3
    #> 8 11192304  Lenard Tillery TEN   RB         3000     0         67.5
    #> 9 11192326  Mo Alie-Cox    IND   TE         2500     0         77.2
