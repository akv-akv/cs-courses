Programming Assignment 3
================
Kirill Avilenko
10/1/2020

## Data explotation

### Outcome of care measures

The Outcome of Care Measures.csv table contains forty seven (47) fields.
This table provides each hospital’s risk-adjusted 30-Day Death
(mortality) and 30-Day Readmission category and rate.

Read data from given CSV file:

``` r
outcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
```

### Hospitals

## Part 1: Plot 30-Days mortality rates from heart attack

In order to plot 30-days mortality rates from heart attack we need to
find and prepare data from “outcome-of-care-measures” table. The
required info is given in column 11, but it is stored as a character.

``` r
str(outcome[,11])
```

    ##  chr [1:4706] "14.3" "18.5" "18.1" "Not Available" "Not Available" ...

Convert data to numeric format and check data:

``` r
outcome[, 11] <- as.numeric(outcome[, 11]);
```

    ## Warning: NAs introduced by coercion

``` r
str(outcome[,11])
```

    ##  num [1:4706] 14.3 18.5 18.1 NA NA NA 17.7 18 15.9 NA ...

Plot the histogram for 30-days mortality rate from heart attack:

``` r
hist(outcome[, 11], 
     main='Hospital 30-Day Death (Mortality) Rates from Heart Attack', 
     xlab='Deaths', 
     col='red')
```

![](progAssignment3_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

## Part 2: Best hospital in a state

In order to define best hospital in a state we need to design a function
that takes two arguments: \* 2-character state code \* Outcome name -
“heart attack”, “heart failure” and “pneumonia” and returns hospital
name.

``` r
best <- function(state, outcome) {
    ## Read outcome data
    outcomeTbl <- read.csv("outcome-of-care-measures.csv", colClasses = "character")

    ## Check that state is valid
    if (!state %in% unique(outcomeTbl[['State']])) {
        stop('invalid state') ## Throw an error with information message
    }
    ## Check if outcome is valid
    if (!outcome %in% c('heart attack', 'heart failure', 'pneumonia')) {
        stop('invalid outcome')
    }
    
    ## Return hospital name in that state with lowest 30-day death ## rate
}
```

## Ranking hospitals by outcome in a state

## Ranking hospitals in all states
