# kaggle-ml-survey
A machine learning research of [the 2021 Kaggle Machine Learning &amp; Data Science Survey](https://www.kaggle.com/c/kaggle-survey-2021) dataset.

## Setup

The following lines of script will load and install some required packages. You can add addtional package names inside the function `p_load()`.

```r
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, ggthemes, glue)
```

The following script will read the raw csv (assuming the current working directory is the root directory.

```r
dat <- read_csv('data/kaggle_survey_2021_responses.csv')

# You can take a look at the data structure with:
glimpse(dat)
```

## EDA

This [link](https://www.kaggle.com/paultimothymooney/2021-kaggle-data-science-machine-learning-survey) contains an exploring data analysis of the kaggle survey dataset.

