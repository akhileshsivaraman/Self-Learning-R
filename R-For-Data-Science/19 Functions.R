##### 19 Functions #####
### When should you write a function exercise 
both_na <- function(x) {
  sum(is.na(x))
}
vec1 <- c(1,2,3,4,5,NA,NA,4)
vec2 <- c(NA,NA,NA,NA,NA)
both_na(c(vec1, vec2))


### Conditional execution exercises
# greeting function based on the time of day
library(lubridate)
library(hms)
greeting <- function(x) {
  if (hms(sec = 0, minutes = 0, hours = 0) < as_hms(now()) && as_hms(now()) <= hms(sec = 0, minutes = 0, hours = 12)) {
    print("Good morning!")
  } else if (hms(sec = 0, minutes = 0, hours = 12) < as_hms(now()) && as_hms(now()) <= hms(sec = 0, minutes = 0, hours = 18)) {
    print("Good afternoon")
  } else if (hms(sec = 0, minutes = 0, hours = 18) < as_hms(now()) && as_hms(now()) <= hms(sec = 0, minutes = 0, hours = 24)) {
    print("Good evening")
  }
}
greeting()


# fizzbuzz
fizzbuzz <- function(x) {
  if (x %% 5 == 0 && x %% 3 != 0) {
    print("buzz")
  } else if (x %% 3 == 0 && x %% 5 !=0) {
    print("fizz")
  } else if (x %% 3 == 0 && x %% 5 == 0) {
    print("fizzbuzz")
  } else {
    print(x)
  }
}


# using cut to instead of nested if-else statements
cut(0:30, breaks = 5, right = T, labels = c("freezing", "cold", "cool", "warm", "hot"))
a <- cut(0:30, breaks = 5, right = T, labels = c("freezing", "cold", "cool", "warm", "hot"))
a[1:10] # extracting values from cut


