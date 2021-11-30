# What programming languages and IDEs do they use? (hypothesis test on the two-way table)

if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, ggthemes, glue)
col_names <- names(read_csv('data/kaggle_survey_2021_responses.csv', n_max=0))
dat <- read_csv('data/kaggle_survey_2021_responses.csv', col_names = col_names, skip=2)


# data analyst, data engineer, data scientist, machine learning engineer, software engineer, statistician

dat <- dat %>% filter(Q3 == "United States of America")
job.dat <- dat %>% 
    filter(Q5 %in% c("Data Analyst",
                     "Data Engineer",
                     "Data Scientist",
                     "Machine Learning Engineer",
                     "Software Engineer",
                     "Statistician",
                     "Student"))

programming <- job.dat %>% 
    select(c(Q5, starts_with("Q7_"))) %>%
    gather("fake_key", "language", -Q5, na.rm = T) %>%
    rename(title = Q5) %>%
    select(-fake_key) %>%
    filter(!language %in% c("None", "Other")) %>%
    count(title, language, .drop = FALSE) %>% 
    complete(title, language) %>%
    replace_na(list(n = 0)) %>%
    group_by(title) %>%
    mutate(prop = prop.table(n))

p <- programming %>% 
    mutate(text = paste0("Language: ", language, "\n", 
                         "Job title: ", title, "\n", 
                         "Count: ", n, "\n",
                         "Proportion: ", round(prop, 3))) %>%
    ggplot(aes(language, title, fill=prop, text=text)) +
    geom_tile() +
    scale_fill_gradient(low="white", high="blue") +
    labs(
        title = "Users' favorite programming language",
        caption = glue("Author: celeritasML
                   Source: Kaggle")) +
    theme(axis.ticks.x = element_blank(),
          axis.text.x = element_text(angle=90, hjust=1),
          axis.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())
ggplotly(p, tooltip="text")

recommend <- job.dat %>% 
    select(c(Q5, Q8)) %>%
    gather("fake_key", "recommend.language", -Q5, na.rm = T) %>%
    rename(title = Q5) %>%
    select(-fake_key) %>%
    filter(!recommend.language %in% c("None", "Other"))
table(recommend)

ide <- job.dat %>% 
    select(c(Q5, starts_with("Q9_"))) %>%
    gather("fake_key", "IDE", -Q5, na.rm = T) %>%
    rename(title = Q5) %>%
    select(-fake_key) %>%
    mutate(IDE = case_when(
        IDE == "Visual Studio Code (VSCode)" ~ "VSCode",
        IDE == "Jupyter (JupyterLab, Jupyter Notebooks, etc)" ~ "Jupyter Notebook",
        TRUE ~ IDE
    )) %>%
    filter(!IDE %in% c("None", "Other")) %>%
    count(title, IDE, .drop = FALSE) %>% 
    complete(title, IDE) %>%
    replace_na(list(n = 0)) %>%
    group_by(title) %>%
    mutate(prop = prop.table(n))

p <- ide %>% 
    mutate(text = paste0("IDE: ", IDE, "\n", 
                         "Job title: ", title, "\n", 
                         "Count: ", n, "\n",
                         "Proportion: ", round(prop, 3))) %>%
    ggplot(aes(IDE, title, fill=prop, text=text)) +
    geom_tile() +
    scale_fill_gradient(low="white", high="blue") +
    labs(
        title = "Users' favorite IDE",
        caption = glue("Author: celeritasML
                   Source: Kaggle")) +
    theme(axis.ticks.x = element_blank(),
          axis.text.x = element_text(angle=90, hjust=1),
          axis.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())
ggplotly(p, tooltip="text")
table(ide)

