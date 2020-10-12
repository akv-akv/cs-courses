Coursera - Getting and Cleaning Data - Quiz 4
================
Kirill Avilenko
10/12/2020

# Question 1

The American Community Survey distributes downloadable data about United
States communities. Download the 2006 microdata survey about housing for
the state of Idaho using download.file() from here:

<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv>

and load the data into R. The code book, describing the variable names
is here:

<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf>

Apply strsplit() to split all the names of the data frame on the
characters “wgtp”. What is the value of the 123 element of the resulting
list? 1 point

# Question 2

Load the Gross Domestic Product data for the 190 ranked countries in
this data set:

<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv>

Remove the commas from the GDP numbers in millions of dollars and
average them. What is the average?

Original data sources:

<http://data.worldbank.org/data-catalog/GDP-ranking-table>

# Question 3

In the data set from Question 2 what is a regular expression that would
allow you to count the number of countries whose name begins with
“United”? Assume that the variable with the country names in it is
named countryNames. How many countries begin with United?

# Question 4

Load the Gross Domestic Product data for the 190 ranked countries in
this data set:

<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv>

Load the educational data from this data set:

<https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv>

Match the data based on the country shortcode. Of the countries for
which the end of the fiscal year is available, how many end in June?

Original data sources:

<http://data.worldbank.org/data-catalog/GDP-ranking-table>

<http://data.worldbank.org/data-catalog/ed-stats>

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
sampleTimes = index(amzn)
```
