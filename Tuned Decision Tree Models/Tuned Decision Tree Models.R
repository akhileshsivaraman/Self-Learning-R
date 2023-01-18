##### Tuned Decision Tree Models - Scooby Doo Monsters #####
# https://juliasilge.com/blog/scooby-doo/?utm_content=buffer9645b&utm_medium=social&utm_source=linkedin&utm_campaign=buffer

library(tidyverse)
library(tidymodels)
scooby_raw <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-07-13/scoobydoo.csv")

# modelling goal is to predict which scooby doo monsters are real and which are fake based on the characteristics of the episode


# how many monsters are real?
scooby_raw %>%
  filter(monster_amount > 0) %>%
  count(monster_real)

# how has the number of real vs fake monsters changed over the decades?
scooby_raw %>%
  filter(monster_amount > 0) %>%
  count(year_aired = 10 * ((lubridate::year(date_aired) +1) %/% 10),
        monster_real) %>%
  mutate(year_aired = factor(year_aired)) %>%
  ggplot(aes(year_aired, n, fill = monster_real)) +
  geom_col(position = position_dodge(preserve = "single"), alpha = 0.8) +
  labs(x = 'date aired', y = 'monsters per decade', fill = 'real monster?')

# how are episodes rated on IMDB?
scooby_raw %>%
  filter(monster_amount > 0) %>%
  mutate(imdb = parse_number(imdb)) %>%
  ggplot(aes(imdb, after_stat(density), fill = monster_real)) +
  geom_histogram(position = "identity", alpha = 0.5) +
  labs(x = "IMDB rating", y = "Density", fill = "real monster")

# looks like there are some meaingful relationships that we can use for modelling 
# but they are not linear so a decision tree may be a good fit

#### build and tune a model ####
# start modelling by setting up a data budget
# only using the year each episode was aired and the episode rating
library(rsample)

set.seed(123)

scooby_split <- scooby_raw %>%
  mutate(imdb = parse_number(imdb), year_aired = lubridate::year(date_aired)) %>%
  filter(monster_amount > 0, !is.na(imdb)) %>%
  mutate(monster_real = case_when(
    monster_real == "FALSE" ~ "fake",
    TRUE ~ "real"
  ),
  monster_real = factor(monster_real)) %>%
  select(year_aired, imdb, monster_real, title) %>%
  initial_split(strata = monster_real)

scooby_train <- training(scooby_split)
scooby_test <- testing(scooby_split)

set.seed(234)

scooby_folds <- bootstraps(scooby_train, strata = monster_real)
scooby_folds

# create decision tree specification
# decision tree specification is tunable and couldn't be fit to the data immediately because model parameters were not set yet
tree_spec <- decision_tree(
  cost_complexity = tune(),
  tree_depth = tune(),
  min_n = tune()
) %>%
  set_mode("classification") %>%
  set_engine("rpart")
tree_spec

# set up a grid of possible model parameters to try
tree_grid <- grid_regular(cost_complexity(), tree_depth(), min_n(), levels = 4)
tree_grid

# fit each possible parameter combination to each resample
# by putting non-default metrics into metric_set(), we can specify which metrics are computed for each resample
doParallel::registerDoParallel()

set.seed(345)

tree_rs <- tune_grid(
  tree_spec,
  monster_real ~ year_aired + imdb, 
  resamples = scooby_folds,
  grid = tree_grid,
  metrics = metric_set(accuracy, roc_auc, sensitivity, specificity)
)
tree_rs


#### Evaluate and understand the model ####
# now that the decision tree model is tuned, we can choose which set of model parameters we want to use

# what are some of the best options?
show_best(tree_rs)

# visualise all of the combinations tried
autoplot(tree_rs) + theme_light()

# if we used select_best(), we would picj the numerically best option
# however, we may want to choose a different option that is within some criteria of the best performance
# like a simpler model that is within one standard error of the optimal result
simpler_tree <- select_by_one_std_err(tree_rs,
                                      -cost_complexity,
                                      metric = "roc_auc")
final_tree <- finalize_model(x = tree_spec, parameters = simpler_tree)

# we can add final tree into training data
final_fit <- fit(final_tree, monster_real ~ year_aired + imdb, scooby_train)
# alternatively we can use last_fit() by swapping out the split for the training data
# this will fit one time on the training data and evaluate one time on the testing data
final_rs <- last_fit(final_tree, monster_real ~ year_aired + imdb, scooby_split)

# this is the first time the testing data has been used on the whole analysis
# we can see how the model performs on the testing data
collect_metrics(final_rs)

#### visualising decision tree results ####
library(parttree)

scooby_train %>%
  ggplot(aes(imdb, year_aired)) +
  geom_parttree(data = final_fit, aes(fill = monster_real), alpha = 0.2) +
  geom_jitter(alpha = 0.7, width = 0.05, height = 0.2, aes(color = monster_real))