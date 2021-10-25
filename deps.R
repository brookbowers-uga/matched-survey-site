repo = "http://cran.us.r-project.org"
# RESTFUL API hosting
if(!require(plumber)) install.packages("plumber", repos = repo)
# %>%
if(!require(dplyr)) install.packages("dplyr", repos = repo)
# db
if(!require(RSQLite)) install.packages("RSQLite", repos = repo)
# sending emails
if(!require(gmailr)) install.packages("gmailr", repos = repo)
# making web requests
if(!require(httr)) install.packages("httr", repos = repo)
# parsing json from web requests
if(!require(jsonlite)) install.packages("jsonlite", repos = repo)
# web app for visualization
if(!require(shiny)) install.packages("shiny", repos = repo)

# for reporting
if(!require(knitr)) install.packages("knitr", repos = repo)
if(!require(kableExtra)) install.packages("kableExtra", repos = repo)
if(!require(ggplot2)) install.packages("ggplot2", repos = repo)
if(!require(stringr)) install.packages("stringr", repos = repo)
if(!require(readr)) install.packages("readr", repos = repo)
if(!require(psych)) install.packages("psych", repos = repo)
if(!require(rmarkdown)) install.packages("rmarkdown", repos = repo)
if(!require(lubridate)) install.packages("lubridate", repos = repo)


#tinytex::install_tinytex()
#webshot::install_phantomjs()