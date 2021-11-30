# What is the typical skill set for these jobs? How does it affect the pay rate? (regression, ANOVA)

if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, ggthemes, glue, stringr, DT)
col_names <- names(read_csv('data/kaggle_survey_2021_responses.csv', n_max=0))
dat <- read_csv('data/kaggle_survey_2021_responses.csv', col_names = col_names, skip=2)

# data analyst, data engineer, data scientist, machine learning engineer, software engineer, statistician

dat <- dat %>% filter(Q3 == "United States of America")
job.dat <- dat %>% filter(Q5 %in% c("Data Analyst", 
                                    "Data Engineer",
                                    "Data Scientist",
                                    "Machine Learning Engineer",
                                    "Software Engineer",
                                    "Statistician",
                                    "Student"))
da.dat <- dat %>% filter(Q5 == "Data Analyst")               # 258
de.dat <- dat %>% filter(Q5 == "Data Engineer")              # 86
ds.dat <- dat %>% filter(Q5 == "Data Scientist")             # 441
mle.dat <- dat %>% filter(Q5 == "Machine Learning Engineer") # 106
sde.dat <- dat %>% filter(Q5 == "Software Engineer")         # 233
stat.dat <- dat %>% filter(Q5 == "Statistician")             # 33

skill.set <- job.dat %>% 
    select(c(Q5, starts_with("Q7_"), starts_with("Q9_"), 
             starts_with("Q12_"), starts_with("Q14_"),
             starts_with("Q16_"), starts_with("Q17_"),
             starts_with("Q18_"), starts_with("Q19_"))) %>%
    mutate(Total = "TotalHelper") %>%
    gather("fake_key", "skillset", -Q5, na.rm = T) %>%
    filter(!skillset %in% c("None", "Other")) %>%
    rename(title = Q5) %>%
    count(title, skillset) %>%
    group_by(title) %>%
    mutate(prop = round(n / max(n), 3)) %>%
    filter(prop >= 0.1 & skillset != "TotalHelper") %>%
    select(-n) %>%
    arrange(title, desc(prop))

datatable(skill.set, filter = 'top', width = 600)

View(skill.set %>% filter(title == "Data Engineer"))

