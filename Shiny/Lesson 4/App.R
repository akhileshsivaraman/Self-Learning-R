#---- Lesson 4: Display reactive output ----
library(shiny)

#---- Two steps to create reactive output ----
# 1. add an R object to your user interface
# 2. Tell shiny how to build the object in the server function. The code needs to call a widget value

#---- Add an R object to the UI ----
# shiny has a family of functions that turn R objects into output for the UI
# each one creates a specific type of output
# e.g. dataTableOutput() creates a data table
# you add output functions inside the sidebarPanel() or mainPanel() functions, as you add HTML elements and widgets
# each output function requires a single argument: a character string that Shiny will use as the name of the reactive R object/element


#---- Provide R code to build the object ----
# placing a function in the UI tells shiny where to display the object so in the server we need to tell it how to build the object
# the server function builds a list-like object named output that contains all the code needed to update the R objects in your app
# each R object needs to have its own entry in the list
# you create an entry by defining a new element for output (output$___) within the server function - the element name should match the name of the reactive element you created in the UI
# each entry to output should be assigned a render function - the render function should correspond to the reactive object you are making
# render functions take a single argument which must be surrounded by {} - the expression within the {} are essentially instructions you give shiny to use later
# e.g. renderDataTable({})


#---- Making outputs reactive ----
# in the above step we use the output argument in our server function to build a list-like object that stores instructions to build R objects in the app
# input is another list-like object. It stores the current values of all the widgets in the app and these values are saved under the names you gave the widget in the UI
# the values of the widgets are saved in input and can be accessed using input$
# if an object uses an input value, shiny will automatically make it reactive
# input$stored_value is like Python's f"{stored_value}"



ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with information from the 2010 US Census"),
      selectInput(inputId = "select",
                  label = "Choose a variable to display",
                  choices = c("Percent White",
                              "Percent Black",
                              "Percent Hispanic",
                              "Percent Asian")
                  ),
      sliderInput(inputId = "range",
                  label = "Range of interest",
                  min = 0, max = 100, step = 2, value = 0
                  )
    ),
    
    mainPanel(
      textOutput("selected_variable"),
      textOutput("selected_range")
    )
  )
)


server <- function(input, output) {
  output$selected_variable <- renderText({
    paste("You have selected", input$select)
  })
  
  output$selected_range <- renderText({
    paste("You have selected", input$range)
  })
}


shinyApp(ui = ui, server = server)