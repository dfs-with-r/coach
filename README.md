
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
    #>  1 11191729  Le'Veon Bell    PIT   RB         9400     24.7      24.6
    #>  2 11192254  Todd Gurley II  LAR   RB         9300     26.5      24.7
    #>  3 11191754  David Johnson   ARI   RB         8800     14        14.0
    #>  4 11191533  Antonio Brown   PIT   WR         8600     24.6      25.3
    #>  5 11192632  Alvin Kamara    NO    RB         8500     19.9      20.6
    #>  6 11191840  DeAndre Hopkins HOU   WR         8300     21.7      21.5
    #>  7 11192079  Davante Adams   GB    WR         7800     16.1      15.5
    #>  8 11192140  Michael Thomas  NO    WR         7800     17.6      17.6
    #>  9 11192363  Ezekiel Elliott DAL   RB         7700     21.9      19.8
    #> 10 11193133  Julio Jones     ATL   WR         7600     17.3      16.9
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
    #> 1 11191533  Antonio Brown    PIT   WR         8600     24.6      25.3
    #> 2 11191840  DeAndre Hopkins  HOU   WR         8300     21.7      21.5
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      26.3
    #> 4 11191393  Larry Fitzgerald ARI   WR         6600     17.2      20.1
    #> 5 11191680  Chris Thompson   WAS   RB         4700     15.9      16.8
    #> 6 11191735  Carlos Hyde      CLE   RB         4500     14.9      15.8
    #> 7 11191361  Jaguars          JAX   DST        3700     12.3      13.2
    #> 8 11191619  Jack Doyle       IND   TE         3600     11.6      12.5
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      13.2
    #> 
    #> [[2]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown    PIT   WR         8600     24.6      25.3
    #> 2 11191811  Keenan Allen     LAC   WR         7500     19.1      20.3
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      26.3
    #> 4 11191393  Larry Fitzgerald ARI   WR         6600     17.2      20.1
    #> 5 11191547  Mark Ingram      NO    RB         5700     16.7      17.9
    #> 6 11191735  Carlos Hyde      CLE   RB         4500     14.9      15.8
    #> 7 11191361  Jaguars          JAX   DST        3700     12.3      13.2
    #> 8 11191619  Jack Doyle       IND   TE         3600     11.6      12.5
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      13.2
    #> 
    #> [[3]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown    PIT   WR         8600     24.6      25.3
    #> 2 11192543  Kareem Hunt      KC    RB         6900     19.3      20.3
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      26.3
    #> 4 11191393  Larry Fitzgerald ARI   WR         6600     17.2      20.1
    #> 5 11191680  Chris Thompson   WAS   RB         4700     15.9      16.8
    #> 6 11191735  Carlos Hyde      CLE   RB         4500     14.9      15.8
    #> 7 11192176  Sterling Shepard NYG   WR         4500     14.0      14.1
    #> 8 11191361  Jaguars          JAX   DST        3700     12.3      13.2
    #> 9 11191619  Jack Doyle       IND   TE         3600     11.6      12.5

Write these results to a file. This file can be submitted directly to
the DFS
site.

