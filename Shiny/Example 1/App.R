#---- Lesson 1: Welcome to Shiny ----
library(shiny)

#---- example 1 ----
# runExample("01_hello")
# code from the app below

# Define UI for app that draws a histogram
ui <- fluidPage(
  
  # App title
  titlePanel("Hello World!"),
  
  # Sidebar layout with input and output definitions
  sidebarLayout(
    
    # Sidebar panel for inputs
    sidebarPanel(
      
      # Input: Slider for the number of bins
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 5,
                  max = 50,
                  value = 30)
      
    ),
    
    # Main panel for displaying outputs
    mainPanel(
      
      # Output: Histogram
      plotOutput(outputId = "distPlot")
      
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Histogram of the Old Faithful Geyser Data
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  output$distPlot <- renderPlot({
    
    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = "#75AADB", border = "orange",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")
    
  })
  
}

# Create Shiny app
shinyApp(ui = ui, server = server)


#---- running the app ----
# Either use the Run App button at the top of the script or
# use runApp("directory name")
# runApp has some other parameters too