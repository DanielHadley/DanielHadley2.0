# Created By Daniel Hadley Thu Jun 21 11:59:24 MDT 2018 #
library(tidyverse)
library(rvest)
years <- seq(1950,2018)


#### Get the season data
for (year in years) {

  url <- paste0("https://www.basketball-reference.com/leagues/NBA_", year, "_totals.html") %>%
    read_html() %>%
    html_nodes(xpath = '//*[@id="totals_stats"]') %>%
    html_table() %>%
    .[[1]] %>%
    write_csv(paste0("~/Downloads/NBA_", year, "_totals.csv"))

}


# Read and combine
data_path <- "~/Downloads/"   # path to the data
files <- dir(data_path, pattern = "*.csv")


clean_seasons <- function(x){
  test <- read_csv(paste0(data_path, x)) %>% 
    mutate(season = str_split(x, "NBA_", simplify = TRUE)[[2]]) %>% 
    mutate(season = str_sub(season, 0, 4))
}

seasons <- files %>% 
  map(clean_seasons) %>% 
  reduce(bind_rows) 

# write_csv(seasons, "~/Github/DanielHadley2.0/data/nba_seasons.csv")




#### Get the playoff data
for (year in years) {
  
  url <- paste0("https://www.basketball-reference.com/playoffs/NBA_", year, "_totals.html") %>%
    read_html() %>%
    html_nodes(xpath = '//*[@id="totals_stats"]') %>%
    html_table() %>%
    .[[1]] %>%
    write_csv(paste0("~/Downloads/NBA_playoffs_", year, "_totals.csv"))
  
}


# Read and combine
data_path <- "~/Downloads/"   # path to the data
files <- dir(data_path, pattern = "*.csv")


clean_seasons <- function(x){
  test <- read_csv(paste0(data_path, x)) %>% 
    mutate(season = str_split(x, "playoffs_", simplify = TRUE)[[2]]) %>% 
    mutate(season = str_sub(season, 0, 4))
}

post_seasons <- files %>% 
  map(clean_seasons) %>% 
  reduce(bind_rows) 

# write_csv(post_seasons, "~/Github/DanielHadley2.0/data/nba_playoffs.csv")




# All the crap I tried that didn't work:

w_line_season <- threes %>%
  group_by(player_id) %>%
  summarise(season = round(mean(season)))


no_line_three_pct <- threes %>% 
  mutate(line_change = case_when(season >= 1995 & season <= 1997 ~ "during",
                                 season < 1995 ~ "before",
                                 TRUE ~ "after")) %>% 
  filter(line_change != "during") %>%
  group_by(player_id) %>% 
  summarise(threes_made = sum(threes_made), threes_attempted = sum(threes_attempted),
            Player = Player[1]) %>% 
  mutate(three_pct = threes_made / threes_attempted) %>% 
  select(player_id, three_pct, Player) 


no_line_prior <- threes %>% 
  mutate(line_change = case_when(season >= 1995 & season <= 1997 ~ "during",
                                 season < 1995 ~ "before",
                                 TRUE ~ "after")) %>% 
  filter(line_change != "during") %>% 
  group_by(player_id) %>% 
  summarise(threes_made = sum(threes_made), threes_attempted = sum(threes_attempted),
            Player = Player[1]) %>% 
  mutate(three_pct = threes_made / threes_attempted) %>% 
  filter(threes_made >= 7) %>%
  left_join(w_line_season) %>% 
  ebb_fit_prior(threes_made, threes_attempted, method = "gamlss", 
                mu_predictors = ~ season + log10(threes_attempted)) 


no_line_data <- threes %>% 
  mutate(line_change = case_when(season >= 1995 & season <= 1997 ~ "during",
                                 season < 1995 ~ "before",
                                 TRUE ~ "after")) %>% 
  filter(line_change != "during") %>%
  group_by(player_id) %>% 
  summarise(threes_made = sum(threes_made), threes_attempted = sum(threes_attempted),
            Player = Player[1]) %>% 
  mutate(three_pct = threes_made / threes_attempted) %>% 
  left_join(w_line_season) %>%
  filter(threes_made >= 7) 

id <- as.vector(no_line_estimate$player_id)

no_line_posterior <- no_line_data %>% 
  select(threes_made, threes_attempted, season) %>% 
  augment(no_line_prior, newdata = .) %>% 
  mutate(player_id = id) %>% 
  left_join(no_line_three_pct)


