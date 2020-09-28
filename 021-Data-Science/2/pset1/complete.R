complete <- function(directory, id=1:332) {
    # Prepare filenames
    fnumber <- str_pad(string=toString(id), width=3, pad='0')
    fileNames <- paste0(directory,'/', fnumber,'.csv',sep="")

    # Read files from directory into list
    tmp <- lapply(fileNames, data.table::fread)
    
    # Bind list into a data frame
    dat <- rbindlist(tmp)
    
    # Return number of complete cases grouped by ID
    return(dat[complete.cases(dat), .(nobs = .N), by = 'ID'])
}