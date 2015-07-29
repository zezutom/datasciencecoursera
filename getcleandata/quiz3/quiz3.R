source("utils.R")
set_wd("quiz3")

load_packages("jpeg", "dplyr", "data.table", "Hmisc")

# Question 1
#
# The American Community Survey distributes downloadable data about United States 
# communities. Download the 2006 microdata survey about housing for the state of Idaho 
# using download.file() from here: 
#
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv 
#
# and load the data into R. The code book, describing the variable names is here: 
#
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
#
# Create a logical vector that identifies the households on greater than 10 acres 
# who sold more than $10,000 worth of agriculture products. Assign that logical vector 
# to the variable agricultureLogical. Apply the which() function like this to identify 
# the rows of the data frame where the logical vector is TRUE. which(agricultureLogical) 
#
# What are the first 3 values in that result?

fname <- "survey.csv"
download_if_not_exists(fname, "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv")
survey_df <- read.csv(fname, header = TRUE, sep = ",")

# greater than 10 acres and sold more than $10,000
agricultureLogical <- (survey$ACR == 3 & survey$AGS == 6)

answer1 <- which(agricultureLogical)

# Expected output: "First 3 values are: 125, 238, 262"
msg("First 3 values are:", stringify(answer1[1:3]))

# Question 2
#
# Using the jpeg package read in the following picture of your instructor into R
#
# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
#
# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting 
# data? (some Linux systems may produce an answer 638 different for the 30th quantile)

fname <- "jeff.jpg"
download_if_not_exists(fname, "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg")
jpg <- readJPEG(jpegFile, native = TRUE)

answer2 <- quantile(pic, c(0.3, 0.8))

# Expected output: "The 30th and 80th quantiles are:  -15259150.1, -10575416"
msg("The 30th and 80th quantiles are: ", stringify(answer2))

# Question 3
# 
# Load the Gross Domestic Product data for the 190 ranked countries in this data set: 
#   
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 
#
# Load the educational data from this data set: 
#  
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv 
#
# Match the data based on the country shortcode. How many of the IDs match? 
# 
# Sort the data frame in descending order by GDP rank (so United States is last). 
#
# What is the 13th country in the resulting data frame? 
#
# Original data sources: 
# http://data.worldbank.org/data-catalog/GDP-ranking-table 
# http://data.worldbank.org/data-catalog/ed-stats
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

fname <- "edu.csv"
download_if_not_exists(fname, "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv")
edu <- read.csv(fname, header = TRUE, sep = ",")

# Merge the two sets by the country shortcode.
merged <- merge(gdp, edu, all = TRUE, by = "CountryCode")

# How many of the IDs match?
answer3.1 <- sum(!is.na(unique(merged$rankingGDP)))

# Sort the data frame in descending order by GDP rank (so United States is last). 
# What is the 13th country in the resulting data frame?
answer3.2 <- subset(merged, select = c(rankingGDP, Long.Name.x))
answer3.2 <- answer3.2[order(answer3.2$rankingGDP, decreasing = TRUE), "Long.Name.x"][13]

# Expected output: "There are 189 matches, 13th country is St. Kitts and Nevis"
msg("There are", answer3.1, "matches, 13th country is", answer3.2)

# Question 4
#
# What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?
avg_rank <- function(label) {
  income_group <- subset(merged, merged$Income.Group == label)
  mean(as.numeric(income_group$rankingGDP), na.rm = TRUE)
}
answer4.oecd <- avg_rank("High income: OECD")
answer4.non.oecd <- avg_rank("High income: nonOECD")
msg("High income OECD:", answer4.oecd, "High income nonOECD:", answer4.non.oecd)

# Question 5
#
# Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. 
# How many countries are Lower middle income but among the 38 nations with highest GDP?

# Create a data table with a minimum number columns to preserve memory
DT <- subset(merged, select = c(Income.Group, rankingGDP)) %>%
      mutate(quantileGDP = cut2(rankingGDP, g = 5)) %>%
      data.table

# Select the number of countries falling into the required category (quantile)
answer5 <- DT[Income.Group == "Lower middle income", .N, 
              by = c("Income.Group", "quantileGDP")] %>%
           subset(quantileGDP == "[  1, 39)", select = N)

# Expected output: "There are 5 countries with Lower middle income but among the 38 nations with highest GDP"
msg("There are", answer5, "countries with Lower middle income but among the 38 nations with highest GDP")

resume_wd()