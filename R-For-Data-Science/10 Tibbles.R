##### R for Data Science ####
# https://r4ds.had.co.nz/index.html

library(tidyverse)

##### 10 Tibbles #####
# tibbles are dataframes
# as_tibble() to coerce a data frame into a tibble
# you can create a new tibble from invidivual vectors with tibble()
tibble(
  x = 1:5,
  y = 1, # will be recycled to match the lengths of other variables
  z = x^2 + y # can refer to variables you just created
)

# tibble does not create row names, change variables names or convert strings to factors
# tibbles can use column names that are not valid R variable names - e.g. with a space. To use these variables you need to use backticks ``

# you can also create tibbles with tribble() = transposed tibble
tribble(
  ~x, ~y, ~z,
  #--|--|----
  "a", 2, 3.6,
  "b", 1, 8.5
)

