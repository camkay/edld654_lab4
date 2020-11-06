# * `select_best` to select your best tuned model.
# * `finalize_model` to finalize your model using your best tuned model.
# * `finalize_recipe` to finalize your recipe using your best tuned model (in this case, we didn't tune anything in our recipe, but it's a good habit to get into).
# * `last_fit` to run your last fit with your `finalized_model` and `finalized_recipe`on your initial data split. When working on talapas, this is the model object you should save and transfer to your local.
# * `collect_metrics` from your final results. Similar to your model tuning, you will report these on the model run on talapas. You can report these in the same Rmd as the preliminary fit and tuning, or in a third CSV that you write to your local.

# source script_0
source("script_0.R")

knn2_mod <- nearest_neighbor() %>%
  set_engine("kknn") %>%
  set_mode("classification") %>%
  set_args(neighbors  = tune(),
           dist_power = tune())

knn2_fit <- readRDS("models/knn2_fit.Rds")

knn2_best <- knn2_fit %>%
  select_best(metric = "roc_auc")

knn2_mod_final <- knn2_mod %>% finalize_model(knn2_best)

knn2_rec_final <- knn1_rec %>% finalize_recipe(knn2_best)

# had to remove parallel processing because it would not allow us to use the term all_nominal for last_fit (googling suggests it is a bug in the parallel/tidymodels packages)

knn2_final_res <- last_fit(
  knn2_mod_final,
  preprocessor = knn2_rec_final, 
  split        = split)

saveRDS(knn2_final_res, "models/knn2_final_fit.Rds")



