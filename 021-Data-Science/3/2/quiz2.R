## Question 1
## Github API
library(jsonlite)
library(httpuv)
library(httr)

oauth_endpoints("github")
myapp <- oauth_app(appname = "test-app",
                   key = "######79581f21######",
                   secret = "######0cd1da375c5203be1bd4e7d40264######")
# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "jtleek/datasharing", "created_at"] 


# Question 2
## The sqldf package allows for execution of SQL commands on R data frames. 
## We will use the sqldf package to practice the queries we might send with the 
## dbSendQuery command in RMySQL.

## Download the American Community Survey data and load it into an R object called acs
## Which of the following commands will select only the data for the probability weights pwgtp1 with ages less than 50?
url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv'
download.file(url=url,destfile = 'survey.csv')
acs <- read.csv('survey.csv')
library(sqldf)
sqldf("select pwgtp1, AGEP from acs where AGEP < 50")

## Question 3
## Using the same data frame you created in the previous problem, 
## what is the equivalent function to unique(acs$AGEP)
unique(acs$AGEP)
sqldf("select distinct AGEP from acs")

## Question 4
##
## How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page:
##http://biostat.jhsph.edu/~jleek/contact.html

url <- 'http://biostat.jhsph.edu/~jleek/contact.html'
con <- url(url)
htmlCode <- readLines(con = con)
sapply(htmlCode[c(10,20,30,100)], nchar)

## Question 5
## Read this data set into R and report the sum of the numbers in the fourth of the nine columns.

## https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for
url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for'
download.file(url=url, destfile = 'wksst8110.for')
data <- read.fwf('wksst8110.for',
                 widths=c(10,5,4,1,3,5,4,1,3,5,4,1,3,5,4,1,3),
                 skip=4)
data <- data[,c("V1","V3","V5","V7","V9","V11","V13","V15","V17")]
sum(data$V7)

