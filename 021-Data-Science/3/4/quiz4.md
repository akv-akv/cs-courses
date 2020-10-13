Coursera - Getting and Cleaning Data - Quiz 4
================
Kirill Avilenko
10/12/2020

# Question 1

The American Community Survey distributes downloadable data about United
States communities. Download the 2006 microdata survey about housing for
the state of Idaho using download.file() from here:

and load the data into R. The code book, describing the variable names
is here:

Apply strsplit() to split all the names of the data frame on the
characters “wgtp”. What is the value of the 123 element of the resulting
list? 1 point

``` r
# Download data
q1data <- data.table::fread(q1datapath)
splitnames <- strsplit(names(q1data), "wgtp") 
splitnames[123]
```

    ## [[1]]
    ## [1] ""   "15"

# Question 2

Load the Gross Domestic Product data for the 190 ranked countries in
this data set:

Remove the commas from the GDP numbers in millions of dollars and
average them. What is the average?

``` r
# Download data
q2data <- data.table::fread(q2datapath,skip=5,nrows =190,select=c(1,2,4,5),
                            col.names = c('country','ranking','economy','value'),
                            encoding = "UTF-8")

#Answer
gsub(',','',q2data$value) %>% as.numeric %>% mean()
```

    ## [1] 377652.4

# Question 3

In the data set from Question 2 what is a regular expression that would
allow you to count the number of countries whose name begins with
“United”? Assume that the variable with the country names in it is
named countryNames. How many countries begin with United?

``` r
#Answer
length(grep("^United",q2data$economy))
```

    ## [1] 3

# Question 4

Load the Gross Domestic Product data for the 190 ranked countries in
this data set:

Load the educational data from this data set:

Match the data based on the country shortcode. Of the countries for
which the end of the fiscal year is available, how many end in June?

``` r
library(readr)
library(dplyr)

## Read data
q4gdpdata <- data.table::fread(q4gdpdatapath,skip=5,nrows =190,select=c(1,2,4,5),
                            col.names = c('CountryCode','ranking','economy','value'),
                            encoding = "UTF-8") %>%
    mutate(ranking = as.numeric(ranking), value = as.numeric(value)) 
```

    ## Warning: Problem with `mutate()` input `value`.
    ## ℹ NAs introduced by coercion
    ## ℹ Input `value` is `as.numeric(value)`.

    ## Warning in mask$eval_all_mutate(dots[[i]]): NAs introduced by coercion

``` r
q4eddata <- data.table::fread(q4eddatapath)

## Join tables
q4merged <- q4gdpdata %>%
    left_join(q4eddata, by='CountryCode')

## Answer
length(grep('Fiscal year end: June 30',q4merged$`Special Notes`))
```

    ## [1] 13

# Question 5

You can use the quantmod (<http://www.quantmod.com/>) package to get
historical stock prices for publicly traded companies on the NASDAQ and
NYSE. Use the following code to download data on Amazon’s stock price
and get the times the data was sampled.

How many values were collected in 2012? How many values were collected
on Mondays in 2012?

``` r
library(quantmod)
```

    ## Loading required package: xts

    ## Loading required package: zoo

    ## 
    ## Attaching package: 'zoo'

    ## The following objects are masked from 'package:base':
    ## 
    ##     as.Date, as.Date.numeric

    ## 
    ## Attaching package: 'xts'

    ## The following objects are masked from 'package:dplyr':
    ## 
    ##     first, last

    ## Loading required package: TTR

    ## Registered S3 method overwritten by 'quantmod':
    ##   method            from
    ##   as.zoo.data.frame zoo

    ## Version 0.4-0 included new data defaults. See ?getSymbols.

``` r
amzn = getSymbols("AMZN",auto.assign=FALSE)
```

    ## 'getSymbols' currently uses auto.assign=TRUE by default, but will
    ## use auto.assign=FALSE in 0.5-0. You will still be able to use
    ## 'loadSymbols' to automatically load data. getOption("getSymbols.env")
    ## and getOption("getSymbols.auto.assign") will still be checked for
    ## alternate defaults.
    ## 
    ## This message is shown once per session and may be disabled by setting 
    ## options("getSymbols.warning4.0"=FALSE). See ?getSymbols for details.

``` r
sampleTimes = as.Date(index(amzn))

#answer1
length(sampleTimes[sampleTimes >= "2012-01-01" & sampleTimes < "2013-01-01"])
```

    ## [1] 250

``` r
length(sampleTimes[sampleTimes >= "2012-01-01" & sampleTimes < "2013-01-01" &
           weekdays(sampleTimes) == 'Monday'])
```

    ## [1] 47