no_line_posterior %>%
  arrange(-.fitted) %>% 
  top_n(20, wt = .fitted) %>% 
  mutate(rank = row_number()) %>% 
  rename('Measured rate' = three_pct, 'Empirical Bayes estimate' = .fitted) %>% 
  gather(type, rate, `Measured rate`, `Empirical Bayes estimate`) %>%
  ggplot(aes(rate, reorder(Player, -rank), color = type)) +
  geom_errorbarh(aes(xmin = .low, xmax = .high), color = "gray50") +
  geom_point(size = 3) +
  labs(x = "Three Point %",
       y = NULL, title = "Measured Rates, Empirical Bayesian Estimates, and Credible Intervals") +  theme_minimal() +
  theme(legend.title=element_blank())




threes %>% 
  ggplot(aes(as.factor(season), three_pct)) +
  geom_boxplot()



line_and_log <- threes %>%
  mutate(line_change = case_when(season >= 1995 & season <= 1997 ~ "during",
                                 season < 1995 ~ "before",
                                 TRUE ~ "after")) %>% 
  group_by(player_id, line_change) %>% 
  summarise(threes_made = sum(threes_made), threes_attempted = sum(threes_attempted),
            Player = Player[1]) %>% 
  mutate(three_pct = threes_made / threes_attempted) %>%
  filter(threes_attempted > 30) %>%
  add_ebb_estimate(threes_made, threes_attempted, method = "gamlss", 
                   mu_predictors = ~ line_change + log10(threes_attempted)) 

line_and_log %>% 
  ggplot(aes(.raw, .fitted, color = line_change)) +
  geom_point()


line_and_log <- line_and_log %>% 
  group_by(player_id) %>%
  summarise(alpha = sum(.alpha1), beta = sum(.beta1), Player = Player[1],
            threes_made = sum(threes_made), threes_attempted = sum(threes_attempted)) %>% 
  mutate(fitted = alpha / (alpha + beta), three_pct = threes_made / threes_attempted)




drop_line_priors <- threes %>%
  mutate(line_change = case_when(season >= 1995 & season <= 1997 ~ "during",
                                 season < 1995 ~ "before",
                                 TRUE ~ "after")) %>% 
  filter(line_change != "during") %>% 
  group_by(player_id) %>% 
  summarise(threes_made = sum(threes_made), threes_attempted = sum(threes_attempted),
            Player = Player[1]) %>% 
  filter(threes_made > 30) %>% 
  mutate(three_pct = threes_made / threes_attempted) %>%
  ebb_fit_prior(threes_made, threes_attempted, method = "gamlss",
                mu_predictors = ~ log(threes_attempted))

drop_line <- threes %>% 
  na.omit() %>% 
  augment(drop_line_priors, newdata = .)

fake_data <- crossing(threes_made = 6,
                      threes_attempted = 12,
                      season = seq(1980, 2018)) %>% 
  mutate(observation = row_number()) %>% 
  augment(drop_line_priors, newdata = .)

# find the mean of the prior, as well as the 95% quantiles,
# for each of these combinations. This does require a bit of
# manual manipulation of alpha0 and beta0:
augment(by_season, newdata = fake_data) %>%
  mutate(prior = .alpha0 / (.alpha0 + .beta0),
         prior.low = qbeta(.025, .alpha0, .beta0),
         prior.high = qbeta(.975, .alpha0, .beta0)) %>%
  ggplot(aes(season, prior)) +
  geom_line() +
  geom_ribbon(aes(ymin = prior.low, ymax = prior.high), alpha = .1, lty = 2) +
  ylab("Prior distribution (mean + 95% quantiles)")





## This makes absolutely no sense. The model suggests that 1980 had the highest prior????

## Seems like there is something broken with gmlss

by_season <- threes %>%
  mutate(line_change = case_when(season >= 1995 & season <= 1997 ~ "during",
                                 season < 1995 ~ "before",
                                 TRUE ~ "after")) %>% 
  group_by(player_id, season) %>% 
  summarise(threes_made = sum(threes_made), threes_attempted = sum(threes_attempted),
            Player = Player[1]) %>% 
  filter(threes_made > 0) %>% 
  mutate(three_pct = threes_made / threes_attempted) %>%
  ebb_fit_prior(threes_made, threes_attempted, method = "gamlss",
                mu_predictors = ~ 0 + ns(season, df = 3) + log(threes_attempted))

fake_data <- crossing(threes_made = 6,
                      threes_attempted = 12,
                      season = seq(1980, 2018))

