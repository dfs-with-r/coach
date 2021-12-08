
<!-- README.md is generated from README.Rmd. Please edit that file -->

# coach

<!-- badges: start -->

[![R-CMD-check](https://github.com/dfs-with-r/coach/workflows/R-CMD-check/badge.svg)](https://github.com/dfs-with-r/coach/actions)
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
remotes::install_github("zamorarr/coach")
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
    #>  1 11191729  Le'Veon Bell    PIT   RB         9400     24.7      25.8
    #>  2 11192254  Todd Gurley II  LAR   RB         9300     26.5      27.0
    #>  3 11191754  David Johnson   ARI   RB         8800     14        13.0
    #>  4 11191533  Antonio Brown   PIT   WR         8600     24.6      25.1
    #>  5 11192632  Alvin Kamara    NO    RB         8500     19.9      19.2
    #>  6 11191840  DeAndre Hopkins HOU   WR         8300     21.7      21.0
    #>  7 11192079  Davante Adams   GB    WR         7800     16.1      15.4
    #>  8 11192140  Michael Thomas  NO    WR         7800     17.6      16.1
    #>  9 11192363  Ezekiel Elliott DAL   RB         7700     21.9      21.4
    #> 10 11193133  Julio Jones     ATL   WR         7600     17.3      17.3
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
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5       27.0
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6       25.1
    #> 3 11192767  Deshaun Watson HOU   QB         6700    26.3       25.2
    #> 4 11191538  Travis Kelce   KC    TE         6400    16.4       17.8
    #> 5 11192302  Cooper Kupp    LAR   WR         5200    12.8       14.6
    #> 6 11191680  Chris Thompson WAS   RB         4700    15.9       16.5
    #> 7 11193143  Mohamed Sanu   ATL   WR         3800    11.4       11.7
    #> 8 11191868  Kapri Bibbs    WAS   RB         3000    13.6       14.4
    #> 9 11191335  Bears          CHI   DST        2300     8.62      10.7
    #> 
    #> [[2]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300     26.5      27.0
    #> 2 11191533  Antonio Brown    PIT   WR         8600     24.6      25.1
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      25.2
    #> 4 11191538  Travis Kelce     KC    TE         6400     16.4      17.8
    #> 5 11191680  Chris Thompson   WAS   RB         4700     15.9      16.5
    #> 6 11192176  Sterling Shepard NYG   WR         4500     14.0      13.5
    #> 7 11193143  Mohamed Sanu     ATL   WR         3800     11.4      11.7
    #> 8 11193209  Eagles           PHI   DST        3000     10.8      11.7
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      14.4
    #> 
    #> [[3]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       27.0
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.1
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3       25.2
    #> 4 11191538  Travis Kelce     KC    TE         6400    16.4       17.8
    #> 5 11191680  Chris Thompson   WAS   RB         4700    15.9       16.5
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       13.5
    #> 7 11191399  Ted Ginn Jr.     NO    WR         4300    12.0       12.5
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       14.4
    #> 9 11191335  Bears            CHI   DST        2300     8.62      10.7

Write these results to a file. This file can be submitted directly to
the DFS site.

``` r
write_lineups(results, "mylineups.csv", site = "draftkings", sport = "nfl")
```

    #>         QB       RB       RB       WR       WR       WR       TE     FLEX
    #> 1 11192767 11192254 11191868 11193143 11192302 11191533 11191538 11191680
    #> 2 11192767 11192254 11191868 11193143 11192176 11191533 11191538 11191680
    #> 3 11192767 11192254 11191868 11191399 11192176 11191533 11191538 11191680
    #>        DST
    #> 1 11191335
    #> 2 11193209
    #> 3 11191335

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
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5       27.0
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6       25.1
    #> 3 11192767  Deshaun Watson HOU   QB         6700    26.3       25.2
    #> 4 11191538  Travis Kelce   KC    TE         6400    16.4       17.8
    #> 5 11192302  Cooper Kupp    LAR   WR         5200    12.8       14.6
    #> 6 11191680  Chris Thompson WAS   RB         4700    15.9       16.5
    #> 7 11193143  Mohamed Sanu   ATL   WR         3800    11.4       11.7
    #> 8 11191868  Kapri Bibbs    WAS   RB         3000    13.6       14.4
    #> 9 11191335  Bears          CHI   DST        2300     8.62      10.7
    #> 
    #> [[2]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300     26.5      27.0
    #> 2 11191533  Antonio Brown    PIT   WR         8600     24.6      25.1
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      25.2
    #> 4 11191538  Travis Kelce     KC    TE         6400     16.4      17.8
    #> 5 11191680  Chris Thompson   WAS   RB         4700     15.9      16.5
    #> 6 11192176  Sterling Shepard NYG   WR         4500     14.0      13.5
    #> 7 11193143  Mohamed Sanu     ATL   WR         3800     11.4      11.7
    #> 8 11193209  Eagles           PHI   DST        3000     10.8      11.7
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      14.4
    #> 
    #> [[3]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       27.0
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.1
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3       25.2
    #> 4 11191538  Travis Kelce     KC    TE         6400    16.4       17.8
    #> 5 11191680  Chris Thompson   WAS   RB         4700    15.9       16.5
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       13.5
    #> 7 11191399  Ted Ginn Jr.     NO    WR         4300    12.0       12.5
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       14.4
    #> 9 11191335  Bears            CHI   DST        2300     8.62      10.7

### Max Exposure

Many times you want to limit the exposure of your lineups to certain
players (due to effects not captured in the model). You can do this by
setting a global `max_exposure` for every player to a constant:

``` r
optimize_generic(data, model, L = 5, max_exposure = 3/5)
```

    #> [[1]]
    #> # A tibble: 9 × 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5       27.0
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6       25.1
    #> 3 11192767  Deshaun Watson HOU   QB         6700    26.3       25.2
    #> 4 11191538  Travis Kelce   KC    TE         6400    16.4       17.8
    #> 5 11192302  Cooper Kupp    LAR   WR         5200    12.8       14.6
    #> 6 11191680  Chris Thompson WAS   RB         4700    15.9       16.5
    #> 7 11193143  Mohamed Sanu   ATL   WR         3800    11.4       11.7
    #> 8 11191868  Kapri Bibbs    WAS   RB         3000    13.6       14.4
    #> 9 11191335  Bears          CHI   DST        2300     8.62      10.7
    #> 
    #> [[2]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191729  Le'Veon Bell     PIT   RB         9400    24.7      25.8 
    #> 2 11192363  Ezekiel Elliott  DAL   RB         7700    21.9      21.4 
    #> 3 11191791  Robert Woods     LAR   WR         6200    15.1      17.0 
    #> 4 11191517  Russell Wilson   SEA   QB         6200    23.2      23.6 
    #> 5 11191861  Jarvis Landry    CLE   WR         5500    16.4      15.7 
    #> 6 11191735  Carlos Hyde      CLE   RB         4500    14.9      15.7 
    #> 7 11192176  Sterling Shepard NYG   WR         4500    14.0      13.5 
    #> 8 11193209  Eagles           PHI   DST        3000    10.8      11.7 
    #> 9 11191758  Cameron Brate    TB    TE         3000     8.94      9.60
    #> 
    #> [[3]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300     26.5      27.0
    #> 2 11191533  Antonio Brown    PIT   WR         8600     24.6      25.1
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      25.2
    #> 4 11191538  Travis Kelce     KC    TE         6400     16.4      17.8
    #> 5 11191680  Chris Thompson   WAS   RB         4700     15.9      16.5
    #> 6 11192176  Sterling Shepard NYG   WR         4500     14.0      13.5
    #> 7 11193143  Mohamed Sanu     ATL   WR         3800     11.4      11.7
    #> 8 11193209  Eagles           PHI   DST        3000     10.8      11.7
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      14.4
    #> 
    #> [[4]]
    #> # A tibble: 9 × 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191729  Le'Veon Bell      PIT   RB         9400    24.7      25.8 
    #> 2 11192363  Ezekiel Elliott   DAL   RB         7700    21.9      21.4 
    #> 3 11191859  Odell Beckham Jr. NYG   WR         7000    18.5      18.6 
    #> 4 11191791  Robert Woods      LAR   WR         6200    15.1      17.0 
    #> 5 11191517  Russell Wilson    SEA   QB         6200    23.2      23.6 
    #> 6 11191735  Carlos Hyde       CLE   RB         4500    14.9      15.7 
    #> 7 11191401  Danny Amendola    MIA   WR         4200    11.5      12.5 
    #> 8 11192493  Hunter Henry      LAC   TE         2500     9.06      8.95
    #> 9 11191335  Bears             CHI   DST        2300     8.62     10.7 
    #> 
    #> [[5]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       27.0
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.1
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3       25.2
    #> 4 11191538  Travis Kelce     KC    TE         6400    16.4       17.8
    #> 5 11191680  Chris Thompson   WAS   RB         4700    15.9       16.5
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       13.5
    #> 7 11191399  Ted Ginn Jr.     NO    WR         4300    12.0       12.5
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       14.4
    #> 9 11191335  Bears            CHI   DST        2300     8.62      10.7

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
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5       27.0
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6       25.1
    #> 3 11192767  Deshaun Watson HOU   QB         6700    26.3       25.2
    #> 4 11191538  Travis Kelce   KC    TE         6400    16.4       17.8
    #> 5 11192302  Cooper Kupp    LAR   WR         5200    12.8       14.6
    #> 6 11191680  Chris Thompson WAS   RB         4700    15.9       16.5
    #> 7 11193143  Mohamed Sanu   ATL   WR         3800    11.4       11.7
    #> 8 11191868  Kapri Bibbs    WAS   RB         3000    13.6       14.4
    #> 9 11191335  Bears          CHI   DST        2300     8.62      10.7
    #> 
    #> [[2]]
    #> # A tibble: 9 × 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5       27.0
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6       25.1
    #> 3 11191538  Travis Kelce   KC    TE         6400    16.4       17.8
    #> 4 11191517  Russell Wilson SEA   QB         6200    23.2       23.6
    #> 5 11191861  Jarvis Landry  CLE   WR         5500    16.4       15.7
    #> 6 11191735  Carlos Hyde    CLE   RB         4500    14.9       15.7
    #> 7 11191401  Danny Amendola MIA   WR         4200    11.5       12.5
    #> 8 11191868  Kapri Bibbs    WAS   RB         3000    13.6       14.4
    #> 9 11191335  Bears          CHI   DST        2300     8.62      10.7
    #> 
    #> [[3]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300     26.5      27.0
    #> 2 11191533  Antonio Brown    PIT   WR         8600     24.6      25.1
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      25.2
    #> 4 11191538  Travis Kelce     KC    TE         6400     16.4      17.8
    #> 5 11191680  Chris Thompson   WAS   RB         4700     15.9      16.5
    #> 6 11192176  Sterling Shepard NYG   WR         4500     14.0      13.5
    #> 7 11193143  Mohamed Sanu     ATL   WR         3800     11.4      11.7
    #> 8 11193209  Eagles           PHI   DST        3000     10.8      11.7
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      14.4
    #> 
    #> [[4]]
    #> # A tibble: 9 × 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5       27.0
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6       25.1
    #> 3 11191538  Travis Kelce   KC    TE         6400    16.4       17.8
    #> 4 11191517  Russell Wilson SEA   QB         6200    23.2       23.6
    #> 5 11191861  Jarvis Landry  CLE   WR         5500    16.4       15.7
    #> 6 11191680  Chris Thompson WAS   RB         4700    15.9       16.5
    #> 7 11193143  Mohamed Sanu   ATL   WR         3800    11.4       11.7
    #> 8 11191868  Kapri Bibbs    WAS   RB         3000    13.6       14.4
    #> 9 11191335  Bears          CHI   DST        2300     8.62      10.7
    #> 
    #> [[5]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       27.0
    #> 2 11191533  Antonio Brown    PIT   WR         8600    24.6       25.1
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3       25.2
    #> 4 11191538  Travis Kelce     KC    TE         6400    16.4       17.8
    #> 5 11191680  Chris Thompson   WAS   RB         4700    15.9       16.5
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       13.5
    #> 7 11191399  Ted Ginn Jr.     NO    WR         4300    12.0       12.5
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       14.4
    #> 9 11191335  Bears            CHI   DST        2300     8.62      10.7

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
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5       35.1
    #> 2 11192767  Deshaun Watson HOU   QB         6700    26.3       32.1
    #> 3 11191649  Josh Gordon    CLE   WR         5800    12.1       26.1
    #> 4 11192844  D'Onta Foreman HOU   RB         4300     5.8       28.3
    #> 5 11191913  Javorius Allen BAL   RB         4200    10.4       33.8
    #> 6 11192401  Trent Taylor   SF    WR         3600     6.47      26.8
    #> 7 11192088  Tevin Jones    PIT   WR         3000     0         29.5
    #> 8 11191342  Titans         TEN   DST        2900     6.17      26.3
    #> 9 11191427  Andrew DePaola OAK   TE         2500     0         27.6
    #> 
    #> [[2]]
    #> # A tibble: 9 × 7
    #>   player_id player          team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>           <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191729  Le'Veon Bell    PIT   RB         9400    24.7       33.8
    #> 2 11191533  Antonio Brown   PIT   WR         8600    24.6       42.1
    #> 3 11193094  Carson Wentz    PHI   QB         6400    23.4       34.1
    #> 4 11193137  Nelson Agholor  PHI   WR         5900    11.8       29.9
    #> 5 11193107  Tevin Coleman   ATL   RB         4400    11.0       35.1
    #> 6 11191741  Giovani Bernard CIN   RB         4400     9.67      37.1
    #> 7 11191928  Martavis Bryant OAK   WR         4200     9.27      30.1
    #> 8 11192965  Emanuel Byrd    GB    TE         2500     5.1       35.5
    #> 9 11191344  Chiefs          KC    DST        2300     7.71      30.8
    #> 
    #> [[3]]
    #> # A tibble: 9 × 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11193133  Julio Jones    ATL   WR         7600    17.3       29.9
    #> 2 11192767  Deshaun Watson HOU   QB         6700    26.3       35.4
    #> 3 11192276  Devin Funchess CAR   WR         5200    12.4       34.0
    #> 4 11192296  Kenny Golladay DET   WR         4800     8.6       31.7
    #> 5 11192596  Evan Engram    NYG   TE         4700    11.6       32.9
    #> 6 11191526  Bilal Powell   NYJ   RB         4700    10.2       29.5
    #> 7 11191795  James White    NE    RB         4000    10.4       30.4
    #> 8 11191339  Broncos        DEN   DST        3300     6.88      27.2
    #> 9 11192832  Michael Thomas LAR   WR         3000     1.79      30.6
    #> 
    #> [[4]]
    #> # A tibble: 9 × 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191372  Aaron Rodgers  GB    QB         7500    20.8       40.0
    #> 2 11191493  LeSean McCoy   BUF   RB         6000    17.3       32.9
    #> 3 11192038  Brandin Cooks  LAR   WR         5600    14.0       28.5
    #> 4 11192378  Derrick Henry  TEN   RB         5400     9.94      32.9
    #> 5 11192596  Evan Engram    NYG   TE         4700    11.6       33.2
    #> 6 11191348  Vikings        MIN   DST        3500     6.83      34.7
    #> 7 11192258  Jaydon Mickens JAX   WR         3000     2.48      29.9
    #> 8 11192649  Jake Wieneke   MIN   WR         3000     0         32.0
    #> 9 11192778  Dalton Schultz DAL   TE         2500     0         35.5
    #> 
    #> [[5]]
    #> # A tibble: 9 × 7
    #>   player_id player                 team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>                  <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191754  David Johnson          ARI   RB         8800    14         32.8
    #> 2 11191533  Antonio Brown          PIT   WR         8600    24.6       37.6
    #> 3 11191472  Cam Newton             CAR   QB         6900    20.7       41.1
    #> 4 11192387  Adam Thielen           MIN   WR         6900    15.2       33.9
    #> 5 11193183  Zach Ertz              PHI   TE         6600    14.4       26.6
    #> 6 11192954  Joe Williams           SF    RB         3500     0         28.7
    #> 7 11192008  Chris Moore            BAL   WR         3000     5.07      36.7
    #> 8 11192561  Damore'ea Stringfellow SEA   WR         3000     0         43.0
    #> 9 11191345  Raiders                OAK   DST        2200     4.38      18.8
