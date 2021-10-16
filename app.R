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


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("HELLO AMERICA HERE COMES GOD"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 5,
                        max = 50,
                        value = 30),
            actionButton("email", "Email")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           tabsetPanel(
             tabPanel("hist", plotOutput("distPlot"), textInput("emailText", h3("Additional email text"), value="Optional text to go in the email")),
             tabPanel("text", h1("JESUS"))
           )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- unlist(loadData("sums"), use.names = FALSE)
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'orange')
    })
    
    observeEvent(input$email, {
      send(output$distplot, input$emailText)
    })
}


# Run the application 
shinyApp(ui = ui, server = server)