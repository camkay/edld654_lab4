# source script_0
source("script_0.R")

# create model
knn1_mod <- nearest_neighbor() %>%
  set_engine("kknn") %>%
  set_mode("classification")

knn1_fit <- fit_resamples(
  knn1_mod,
  preprocessor = knn1_rec,
  resamples    = train_cv
)

saveRDS(knn1_fit, "models/knn1_fit.Rds")


# * Create a KNN model object, setting the appropriate mode and engine - pick a random $k$ for now.
# * Use `fit_resamples` to fit the model. Save these resamples to an object.
# * Save the fit resamples object as a `.Rds` file in the models folder using a relative path.
# * Use session -> restart R, and run the script locally to ensure everything works.
