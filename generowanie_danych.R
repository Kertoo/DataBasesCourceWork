library(lubridate)

time_enter <- seq(
  as_datetime("2023-06-12 00:00:00"),
  as_datetime("2023-04-12 00:00:00"),
  length.out = 10^5
)[sample.int(10^5, 5000)]

user_name <- sample(
  replace = TRUE, size = 5000,
  x = c(
    "Frobertus", "Tassilo", "Wilberga", "Albino Hernandes",
    "Cristiana Tavares", "Grethe Due", "Elisabeth Wulff",
    "Torben Johannsen", "Thorvald Lauritzen", "Soren Jensen",
    "Borja Cutrina", "Lidia Almirall", "Fernando Valdovinos",
    "Christian Chistau", "Lara Duque", "Liam Krauser", "Lotta Hautzig",
    "Gustav Messerschmidt", "Sam Kahler", "Hannelore Ungar", "Nela Itschner",
    "Mirella Durtschi", "Nolan Schawalder", "Marisa Hofstetter",
    "Laila Schweizer", "Yanni Apostolilis", "Xene Franga",
    "Giannis Panilis", "Photios Mastrotis", "Eleftheria Condeli"
  )
)

x <- paste0(rep(
  "INSERT INTO visits (user_name, date_enter, date_exit, view_count)\nVALUES (", 
  500), "'", user_name, "'", ", ", "'", 
  time_enter, "'", ", '", 
  time_enter + VGAM::rposnorm(n=5000, mean = 2000, sd = 3500), 
  "', ", rpois(n=5000,lambda = 3), ")", collapse = "\n")
clipr::write_clip(x)



items <- c("Crips", "Tortilla", "Fidget spinner", 
           "Frying pan", "Computer keyboard", "Soap")

gen1 <- sample(replace = TRUE, x = items, size = 100)

cntr <- sample(
  replace = TRUE, size = 100,
  x = c(
    "GUF", "HMD", "GNB", "NOR", "PHL", "POL", "SDN"
  )
)

clipr::write_clip(
  paste0(rep(
    "INSERT INTO sales (product_name, country_of_origin, quantity_bought, id_visit)\nVALUES (", 
    50), "'", gen1, "'", 
    ", ", "'", sample(replace = TRUE, x = cntr, size = 100), "'", ", ", 
    VGAM::rposgeom(n = 100, prob = .2), 
    ", ", sample(x = 1:5000 , size = 100, replace = TRUE), ")", collapse = "\n")
)

algs <- c(
  "OLS", "xgboost", "catboost", "SVM",
  "Lasso", "nnet", "VGAM"
)

clipr::write_clip(
  paste0(rep(
    "INSERT INTO predictions (alg_name, id_visit, predicted_time, low_pred, high_pred, var_num)\nVALUES (", 
    50), "'", sample(size = 3500, x = algs, replace = TRUE), "'",
    ", ", sample(1:5000, replace = TRUE, size = 3500), ", DATEADD(s, ",
    VGAM::rposnorm(n=3500, mean = 1900, sd = 700), ", 0)",
    ", DATEADD(s, ", VGAM::rposnorm(n=3500, mean = 2650, sd = 400), ", 0)",
    ", DATEADD(s, ", VGAM::rposnorm(n=3500, mean = 3350, sd = 250), ", 0), ", 
    VGAM::rposgeom(n = 3500, prob = .5), ")", collapse = "\n")
)




