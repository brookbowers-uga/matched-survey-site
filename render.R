#Sys.setenv(RSTUDIO_PANDOC="E:\\Program Files\\RStudio\\bin\\pandoc")
source("qualtrics.R")
source("matched-pairs.R")
renderReport <- function(fileName,params) {
  rmarkdown::render("New.Rmd", output_file=fileName,params = params)
}

params <- calcPair(
  mapAdvisorQualtricsResults(fetchResponse("SV_dcXVPtf3N55z3ng","R_3Ic7LXPYQFHbLd4")),
  mapAdviseeQualtricsResults(fetchResponse("SV_9BjFOsJZkUxX7dc","R_1DqGryQbOjdZpxb")))
params$feedback <- "HELLO AMERICA!!"#input$feedback
rmarkdown::render("New.Rmd", output_file="report.pdf", params = params)

