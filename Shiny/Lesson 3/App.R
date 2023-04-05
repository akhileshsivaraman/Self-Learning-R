#---- Lesson 3: Add control widgets ----
library(shiny)

#---- Adding widgets ----
# You can add widgets in the same way you add other types of HTML
# place widget functions in the sidebarPanel or mainPanel in the ui
# widgets take many arguments, the first two are:
# - name for the widget (inputID): the user won't see this but you can use it to access the widget's value (it's like a key)
# - label: the user will see this

# gallery of widgets with explanations and sample code: https://shiny.rstudio.com/gallery/widget-gallery.html

ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    
    sidebarPanel(
      helpText("Create demographic maps with information from the 2010 US Census"),
      selectInput(inputId = "select",
                  label = h5("Choose a variable to display"),
                  choices = list("Percent White" = 1,
                                 "Percent Black" = 2,
                                 "Percent Hispanic" = 3,
                                 "Percent Asian" = 4)),
      sliderInput(inputId = "range",
                  label = h5("Range of interest"), 
                  min = 0, max = 100, step = 5, value = 0)
    ),
    
    mainPanel()
  )
)


server <- function(input, output) {
  
}


shinyApp(ui = ui, server = server)