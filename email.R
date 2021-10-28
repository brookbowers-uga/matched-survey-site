library(gmailr)
library(dplyr)
library(jsonlite)
library(httr)
library(RCurl)
#gm_auth_configure(path = "./matched-pairs-secret.json")
#gm_auth(email = TRUE, cache = ".secret")

send <- function(from, to, emailText, attachment) {
	subject <- "Your advisee/advisor report"
	message.body <- emailText
	file <- file(attachment, "rb")
	print(file)
	binFile <- readBin(file, raw(), file.info(attachment)[1, "size"])
	attachmentContent <- base64(binFile, mode="character")
	msg <- sprintf('{\"personalizations\":
	              [{\"to\": [{\"email\": \"%s\"},{\"email\": \"%s\"}]}],
                      \"from\": {\"email\": \"%s\"},
                      \"subject\": \"%s",
                      \"content\": [{\"type\": \"text/plain\",
		      \"value\": \"%s\"}],
		      \"attachments\": [{\"content\": \"%s\", \"type\":\"application/pdf\",\"filename\":\"%s\"}]}', 
		      to[1], to[2], from, subject, message.body,attachmentContent,attachment)
        pp <- POST("https://api.sendgrid.com/v3/mail/send",
		  body=msg,
		  config=add_headers("Authorization" = sprintf("Bearer %s", Sys.getenv("SENDGRID_API")),
"Content-Type" = "application/json"), verbose())
	print(pp)
  #my_email_message <- gm_mime() %>%
  #gm_to(to) %>%
  #gm_from(from) %>%
  #gm_subject("Your advisor/advisee assement report") %>%
  #gm_text_body(emailText)%>%
  #gm_attach_file(attachment)
  
  #gm_send_message(my_email_message)
}

