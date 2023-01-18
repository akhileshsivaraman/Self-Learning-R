##### R for Data Science ####
# https://r4ds.had.co.nz/index.html

library(tidyverse)

#### Definitions ####
# tidying = formatting the data such that each column is a variable and each row is an observation
# transforming = narrowing in on observations of interest, creating new variables from existing ones, calculating summary statistics, etc
# wrangling = tidying + transforming


#### 5 Data Transformation ####
library(nycflights13)

#### dplyr - 5 key functions ####
# filter() picks observations by their values
# arrange() reorders rows
# mutate() creates new variables with functions of existing variables
# select() picks variables by their names
# summarise() collapses many values down to a single summary
# all these functions can be used in conjunction with group_by() which tells the function to operate on a group-by-group basis rather than on the entire dataset

#### filter rows ####
# second and subsequent arguments in filter() are expressions that filter the data frame
# the expressions define the variable too

# select all flights on Jan 1st
jan1 <- filter(flights, month == 1, day == 1)

## logical operators
# & = and, so every expression must be true in order for a row to be included
# | = or
# ! = not

# select all flights in Nov and Dec
nov_dec <- filter(flights, month == 11 | month == 12)
# alternatively can use the shorthand x %in% y
# which rows does x, the variable, take the value of y
nov_dec1 <- filter(flights, month %in% c(11, 12))

# selecting all flights that arrived more than 2 hours late
filter(flights, arr_delay > 120)

## missing values
# filter() only includes rows where the condition is TRUE so it excludes both FALSE and NA values
# if you want to preserve missing values, ask for them explicitly with is.na()


#### arrange/re-order ####
# works similarly to filter()
# takes a data frame and a set of column names to order by
arrange(flights, year, month, day)

# sort to find the most delayed flights
arrange(flights, arr_delay)
# sort to find the shortest flights
arrange(flights, distance)
# sort to find the longest flights, use desc() to flip the order
arrange(flights, desc(distance))


#### select columns ####
# allows you to rapidly zoom in on a useful subset using operations based on the names of the variables

# select columns by name
select(flights, year, month, day)

# select all columns between year and day
select(flights, year:day)

# select all columns except those from year to day
select(flights, -(year:day))

## helper functions you can use within select()
# starts_with("abc") - matches names that begin with "abc"
# ends_with("abc")
# contains("abc")
# matches("abc") - selects variables that match a regular expression
# num_range("x", 1:3) - matches x1, x2, x3


#### adding new variables with mutate ####
# adds new columns at the end of the dataset
# name the variables then express how to calculate them
# the variables used to calculate the new variables must be vectorised
mutate(flights, 
       gain = dep_delay - arr_delay,
       speed = distance/air_time * 60)

# if you only want to keep the new variables use transmute()
transmute(flights, 
          gain = dep_delay - arr_delay,
          speed = distance/air_time * 60)


#### grouped summaries with summarise() ####
# collapses a data frame into a single row
summarise(flights, delay = mean(dep_delay, na.rm = TRUE)) # need to remove NA otherwise the output will be NA as there are NAs in the input

# we can use group_by() to calculate summaries for individual groups
by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))


## counts
# whenever you do an aggregation, it is always a good idea to include either a count or a count of non-missing values
not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))

delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarise(delay = mean(arr_delay))
ggplot(delays, aes(delay)) +
  geom_freqpoly()

delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarise(delay = mean(arr_delay, na.rm = T),
            n = n())
ggplot(delays, aes(n, delay)) +
  geom_point(alpha = 0.1)