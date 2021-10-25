#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

source("db.R")
source("email.R")
source("qualtrics.R")
source("matched-pairs.R")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("HELLO AMERICA HERE COMES GOD"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            actionButton("email", "Send Email")
        ),

        # Show a plot of the generated distribution
        mainPanel(
          textInput("feedback", h3("Feedback"), placeholder="Optional text to go in the report")
           #tabsetPanel(
             #tabPanel("Report", tags$iframe(style="height:600px; width:100%", src="http://localhost/ressources/pdf/R-Intro.pdf"))
             #tabPanel("hist", plotOutput("distPlot"), textInput("feedback", h3("Feedback"), placeholder="Optional text to go in the report")),
             #tabPanel("text", h1("JESUS"))
           #)
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    observeEvent(input$email, {
      params <- calcPair(
        mapAdvisorQualtricsResults(fetchResponse("SV_dcXVPtf3N55z3ng","R_3Ic7LXPYQFHbLd4")),
        mapAdviseeQualtricsResults(fetchResponse("SV_9BjFOsJZkUxX7dc","R_1DqGryQbOjdZpxb")))
      params$feedback <- input$feedback
      rmarkdown::render("New.Rmd", output_file="report.pdf", params = params)
      #send(output$distplot, input$emailText)
    })
}


# Run the application 
shinyApp(ui = ui, server = server)