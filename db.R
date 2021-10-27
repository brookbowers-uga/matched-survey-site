#db.R
library(RSQLite)
dbPath <- "./db.db"

saveData <- function(data, table) {
  # Connect to the database
  db <- dbConnect(SQLite(), dbPath)
  # Construct the update query by looping over the data fields
  query <- sprintf(
    "INSERT INTO %s (%s) VALUES ('%s')",
    table, 
    paste(names(data), collapse = ", "),
    paste(data, collapse = "', '")
  )
  # Submit the update query and disconnect
  dbExecute(db, query)
  dbDisconnect(db)
}

loadData <- function(table) {
  # Connect to the database
  db <- dbConnect(SQLite(), dbPath)
  # Construct the fetching query
  query <- sprintf("SELECT * FROM %s", table)
  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  data
}

loadQuery <- function(query) {
  db <- dbConnect(SQLite(), dbPath)
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  data
}


query <- function(query) {
  db <- dbConnect(SQLite(), dbPath)
  data <- dbExecute(db, query)
  dbDisconnect(db)
  data
}

query("CREATE TABLE IF NOT EXISTS sums(sum INTEGER);")
query("CREATE TABLE IF NOT EXISTS advisor_responses(surveyID, responseID, pairID);")
query("CREATE TABLE IF NOT EXISTS advisee_responses(surveyID, responseID, pairID);")
query("CREATE TABLE IF NOT EXISTS report_feedback(pairID, feedback);")
query("CREATE TABLE IF NOT EXISTS emails_sent(pairID, dateTime);")

#loadData("sums")
