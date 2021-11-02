library(bnlearn)
library(dplyr)
library(gRain)
library(plumber)

bn.small = readRDS("rds/bn-small.rds")
grain = as.grain(bn.small)

#* @apiTitle DS/ML Advice API


#* Intro
#* @param msg Any message passes to API
#* @get /intro
function(msg = "") {
  list(msg = paste0("This a DS/ML Advice API based on Kaggle Service. I received your message: ", msg, "."))
}

#* Which programming language should I learn first?
#* @post /first-language
function() {
  list(language = "Python")
}

#* Which programming language should I learn after Python?
#* @param age Your age, leave empty or one of c("18-21","22-24","25-29","30-34","35-39","40-44","45-49","50-54","55-59","60-69","70+")
#* @param gender Your gender, leave empty or one of c("Man", "Woman", Other")
#* @param country Your country, try Other if not work
#* @param education Your educational level, leave empty or one of c("BS","CollegeNoDegree","HighSchool","MS","PhD","ProDoc","Other")
#* @param title Your target job title, leave empty or one of c("Business Analyst","Data Analyst","Data Engineer","Machine Learning Engineer","DBA/Database Engineer","Research Scientist","Software Engineer","Statistician","Developer Relations/Advocacy","Product Manager","Program/Project Manager")
#* @post /next-language
function(age = "", gender = "", country = "", education = "", title = "") {
  junction = compile(grain)
  nodes = NULL
  values = NULL
  if (age != "") {
    nodes = c(nodes, "age")
    values = c(values, age)
  }
  if (gender != "") {
    nodes = c(nodes, "gender")
    values = c(values, gender)
  }
  if (country != "") {
    nodes = c(nodes, "country")
    values = c(values, country)
  }
  if (education != "") {
    nodes = c(nodes, "education")
    values = c(values, education)
  }
  if (title != "") {
    nodes = c(nodes, "title")
    values = c(values, title)
  }
  jevi = setEvidence(junction, nodes = nodes, states = values)
  q = querygrain(jevi, nodes = c("code.first"), type = "marginal")
  q.next = q$code.first[!names(q$code.first) %in% c("Python", "Other")]
  ans = data.frame(Prob=sort(q.next, decreasing=TRUE)) %>% rownames_to_column(var = "language")
  ans[1:3,]
}