# find the mean of the prior, as well as the 95% quantiles,
# for each of these combinations. This does require a bit of
# manual manipulation of alpha0 and beta0:
augment(by_season, newdata = fake_data) %>%
  mutate(prior = .alpha0 / (.alpha0 + .beta0),
         prior.low = qbeta(.025, .alpha0, .beta0),
         prior.high = qbeta(.975, .alpha0, .beta0)) %>%
  ggplot(aes(season, prior)) +
  geom_line() +
  geom_ribbon(aes(ymin = prior.low, ymax = prior.high), alpha = .1, lty = 2) +
  ylab("Prior distribution (mean + 95% quantiles)")





## One last chance to salvage

by_season <- threes %>%
  mutate(line_change = case_when(season >= 1995 & season <= 1997 ~ "during",
                                 season < 1995 ~ "before",
                                 TRUE ~ "after")) %>% 
  group_by(player_id, season) %>% 
  summarise(threes_made = sum(threes_made), threes_attempted = sum(threes_attempted),
            Player = Player[1]) %>% 
  filter(threes_made > 0) %>% 
  mutate(three_pct = threes_made / threes_attempted) %>%
  ebb_fit_prior(threes_made, threes_attempted, method = "gamlss",
                mu_predictors = ~ 0 + ns(season, df = 3) + log(threes_attempted))

fake_data <- crossing(threes_made = 6,
                      threes_attempted = 12,
                      season = seq(1980, 2018))

# find the mean of the prior, as well as the 95% quantiles,
# for each of these combinations. This does require a bit of
# manual manipulation of alpha0 and beta0:
augment(by_season, newdata = fake_data) %>%
  mutate(prior = .alpha0 / (.alpha0 + .beta0),
         prior.low = qbeta(.025, .alpha0, .beta0),
         prior.high = qbeta(.975, .alpha0, .beta0)) %>%
  ggplot(aes(season, prior)) +
  geom_line() +
  geom_ribbon(aes(ymin = prior.low, ymax = prior.high), alpha = .1, lty = 2) +
  ylab("Prior distribution (mean + 95% quantiles)")




by_season <- threes %>%
  mutate(line_change = case_when(season >= 1995 & season <= 1997 ~ "during",
                                 season < 1995 ~ "before",
                                 TRUE ~ "after")) %>% 
  group_by(player_id, season) %>% 
  summarise(threes_made = sum(threes_made), threes_attempted = sum(threes_attempted),
            Player = Player[1]) %>% 
  filter(threes_made > 4) %>% 
  mutate(three_pct = threes_made / threes_attempted) %>%
  add_ebb_estimate(threes_made, threes_attempted, method = "gamlss", 
                   mu_predictors = ~ 0 + ns(season, df = 3) + log10(threes_attempted)) %>% 
  mutate(fitted = .alpha0 / (.alpha0 + .beta0))


by_season %>% 
  ggplot(aes(.raw, .fitted, color = season)) +
  geom_point()


by_season <- by_season %>%  
  group_by(player_id) %>%
  summarise(alpha = sum(.alpha1), beta = sum(.beta1), Player = Player[1],
            threes_made = sum(threes_made), threes_attempted = sum(threes_attempted)) %>% 
  mutate(fitted = alpha / (alpha + beta), three_pct = threes_made / threes_attempted)




threes_for_model <- threes %>%
  group_by(player_id, season) %>% 
  summarise(threes_made = sum(threes_made), threes_attempted = sum(threes_attempted),
            Player = Player[1]) %>% 
  filter(threes_made > 0) %>% 
  dplyr::select(threes_made, threes_attempted, season)

fit <- gamlss(cbind(threes_made, threes_attempted - threes_made) ~ log(threes_attempted),
              data = threes_for_model,
              family = BB(mu.link = "identity"))

fit3 <- gamlss(cbind(threes_made, threes_attempted - threes_made) ~ 0 + ns(season, df = 3) + log(threes_attempted),
               data = threes_for_model,
               family = BB(mu.link = "identity"))




seasons <- seasons %>%   
  filter(Rk != "Rk") %>% 
  mutate_at(vars(Age, G:season), as.numeric) %>% 
  mutate(birth_year = season - Age)


player_ids <- seasons %>% 
  group_by(Player, birth_year) %>% 
  count() %>% 
  select(-n) %>% 
  ungroup() %>% 
  mutate(player_id = row_number())

seasons <- seasons %>% 
  left_join(player_ids)


