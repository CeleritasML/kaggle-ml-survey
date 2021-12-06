# kaggle-ml-survey
A machine learning research of [the 2021 Kaggle Machine Learning &amp; Data Science Survey](https://www.kaggle.com/c/kaggle-survey-2021) dataset.

## Setup

The following lines of script will load and install some required packages. You can add addtional package names inside the function `p_load()`.

```r
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, ggthemes, glue)
```

The following scripts will read the raw csv (assuming the current working directory is the root directory.

```r
col_names <- names(read_csv('data/kaggle_survey_2021_responses.csv', n_max=0))
dat <- read_csv('data/kaggle_survey_2021_responses.csv', col_names = col_names, skip=2)

# You can take a look at the data structure with:
glimpse(dat)
```

Run the following script to set up the `{ggplot2}` custom theme:

```r
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
```

