corr <- function(directory, threshold=0) {
    # Prepare filenames
    fileNames <- list.files(directory, full.names = TRUE)
    
    # Read files from directory into list
    tmp <- lapply(fileNames, data.table::fread)
    
    # Bind list into a data frame
    dat <- rbindlist(tmp)
    
    # Filter complete cases/ number above threshold and calculate correlation
    dat <- dat[complete.cases(dat), 
               .(nobs = .N, corr = cor(x = sulfate, y = nitrate)), 
               by = 'ID'][nobs>threshold]
    
    # Return result
    return(dat[,corr]) 
}

cr <- corr("specdata", 150)
head(cr)
summary(cr)
