library(gmailr)
library(dplyr)
gm_auth_configure(path = "./matched-pairs-secret.json")
gm_auth(email = TRUE, cache = ".secret")

send <- function(from, to, emailText, attachment){
  my_email_message <- gm_mime() %>%
  gm_to(to) %>%
  gm_from(from) %>%
  gm_subject("Your advisor/advisee assement report") %>%
  gm_text_body(emailText)%>%
  gm_attach_file(attachment)
  
  gm_send_message(my_email_message)
}

