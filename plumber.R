# plumber.R
source("db.R")
source("qualtrics.R")
source("matched-pairs.R")
source("email.R")
library(tidyverse)
#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg="") {
  list(msg = paste0("The message is: '", msg, "'"))
}

#* Plot a histogram
#* @serializer png
#* @get /plot
function() {
  rand <- rnorm(100)
  hist(rand)
}

#* Return the sum of two numbers AND SAVE TO DB
#* @param a The first number to add
#* @param b The second number to add
#* @post /sum
function(a, b) {
  res <- data.frame(sum = as.numeric(a) + as.numeric(b))
  saveData(res, "sums")
  res
}

#* Store survey and response id
#* @param surveyID
#* @param responseID
#* @param pairID
#* @post /recordAdviseeResponse
function(surveyID, responseID, pairID) {
  res <- data.frame(surveyID = surveyID, responseID = responseID, pairID = pairID)
  saveData(res, "advisee_responses")
  res
}

#* Store survey and response id
#* @param surveyID
#* @param responseID
#* @param pairID
#* @post /recordAdvisorResponse
function(surveyID, responseID, pairID) {
  res <- data.frame(surveyID = surveyID, responseID = responseID, pairID = pairID)
  saveData(res, "advisor_responses")
  advisee <- loadQuery(paste("SELECT * FROM advisee_responses WHERE pairID =", pairID))
  qualtricsAdvisee <- mapAdviseeQualtricsResults(fetchResponse(surveyID = advisee$surveyID, responseID = advisee$responseID))
  qualtricsAdvisor <- mapAdvisorQualtricsResults(fetchResponse(surveyID = surveyID, responseID = responseID))
  matchedPair <- calcPair(qualtricsAdvisor, qualtricsAdvisee)
  matchedPair$feedback <- "Please reach out to hfedesco@uga.edu for any questions, comments, or concerns!"
  reportName <- paste("report-",qualtricsAdvisee$FirstName,"-",qualtricsAdvisor$Firstname,"-",Sys.Date,".pdf",sep="")
  rmarkdown::render("New.Rmd", output_file=reportName, params = matchedPair)
  send("matched.pairs.uga@gmail.com", c(qualtricsAdvisee$Email, qualtricsAdvisor$Email), "Please find attached your advisee/advisor report", reportName)
  file.remove(reportName)
  sentEmail <- data.frame(pairID, now())
  saveData("emails_sent", sentEmail)

  sentEmail
}
