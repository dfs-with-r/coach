
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
    #>  1 11191729  Le'Veon Bell    PIT   RB         9400     24.7      24.0
    #>  2 11192254  Todd Gurley II  LAR   RB         9300     26.5      27.2
    #>  3 11191754  David Johnson   ARI   RB         8800     14        14.0
    #>  4 11191533  Antonio Brown   PIT   WR         8600     24.6      25.0
    #>  5 11192632  Alvin Kamara    NO    RB         8500     19.9      20.1
    #>  6 11191840  DeAndre Hopkins HOU   WR         8300     21.7      22.0
    #>  7 11192079  Davante Adams   GB    WR         7800     16.1      15.4
    #>  8 11192140  Michael Thomas  NO    WR         7800     17.6      17.6
    #>  9 11192363  Ezekiel Elliott DAL   RB         7700     21.9      21.5
    #> 10 11193133  Julio Jones     ATL   WR         7600     17.3      18.6
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
    #> 1 11192254  Todd Gurley II   LAR   RB         9300     26.5      27.2
    #> 2 11191533  Antonio Brown    PIT   WR         8600     24.6      25.0
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      26.2
    #> 4 11191547  Mark Ingram      NO    RB         5700     16.7      18.1
    #> 5 11191861  Jarvis Landry    CLE   WR         5500     16.4      18.6
    #> 6 11192176  Sterling Shepard NYG   WR         4500     14.0      13.2
    #> 7 11191619  Jack Doyle       IND   TE         3600     11.6      11.9
    #> 8 11193209  Eagles           PHI   DST        3000     10.8      11.2
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      12.9
    #> 
    #> [[2]]
    #> # A tibble: 9 × 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5      27.2 
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6      25.0 
    #> 3 11192767  Deshaun Watson HOU   QB         6700    26.3      26.2 
    #> 4 11192749  Tyreek Hill    KC    WR         6500    17.2      18.8 
    #> 5 11191861  Jarvis Landry  CLE   WR         5500    16.4      18.6 
    #> 6 11191735  Carlos Hyde    CLE   RB         4500    14.9      14.9 
    #> 7 11191619  Jack Doyle     IND   TE         3600    11.6      11.9 
    #> 8 11191868  Kapri Bibbs    WAS   RB         3000    13.6      12.9 
    #> 9 11191338  Cowboys        DAL   DST        2300     7.19      8.60
    #> 
    #> [[3]]
    #> # A tibble: 9 × 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5      27.2 
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6      25.0 
    #> 3 11192767  Deshaun Watson HOU   QB         6700    26.3      26.2 
    #> 4 11192749  Tyreek Hill    KC    WR         6500    17.2      18.8 
    #> 5 11191861  Jarvis Landry  CLE   WR         5500    16.4      18.6 
    #> 6 11191735  Carlos Hyde    CLE   RB         4500    14.9      14.9 
    #> 7 11193209  Eagles         PHI   DST        3000    10.8      11.2 
    #> 8 11191868  Kapri Bibbs    WAS   RB         3000    13.6      12.9 
    #> 9 11192493  Hunter Henry   LAC   TE         2500     9.06      9.19

Write these results to a file. This file can be submitted directly to
the DFS site.

