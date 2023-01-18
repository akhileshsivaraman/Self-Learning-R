##### R for Data Science ####
# https://r4ds.had.co.nz/index.html

library(tidyverse)

##### Exploratory Data Analysis #####
# EDA is an iterative cycle to understand your data
# 1. generate questions about your data
# 2. Search for answers by visualising, transforming and modelling your data
# 3. Use what you learn to refine your questions and generate new questions
# in the initial stages of of EDA, investigate any idea, some will lead to further ideas and others will be dead ends
# as part of EDA you will investigate the quality of your data and clean it using visualisation, transformation and modelling techniques

### two useful questions to start with
# 1. what type of variation occurs within my variables? (for one variable, how much the does the value vary between observations)
# 2. what type of covariation occurs between my variables? (for multiple variables, how much do the values of multiple observations vary together in a related way)

#### outliers
# good practice to repeat your analysis with and without outliers
# if they have minimal effect on the results and you can't figure out why they're there, it's reasonable to replace them with missing values and move on
# if they have a substantial effect on your results, you shouldn't drop them without justification
# the easiest way to replace values with missing values is to use mutate() and ifelse()
# ifelse() takes three arguments - the first is the test (e.g. y is between 5 and 10); the second is what to do when the test is TRUE and the third is what to do when the test is FALSE


### covariation
# the best way to spot covariation is to visualise the relationship between multiple variables
# e.g. breaking down a continuous variable by a categorical variable
# boxplots are a great tool for this
# for two categorical variables, visualise covariation by count using one of the axes and the size or shape of the observation
# for two continuous variables, a scatterplot will do the job or you can bin one of the continuous variables then use a boxplot (this can be done with cut_width(x, width))

# covariation may reveal patterns that we can use to make predictive models

#### creating a model from a pattern ####
library(modelr)
# this model predicts price from carat of diamonds
mod <- lm(log(price) ~ log(carat), data = diamonds)
# compute the residuals (i.e. the difference between the predicted value and the actual value)
# residuals tell us the price of the diamond once the effect of carat has been removed - we remove the effect of carat on the price is very strong
diamonds2 <- diamonds %>%
  add_residuals(mod) %>%
  mutate(resid = exp(resid))
ggplot(diamonds2) +
  geom_point(aes(carat, resid))
ggplot(diamonds2) +
  geom_boxplot(aes(cut, resid))
