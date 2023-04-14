#---- Chapter 1: Your First Shiny App ----

library(shiny)

ui <- fluidPage(
  textInput("username", "What's your name?"),
  
  textOutput("greeting")
)


server <- function(input, output) {
  output$greeting <- renderText({
    paste("Hello", input$username)
  })
}

shinyApp(ui, server)