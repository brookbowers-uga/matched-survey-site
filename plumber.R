# plumber.R
source("db.R")

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
  res <- data.frame(surveyID = surveyID, responseID = responseID)
  saveData(res, "advisee_responses")
  res
}

#* Store survey and response id
#* @param surveyID
#* @param responseID
#* @param pairID
#* @post /recordAdvisorResponse
function(surveyID, responseID, pairID) {
  res <- data.frame(surveyID = surveyID, responseID = responseID)
  saveData(res, "advisor_responses")
  res
}