threes <- seasons %>% 
  filter(season > 1979) %>% 
  group_by(player_id) %>% 
  summarise(`3P` = sum(`3P`), `3PA` = sum(`3PA`), Player = Player[1]) %>% 
  mutate(average = `3P` / `3PA`)


threes %>% filter(`3P` > 100) %>% ggplot(aes(average)) + geom_histogram(bins = 60)

threes <- threes %>% 
  add_ebb_estimate(`3P`, `3PA`, prior_subset = `3P` > 100)


threes %>% 
  ggplot(aes(.raw, .fitted, color = `3PA`)) +
  geom_point()


threes %>%
  arrange(-.fitted) %>% 
  top_n(10, wt = .fitted) %>% 
  mutate(rank = row_number()) %>% 
  rename('Measured rate' = average, 'Empirical Bayes estimate' = .fitted) %>% 
  gather(type, rate, `Measured rate`, `Empirical Bayes estimate`) %>%
  ggplot(aes(rate, reorder(Player, -rank), color = type)) +
  geom_errorbarh(aes(xmin = .low, xmax = .high), color = "gray50") +
  geom_point(size = 3) +
  labs(x = "Three Point %",
       y = NULL, title = "Measured Rates, Empirical Bayesian Estimates, and Credible Intervals") +  theme_minimal() +
  theme(legend.title=element_blank())


threes %>%
  filter(`3PA` > 100) %>% 
  ggplot(aes(log(`3PA`), average))+
  geom_point() + geom_smooth(method = "lm")

threes <- threes %>%
  filter(`3PA` > 0) %>%
  rename(threes = `3P`, attempts = `3PA`) %>% 
  add_ebb_estimate(threes, attempts, method = "gamlss", mu_predictors = ~ log10(attempts))


threes %>% 
  ggplot(aes(.raw, .fitted, color = attempts)) +
  geom_point()

threes %>% 
  ggplot(aes(log(attempts), .fitted)) +
  geom_point() + geom_smooth(method = "lm")


threes %>%
  arrange(-.fitted) %>% 
  top_n(10, wt = .fitted) %>% 
  mutate(rank = row_number()) %>% 
  rename('Measured rate' = average, 'Empirical Bayes estimate' = .fitted) %>% 
  gather(type, rate, `Measured rate`, `Empirical Bayes estimate`) %>%
  ggplot(aes(rate, reorder(Player, -rank), color = type)) +
  geom_errorbarh(aes(xmin = .low, xmax = .high), color = "gray50") +
  geom_point(size = 3) +
  labs(x = "Three Point %",
       y = NULL, title = "Measured Rates, Empirical Bayesian Estimates, and Credible Intervals") +  theme_minimal() +
  theme(legend.title=element_blank())



seasons %>% 
  filter(season > 1979) %>% 
  mutate(average = `3P` / `3PA`) %>% 
  ggplot(aes(as.factor(season), average)) +
  geom_boxplot()


threes2 <- seasons %>%
  filter(season > 1979) %>% 
  group_by(player_id, season) %>% 
  summarise(`3P` = sum(`3P`), `3PA` = sum(`3PA`), Player = Player[1]) %>% 
  mutate(average = `3P` / `3PA`) %>% 
  filter(`3PA` > 100) %>%
  rename(threes = `3P`, attempts = `3PA`) %>%
  add_ebb_estimate(threes, attempts, method = "gamlss", 
                   mu_predictors = ~ 0 + ns(season, df = 3) + log10(attempts))

threes_final <- threes2 %>%
  group_by(player_id) %>%
  summarise(alpha = sum(.alpha1), beta = sum(.beta1), Player = Player[1]) %>% 
  mutate(fitted = alpha / (alpha + beta))






seasons %>% 
  filter(season > 1979) %>% 
  mutate(average = `3P` / `3PA`) %>% 
  ggplot(aes(as.factor(season), average)) +
  geom_boxplot()


threes2 <- seasons %>%
  filter(season > 1979) %>% 
  group_by(player_id, season) %>% 
  summarise(`3P` = sum(`3P`), `3PA` = sum(`3PA`), Player = Player[1]) %>% 
  mutate(average = `3P` / `3PA`) %>% 
  filter(`3PA` > 100) %>%
  rename(threes = `3P`, attempts = `3PA`) %>%
  add_ebb_estimate(threes, attempts, method = "gamlss", 
                   mu_predictors = ~ 0 + ns(season, df = 5) + log10(attempts))

