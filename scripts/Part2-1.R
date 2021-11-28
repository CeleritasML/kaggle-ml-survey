# What programming languages and IDEs do they use? (hypothesis test on the two-way table)

if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, ggthemes, glue)
col_names <- names(read_csv('data/kaggle_survey_2021_responses.csv', n_max=0))
dat <- read_csv('data/kaggle_survey_2021_responses.csv', col_names = col_names, skip=2)


# data analyst, data engineer, data scientist, machine learning engineer, software engineer, statistician

us.dat <- dat %>% filter(Q3 == "United States of America")
job.dat <- us.dat %>% filter(Q5 %in% c("Data Analyst", 
                                       "Data Engineer",
                                       "Data Scientist",
                                       "Machine Learning Engineer",
                                       "Software Engineer",
                                       "Statistician"))

programming <- job.dat %>% 
    select(c(Q5, starts_with("Q7_"))) %>%
    gather("fake_key", "language", -Q5, na.rm = T) %>%
    rename(title = Q5) %>%
    select(-fake_key)

recommend <- job.dat %>% 
    select(c(Q5, Q8)) %>%
    gather("fake_key", "recommend.language", -Q5, na.rm = T) %>%
    rename(title = Q5) %>%
    select(-fake_key)

ide <- job.dat %>% 
    select(c(Q5, starts_with("Q9_"))) %>%
    gather("fake_key", "IDE", -Q5, na.rm = T) %>%
    rename(title = Q5) %>%
    select(-fake_key)

programming %>% table()
recommend %>% table()
ide %>% table()
