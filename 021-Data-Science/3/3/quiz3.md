Coursera - Getting and Cleaning Data Quiz 3
================
Kirill Avilenko
10/12/2020

# Question 1

The American Community Survey distributes downloadable data about United
States communities. Download the 2006 microdata survey about housing for
the state of Idaho using download.file() from here:

``` r
q1datapath <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'
```

and load the data into R. The code book, describing the variable names
is here:

``` r
q1cbpath <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf'
```

Create a logical vector that identifies the households on greater than
10 acres who sold more than $10,000 worth of agriculture products.
Assign that logical vector to the variable agricultureLogical. Apply the
which() function like this to identify the rows of the data frame where
the logical vector is TRUE. which(agricultureLogical)

``` r
## Download data and read into R
download.file(q1datapath, destfile = 'data/q1data.csv')
q1data <- read.csv('data/q1data.csv')
download.file(q1cbpath, 'data/q1codebook.pdf')

## Set header to lower
names(q1data) <- names(q1data) %>% tolower()

## Create logical vector
agricultureLogical <- q1data$acr == 3 & q1data$ags == 6

## What are the first 3 values that result?
head(which(agricultureLogical), 3)
```

    ## [1] 125 238 262

# Question 2

Using the jpeg package read in the following picture of your instructor
into R

``` r
q2jpgpath <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg'
```

Use the parameter native=TRUE. What are the 30th and 80th quantiles of
the resulting data? (some Linux systems may produce an answer 638
different for the 30th quantile)

``` r
library(jpeg)
## Download data
download.file(q2jpgpath,destfile = 'data/q2.jpg')
q1data <- readJPEG('data/q2.jpg',native = TRUE)

## Getting answer
quantile(q1data, probs = c(0.3, 0.8)) 
```

    ##       30%       80% 
    ## -15259150 -10575416

# Question 3

Load the Gross Domestic Product data for the 190 ranked countries in
this data set:

``` r
q3gdpdatapath <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv'
```

Load the educational data from this data set:

``` r
q3eddatapath <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv'
```

Match the data based on the country shortcode. How many of the IDs
match? Sort the data frame in descending order by GDP rank (so United
States is last). What is the 13th country in the resulting data frame?

``` r
## Download data
library(readr)
library(dplyr)
download.file(q3gdpdatapath,'data/q3gdp.csv')
download.file(q3eddatapath,'data/q3ed.csv')
q3gdp <- read_csv('data/q3gdp.csv')
```

    ## Warning: Missing column names filled in: 'X1' [1], 'X3' [3], 'X4' [4], 'X5' [5],
    ## 'X6' [6], 'X7' [7], 'X8' [8], 'X9' [9], 'X10' [10]

    ## Parsed with column specification:
    ## cols(
    ##   X1 = col_character(),
    ##   `Gross domestic product 2012` = col_character(),
    ##   X3 = col_logical(),
    ##   X4 = col_character(),
    ##   X5 = col_character(),
    ##   X6 = col_character(),
    ##   X7 = col_logical(),
    ##   X8 = col_logical(),
    ##   X9 = col_logical(),
    ##   X10 = col_logical()
    ## )

``` r
q3ed <- read_csv('data/q3ed.csv')
```

    ## Parsed with column specification:
    ## cols(
    ##   .default = col_character(),
    ##   `National accounts reference year` = col_double(),
    ##   `System of National Accounts` = col_double(),
    ##   `PPP survey year` = col_double(),
    ##   `Latest industrial data` = col_double(),
    ##   `Latest trade data` = col_double(),
    ##   `Latest water withdrawal data` = col_double()
    ## )

    ## See spec(...) for full column specifications.

``` r
## Read data
q3data <- read_csv('data/q3gdp.csv', skip=5, n_max=190, col_names = FALSE) %>% 
    select(c(1,2,4,5)) %>%
    rename(CountryCode = 'X1',Ranking = 'X2', Economy = 'X4', Value = 'X5') %>%
    mutate(Ranking = as.numeric(Ranking), Value = as.numeric(Value)) 
```

    ## Parsed with column specification:
    ## cols(
    ##   X1 = col_character(),
    ##   X2 = col_double(),
    ##   X3 = col_logical(),
    ##   X4 = col_character(),
    ##   X5 = col_number(),
    ##   X6 = col_character(),
    ##   X7 = col_logical(),
    ##   X8 = col_logical(),
    ##   X9 = col_logical(),
    ##   X10 = col_logical()
    ## )

``` r
## Join tables
q3merged <- q3data %>%
    left_join(q3ed, by='CountryCode')

## 13th country
q3data %>%
    arrange(desc(Ranking)) %>% 
    select(Economy) %>% 
    filter(row_number()==13)
```

    ## # A tibble: 1 x 1
    ##   Economy            
    ##   <chr>              
    ## 1 St. Kitts and Nevis

``` r
## Matches 
setdiff(q3data$CountryCode, q3ed$CountryCode)
```

    ## [1] "SSD"

# Question 4

What is the average GDP ranking for the “High income: OECD” and “High
income: nonOECD” group?

# Question 5

Cut the GDP ranking into 5 separate quantile groups. Make a table versus
Income.Group. How many countries are Lower middle income but among the
38 nations with highest GDP?
