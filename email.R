library(gmailr)
library(dplyr)
gm_auth_configure(path = "email_secret.json")
gm_auth()

send <- function(plot, emailText) {
  my_email_message <- gm_mime() %>%
  gm_to("bbb41415@uga.edu") %>%
  gm_from("upidstupid@gmail.com") %>%
  gm_subject("My test message") %>%
  gm_text_body(emailText)%>%
  gm_attach_file()
  
  gm_send_message(my_email_message)
}