# Where do they get and share the knowledge? (EDA)

if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, ggthemes, glue, stringr, olsrr, plotly)
col_names <- names(read_csv('data/kaggle_survey_2021_responses.csv', n_max=0))
dat <- read_csv('data/kaggle_survey_2021_responses.csv', col_names = col_names, skip=2)

ggplot2::theme_set(
    theme_fivethirtyeight() +
        theme(
            text = element_text(family = "Roboto Condensed"),
            title = element_text(size = 14),
            plot.subtitle = element_text(size = 12),
            plot.caption = element_text(size = 10),
            axis.title = element_text(size = 14),
            axis.text = element_text(size = 12),
            panel.grid.minor.x = element_blank()
        )
)
# data analyst, data engineer, data scientist, machine learning engineer, software engineer, statistician

dat <- dat %>% filter(Q3 == "United States of America")
job.dat <- dat %>% filter(Q5 %in% c("Data Analyst", 
                                    "Data Engineer",
                                    "Data Scientist",
                                    "Machine Learning Engineer",
                                    "Software Engineer",
                                    "Statistician",
                                    "Student"))

learning_platform <- job.dat %>% 
    select(c(Q5, starts_with("Q40_"))) %>%
    gather("fake_key", "learning", -Q5, na.rm = T) %>%
    rename(title = Q5) %>%
    select(-fake_key) %>%
    mutate(learning = case_when(
        learning == "Cloud-certification programs (direct from AWS, Azure, GCP, or similar)" ~ "Cloud-certif Programs",
        learning == "University Courses (resulting in a university degree)" ~ "University",
        TRUE ~ learning
    )) %>%
    filter(!learning %in% c("None", "Other")) %>%
    count(title, learning, .drop = FALSE) %>% 
    complete(title, learning) %>%
    replace_na(list(n = 0)) %>%
    group_by(title) %>%
    mutate(prop = prop.table(n))

p <- learning_platform %>% 
    mutate(text = paste0("Platform: ", learning, "\n", 
                         "Job title: ", title, "\n", 
                         "Count: ", n, "\n",
                         "Proportion: ", round(prop, 3))) %>%
    ggplot(aes(learning, title, fill=prop, text=text)) +
    geom_tile() +
    scale_fill_gradient(low="white", high="blue") +
    labs(
        title = "Users' favorite learning platforms",
        caption = glue("Author: celeritasML
                   Source: Kaggle")) +
    theme(axis.ticks.x = element_blank(),
          axis.text.x = element_text(angle=90, hjust=1),
          axis.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())
ggplotly(p, tooltip="text")
    

share_deploy <- job.dat %>% 
    select(c(Q5, starts_with("Q39_"))) %>%
    gather("fake_key", "share", -Q5, na.rm = T) %>%
    rename(title = Q5) %>%
    select(-fake_key) %>%
    mutate(share = case_when(
        share == "I do not share my work publicly" ~ "\'PRIVATE\'",
        TRUE ~ share
    )) %>%
    filter(!share %in% c("Other")) %>%
    count(title, share, .drop = FALSE) %>% 
    complete(title, share) %>%
    replace_na(list(n = 0)) %>%
    group_by(title) %>%
    mutate(prop = prop.table(n))

p <- share_deploy %>% 
    mutate(text = paste0("Platform: ", share, "\n", 
                         "Job title: ", title, "\n",
                         "Count: ", n, "\n",
                         "Proportion: ", round(prop, 3))) %>%
    ggplot(aes(share, title, fill=prop, text=text)) +
    geom_tile() +
    scale_fill_gradient(low="white", high="blue") +
    labs(
        title = "Users' favorite share platforms",
        caption = glue("Author: celeritasML
                   Source: Kaggle")) +
    theme(axis.ticks.x = element_blank(),
          axis.text.x = element_text(angle=90, hjust=1),
          axis.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())
ggplotly(p, tooltip="text")


media_source <- job.dat %>% 
    select(c(Q5, starts_with("Q42_"))) %>%
    gather("fake_key", "media", -Q5, na.rm = T) %>%
    rename(title = Q5) %>%
    select(-fake_key) %>%
    filter(!media %in% c("None", "Other")) %>%
    count(title, media, .drop = FALSE) %>% 
    complete(title, media) %>%
    replace_na(list(n = 0)) %>%
    group_by(title) %>%
    mutate(prop = prop.table(n)) %>%
    separate(media, into = c("media", "media_suffix"), sep = " \\(")

p <- media_source %>% 
    mutate(text = paste0("Platform: ", media, "\n", 
                         "Job title: ", title, "\n", 
                         "Count: ", n, "\n", 
                         "Proportion: ", round(prop, 3))) %>%
    ggplot(aes(media, title, fill=prop, text=text)) +
    geom_tile() +
    scale_fill_gradient(low="white", high="blue") +
    labs(
        title = "Users' favorite media source",
        caption = glue("Author: celeritasML
                   Source: Kaggle")) +
    theme(axis.ticks.x = element_blank(),
          axis.text.x = element_text(angle=90, hjust=1),
          axis.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())
ggplotly(p, tooltip="text")
