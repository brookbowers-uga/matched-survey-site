library(gmailr)
library(dplyr)
#gm_auth_configure(path = "./email_secret.json")
#gm_auth(email = TRUE, cache = ".secret")

# send <- function(plot, emailText) {
#   my_email_message <- gm_mime() %>%
#   gm_to("bbb41415@uga.edu") %>%
#   gm_from("upidstupid@gmail.com") %>%
#   gm_subject("My test message") %>%
#   gm_text_body(emailText)#%>%
#   #gm_attach_file()
#   
#   gm_send_message(my_email_message)
# }

library("sendmailR")

msg <- mime_part('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0
Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>HTML demo</title>
  <style type="text/css">
  </style>
</head>
<body>
<h1>HTML demo</h1>
</body>
</html>')

## Set content type.
msg[["headers"]][["Content-Type"]] <- "text/html"

from <- sprintf("<sendmailR@\\%s>", Sys.info()[4])
to <- "<bbb41415@uga.edu>"
subject <- "HTML test"
body <- list(msg)
sendmail(from, to, subject, body,
         control=list(smtpServer="ASPMX.L.GOOGLE.COM"))