# Where do they get and share the knowledge? (EDA)

if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, ggthemes, glue, stringr, olsrr)
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

learning_platform <- job.dat %>% 
    select(c(Q5, starts_with("Q40_"))) %>%
    gather("fake_key", "learning", -Q5, na.rm = T) %>%
    rename(title = Q5) %>%
    select(-fake_key)

share_deploy <- job.dat %>% 
    select(c(Q5, starts_with("Q39_"))) %>%
    gather("fake_key", "share", -Q5, na.rm = T) %>%
    rename(title = Q5) %>%
    select(-fake_key)

media_source <- job.dat %>% 
    select(c(Q5, starts_with("Q42_"))) %>%
    gather("fake_key", "media", -Q5, na.rm = T) %>%
    rename(title = Q5) %>%
    select(-fake_key)


learning_platform %>% table()
share_deploy %>% table()
media_source %>% table()
