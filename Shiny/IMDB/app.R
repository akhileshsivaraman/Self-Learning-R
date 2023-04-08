#---- IMDB Movie Browser ----

#---- loading packages and data ----
library(shiny)
library(tidyverse)
library(data.table)
load("data/movies.RData")



#---- defining variables ----
studio_names <- unique(movies$studio)


#---- UI ----
ui <- fluidPage(
  
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput(inputId = "y", 
                  label = "Y-axis",
                  choices = c("IMDB Rating" = "imdb_rating",
                              "Number of votes" = "imdb_num_votes", 
                              "Critic's score" = "critics_score", 
                              "Audience score" = "audience_score",
                              "Run time "= "runtime"),
                  selected = "audience_score"),
      
      selectInput(inputId = "x",
                  label = "X-axis",
                  choices = c("IMDB Rating" = "imdb_rating",
                              "Number of votes" = "imdb_num_votes", 
                              "Critic's score" = "critics_score", 
                              "Audience score" = "audience_score",
                              "Run time "= "runtime"),
                  selected = "critics_score"),
      
      selectInput(inputId = "z",
                  label = "Colour by",
                  choices = c("Type of film" = "title_type", 
                              "Genre" = "genre",
                              "MPAA Rating" = "mpaa_rating",
                              "Critic's rating" = "critics_rating",
                              "Audience rating" = "audience_rating"),
                  selected = "genre"),
      
      selectInput(inputId = "selected_studio",
                  label = "Select a studio",
                  choices = studio_names,
                  selectize = T,
                  multiple = T),
      
      sliderInput(inputId = "alpha", 
                  label = "Select transparency", 
                  min = 0,
                  max = 1, 
                  value = 0.5, 
                  step = 0.05),
      
      numericInput(inputId = "sample_size", 
                   label = "Number of films to view", 
                   value = 100, 
                   min = 1,
                   max = 651,
                   step = 1),
      helpText("Enter a number between 1 and 651"),
      
      checkboxInput(inputId = "show_table", 
                    label = "Show table?", 
                    value = FALSE)
    ),
    
    mainPanel(
      plotOutput(outputId = "scatterplot"),
      dataTableOutput(outputId = "movie_table")
    )
  )
)



#---- server ----
server <- function(input, output){

  # sample movies data according to the user inputs
  movies_sample <- reactive({
    req(input$sample_size, cancelOutput = TRUE) # if the user were to clear the numeric input, the app would throw up an error. We use req() to avoid that error by checking if the input is valid and throwing up a silent error if it is invalid. cancelOutput=TRUE retains the previous output rather than leaving the output blank
    req(input$selected_studio, cancelOutput = TRUE)
    movies |>
      filter(studio %in% input$selected_studio) |>
      slice_sample(n = input$sample_size)
  })
  
  # create graph
  output$scatterplot <- renderPlot({
    ggplot(movies_sample()) +
      geom_point(aes_string(input$x, input$y, colour = input$z), alpha = input$alpha)
  })
  
  
  # select columns for table
  movies_table_sample <- reactive({
    movies_sample() |>
      select(c("title", "genre", "runtime", "mpaa_rating", "studio", "imdb_rating", "critics_rating", "audience_rating"))
  })
  
  # create table
  output$movie_table <- renderDataTable({
    if(input$show_table){
      data.table(movies_table_sample(), keep.rownames = F)
    }
  })
}


#---- create app ----
shinyApp(ui, server)