``` r
write_lineups(results, "mylineups.csv", site = "draftkings", sport = "nfl")
```

    #>         QB       RB       RB       WR       WR       WR       TE     FLEX
    #> 1 11192767 11192254 11191547 11191861 11192176 11191533 11191619 11191868
    #> 2 11192767 11191735 11192254 11191861 11192749 11191533 11191619 11191868
    #> 3 11192767 11191735 11192254 11191861 11192749 11191533 11192493 11191868
    #>        DST
    #> 1 11193209
    #> 2 11191338
    #> 3 11193209

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
    #> 1 11192254  Todd Gurley II   LAR   RB         9300     26.5      27.2
    #> 2 11191533  Antonio Brown    PIT   WR         8600     24.6      25.0
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      26.2
    #> 4 11191547  Mark Ingram      NO    RB         5700     16.7      18.1
    #> 5 11191861  Jarvis Landry    CLE   WR         5500     16.4      18.6
    #> 6 11192176  Sterling Shepard NYG   WR         4500     14.0      13.2
    #> 7 11191619  Jack Doyle       IND   TE         3600     11.6      11.9
    #> 8 11193209  Eagles           PHI   DST        3000     10.8      11.2
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      12.9
    #> 
    #> [[2]]
    #> # A tibble: 9 × 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5      27.2 
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6      25.0 
    #> 3 11192767  Deshaun Watson HOU   QB         6700    26.3      26.2 
    #> 4 11192749  Tyreek Hill    KC    WR         6500    17.2      18.8 
    #> 5 11191861  Jarvis Landry  CLE   WR         5500    16.4      18.6 
    #> 6 11191735  Carlos Hyde    CLE   RB         4500    14.9      14.9 
    #> 7 11191619  Jack Doyle     IND   TE         3600    11.6      11.9 
    #> 8 11191868  Kapri Bibbs    WAS   RB         3000    13.6      12.9 
    #> 9 11191338  Cowboys        DAL   DST        2300     7.19      8.60
    #> 
    #> [[3]]
    #> # A tibble: 9 × 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5      27.2 
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6      25.0 
    #> 3 11192767  Deshaun Watson HOU   QB         6700    26.3      26.2 
    #> 4 11192749  Tyreek Hill    KC    WR         6500    17.2      18.8 
    #> 5 11191861  Jarvis Landry  CLE   WR         5500    16.4      18.6 
    #> 6 11191735  Carlos Hyde    CLE   RB         4500    14.9      14.9 
    #> 7 11193209  Eagles         PHI   DST        3000    10.8      11.2 
    #> 8 11191868  Kapri Bibbs    WAS   RB         3000    13.6      12.9 
    #> 9 11192493  Hunter Henry   LAC   TE         2500     9.06      9.19

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
    #> 1 11192254  Todd Gurley II   LAR   RB         9300     26.5      27.2
    #> 2 11191533  Antonio Brown    PIT   WR         8600     24.6      25.0
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      26.2
    #> 4 11191547  Mark Ingram      NO    RB         5700     16.7      18.1
    #> 5 11191861  Jarvis Landry    CLE   WR         5500     16.4      18.6
    #> 6 11192176  Sterling Shepard NYG   WR         4500     14.0      13.2
    #> 7 11191619  Jack Doyle       IND   TE         3600     11.6      11.9
    #> 8 11193209  Eagles           PHI   DST        3000     10.8      11.2
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      12.9
    #> 
    #> [[2]]
    #> # A tibble: 9 × 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191840  DeAndre Hopkins   HOU   WR         8300    21.7      22.0 
    #> 2 11192722  Leonard Fournette JAX   RB         7100    19.2      20.5 
    #> 3 11192749  Tyreek Hill       KC    WR         6500    17.2      18.8 
    #> 4 11191517  Russell Wilson    SEA   QB         6200    23.2      22.7 
    #> 5 11191493  LeSean McCoy      BUF   RB         6000    17.3      17.8 
    #> 6 11192276  Devin Funchess    CAR   WR         5200    12.4      14.5 
    #> 7 11191735  Carlos Hyde       CLE   RB         4500    14.9      14.9 
    #> 8 11191361  Jaguars           JAX   DST        3700    12.3      11.6 
    #> 9 11192493  Hunter Henry      LAC   TE         2500     9.06      9.19
    #> 
    #> [[3]]
    #> # A tibble: 9 × 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5      27.2 
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6      25.0 
    #> 3 11192767  Deshaun Watson HOU   QB         6700    26.3      26.2 
    #> 4 11192749  Tyreek Hill    KC    WR         6500    17.2      18.8 
    #> 5 11191861  Jarvis Landry  CLE   WR         5500    16.4      18.6 
    #> 6 11191735  Carlos Hyde    CLE   RB         4500    14.9      14.9 
    #> 7 11191619  Jack Doyle     IND   TE         3600    11.6      11.9 
    #> 8 11191868  Kapri Bibbs    WAS   RB         3000    13.6      12.9 
    #> 9 11191338  Cowboys        DAL   DST        2300     7.19      8.60
    #> 
    #> [[4]]
    #> # A tibble: 9 × 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191840  DeAndre Hopkins   HOU   WR         8300    21.7      22.0 
    #> 2 11192363  Ezekiel Elliott   DAL   RB         7700    21.9      21.5 
    #> 3 11192722  Leonard Fournette JAX   RB         7100    19.2      20.5 
    #> 4 11191517  Russell Wilson    SEA   QB         6200    23.2      22.7 
    #> 5 11191547  Mark Ingram       NO    RB         5700    16.7      18.1 
    #> 6 11192276  Devin Funchess    CAR   WR         5200    12.4      14.5 
    #> 7 11191401  Danny Amendola    MIA   WR         4200    11.5      12.9 
    #> 8 11193209  Eagles            PHI   DST        3000    10.8      11.2 
    #> 9 11192493  Hunter Henry      LAC   TE         2500     9.06      9.19
    #> 
    #> [[5]]
    #> # A tibble: 9 × 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5      27.2 
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6      25.0 
    #> 3 11192767  Deshaun Watson HOU   QB         6700    26.3      26.2 
    #> 4 11192749  Tyreek Hill    KC    WR         6500    17.2      18.8 
    #> 5 11191861  Jarvis Landry  CLE   WR         5500    16.4      18.6 
    #> 6 11191735  Carlos Hyde    CLE   RB         4500    14.9      14.9 
    #> 7 11193209  Eagles         PHI   DST        3000    10.8      11.2 
    #> 8 11191868  Kapri Bibbs    WAS   RB         3000    13.6      12.9 
    #> 9 11192493  Hunter Henry   LAC   TE         2500     9.06      9.19

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
    #> 1 11192254  Todd Gurley II   LAR   RB         9300     26.5      27.2
    #> 2 11191533  Antonio Brown    PIT   WR         8600     24.6      25.0
    #> 3 11192767  Deshaun Watson   HOU   QB         6700     26.3      26.2
    #> 4 11191547  Mark Ingram      NO    RB         5700     16.7      18.1
    #> 5 11191861  Jarvis Landry    CLE   WR         5500     16.4      18.6
    #> 6 11192176  Sterling Shepard NYG   WR         4500     14.0      13.2
    #> 7 11191619  Jack Doyle       IND   TE         3600     11.6      11.9
    #> 8 11193209  Eagles           PHI   DST        3000     10.8      11.2
    #> 9 11191868  Kapri Bibbs      WAS   RB         3000     13.6      12.9
    #> 
    #> [[2]]
    #> # A tibble: 9 × 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300     26.5      27.2
    #> 2 11191533  Antonio Brown  PIT   WR         8600     24.6      25.0
    #> 3 11192749  Tyreek Hill    KC    WR         6500     17.2      18.8
    #> 4 11191547  Mark Ingram    NO    RB         5700     16.7      18.1
    #> 5 11191861  Jarvis Landry  CLE   WR         5500     16.4      18.6
    #> 6 11191365  Josh McCown    NYJ   QB         4800     17.5      17.9
    #> 7 11191619  Jack Doyle     IND   TE         3600     11.6      11.9
    #> 8 11193209  Eagles         PHI   DST        3000     10.8      11.2
    #> 9 11191868  Kapri Bibbs    WAS   RB         3000     13.6      12.9
    #> 
    #> [[3]]
    #> # A tibble: 9 × 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5      27.2 
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6      25.0 
    #> 3 11192767  Deshaun Watson HOU   QB         6700    26.3      26.2 
    #> 4 11192749  Tyreek Hill    KC    WR         6500    17.2      18.8 
    #> 5 11191861  Jarvis Landry  CLE   WR         5500    16.4      18.6 
    #> 6 11191735  Carlos Hyde    CLE   RB         4500    14.9      14.9 
    #> 7 11191619  Jack Doyle     IND   TE         3600    11.6      11.9 
    #> 8 11191868  Kapri Bibbs    WAS   RB         3000    13.6      12.9 
    #> 9 11191338  Cowboys        DAL   DST        2300     7.19      8.60
    #> 
    #> [[4]]
    #> # A tibble: 9 × 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5      27.2 
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6      25.0 
    #> 3 11192749  Tyreek Hill    KC    WR         6500    17.2      18.8 
    #> 4 11191517  Russell Wilson SEA   QB         6200    23.2      22.7 
    #> 5 11191861  Jarvis Landry  CLE   WR         5500    16.4      18.6 
    #> 6 11191735  Carlos Hyde    CLE   RB         4500    14.9      14.9 
    #> 7 11191362  Ravens         BAL   DST        3800    11.7      11.9 
    #> 8 11191868  Kapri Bibbs    WAS   RB         3000    13.6      12.9 
    #> 9 11192493  Hunter Henry   LAC   TE         2500     9.06      9.19
    #> 
    #> [[5]]
    #> # A tibble: 9 × 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5      27.2 
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6      25.0 
    #> 3 11192767  Deshaun Watson HOU   QB         6700    26.3      26.2 
    #> 4 11192749  Tyreek Hill    KC    WR         6500    17.2      18.8 
    #> 5 11191861  Jarvis Landry  CLE   WR         5500    16.4      18.6 
    #> 6 11191735  Carlos Hyde    CLE   RB         4500    14.9      14.9 
    #> 7 11193209  Eagles         PHI   DST        3000    10.8      11.2 
    #> 8 11191868  Kapri Bibbs    WAS   RB         3000    13.6      12.9 
    #> 9 11192493  Hunter Henry   LAC   TE         2500     9.06      9.19

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
    #>   player_id player           team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>            <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11191533  Antonio Brown    PIT   WR         8600    24.6       51.0
    #> 2 11192632  Alvin Kamara     NO    RB         8500    19.9       42.0
    #> 3 11191393  Larry Fitzgerald ARI   WR         6600    17.2       36.2
    #> 4 11191395  Philip Rivers    LAC   QB         6400    18.7       51.9
    #> 5 11191915  Marqise Lee      JAX   WR         4900     9.55      33.4
    #> 6 11193139  Mike Wallace     PHI   WR         4200    10.5       38.0
    #> 7 11191367  Frank Gore       MIA   RB         3700    11.2       37.3
    #> 8 11191354  Steelers         PIT   DST        3400     7.94      28.8
    #> 9 11192330  Jevoni Robinson  HOU   TE         2500     0         28.1
    #> 
    #> [[2]]
    #> # A tibble: 9 × 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192079  Davante Adams  GB    WR         7800    16.1       40.6
    #> 2 11193133  Julio Jones    ATL   WR         7600    17.3       33.9
    #> 3 11191363  Tom Brady      NE    QB         7200    20.7       43.4
    #> 4 11192758  Dalvin Cook    MIN   RB         6200    17.4       31.1
    #> 5 11193135  Alshon Jeffery PHI   WR         6000    12.9       43.2
    #> 6 11191512  Travaris Cadet BUF   RB         4000     4.17      33.7
    #> 7 11191563  Kendall Wright MIN   WR         3600     8.09      31.7
    #> 8 11191336  Bengals        CIN   DST        2700     6.31      35.0
    #> 9 11192918  Kevin Rader    GB    TE         2500     0         34.4
    #> 
    #> [[3]]
    #> # A tibble: 9 × 7
    #>   player_id player            team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>             <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II    LAR   RB         9300    26.5       36.4
    #> 2 11191533  Antonio Brown     PIT   WR         8600    24.6       41.7
    #> 3 11192002  Melvin Gordon III LAC   RB         6800    18.4       36.5
    #> 4 11193135  Alshon Jeffery    PHI   WR         6000    12.9       33.0
    #> 5 11192050  Robby Anderson    NYJ   WR         5700    13.1       33.2
    #> 6 11191467  Case Keenum       DEN   QB         5100    16.7       35.5
    #> 7 11192851  Saeed Blacknall   OAK   WR         3000     0         32.7
    #> 8 11191733  A.J. Derby        MIA   TE         2500     5.13      29.9
    #> 9 11191352  Jets              NYJ   DST        2400     4.44      31.4
    #> 
    #> [[4]]
    #> # A tibble: 9 × 7
    #>   player_id player          team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>           <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192079  Davante Adams   GB    WR         7800    16.1       43.4
    #> 2 11192767  Deshaun Watson  HOU   QB         6700    26.3       46.3
    #> 3 11193183  Zach Ertz       PHI   TE         6600    14.4       40.2
    #> 4 11192038  Brandin Cooks   LAR   WR         5600    14.0       36.6
    #> 5 11191936  DeVante Parker  MIA   WR         5300    10         38.4
    #> 6 11192276  Devin Funchess  CAR   WR         5200    12.4       40.0
    #> 7 11192997  Chris Carson    SEA   RB         4500     9.92      31.0
    #> 8 11191574  Derrick Coleman ARI   RB         3000     0.27      39.7
    #> 9 11191355  Chargers        LAC   DST        2800     9.94      28.7
    #> 
    #> [[5]]
    #> # A tibble: 9 × 7
    #>   player_id player         team  position salary fpts_avg fpts_proj
    #>   <chr>     <chr>          <chr> <chr>     <int>    <dbl>     <dbl>
    #> 1 11192254  Todd Gurley II LAR   RB         9300    26.5       41.8
    #> 2 11191533  Antonio Brown  PIT   WR         8600    24.6       46.8
    #> 3 11192140  Michael Thomas NO    WR         7800    17.6       36.3
    #> 4 11191547  Mark Ingram    NO    RB         5700    16.7       31.2
    #> 5 11191467  Case Keenum    DEN   QB         5100    16.7       45.3
    #> 6 11191735  Carlos Hyde    CLE   RB         4500    14.9       34.8
    #> 7 11191863  Paul Turner    NE    WR         3000     0         28.1
    #> 8 11191528  Garrett Celek  SF    TE         2600     4.91      30.9
    #> 9 11191338  Cowboys        DAL   DST        2300     7.19      24.9
