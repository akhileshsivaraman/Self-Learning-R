#---- Lesson 5: Using R scripts and data ----
library(shiny)


#---- loading data and R scripts ----
# shiny uses the directory in which the app script sits as working directory
# where to place the commands to load files matters because shiny runs some sections more than others
# shiny runs the whole script the first time you run the app
# shiny runs the server function whenever a new user uses the app
# as a user interacts with a widget, shiny re-runs the expressions assigned to the reactive object that depends on that widget
# consequently, it is best to place code to load files at the beginning of your script, outside the server function
# any user specific objects should be defined inside the server functions but outside render calls
# any code the must be re-run to build an object should go inside a render function


#---- loading in practice ----
# load packages
library(maps)
library(mapproj)

# source function
source("helpers.R")

# load data
counties <- readRDS("data/counties.rds")


#---- UI ----
ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with information from the 2010 US Census."),
      
      selectInput(inputId = "selected_demographic",
                  label = "Choose a demographic to display",
                  choices = c("Percent White", "Percent Black", "Percent Hispanic", "Percent Asian"),
                  selected = "Percent White"
                  ),
      
      sliderInput(inputId = "selected_range",
                  label = "Range of interest",
                  min = 0, max = 100, value = c(0, 100)
                  )
    ),
    
    mainPanel(plotOutput("map"))
  )
)


#---- server ----
server <- function(input, output){
  output$map <- renderPlot({
    data <- switch(input$selected_demographic, # if the selected_demographic matches one of the following, that column from counties is taken as the data
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    
    colour <- switch(input$selected_demographic,
                     "Percent White" = "darkgreen",
                     "Percent Black" = "blue",
                     "Percent Hispanic" = "firebrick",
                     "Percent Asian" = "orange")
    
    percent_map(var = data,
                color = colour,
                legend.title = paste(input$selected_demographic, "in US counties"),
                min = input$selected_range[1],
                max = input$selected_range[2])
  })
}


shinyApp(ui, server)