#qualtrics.R

library(httr)
library(jsonlite)

token <- "XiuvZKtXd8LeHmUcNNaWTUzI080hOeXJLTjve82O"

fetchResponse <- function(surveyID, responseID) {
  URL <- paste("https://ugeorgia.ca1.qualtrics.com/API/v3/surveys/",surveyID,"/responses/",responseID, sep="")
  get_response <- GET(url = URL, add_headers("content-type" = "application/json", "x-api-token" = token))
  get_response_text <- content(get_response, "text")
  get_response_json <- fromJSON(get_response_text, flatten = TRUE)
  get_response_json
  }