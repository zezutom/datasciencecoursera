Source code: [quiz4.R](https://github.com/zezutom/datasciencecoursera/blob/master/getcleandata/quiz1/quiz4.R) and [utils.R](https://github.com/zezutom/datasciencecoursera/blob/master/getcleandata/utils.R)

# Question 1
The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here: 

https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv 

and load the data into R. The code book, describing the variable names is here: 

https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf 

Apply ```strsplit()``` to split all the names of the data frame on the characters "wgtp". 

What is the value of the 123 element of the resulting list?

```
fname <- "survey.csv"
download_if_not_exists(fname, "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv")
survey_df <- read.csv(fname, header = TRUE, sep = ",")
answer1 <- strsplit(names(survey_df), "wgtp")[[123]]
print("The value of the 123th element is:")

# Expected output: ""   "15"
print(answer1)
```
__Answer:__ ""   "15"

# Question 2
Load the Gross Domestic Product data for the 190 ranked countries in this data set: 

https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 

Remove the commas from the GDP numbers in millions of dollars and average them. 

What is the average? 

Original data sources: http://data.worldbank.org/data-catalog/GDP-ranking-table

```
fname <- "gdp.csv"
download_if_not_exists(fname, "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv")

# First 4 rows are rubbish, skip them
#
# Secondly, according to this source: http://data.worldbank.org/data-catalog/GDP-ranking-table
# there are 214 economies, i.e select first 215 rows, as the 1st row is a header
#
# Finally, select the relevant columns and rename them, so that they match column names in the "edu" data set
gdp <- read.csv(fname, skip = 4, nrows = 215) %>%
  subset(!is.na(X) & X != "", select = c("X", "X.1", "X.3", "X.4")) %>%
  rename(CountryCode = X, rankingGDP = X.1, Long.Name = X.3, gdp = X.4)

answer2 <- gsub(",", "", gdp$gdp) %>%
           as.numeric %>%
           mean(na.rm = TRUE)

# Expected output: "The average GDP is 377652.421052632"
msg("The average GDP is", answer2)
```
__Answer:__ 377652.4

# Question 3
In the data set from Question 2 what is a regular expression that would 
allow you to count the number of countries whose name begins with "United"? 

Assume that the variable with the country names in it is named countryNames. 

How many countries begin with United?

```
# Let's assume countries are represented by their 'long names'
countryNames <- gdp$Long.Name

# Regular expression to count the number of countries whose name begins with "United"
answer3.1 <- grep("^United", countryNames)

# So, how many countries begin with United?
answer3.2 <- length(answer3.1)

msg("Regex to find countries beginning with 'United':", "grep('^United', countryNames)")

# Expected output: "Number of such countries: 3"
msg( "Number of such countries:", answer3.2)
```
__Answer:__ grep("^United", countryNames), 3

# Question 4
Load the Gross Domestic Product data for the 190 ranked countries in this data set: 

https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 

Load the educational data from this data set: 

https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv 

Match the data based on the country shortcode. 

Of the countries for which the end of the fiscal year is available, how many end in June? 

Original data sources: 
http://data.worldbank.org/data-catalog/GDP-ranking-table 
http://data.worldbank.org/data-catalog/ed-stats

```
# For the GDP data we continue using the 'gdp' variable created earlier in this script

# Educational data
fname <- "edu.csv"
download_if_not_exists(fname, "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv")
edu <- read.csv(fname, header = TRUE, sep = ",")

# Match the data based on the country shortcode
merged <- merge(gdp, edu, all = TRUE, by = "CountryCode")

# Bash alternative: grep -i "fiscal year end.*june" edu.csv | wc -l
answer4 <- "fiscal year end.*june" %>% 
           grep(merged$Special.Notes %>% tolower) %>% 
           length

# Expected output: "There are 13 countries whose fiscal year ends in June"
msg("There are", answer4, "countries whose fiscal year ends in June")
```
__Answer:__ 13

# Question 5
You can use the quantmod (http://www.quantmod.com/) package to get historical stock prices for publicly traded companies on the NASDAQ and NYSE. 

Use the following code to download data on Amazon's stock price and get the times the data was sampled.

```
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn) 
```

How many values were collected in 2012? 

How many values were collected on Mondays in 2012?

```
amzn <- getSymbols("AMZN",auto.assign=FALSE)
sampleTimes <- index(amzn)

# Table: 
#  cols .. year, ${weekday_name} (Monday ..), Total
#  rows .. collected values per year and weekday & row sum
DF <- table(Year = year(sampleTimes), weekdays(sampleTimes)) %>% 
      addmargins(FUN = list(Total = sum), quiet = TRUE) %>%
      as.data.frame

# Let's use meaningful column labels
colnames(DF) <- c("Year", "Value", "Count")

# A custom filter
filterDF <- function(value) {
  subset(DF, Year == 2012 & Value == value, select = Count)
}

# How many values were collected in 2012?
answer5.1 <- filterDF("Total")

# How many values were collected on Mondays in 2012?
answer5.2 <- filterDF("Monday")

# Expected output: "There were 250 values collected in 2012"
msg("There were", answer5.1, "values collected in 2012")

# Expected output: "47 values were collected on Mondays in 2012"
msg(answer5.2, "values were collected on Mondays in 2012")
```
__Answer:__ 250, 47