``` r
write_lineups(results, "mylineups.csv", site = "draftkings", sport = "nfl")
```

    #>         QB       RB       RB       WR       WR       WR       TE     FLEX
    #> 1 11192767 11191735 11191868 11191393 11191840 11191533 11191619 11191680
    #> 2 11192767 11191735 11191547 11191393 11191811 11191533 11191619 11191868
    #> 3 11192767 11191735 11192543 11191393 11192176 11191533 11191619 11191680
    #>        DST
    #> 1 11191361
    #> 2 11191361
    #> 3 11191361

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
    #> 1 11191533  Antonio Brown    PIT   WR         8600     24.6      25.3
    #> 2 11191840  DeAndre Hopkins  HOU   WR         8300     21.7      21.5
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      26.3
    #> 4 11191393  Larry Fitzgerald ARI   WR         6600     17.2      20.1
    #> 5 11191680  Chris Thompson   WAS   RB         4700     15.9      16.8
    #> 6 11191735  Carlos Hyde      CLE   RB         4500     14.9      15.8
    #> 7 11191361  Jaguars          JAX   DST        3700     12.3      13.2
    #> 8 11191619  Jack Doyle       IND   TE         3600     11.6      12.5
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      13.2
    #> 
    #> [[2]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown    PIT   WR         8600     24.6      25.3
    #> 2 11191811  Keenan Allen     LAC   WR         7500     19.1      20.3
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      26.3
    #> 4 11191393  Larry Fitzgerald ARI   WR         6600     17.2      20.1
    #> 5 11191547  Mark Ingram      NO    RB         5700     16.7      17.9
    #> 6 11191735  Carlos Hyde      CLE   RB         4500     14.9      15.8
    #> 7 11191361  Jaguars          JAX   DST        3700     12.3      13.2
    #> 8 11191619  Jack Doyle       IND   TE         3600     11.6      12.5
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      13.2
    #> 
    #> [[3]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown    PIT   WR         8600     24.6      25.3
    #> 2 11192543  Kareem Hunt      KC    RB         6900     19.3      20.3
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      26.3
    #> 4 11191393  Larry Fitzgerald ARI   WR         6600     17.2      20.1
    #> 5 11191680  Chris Thompson   WAS   RB         4700     15.9      16.8
    #> 6 11191735  Carlos Hyde      CLE   RB         4500     14.9      15.8
    #> 7 11192176  Sterling Shepard NYG   WR         4500     14.0      14.1
    #> 8 11191361  Jaguars          JAX   DST        3700     12.3      13.2
    #> 9 11191619  Jack Doyle       IND   TE         3600     11.6      12.5

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
    #> 1 11191533  Antonio Brown    PIT   WR         8600     24.6      25.3
    #> 2 11191840  DeAndre Hopkins  HOU   WR         8300     21.7      21.5
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      26.3
    #> 4 11191393  Larry Fitzgerald ARI   WR         6600     17.2      20.1
    #> 5 11191680  Chris Thompson   WAS   RB         4700     15.9      16.8
    #> 6 11191735  Carlos Hyde      CLE   RB         4500     14.9      15.8
    #> 7 11191361  Jaguars          JAX   DST        3700     12.3      13.2
    #> 8 11191619  Jack Doyle       IND   TE         3600     11.6      12.5
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      13.2
    #> 
    #> [[2]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191811  Keenan Allen     LAC   WR         7500    19.1      20.3 
    #> 2 11192543  Kareem Hunt      KC    RB         6900    19.3      20.3 
    #> 3 11192749  Tyreek Hill      KC    WR         6500    17.2      17.2 
    #> 4 11193094  Carson Wentz     PHI   QB         6400    23.4      23.2 
    #> 5 11191493  LeSean McCoy     BUF   RB         6000    17.3      18.4 
    #> 6 11191547  Mark Ingram      NO    RB         5700    16.7      17.9 
    #> 7 11192176  Sterling Shepard NYG   WR         4500    14.0      14.1 
    #> 8 11191340  Lions            DET   DST        3400     9.94     11.8 
    #> 9 11191397  Benjamin Watson  NO    TE         3100     8.58      9.83
    #> 
    #> [[3]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown    PIT   WR         8600     24.6      25.3
    #> 2 11191811  Keenan Allen     LAC   WR         7500     19.1      20.3
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      26.3
    #> 4 11191393  Larry Fitzgerald ARI   WR         6600     17.2      20.1
    #> 5 11191547  Mark Ingram      NO    RB         5700     16.7      17.9
    #> 6 11191735  Carlos Hyde      CLE   RB         4500     14.9      15.8
    #> 7 11191361  Jaguars          JAX   DST        3700     12.3      13.2
    #> 8 11191619  Jack Doyle       IND   TE         3600     11.6      12.5
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      13.2
    #> 
    #> [[4]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192543  Kareem Hunt      KC    RB         6900     19.3      20.3
    #> 2 11192749  Tyreek Hill      KC    WR         6500     17.2      17.2
    #> 3 11191538  Travis Kelce     KC    TE         6400     16.4      16.7
    #> 4 11193094  Carson Wentz     PHI   QB         6400     23.4      23.2
    #> 5 11191493  LeSean McCoy     BUF   RB         6000     17.3      18.4
    #> 6 11191861  Jarvis Landry    CLE   WR         5500     16.4      15.9
    #> 7 11191680  Chris Thompson   WAS   RB         4700     15.9      16.8
    #> 8 11192176  Sterling Shepard NYG   WR         4500     14.0      14.1
    #> 9 11193209  Eagles           PHI   DST        3000     10.8      11.0
    #> 
    #> [[5]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown    PIT   WR         8600     24.6      25.3
    #> 2 11192543  Kareem Hunt      KC    RB         6900     19.3      20.3
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      26.3
    #> 4 11191393  Larry Fitzgerald ARI   WR         6600     17.2      20.1
    #> 5 11191680  Chris Thompson   WAS   RB         4700     15.9      16.8
    #> 6 11191735  Carlos Hyde      CLE   RB         4500     14.9      15.8
    #> 7 11192176  Sterling Shepard NYG   WR         4500     14.0      14.1
    #> 8 11191361  Jaguars          JAX   DST        3700     12.3      13.2
    #> 9 11191619  Jack Doyle       IND   TE         3600     11.6      12.5

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
    #> 1 11191533  Antonio Brown    PIT   WR         8600     24.6      25.3
    #> 2 11191840  DeAndre Hopkins  HOU   WR         8300     21.7      21.5
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      26.3
    #> 4 11191393  Larry Fitzgerald ARI   WR         6600     17.2      20.1
    #> 5 11191680  Chris Thompson   WAS   RB         4700     15.9      16.8
    #> 6 11191735  Carlos Hyde      CLE   RB         4500     14.9      15.8
    #> 7 11191361  Jaguars          JAX   DST        3700     12.3      13.2
    #> 8 11191619  Jack Doyle       IND   TE         3600     11.6      12.5
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      13.2
    #> 
    #> [[2]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown    PIT   WR         8600     24.6      25.3
    #> 2 11191811  Keenan Allen     LAC   WR         7500     19.1      20.3
    #> 3 11191393  Larry Fitzgerald ARI   WR         6600     17.2      20.1
    #> 4 11193094  Carson Wentz     PHI   QB         6400     23.4      23.2
    #> 5 11191547  Mark Ingram      NO    RB         5700     16.7      17.9
    #> 6 11191680  Chris Thompson   WAS   RB         4700     15.9      16.8
    #> 7 11191361  Jaguars          JAX   DST        3700     12.3      13.2
    #> 8 11191619  Jack Doyle       IND   TE         3600     11.6      12.5
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      13.2
    #> 
    #> [[3]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown    PIT   WR         8600     24.6      25.3
    #> 2 11191811  Keenan Allen     LAC   WR         7500     19.1      20.3
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      26.3
    #> 4 11191393  Larry Fitzgerald ARI   WR         6600     17.2      20.1
    #> 5 11191547  Mark Ingram      NO    RB         5700     16.7      17.9
    #> 6 11191735  Carlos Hyde      CLE   RB         4500     14.9      15.8
    #> 7 11191361  Jaguars          JAX   DST        3700     12.3      13.2
    #> 8 11191619  Jack Doyle       IND   TE         3600     11.6      12.5
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      13.2
    #> 
    #> [[4]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown    PIT   WR         8600     24.6      25.3
    #> 2 11191811  Keenan Allen     LAC   WR         7500     19.1      20.3
    #> 3 11191393  Larry Fitzgerald ARI   WR         6600     17.2      20.1
    #> 4 11193094  Carson Wentz     PHI   QB         6400     23.4      23.2
    #> 5 11191493  LeSean McCoy     BUF   RB         6000     17.3      18.4
    #> 6 11191735  Carlos Hyde      CLE   RB         4500     14.9      15.8
    #> 7 11191361  Jaguars          JAX   DST        3700     12.3      13.2
    #> 8 11191619  Jack Doyle       IND   TE         3600     11.6      12.5
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      13.2
    #> 
    #> [[5]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown    PIT   WR         8600     24.6      25.3
    #> 2 11192543  Kareem Hunt      KC    RB         6900     19.3      20.3
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      26.3
    #> 4 11191393  Larry Fitzgerald ARI   WR         6600     17.2      20.1
    #> 5 11191680  Chris Thompson   WAS   RB         4700     15.9      16.8
    #> 6 11191735  Carlos Hyde      CLE   RB         4500     14.9      15.8
    #> 7 11192176  Sterling Shepard NYG   WR         4500     14.0      14.1
    #> 8 11191361  Jaguars          JAX   DST        3700     12.3      13.2
    #> 9 11191619  Jack Doyle       IND   TE         3600     11.6      12.5

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
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11193133  Julio Jones      ATL   WR         7600    17.3       35.7
    #> 2 11192543  Kareem Hunt      KC    RB         6900    19.3       31.6
    #> 3 11193183  Zach Ertz        PHI   TE         6600    14.4       46.8
    #> 4 11191791  Robert Woods     LAR   WR         6200    15.1       36.5
    #> 5 11191630  Derek Carr       OAK   QB         6000    15.4       49.6
    #> 6 11191805  Corey Grant      JAX   RB         4000     2.75      45.5
    #> 7 11191346  Rams             LAR   DST        3600    10.3       25.6
    #> 8 11192718  D.J. Chark Jr.   JAX   WR         3000     0         35.2
    #> 9 11192027  Stephen Anderson HOU   TE         2700     4.35      36.6
    #> 
    #> [[2]]
    #> # A tibble: 9 x 7
    #>   player_id player              team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>               <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown       PIT   WR         8600    24.6       41.5
    #> 2 11193133  Julio Jones         ATL   WR         7600    17.3       36.6
    #> 3 11192767  Deshaun Watson      HOU   QB         6700    26.3       45.8
    #> 4 11192776  Christian McCaffrey CAR   RB         6400    15.2       32.7
    #> 5 11191493  LeSean McCoy        BUF   RB         6000    17.3       33.0
    #> 6 11191601  Randall Cobb        GB    WR         4700    10.6       37.9
    #> 7 11191678  Theo Riddick        DET   RB         4200     9.69      32.8
    #> 8 11192696  Mark Andrews        BAL   TE         2700     0         31.8
    #> 9 11191334  Texans              HOU   DST        2200     5.19      28.4
    #> 
    #> [[3]]
    #> # A tibble: 9 x 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191729  Le'Veon Bell      PIT   RB         9400    24.7       32.9
    #> 2 11191533  Antonio Brown     PIT   WR         8600    24.6       37.4
    #> 3 11192722  Leonard Fournette JAX   RB         7100    19.2       33.0
    #> 4 11193095  Matt Ryan         ATL   QB         6300    15.6       42.0
    #> 5 11191619  Jack Doyle        IND   TE         3600    11.6       29.9
    #> 6 11191497  Torrey Smith      CAR   WR         3500     6.58      33.5
    #> 7 11192537  Chad Beebe        MIN   WR         3000     0         29.4
    #> 8 11191593  Tim Wright        KC    TE         2500     0         34.1
    #> 9 11191337  Browns            CLE   DST        2000     4.69      25.4
    #> 
    #> [[4]]
    #> # A tibble: 9 x 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191393  Larry Fitzgerald ARI   WR         6600    17.2       28.8
    #> 2 11191386  Greg Olsen       CAR   TE         5400     9.1       29.9
    #> 3 11191680  Chris Thompson   WAS   RB         4700    15.9       31.0
    #> 4 11191735  Carlos Hyde      CLE   RB         4500    14.9       34.0
    #> 5 11192200  C.J. Beathard    SF    QB         4400    13.8       35.1
    #> 6 11192019  Donte Moncrief   JAX   WR         4000     6.42      33.0
    #> 7 11191563  Kendall Wright   MIN   WR         3600     8.09      28.2
    #> 8 11191355  Chargers         LAC   DST        2800     9.94      33.7
    #> 9 11191531  Niles Paul       JAX   TE         2500     1.63      29.4
    #> 
    #> [[5]]
    #> # A tibble: 9 x 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191363  Tom Brady      NE    QB         7200    20.7       38.8
    #> 2 11192749  Tyreek Hill    KC    WR         6500    17.2       30.5
    #> 3 11192628  Jordan Howard  CHI   RB         6300    13.5       35.6
    #> 4 11191861  Jarvis Landry  CLE   WR         5500    16.4       32.0
    #> 5 11191409  Marshawn Lynch OAK   RB         5100    11.4       28.7
    #> 6 11191502  Pierre Garcon  SF    WR         4900    11.6       31.4
    #> 7 11191624  Dion Lewis     TEN   RB         4900    13.6       30.0
    #> 8 11191350  Saints         NO    DST        3600     8.67      23.3
    #> 9 11193189  Troy Mangen    ATL   TE         2500     0         32.9
