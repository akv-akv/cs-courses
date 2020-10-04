## Getting and cleaning data quiz

## Question 1
## The American Community Survey distributes downloadable data about United States communities. 
## Download the 2006 microdata survey about housing for the state of Idaho 
## using download.file() from here:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
## and load the data into R. The code book, describing the variable names is here:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
## How many properties are worth $1,000,000 or more?

## Solution:
## Download CSV file and codebook
urlfile <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'
urlcode <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf'
download.file(url = urlfile, destfile = 'housing_survey.csv')
download.file(url = urlcode, destfile = 'housing_survey_code.pdf')

## Read CSV
data <- read.csv('housing_survey.csv')

## Filter non-na values from column VAL
values <- data[!is.na(data["VAL"]), "VAL"]

## Filter values equal to 24 (in accordance with codebook 24 means > $1mln)
length(values[values == 24])


# Question 3
## Download the Excel spreadsheet on Natural Gas Aquisition Program here:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx
## Read rows 18-23 and columns 7-15 into R and assign the result to a variable called: dat
## What is the value of: sum(dat$Zip*dat$Ext,na.rm=T)

## Download raw data
urlfile <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx'
download.file(url = urlfile, destfile = 'NGAP.xlsx')

## Read data
dat <- readxl::read_xlsx(path = 'NGAP.xlsx', range = "R18C7:R23C15")
sum(dat$Zip*dat$Ext, na.rm = T)



## Question 4
## Read the XML data on Baltimore restaurants from here:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml
## How many restaurants have zipcode 21231?

## Download raw data
urlfile <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml'
download.file(url = urlfile, destfile = 'restaurants.xml')

## Read data
library(XML)
doc <- xmlTreeParse('restaurants.xml', useInternalNodes = TRUE)
rootNode <- xmlRoot(doc)

## Parse list of values of tag "zipcode"
code <- xpathSApply(rootNode,"//zipcode",xmlValue)

## Count 21231 zip-codes
length(code[code == 21231])


## Question 5

## The American Community Survey distributes downloadable data about United States communities. 
## Download the 2006 microdata survey about housing for the state of Idaho 
## using download.file() from here:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv
## using the fread() command load the data into an R object DT
## The following are ways to calculate the average value of the variable 'pwgtp15'
## broken down by sex. Using the data.table package, which will deliver the fastest user time?

## Download raw data
urlfile = 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv'
download.file(url = urlfile, destfile = 'housing_survey_Idaho.csv')

# Read data 
library(data.table)
DT <- fread('housing_survey_Idaho.csv')

# Calculate time for different options:
system.time(tapply(DT$pwgtp15,DT$SEX,mean))
system.time(mean(DT[DT$SEX==1,]$pwgtp15))
system.time(mean(DT[DT$SEX==2,]$pwgtp15))
system.time(mean(DT$pwgtp15, by=DT$SEX))
system.time(DT[,mean(pwgtp15),by=SEX])
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))






