
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
remotes::install_github("dfs-with-r/coach")
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
    #>  1 11191729  Le'Veon Bell    PIT   RB         9400     24.7      22.6
    #>  2 11192254  Todd Gurley II  LAR   RB         9300     26.5      26.9
    #>  3 11191754  David Johnson   ARI   RB         8800     14        13.5
    #>  4 11191533  Antonio Brown   PIT   WR         8600     24.6      22.3
    #>  5 11192632  Alvin Kamara    NO    RB         8500     19.9      19.2
    #>  6 11191840  DeAndre Hopkins HOU   WR         8300     21.7      21.9
    #>  7 11192079  Davante Adams   GB    WR         7800     16.1      15.5
    #>  8 11192140  Michael Thomas  NO    WR         7800     17.6      17.2
    #>  9 11192363  Ezekiel Elliott DAL   RB         7700     21.9      23.0
    #> 10 11193133  Julio Jones     ATL   WR         7600     17.3      17.4
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
    #> 1 11192254  Todd Gurley II   LAR   RB         9300     26.5      26.9
    #> 2 11192363  Ezekiel Elliott  DAL   RB         7700     21.9      23.0
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      25.9
    #> 4 11191393  Larry Fitzgerald ARI   WR         6600     17.2      19.4
    #> 5 11191861  Jarvis Landry    CLE   WR         5500     16.4      17.9
    #> 6 11193143  Mohamed Sanu     ATL   WR         3800     11.4      13.4
    #> 7 11191362  Ravens           BAL   DST        3800     11.7      14.3
    #> 8 11191619  Jack Doyle       IND   TE         3600     11.6      13.4
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      14.5
    #> 
    #> [[2]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       26.9
    #> 2 11192363  Ezekiel Elliott  DAL   RB         7700    21.9       23.0
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3       25.9
    #> 4 11191393  Larry Fitzgerald ARI   WR         6600    17.2       19.4
    #> 5 11191861  Jarvis Landry    CLE   WR         5500    16.4       17.9
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       14.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       13.4
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       14.5
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      12.4
    #> 
    #> [[3]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300     26.5      26.9
    #> 2 11192363  Ezekiel Elliott  DAL   RB         7700     21.9      23.0
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      25.9
    #> 4 11191572  Marvin Jones Jr. DET   WR         6500     14.6      18.0
    #> 5 11191861  Jarvis Landry    CLE   WR         5500     16.4      17.9
    #> 6 11193143  Mohamed Sanu     ATL   WR         3800     11.4      13.4
    #> 7 11191362  Ravens           BAL   DST        3800     11.7      14.3
    #> 8 11191619  Jack Doyle       IND   TE         3600     11.6      13.4
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      14.5

Write these results to a file. This file can be submitted directly to
the DFS site.

