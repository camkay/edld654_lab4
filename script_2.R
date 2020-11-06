# source script_0
source("script_0.R")

# create grid with maximum entropy
knn_params <- parameters(neighbors(range = c(1, 20)), dist_power())
knn_sfd    <- grid_max_entropy(knn_params, size = 25)

# knn_sfd %>%
#   ggplot(aes(neighbors, dist_power)) +
#     geom_point()

# create model
knn2_mod <- nearest_neighbor() %>%
  set_engine("kknn") %>%
  set_mode("classification") %>%
  set_args(neighbors  = tune(),
           dist_power = tune())

cl <- parallel::makeCluster(8)
doParallel::registerDoParallel(cl)

knn2_fit <- tune::tune_grid(
  knn2_mod,
  preprocessor = knn1_rec,
  resamples    = train_cv,
  control = tune::control_resamples(save_pred = TRUE)
)

parallel::stopCluster(cl)

saveRDS(knn2_fit, "models/knn2_fit.Rds")

