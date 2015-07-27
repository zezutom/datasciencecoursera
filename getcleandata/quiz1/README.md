Source code: [quiz1.R](https://github.com/zezutom/datasciencecoursera/blob/master/getcleandata/quiz1/quiz1.R) and [utils.R](https://github.com/zezutom/datasciencecoursera/blob/master/getcleandata/utils.R)

# Question 1
The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here: 
* https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv 

and load the data into R. The code book, describing the variable names is here:
* https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

How many properties are worth $1,000,000 or more?

```
fname <- "survey.csv"
download_if_not_exists(fname, "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv")
survey_df <- read.csv(fname, header = TRUE, sep = ",")

answer1 <- nrow(subset(survey_df, VAL == 24))

## Expected output: "There are 53 properties worth $1,000,000 or more."
msg("There are", answer1, "properties worth $1,000,000 or more.")
```
__Answer: There are 53 properties worth $1,000,000 or more.__

# Question 2
Use the data you loaded from Question 1. Consider the variable FES in the code book. Which of the "tidy data" principles does this variable violate?

```
## To answer the question, check the FES definition in the code book:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
## Note statements like these:
## ".. in .LF"
## ".. not in .LF"
## That suggests FES depends on another variable
```
__Answer: The FES definition breaks the 'Tidy data has one variable per column' principle.__

# Question 3
Download the Excel spreadsheet on Natural Gas Aquisition Program here:
* https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx

Read rows 18-23 and columns 7-15 into R and assign the result to a variable called ```dat```

What is the value of ```sum(dat$Zip*dat$Ext,na.rm=T)```?

```
fname <- "GAP.xlsx"
download_if_not_exists(fname, "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx")
dat <- read.xlsx(fname, 1, rowIndex = 18:23, colIndex = 7:15)
answer3 <- sum(dat$Zip*dat$Ext,na.rm=T)

## Expected output: "The value of sum(dat$Zip*dat$Ext,na.rm=T) is 36534720"
msg("The value of sum(dat$Zip*dat$Ext,na.rm=T) is", answer3)
```
__Answer: The value of sum(dat$Zip*dat$Ext,na.rm=T) is 36534720__

# Question 4
Read the XML data on Baltimore restaurants from here:
* https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml

How many restaurants have zipcode 21231?

```
fname <- "restaurants.xml"
download_if_not_exists(fname, "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml")
doc <- xmlParse(fname) 
answer4 <- length(xpathApply(doc, "//zipcode[text()='21231']", xmlValue))

## Expected output: "There are 127 restaurants with the zipcode 21231"
msg("There are", answer4, "restaurants with the zipcode 21231")
```
__Answer: There are 127 restaurants with the zipcode 21231__

# Question 5
The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using ```download.file()``` from here:
* https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv

Using the ```fread()``` command load the data into an R object DT.

Which of the following is the fastest way to calculate the average value of the variable ```pwgtp15``` broken down by sex using the data.table package?:

1. sapply(split(DT$pwgtp15,DT$SEX),mean)
2. tapply(DT$pwgtp15,DT$SEX,mean)
3. mean(DT$pwgtp15,by=DT$SEX)
4. DT[,mean(pwgtp15),by=SEX]
5. rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]
6. mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)

```
fname <- "housing.csv"
download_if_not_exists(fname, "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv")
DT <- fread(input = fname, sep = ",")

funs <- list(
  fun1 = function() { sapply(split(DT$pwgtp15,DT$SEX),mean) },
  fun2 = function() { tapply(DT$pwgtp15,DT$SEX,mean) },
  fun3 = function() { mean(DT$pwgtp15,by=DT$SEX) },
  fun4 = function() { DT[,mean(pwgtp15),by=SEX] },
  fun5 = function() { rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2] },
  fun6 = function() { mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15) }
)

## set to FALSE if you want to remove verbose logs below
debug <- TRUE

fastest <- NULL
min <- .Machine$integer.max

lapply(funs, function(FUN) {
  if (debug) print(FUN)
  st <- system.time(x <- try(FUN(), silent = TRUE))
  if (inherits(x, "try-error")) {
    if(debug) print("run-time error, skipping..")  
  } else {
    et <- st[3]
    if (et < min) {
      min <<- et
      fastest <<- FUN
    }
    if (debug) {
      print(paste("elapsed time:", sprintf("%.10f", et)))
      print(x)      
    }
  }
})

## The function 'mean(DT$pwgtp15,by=DT$SEX)' should be the fastest one.
print("The fastest calculation is:")
print(fastest)
msg("with running time of", sprintf("%.10f", min), "seconds")
```
__Answer: The function ```mean(DT$pwgtp15,by=DT$SEX)``` should be the fastest one.__
