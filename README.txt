==Matched Surveys Site (MSS)==
Quick and dirty solution for pulling surveys from Qualtrics, matching them based on a pre-existing id/relationship, computing, visualizing, and emailing some results

==Dependencies==
# RESTFUL API hosting
install.packages(plumber)
# %>%
install.packages(dplyr)
# db
install.packages(RSQLite)
# sending emails
install.packages(gmailr)
# making web requests
install.packages(httr)
# parsing json from web requests
install.packages(jsonlite)
# web app for visualization
install.packages(shiny)

# for reporting
install.packages(knitr)
install.packages(kableExtra)
install.packages(ggplot2)
install.packages(stringr)
install.packages(readr)
install.packages(psych)

==Setup==
You need to provide an API secret from the google developer console for GMail API. MSS will then have you do an authorization step in browser, then MSS can send emails on your behalf.

==Running==
Rscript run-shiny.R
Rscript api.R
