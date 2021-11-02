library(bnlearn)
library(dplyr)
library(gRain)
library(lattice)
library(tidyverse)
library(Rgraphviz)


# Read csv
file <- "../data/kaggle_survey_2021_responses.csv"
# headers = read.csv(file, skip = 0, header = F, nrows = 1, as.is = T, fileEncoding = "utf8")
# dat = read.csv(file, skip = 2, header = F, fileEncoding = "utf8")
# colnames(dat)= headers
# saveRDS(dat, "rds/survey.rds")

dat <- readRDS("rds/survey.rds")

dat$Q2[dat$Q2 %in% c("Nonbinary", "Prefer not to say", "Prefer to self-describe")] <- "Other"
dat$Q3[dat$Q3 == "Hong Kong (S.A.R.)"] <- "HKSAR"
dat$Q3[dat$Q3 == "I do not wish to disclose my location"] <- "Other"
dat$Q3[dat$Q3 == "I do not wish to disclose my location"] <- "Other"
dat$Q3[dat$Q3 == "Iran, Islamic Republic of..."] <- "Iran"
dat$Q3[dat$Q3 == "United Arab Emirates"] <- "UAE"
dat$Q3[dat$Q3 == "United Kingdom of Great Britain and Northern Ireland"] <- "UK"
dat$Q3[dat$Q3 == "United States of America"] <- "US"
dat$Q4[dat$Q4 == "No formal education past high school"] <- "HighSchool"
dat$Q4[dat$Q4 == "Some college/university study without earning a bachelor¡¯s degree"] <- "CollegeNoDegree"
dat$Q4[dat$Q4 == "Bachelor¡¯s degree"] <- "BS"
dat$Q4[dat$Q4 == "Master¡¯s degree"] <- "MS"
dat$Q4[dat$Q4 == "Doctoral degree"] <- "PhD"
dat$Q4[dat$Q4 == "Professional doctorate"] <- "ProDoc"
dat$Q4[dat$Q4 == "I prefer not to answer"] <- "Other"
dat$Q8[dat$Q8 %in% c("", "Bash", "Julia", "None", "Swift")] <- "Other"
dat$Q11[dat$Q11 == "A laptop"] <- "laptop"
dat$Q11[dat$Q11 == "A personal computer / desktop"] <- "desktop"
dat$Q11[dat$Q11 == "A deep learning workstation (NVIDIA GTX, LambdaLabs, etc)"] <- "workstation"
dat$Q11[dat$Q11 == "A cloud computing platform (AWS, Azure, GCP, hosted notebooks, etc)"] <- "cloud"
dat$Q11[dat$Q11 == ""] <- "None"

