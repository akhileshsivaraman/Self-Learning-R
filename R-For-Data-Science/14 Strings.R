##### R for Data Science ####
# https://r4ds.had.co.nz/index.html

library(tidyverse)
library(htmlwidgets)

##### 14 Strings ####
#### 14.2 String basics ####
# you can create strings with quotes
string1 <- "this is a string"
# to see the raw contents of a string use writeLines()
writeLines(string1)
# store multiple strings in a character vector
c("one", "two", "three")

## 14.2.1 string length
str_length(string1) # number of characters

## 14.2.2 combining strings
str_c("x", "y")
str_c("x", "y", sep = ",") # can control how they're separated

# NAs
x <- c("abc",NA)
str_c("|-",x,"-|") #NA not printed
str_c("|-",str_replace_na(x),"-|") #print NAs

# str_c() is vectorised so it automatically recycles shorter vectors to the same length as the longest
str_c("prefix-", c("a", "b", "c"), "-suffix")

# objects of length 0 are dropped silently
name <- "Hadley"
time_of_day <- "morning"
birthday <- FALSE

str_c(
  "Good ", time_of_day, " ", name,
  if (birthday) " and HAPPY BIRTHDAY",
  "."
)

# to collapse a vector of strings into a single string use collapse
str_c(c("x", "y", "z"), collapse = ", ")

## 14.2.3 subsetting strings
# extract parts of a string with str_sub()
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3) # also takes start and end arguments which give the position of the substring

## 14.2.4 Locales
# can change the case of strings using str_to_lower(), str_to_upper(), str_to_title()
# you can specify the locale as the rules of capitalisation differ by language
# default locale = the one provided by your operating system


#### 14.3 Matching patterns with regular expressions ####
# regexps (regular expressions) are a terse language that allow you to describe patterns in strings

## 14.3.1 Basic matches
# simplest patterns match exact strings
x <- c("apple", "banana", "pear")
str_view(x, "an")

# . matches any character except a new line
str_view(x, ".a.")
# how to match an actual full stop - use an escape to tell the expression that you want to match it exactly
# "\\." would match a full stop
# similarly, "\\\\" is used to match one backslash

## 14.3.2 Anchors
# by default, regular expressions will match any part of a string
# we can anchor the regexp so that it matches from the start or the end of the string
# ^ matches to the start
# $ matches to the end
str_view(x, "^a")
str_view(x, "a$")

# to force a regexp to only match a complete string, anchor it with both ^ and $
x <- c("apple pie", "apple", "apple cake")
str_view(x, "apple")
str_view(x, "^apple$")

## 14.3.3 Character classes and alternatives
# special patterns that match more than one character
# e.g. "." matches any character apart from a newline
# \d matches any digit
# \s matches any whitespace
# [abc] matches a, b or c
# [^abc] matches anything except a, b or c
# note: to create a regexp containing \s or \d, you'll need to escape the \ so you'll need an extra \ (i.e. \\s or \\d)
# a nice/more readable alternative to backslash escapes for metacharacters is [] for a single character
str_view(c("abc","a.c","a*c","a c"), "a[.]c")
str_view(c("abc","a.c","a*c","a c"), "a[*]c")
str_view(c("abc","a.c","a*c","a c"), "a[ ]c")

# alternation |
# character either side of | will be matched
# use parentheses to make clear which characters can be alternated
str_view(c("grey","gray"), "gr(e|a)y")


## 14.3.4 Repetition
# controlling how many times a pattern matches
# ? = 0 or 1
# + = 1 or more
# * = 0 or more
x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")
str_view(x, "CC+")
str_view(x, "C[LX]+") # square brackets to indicate which pattern to match multiple times

# you can also specify the number of matches precisely
# {n} = exactly n
# {n,} = n or more
# {,m} = at most m
# {n,m} = between n and m
str_view(x, "C{2}")
str_view(x, "C{2,}")
str_view(x, "C{2,3}")
# these matches are greedy by default so they will match the longest string possible
# you can make them lazy to match the shortest string possible by using a ?
str_view(x, "C{2,3}?")

x <- c("EP|IP|EF", "[PLEASE]+")
str_view(x, "EP|IP|EF")

# 14.3.5 Grouping and backreferences
# parentheses can be used to diambiguate complex expressions
# parentheses can also be used to create a numbered capturing group
# a capturing group stores the part of the string that is matched by the part of the regexp inside the parentheses
# you can reference the text matched by a capturing group using backreferences e.g. \1 or \2
fruit <- c("banana", "coconut", "cucumber", "jujube", "papaya", "salal berry")
str_view(fruit, "(..)\\1", match = T) # matches pairs of repeated letters


#### 14.4 Tools ####