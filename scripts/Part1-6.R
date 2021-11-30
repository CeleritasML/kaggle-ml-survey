# Is there a certain correlation between industry and the need for these jobs? (EDA, bootstrap, hypothesis testing)

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

industry.dat <- job.dat %>%
    filter(Q5 != "Student") %>%
    select(Q5, Q20, Q25) %>%
    filter(Q20 %in% c("Academics/Education", 
                      "Accounting/Finance", 
                      "Computers/Technology",
                      "Insurance/Risk Assessment",
                      "Medical/Pharmaceutical",
                      "Online Service/Internet-based Services")) %>%
    mutate(Q25 = str_remove_all(Q25, "[$,]")) %>%
    mutate(Q25 = str_replace(Q25, ">1000000", "1000000-2000000")) %>%
    separate(Q25, into = c("salary_lb", "salary_ub"), sep = "-") %>%
    mutate(salary_lb = as.numeric(salary_lb)) %>%
    mutate(salary_ub = as.numeric(salary_ub))

table(industry.dat$Q20)

p <- industry.dat %>% 
    count(Q5, Q20) %>%
    rename(title=Q5, Industry=Q20, count=n) %>%
    ggplot(aes(x=Industry, y=count)) +
    geom_bar(stat = "identity") +
    coord_flip() +
    facet_wrap(~ title) +
    labs(
        title = "Users' work industry",
        caption = glue("Author: celeritasML
                   Source: Kaggle")) +
    theme(axis.ticks.x = element_blank(),
          axis.text.x = element_text(angle=90, hjust=1),
          axis.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())
ggplotly(p)
    
industry.dat %>% 
    mutate(Q20 = fct_reorder(Q20, salary_lb, .fun='length')) %>%
    ggplot(aes(x=Q20, y=salary_lb)) +
    geom_boxplot() +
    coord_flip() +
    facet_wrap(~ Q5) +
    labs(
        title = "Users' salary vs industry",
        caption = glue("Author: celeritasML
                   Source: Kaggle")) +
    theme(axis.ticks.x = element_blank(),
          axis.text.x = element_text(angle=90, hjust=1),
          axis.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())
