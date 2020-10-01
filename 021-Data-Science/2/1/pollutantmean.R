pollutantmean <- function(directory, pollutant, id=1:332) {
    ## Create data frame
    dat <- data.frame()
    ## Read CSV into data file
    for(i in id) {
        # Get full path to file
        fnumber <- str_pad(string=toString(i), width=3, pad='0')
        filename <- paste(directory,'/', fnumber,'.csv',sep="")
        # Read file into data frame
        dat <- rbind(dat, read.csv(filename))
    }
    ## Prepare subset with specific pollutant
    subset <- dat[,pollutant]
    ## Calculate mean
    mean(subset, na.rm = TRUE)
}