``` r
write_lineups(results, "mylineups.csv", site = "draftkings", sport = "nfl")
```

    #>         QB       RB       RB       WR       WR       WR       TE     FLEX
    #> 1 11192767 11192363 11192254 11191393 11193143 11191861 11191619 11191868
    #> 2 11192767 11192363 11192254 11191393 11191861 11192176 11191619 11191868
    #> 3 11192767 11192363 11192254 11193143 11191861 11191572 11191619 11191868
    #>        DST
    #> 1 11191362
    #> 2 11191355
    #> 3 11191362

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
    #> 1 11192254  Todd Gurley II   LAR   RB         9300     26.5      26.9
    #> 2 11192363  Ezekiel Elliott  DAL   RB         7700     21.9      23.0
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      25.9
    #> 4 11191393  Larry Fitzgerald ARI   WR         6600     17.2      19.4
    #> 5 11191861  Jarvis Landry    CLE   WR         5500     16.4      17.9
    #> 6 11193143  Mohamed Sanu     ATL   WR         3800     11.4      13.4
    #> 7 11191362  Ravens           BAL   DST        3800     11.7      14.3
    #> 8 11191619  Jack Doyle       IND   TE         3600     11.6      13.4
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      14.5
    #> 
    #> [[2]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       26.9
    #> 2 11192363  Ezekiel Elliott  DAL   RB         7700    21.9       23.0
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3       25.9
    #> 4 11191393  Larry Fitzgerald ARI   WR         6600    17.2       19.4
    #> 5 11191861  Jarvis Landry    CLE   WR         5500    16.4       17.9
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       14.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       13.4
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       14.5
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      12.4
    #> 
    #> [[3]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300     26.5      26.9
    #> 2 11192363  Ezekiel Elliott  DAL   RB         7700     21.9      23.0
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      25.9
    #> 4 11191572  Marvin Jones Jr. DET   WR         6500     14.6      18.0
    #> 5 11191861  Jarvis Landry    CLE   WR         5500     16.4      17.9
    #> 6 11193143  Mohamed Sanu     ATL   WR         3800     11.4      13.4
    #> 7 11191362  Ravens           BAL   DST        3800     11.7      14.3
    #> 8 11191619  Jack Doyle       IND   TE         3600     11.6      13.4
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      14.5

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
    #> 1 11192254  Todd Gurley II   LAR   RB         9300     26.5      26.9
    #> 2 11192363  Ezekiel Elliott  DAL   RB         7700     21.9      23.0
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      25.9
    #> 4 11191393  Larry Fitzgerald ARI   WR         6600     17.2      19.4
    #> 5 11191861  Jarvis Landry    CLE   WR         5500     16.4      17.9
    #> 6 11193143  Mohamed Sanu     ATL   WR         3800     11.4      13.4
    #> 7 11191362  Ravens           BAL   DST        3800     11.7      14.3
    #> 8 11191619  Jack Doyle       IND   TE         3600     11.6      13.4
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      14.5
    #> 
    #> [[2]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown    PIT   WR         8600    24.6       22.3
    #> 2 11191840  DeAndre Hopkins  HOU   WR         8300    21.7       21.9
    #> 3 11191572  Marvin Jones Jr. DET   WR         6500    14.6       18.0
    #> 4 11191517  Russell Wilson   SEA   QB         6200    23.2       24.0
    #> 5 11192596  Evan Engram      NYG   TE         4700    11.6       13.8
    #> 6 11191680  Chris Thompson   WAS   RB         4700    15.9       15.9
    #> 7 11191735  Carlos Hyde      CLE   RB         4500    14.9       15.1
    #> 8 11191911  Ty Montgomery    GB    RB         3700    11.4       12.7
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      12.4
    #> 
    #> [[3]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       26.9
    #> 2 11192363  Ezekiel Elliott  DAL   RB         7700    21.9       23.0
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3       25.9
    #> 4 11191393  Larry Fitzgerald ARI   WR         6600    17.2       19.4
    #> 5 11191861  Jarvis Landry    CLE   WR         5500    16.4       17.9
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       14.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       13.4
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       14.5
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      12.4
    #> 
    #> [[4]]
    #> # A tibble: 9 × 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown     PIT   WR         8600     24.6      22.3
    #> 2 11192722  Leonard Fournette JAX   RB         7100     19.2      20.4
    #> 3 11191572  Marvin Jones Jr.  DET   WR         6500     14.6      18.0
    #> 4 11191517  Russell Wilson    SEA   QB         6200     23.2      24.0
    #> 5 11192596  Evan Engram       NYG   TE         4700     11.6      13.8
    #> 6 11191680  Chris Thompson    WAS   RB         4700     15.9      15.9
    #> 7 11191735  Carlos Hyde       CLE   RB         4500     14.9      15.1
    #> 8 11193143  Mohamed Sanu      ATL   WR         3800     11.4      13.4
    #> 9 11191362  Ravens            BAL   DST        3800     11.7      14.3
    #> 
    #> [[5]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300     26.5      26.9
    #> 2 11192363  Ezekiel Elliott  DAL   RB         7700     21.9      23.0
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      25.9
    #> 4 11191572  Marvin Jones Jr. DET   WR         6500     14.6      18.0
    #> 5 11191861  Jarvis Landry    CLE   WR         5500     16.4      17.9
    #> 6 11193143  Mohamed Sanu     ATL   WR         3800     11.4      13.4
    #> 7 11191362  Ravens           BAL   DST        3800     11.7      14.3
    #> 8 11191619  Jack Doyle       IND   TE         3600     11.6      13.4
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      14.5

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
    #> 1 11192254  Todd Gurley II   LAR   RB         9300     26.5      26.9
    #> 2 11192363  Ezekiel Elliott  DAL   RB         7700     21.9      23.0
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      25.9
    #> 4 11191393  Larry Fitzgerald ARI   WR         6600     17.2      19.4
    #> 5 11191861  Jarvis Landry    CLE   WR         5500     16.4      17.9
    #> 6 11193143  Mohamed Sanu     ATL   WR         3800     11.4      13.4
    #> 7 11191362  Ravens           BAL   DST        3800     11.7      14.3
    #> 8 11191619  Jack Doyle       IND   TE         3600     11.6      13.4
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      14.5
    #> 
    #> [[2]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300     26.5      26.9
    #> 2 11192363  Ezekiel Elliott  DAL   RB         7700     21.9      23.0
    #> 3 11191393  Larry Fitzgerald ARI   WR         6600     17.2      19.4
    #> 4 11191517  Russell Wilson   SEA   QB         6200     23.2      24.0
    #> 5 11191861  Jarvis Landry    CLE   WR         5500     16.4      17.9
    #> 6 11193143  Mohamed Sanu     ATL   WR         3800     11.4      13.4
    #> 7 11191362  Ravens           BAL   DST        3800     11.7      14.3
    #> 8 11191619  Jack Doyle       IND   TE         3600     11.6      13.4
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      14.5
    #> 
    #> [[3]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300    26.5       26.9
    #> 2 11192363  Ezekiel Elliott  DAL   RB         7700    21.9       23.0
    #> 3 11192767  Deshaun Watson   HOU   QB         6700    26.3       25.9
    #> 4 11191393  Larry Fitzgerald ARI   WR         6600    17.2       19.4
    #> 5 11191861  Jarvis Landry    CLE   WR         5500    16.4       17.9
    #> 6 11192176  Sterling Shepard NYG   WR         4500    14.0       14.0
    #> 7 11191619  Jack Doyle       IND   TE         3600    11.6       13.4
    #> 8 11191868  Kapri Bibbs      WAS   RB         3000    13.6       14.5
    #> 9 11191355  Chargers         LAC   DST        2800     9.94      12.4
    #> 
    #> [[4]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300     26.5      26.9
    #> 2 11192363  Ezekiel Elliott  DAL   RB         7700     21.9      23.0
    #> 3 11191393  Larry Fitzgerald ARI   WR         6600     17.2      19.4
    #> 4 11191517  Russell Wilson   SEA   QB         6200     23.2      24.0
    #> 5 11191861  Jarvis Landry    CLE   WR         5500     16.4      17.9
    #> 6 11191399  Ted Ginn Jr.     NO    WR         4300     12.0      13.1
    #> 7 11191362  Ravens           BAL   DST        3800     11.7      14.3
    #> 8 11191619  Jack Doyle       IND   TE         3600     11.6      13.4
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      14.5
    #> 
    #> [[5]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II   LAR   RB         9300     26.5      26.9
    #> 2 11192363  Ezekiel Elliott  DAL   RB         7700     21.9      23.0
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      25.9
    #> 4 11191572  Marvin Jones Jr. DET   WR         6500     14.6      18.0
    #> 5 11191861  Jarvis Landry    CLE   WR         5500     16.4      17.9
    #> 6 11193143  Mohamed Sanu     ATL   WR         3800     11.4      13.4
    #> 7 11191362  Ravens           BAL   DST        3800     11.7      14.3
    #> 8 11191619  Jack Doyle       IND   TE         3600     11.6      13.4
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      14.5

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
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192722  Leonard Fournette JAX   RB         7100    19.2       42.3
    #> 2 11192543  Kareem Hunt       KC    RB         6900    19.3       32.5
    #> 3 11191393  Larry Fitzgerald  ARI   WR         6600    17.2       37.9
    #> 4 11193103  Devonta Freeman   ATL   RB         6600    14.7       35.4
    #> 5 11191538  Travis Kelce      KC    TE         6400    16.4       33.4
    #> 6 11191874  Dak Prescott      DAL   QB         5500    17.5       40.2
    #> 7 11192276  Devin Funchess    CAR   WR         5200    12.4       41.2
    #> 8 11192686  Jeff Janis        CLE   WR         3000     0.2       30.3
    #> 9 11191337  Browns            CLE   DST        2000     4.69      23.8
    #> 
    #> [[2]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191572  Marvin Jones Jr. DET   WR         6500    14.6       34.7
    #> 2 11191861  Jarvis Landry    CLE   WR         5500    16.4       38.5
    #> 3 11192176  Sterling Shepard NYG   WR         4500    14.0       28.7
    #> 4 11191913  Javorius Allen   BAL   RB         4200    10.4       34.1
    #> 5 11191588  Mike Glennon     ARI   QB         4100    11.2       36.2
    #> 6 11192756  Brian Hill       CIN   RB         3000     1.33      32.2
    #> 7 11192539  Joel Bouagnon    GB    RB         3000     0         30.1
    #> 8 11193209  Eagles           PHI   DST        3000    10.8       26.0
    #> 9 11191756  MyCole Pruitt    HOU   TE         2500     0         28.1
    #> 
    #> [[3]]
    #> # A tibble: 9 × 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II    LAR   RB         9300    26.5       34.9
    #> 2 11192002  Melvin Gordon III LAC   RB         6800    18.4       49.6
    #> 3 11191896  Mike Evans        TB    WR         6700    13.7       29.8
    #> 4 11191517  Russell Wilson    SEA   QB         6200    23.2       34.6
    #> 5 11191861  Jarvis Landry     CLE   WR         5500    16.4       39.8
    #> 6 11192596  Evan Engram       NYG   TE         4700    11.6       32.7
    #> 7 11191670  Mike Gillislee    NO    RB         3400     7.76      36.4
    #> 8 11192031  Nelson Spruce     LAC   WR         3000     0         29.5
    #> 9 11191335  Bears             CHI   DST        2300     8.62      26.8
    #> 
    #> [[4]]
    #> # A tibble: 9 × 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown     PIT   WR         8600    24.6       34.9
    #> 2 11192722  Leonard Fournette JAX   RB         7100    19.2       37.6
    #> 3 11191508  Golden Tate       DET   WR         6700    14.7       40.2
    #> 4 11192260  Jamaal Williams   GB    RB         6000     9.11      30.9
    #> 5 11191865  Brett Hundley     SEA   QB         4300    12.6       37.2
    #> 6 11191362  Ravens            BAL   DST        3800    11.7       27.5
    #> 7 11192401  Trent Taylor      SF    WR         3600     6.47      33.7
    #> 8 11191551  Terrelle Pryor    NYJ   WR         3400     5.56      33.1
    #> 9 11191495  Rhett Ellison     NYG   TE         2500     3.72      30.8
    #> 
    #> [[5]]
    #> # A tibble: 9 × 7
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191840  DeAndre Hopkins  HOU   WR         8300    21.7       47.2
    #> 2 11192363  Ezekiel Elliott  DAL   RB         7700    21.9       36.8
    #> 3 11191572  Marvin Jones Jr. DET   WR         6500    14.6       40.3
    #> 4 11192260  Jamaal Williams  GB    RB         6000     9.11      37.5
    #> 5 11191630  Derek Carr       OAK   QB         6000    15.4       47.9
    #> 6 11191382  Delanie Walker   TEN   TE         4900    11.0       31.7
    #> 7 11191737  TJ Jones         DET   WR         3300     5.56      32.6
    #> 8 11192110  Trey Griffey     PIT   WR         3000     0         34.9
    #> 9 11191359  Redskins         WAS   DST        2800     7.06      30.7