dat.small <- data.frame(
  age = factor(dat$Q1),
  gender = factor(dat$Q2),
  country = factor(dat$Q3),
  education = factor(dat$Q4),
  job.title = factor(dat$Q5),
  job.industry = factor(dat$Q20),
  job.employee = factor(dat$Q21),
  job.team = factor(dat$Q22),
  job.ml.usage = factor(dat$Q23),
  job.salary = factor(dat$Q25),
  job.ml.cost = factor(dat$Q26),
  code.year = factor(dat$Q6),
  code.python = factor(dat$Q7_Part_1 != ""),
  code.r = factor(dat$Q7_Part_2 != ""),
  code.sql = factor(dat$Q7_Part_3 != ""),
  code.c = factor(dat$Q7_Part_4 != ""),
  code.cpp = factor(dat$Q7_Part_5 != ""),
  code.java = factor(dat$Q7_Part_6 != ""),
  code.javascript = factor(dat$Q7_Part_7 != ""),
  code.matlab = factor(dat$Q7_Part_11 != ""),
  code.first = factor(dat$Q8),
  ide.jupyter = factor(dat$Q9_Part_1 != ""),
  ide.rstudio = factor(dat$Q9_Part_2 != ""),
  ide.vs = factor(dat$Q9_Part_3 != ""),
  ide.vscode = factor(dat$Q9_Part_4 != ""),
  ide.pycharm = factor(dat$Q9_Part_5 != ""),
  ide.spyder = factor(dat$Q9_Part_6 != ""),
  ide.notepad = factor(dat$Q9_Part_7 != ""),
  ide.slime = factor(dat$Q9_Part_8 != ""),
  ide.vim = factor(dat$Q9_Part_9 != ""),
  ide.matlab = factor(dat$Q9_Part_10 != ""),
  compute.plat = factor(dat$Q11),
  hardware.nvidia = factor(dat$Q12_Part_1 != ""),
  hardware.tpu = factor(dat$Q12_Part_2 != ""),
  hardware.aws.train = factor(dat$Q12_Part_3 != ""),
  hardware.aws.infer = factor(dat$Q12_Part_4 != ""),
  hardware.tpu.freq = factor(dat$Q13),
  vis.matplotlib = factor(dat$Q14_Part_1 != ""),
  vis.seaborn = factor(dat$Q14_Part_2 != ""),
  vis.plotly = factor(dat$Q14_Part_3 != ""),
  vis.ggplot = factor(dat$Q14_Part_4 != ""),
  vis.shiny = factor(dat$Q14_Part_5 != ""),
  vis.d3 = factor(dat$Q14_Part_6 != ""),
  vis.altair = factor(dat$Q14_Part_7 != ""),
  vis.bokeh = factor(dat$Q14_Part_8 != ""),
  vis.geoplotlib = factor(dat$Q14_Part_9 != ""),
  vis.leaflet = factor(dat$Q14_Part_10 != ""),
  ml.year = factor(dat$Q15),
  ml.sklearn = factor(dat$Q16_Part_1 != ""),
  ml.tf = factor(dat$Q16_Part_2 != ""),
  ml.keras = factor(dat$Q16_Part_3 != ""),
  ml.pytorch = factor(dat$Q16_Part_4 != ""),
  ml.fastai = factor(dat$Q16_Part_5 != ""),
  ml.mxnet = factor(dat$Q16_Part_6 != ""),
  ml.xgboost = factor(dat$Q16_Part_7 != ""),
  ml.lightgbm = factor(dat$Q16_Part_8 != ""),
  ml.catboost = factor(dat$Q16_Part_9 != ""),
  ml.prophet = factor(dat$Q16_Part_10 != ""),
  ml.h2o3 = factor(dat$Q16_Part_11 != ""),
  ml.caret = factor(dat$Q16_Part_12 != ""),
  ml.tidymodel = factor(dat$Q16_Part_13 != ""),
  ml.jax = factor(dat$Q16_Part_14 != ""),
  ml.pytorchlightning = factor(dat$Q16_Part_15 != ""),
  ml.huggingface = factor(dat$Q16_Part_16 != ""),
  ml.model.lr = factor(dat$Q17_Part_1 != ""),
  ml.model.dt = factor(dat$Q17_Part_2 != ""),
  ml.model.gb = factor(dat$Q17_Part_3 != ""),
  ml.model.bayes = factor(dat$Q17_Part_4 != ""),
  ml.model.evol = factor(dat$Q17_Part_5 != ""),
  ml.model.dnn = factor(dat$Q17_Part_6 != ""),
  ml.model.cnn = factor(dat$Q17_Part_7 != ""),
  ml.model.gan = factor(dat$Q17_Part_8 != ""),
  ml.model.rnn = factor(dat$Q17_Part_9 != ""),
  ml.model.trans = factor(dat$Q17_Part_10 != "")
)
str(dat.small)

table(dat.small[,c("ide.jupyter", "code.python")]) #TRUE
table(dat.small[,c("ide.jupyter", "code.r")]) #TRUE

ide.code <- function(ide, code) {
  a <- table(dat.small[,c(ide, code)])
  return(tibble(TT=round(a[2,2]/sum(a[,2]), 3), TF=round(a[2,1]/sum(a[,1]), 3), T=round(sum(a[2,])/sum(a), 3)))
}

cond.table <- expand.grid(ide = c("ide.jupyter","ide.rstudio","ide.vs","ide.vscode","ide.pycharm","ide.spyder","ide.notepad","ide.slime","ide.vim","ide.matlab"), code = c("code.python","code.r","code.sql","code.c","code.cpp","code.java","code.javascript","code.matlab"), stringsAsFactors = F) %>%
  group_by(ide, code) %>%
  do(ide.code(.$ide, .$code))

write.csv(cond.table, "ide-code-table.csv", row.names = F)
saveRDS(dat.small, "rds/survey-small.rds")