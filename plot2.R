library(lubridate)


# reading the data
data <- read.table(
    "./data/household_power_consumption.txt",
    sep = ";",
    header = TRUE)

# subsetting only two dates: 2007-02-01, 2007-02-02
data <- data[(data$Date == "1/2/2007") | (data$Date == "2/2/2007") ,]

# convert variables to numeric
cols.num <- names(data)[3:9]
data[cols.num] <- sapply(data[cols.num], as.numeric)

# extracting time in POSIXct format
#
# Note: According to the dataset description, the time zone is "Europe/Paris"
# or "CET".
only_date <- dmy(data$Date)
only_time <- hms(data$Time)
data['POSIXct'] <- as.POSIXct(
    (24*3600)*(as.numeric(only_date) + (hour(only_time) - 1)/24 + minute(only_time)/(24*60)),
    origin = '1970-01-01',
    tz = "Europe/Paris")
data$Date <- NULL
data$Time <- NULL

# plotting the graph
png("plot2.png")
plot(
    data$POSIXct,
    data$Global_active_power,
    type = "l",
    xlab = "datetime",
    ylab = "Global Active Power (kilowatts)")
dev.off()
