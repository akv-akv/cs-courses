## Packages
library(utils)
library(dplyr)
library(readr)

## Download file and prepare date
url = 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
download.file(url=url,destfile = 'data/pc.zip')
unzip('data/pc.zip', exdir='./data')
data <- read_delim('data/household_power_consumption.txt', 
                   delim=';', 
                   na = c('','?','NA'),
                   col_types = cols(Date = col_date('%d/%m/%Y'),
                                    Time = col_time(format = ""),
                                    Global_active_power = col_double(),
                                    Global_reactive_power = col_double(),
                                    Voltage = col_double(),
                                    Global_intensity = col_double(),
                                    Sub_metering_1 = col_double(),
                                    Sub_metering_2 = col_double(),
                                    Sub_metering_3 = col_double()))


data <- data %>% filter(Date == '2007-02-01' | Date == '2007-02-02') %>% 
    mutate(DateTime = parse_datetime(paste(Date,Time,sep = ' ')))

## Plot 2
png(filename = 'plot2.png')
plot(data$DateTime, data$Global_active_power,
     ylab = 'Global Active Power (kilowatts)',
     xlab = '',
     type = 'l')
dev.off()