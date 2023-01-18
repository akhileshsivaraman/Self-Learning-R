##### R for Data Science ####
# https://r4ds.had.co.nz/index.html

library(tidyverse)

##### 13 Relational Data #####
# relational data = multiple tables of data
# relations are defined between a pair of tables
# therefore the relations of three or more tables are always a property of the relations between each pair

# there are three verbs to working with pairs of tables:
# mutating joins: add new variables to one data frame from matching observations in another
# filtering joins: filter observations from one data frame based on whether or not they match an observation in the other table
# set opreations: treat observations as if they were set elements

library(nycflights13)

#### 13.2 nycflights13 ####
# nycflights13 contains 5 tibbles
airlines
airports
planes
weather
flights
# the first 4 tibbles are connected to flights by having at least one variable in common

#### 13.3 Keys ####
# variables used to connect each pair of tables are called keys
# key = a variable or a set of variables that uniquely identifies an observation
# there are two types of key:
# primary key = uniquely identifies an observation in its own table
# foreign key = uniquely identifies an observation in another table
# a variable can be both

# once you've identified primary keys in your tables, it's good practice to verify that they do uniquely identify each observation
# one way to do that is to count() the primary keys and look for entries where n > 1
planes %>%
  count(tailnum) %>%
  filter(n > 1)
# n < 1 => this variable is a primary key

weather %>%
  count(year, month, day, hour, origin) %>%
  filter(n > 1)
# n > 1 => this combo of variables is not a primary key

# sometimes there is no explicit primary key even though each row is an observation
# so it can be useful to add a surrogate key with mutate() and row_number()
# this makes it easier to match observations if you've done some filtering and want to check back in with the original data

# a primary key and the corresponding foreign key in another table form a relation
# relations are typically one-to-many, e.g. each flight has one plane but each plane has many flights
# you can model many-to-many relations with a many-to-1 relation + a 1-to-many relation
# e.g. there's a many-to-many relationship between airlines and airports; each airline flies to many airports and each airport hosts many airlines


#### 13.4 Mutating joins ####
# allows you to combine variables from two tables
# first matches observations by their keys then copies across variables from one table to the other
# adding full airline name to flights data
# full names are in the airlines tibble
flights2 <- flights %>%
  left_join(airlines, by = "carrier") # carrier is the common variable to which the variables not in common are mapped to

#### 13.4.1 understanding joins ####
## inner join
# matches pairs of observations whenever their keys are equal - unmatched rows are not included in the result
# the output of an inner join is a new data frame that contains the key, the variables in x and the variables in y
# by tells dplyr which variable is the key

## outer joins
# three types:
# left join = keeps all observations in x
# right join = keeps all observations in y
# full join = keeps all observations in x and y
# these joins add an additional virtual observation to the output table whereby if there is no match for an observation, an NA will be generated
# as a result, unmatched rows are retained

#### 13.4.4 duplicate keys ####
# keys are not always unique
# one table can have duplicate keys or both table can have duplicate keys
# when one table has duplicate keys, it is typically a one-to-many relationship so it is useful for adding additional information
# when both tables have duplicate keys, it is usually an error because the keys are not unique identifiers
# when you join duplicated keys, you get all possible combinations

#### 13.4.5 defining the key columns ####
## defining by
# by = NULL => uses all the variables that appear in both tables
# by = "a character vector" => uses a common variables
# by = c("a named" = "character vector") => matches variable "a named" in table x to variable "character vector" in table y


#### 13.5 Filtering joins ####
# match observations in the same way as mutating joins but affect observations not variables
# two types:
# semi_join(x,y) => keeps all observation in x that have a match in y
# anti_joni(x,y) => drops all observations in x that have a match in y

# semi-joins
# useful for matching filtered summary tables back to the original rows
# e.g. finding the top 10 destinations then looking for each flight that went to one of those destinations
topdest <- flights %>%
  count(dest, sort = T) %>%
  head(10)
topdest
flights %>%
  semi_join(topdest)
# filtering joins do not duplicate rows like mutating joins do

# anti-joins
# useful for diagnosing join mismatches
# e.g. when connecting flights and planes, you might be interested to know that there are many flights that don't have a match in planes
flights %>%
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = T)


#### 13.6 Join problems ####
# data won't always be clean so there are some things you need to do
# 1. start by identifying variables that form the primary key in each table
# do this based on your understanding of the data, not empirically by looking for a combination of variables
# 2. check that none of the variables in the primary key are missing
# 3. check that your foreign keys match primary keys in another table (the best way to do this is with anti_join())


#### 13.7 Set operations ####
# useful for when you want to break a single complex filter into simpler pieces
# all these operations work with a complete row, comparing the values of every variable
# they expect the x and y inputs to have the same variables and treat the observations like sets
# intersect(x,y): return only observations in both x and y
# union(x,y): return unique observations in x and y
# setdiff(x,y): return observations in x but not y