threes_final <- threes2 %>%
  group_by(player_id) %>%
  summarise(alpha = sum(.alpha1), beta = sum(.beta1), Player = Player[1], 
            season = season[1], threes = sum(threes), attempts = sum(attempts)) %>% 
  mutate(fitted = alpha / (alpha + beta), average = threes / attempts)




## take out log attempts
threes2 <- seasons %>%
  filter(season > 1979) %>% 
  group_by(player_id, season) %>% 
  summarise(`3P` = sum(`3P`), `3PA` = sum(`3PA`), Player = Player[1]) %>% 
  mutate(average = `3P` / `3PA`) %>% 
  filter(`3PA` > 100) %>%
  rename(threes = `3P`, attempts = `3PA`) %>%
  add_ebb_estimate(threes, attempts, method = "gamlss", 
                   mu_predictors = ~ 0 + ns(season, df = 5))

threes_final <- threes2 %>%
  group_by(player_id) %>%
  summarise(alpha = sum(.alpha1), beta = sum(.beta1), Player = Player[1], 
            season = season[1], threes = sum(threes), attempts = sum(attempts)) %>% 
  mutate(fitted = alpha / (alpha + beta), average = threes / attempts)

# Seems to strongly bias for older players
threes_final %>% 
  ggplot(aes(average, fitted, color = season)) +
  geom_point() + geom_smooth(method = "lm")



## take season
threes2 <- seasons %>%
  filter(season > 1979) %>% 
  group_by(player_id, season) %>% 
  summarise(`3P` = sum(`3P`), `3PA` = sum(`3PA`), Player = Player[1]) %>% 
  mutate(average = `3P` / `3PA`) %>% 
  filter(`3PA` > 100) %>%
  rename(threes = `3P`, attempts = `3PA`) %>%
  add_ebb_estimate(threes, attempts, method = "gamlss", mu_predictors = ~ log10(attempts))

threes_final <- threes2 %>%
  group_by(player_id) %>%
  summarise(alpha = sum(.alpha1), beta = sum(.beta1), Player = Player[1], 
            season = season[1], threes = sum(threes), attempts = sum(attempts)) %>% 
  mutate(fitted = alpha / (alpha + beta), average = threes / attempts)

# Seems to favor more shooters
threes_final %>% 
  ggplot(aes(average, fitted, color = season)) +
  geom_point() + geom_smooth(method = "lm")




## take out attempts
threes2 <- seasons %>%
  filter(season > 1979) %>% 
  group_by(player_id, season) %>% 
  summarise(`3P` = sum(`3P`), `3PA` = sum(`3PA`), Player = Player[1]) %>% 
  mutate(average = `3P` / `3PA`) %>% 
  filter(`3PA` > 100) %>%
  rename(threes = `3P`, attempts = `3PA`) %>%
  add_ebb_estimate(threes, attempts)

threes_final <- threes2 %>%
  group_by(player_id) %>%
  summarise(alpha = sum(.alpha1), beta = sum(.beta1), Player = Player[1], 
            season = season[1], threes = sum(threes), attempts = sum(attempts)) %>% 
  mutate(fitted = alpha / (alpha + beta), average = threes / attempts)

# Seems to favor more shooters
threes_final %>% 
  ggplot(aes(average, fitted, color = season)) +
  geom_point() + geom_smooth(method = "lm")





## take season
threes2 <- seasons %>%
  filter(season > 1979) %>%
  mutate(line_change = case_when(season >= 1995 & season <= 1997 ~ "during",
                                 season < 1995 ~ "before",
                                 TRUE ~ "after")) %>% 
  group_by(player_id, line_change) %>% 
  summarise(`3P` = sum(`3P`), `3PA` = sum(`3PA`), Player = Player[1]) %>% 
  mutate(average = `3P` / `3PA`) %>% 
  filter(`3PA` > 100) %>%
  rename(threes = `3P`, attempts = `3PA`) %>%
  add_ebb_estimate(threes, attempts, method = "gamlss", mu_predictors = ~ line_change)

threes_final <- threes2 %>%
  group_by(player_id) %>%
  summarise(alpha = sum(.alpha1), beta = sum(.beta1), Player = Player[1], 
            threes = sum(threes), attempts = sum(attempts)) %>% 
  mutate(fitted = alpha / (alpha + beta), average = threes / attempts)

# Seems to work well
threes_final %>% 
  ggplot(aes(average, fitted)) +
  geom_point() + geom_smooth(method = "lm")


threes2 %>% 
  ggplot(aes(average, .fitted, color = line_change)) +
  geom_point()

