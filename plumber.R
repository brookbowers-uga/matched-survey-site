# plumber.R
source("db.R")
source("qualtrics.R")
source("matched-pairs.R")
source("email.R")
library(tidyverse)
library(lubridate)
library(sendgridr)
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
  res <- data.frame(surveyID = surveyID, responseID = responseID, pairID = pairID, stringsAsFactors=FALSE)
  saveData(res, "advisee_responses")
  res
}

#* Store survey and response id
#* @param surveyID
#* @param responseID
#* @param pairID
#* @post /recordAdvisorResponse
function(surveyID, responseID, pairID) {
  alreadySent <- loadQuery(paste("SELECT * FROM sent_emails WHERE pairID ='",pairID,"'",sep=""))
  if(nrow(alreadySent) > 0) return("Already emailed!")
  
  res <- data.frame(surveyID = surveyID, responseID = responseID, pairID = pairID, stringsAsFactors=FALSE)
  saveData(res, "advisor_responses")
  query <- paste("SELECT * FROM advisee_responses WHERE pairID ='",pairID,"'",sep="")
  print(query)
  advisee <- loadQuery(query)
  print(advisee)
  qualtricsAdvisee <- mapAdviseeQualtricsResults(fetchResponse(surveyID = advisee$surveyID, responseID = advisee$responseID))
  qualtricsAdvisor <- mapAdvisorQualtricsResults(fetchResponse(surveyID = surveyID, responseID = responseID))
  params <- calcPair(qualtricsAdvisor, qualtricsAdvisee)
  params$feedback <- "Please reach out to hfedesco@uga.edu for any questions, comments, or concerns!"
  reportName <- paste("report-",qualtricsAdvisee$FirstName,"-",qualtricsAdvisor$FirstName,"-",Sys.Date(),".pdf",sep="")
  print(Cstack_info())
  rmarkdown::render("New.Rmd", output_file=reportName, params = params)
  print(auth_check())
  print(Cstack_info())
  print("Try Send")
  send("matched.pairs.uga@gmail.com", c(qualtricsAdvisee$Email, qualtricsAdvisor$Email), "Please find attached your advisee/advisor report", reportName)
  print("Send done")
  file.remove(reportName)
  print("make send email")
  sentEmail <- data.frame(pairID = pairID, dateTime = toString(now()), stringsAsFactors=FALSE)
  print("save send email")
  saveData(sentEmail, "sent_emails")
  print("job done")
  sentEmail
}
