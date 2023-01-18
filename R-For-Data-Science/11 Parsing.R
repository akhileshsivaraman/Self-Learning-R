##### R for Data Science ####
# https://r4ds.had.co.nz/index.html

library(tidyverse)

##### 11 Parsing #####
#### 11.4 Parsing a file ####
# functions in the readr package read rectangular data
# while they read, the functions guess the type of each column (e.g. logical, integer, time, date, etc)
# although all the observations in each column might not be the same, readr will assign all observations a type based on what most of them are
# these guesses don't always work in large files because readr uses the first 1000 rows to make the guesses
# this can lead to parsing problems
challenge <- read_csv(readr_example("challenge.csv"))
problems(challenge) # use problems() to identify parsing failures
# we can then work column by column to sort out parsing problems
tail(challenge)
# e.g. were the y column to not be <date>, we can then use the following call to specify the column type
challnege <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_date() # specify y as a date column
  )
)

# alternatively, we can tell the function to guess using more than the default 1000 rows
challenge2 <- read_csv(readr_example("challenge.csv"), guess_max = 1001)

# or to make diagnosing problems easier, you can read all the columns in as character vectors
# then use type_convert() to apply th parsing heuristics to the character columns in a data frame
challenge3 <- read_csv(readr_example("challenge.csv"),
                       col_types = cols(.default = col_character()))
type_convert(challenge3)


#### 11.5 Writing to a file ####
# write_csv() or write_tsv()
# these increase the chances of the output file being read back correctly
# but CSVs do not retain the column type so you may have to specify those again
# alternatively, you can use write_rds() to store data in RDS format - a binary format for R
# the feather package also implements a binary file format and it can be shared across languages
# write_feather("xyz.feather")


#### 11.6 Other types of data ####
# these packages read data from other programming languages/sources
# haven reads SPSS, Stata and SAS files
# readxl reads excel files
# DBI along with a database specific backend (e.g. RPostgreSQL) allows you to run SQL queries against a database and return a data frame
# jsonlite for json objects
# xml2 for XML files