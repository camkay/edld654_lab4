library(tidyverse)
library(tidymodels)

all_cores <- parallel::detectCores(logical = FALSE)

library(doParallel)
cl <- makePSOCKcluster(all_cores)
registerDoParallel(cl)
foreach::getDoParWorkers()
clusterEvalQ(cl, {library(tidymodels)})

full_train <- read_csv("data/train.csv")

# full_train <- full_train %>%
#   slice_sample(prop = .005)

split    <- initial_split(full_train)
train    <- training(split)
train_cv <- vfold_cv(train)

knn1_rec <- recipe(classification ~ gndr + ethnic_cd + enrl_grd + lat + lon, data = train) %>%
  step_mutate(classification = ifelse(classification < 3, "below", "proficient")) %>%
  step_mutate(enrl_grd = factor(enrl_grd)) %>%
  step_unknown(all_nominal(), -all_outcomes()) %>%
  step_medianimpute(all_numeric(), -all_outcomes()) %>%
  step_normalize(all_numeric(), -all_outcomes()) %>%
  step_dummy(all_nominal(), -all_outcomes()) %>%
  step_nzv(all_predictors())


