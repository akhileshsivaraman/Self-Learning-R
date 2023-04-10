#---- IMDB Movie Browser ----

#---- loading packages and data ----
library(shiny)
library(shinythemes)
library(tidyverse)
library(data.table)
load("data/movies.RData")



#---- defining variables ----
studio_names <- unique(movies$studio)

movies <- movies |>
  mutate(score_ratio = audience_score/critics_score)

n_movies <- nrow(movies)


#---- UI ----
ui <- fluidPage(
  
  shinytheme(theme = "simplex"),
  
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
      
      radioButtons(inputId = "file_type",
                   label = "Select file type",
                   choices = c("csv", "tsv"),
                   selected = "csv"),
      downloadButton(outputId = "download_data", 
                     label = "Download data"),
      helpText("Download data of films sampled"),
      
      br(),
      
      checkboxGroupInput(inputId = "selected_title_type",
                         label = "Select title types to include in the summary table",
                         choices = levels(movies$title_type), # another way to provide choices is using levels rather than unique
                         selected = levels(movies$title_type)),
      
      selectInput(inputId = "selected_studio",
                  label = "Select a studio",
                  choices = studio_names, # one way to provide choices is in a vector where you've identified unique options
                  selectize = T,
                  multiple = T, 
                  selected = levels(movies$studio)),
      
      checkboxInput(inputId = "show_table", 
                    label = "Show table?", 
                    value = FALSE)
    ),
    
    mainPanel(
      titlePanel("IMDB Movie Browser"),
      p("The data used represents", n_movies, "randomly sampled movies released between 1972 and 2014 in the US"),
      br(),
      
      tabsetPanel(
        type = "tabs",
        tabPanel(
          title = "Plot",
          h4("Investigate movie ratings on IMDB"),
          plotOutput(outputId = "scatterplot", 
                     brush = "plot_brush"), # define the variable stored in input
          textOutput(outputId = "correlation"),
          br(),
          h5("Select some films in the graph above to see more about them"),
          dataTableOutput(outputId = "brush_table")
        ),
        
        tabPanel(
          title = "Summary stats",
          h4("Summary statistics by MPAA rating"),
          p("score ratio = audience score/critic's score"),
          tableOutput(outputId = "summary_table")
        ),
        
        tabPanel(
          title = "Sampled data",
          dataTableOutput(outputId = "movie_table")
        )
      )
    )
  )
)



#---- server ----
server <- function(input, output){

  #---- sample movies data according to the user inputs ----
  movies_sample <- reactive({
    req(input$sample_size, cancelOutput = TRUE) # if the user were to clear the numeric input, the app would throw up an error. We use req() to avoid that error by checking if the input is valid and throwing up a silent error if it is invalid. cancelOutput=TRUE retains the previous output rather than leaving the output blank
    req(input$selected_studio, cancelOutput = TRUE)
    movies |>
      filter(studio %in% input$selected_studio) |>
      slice_sample(n = input$sample_size)
  })
  
  
  #---- graph ----
  output$scatterplot <- renderPlot({
    ggplot(movies_sample()) +
      geom_point(aes_string(input$x, input$y, colour = input$z), alpha = input$alpha)
  })
  
  output$brush_table <- renderDataTable({
    brushedPoints(movies_sample(), brush = input$plot_brush) |>
      select(c("title", "audience_score", "critics_score"))
  }, options = list(pageLength = 10))
  
  
  #---- download data file ----
  output$download_data <- downloadHandler(
    filename = function(){
      paste0("movies.", input$file_type)
    },
    content = function(file){
      if (input$file_type == "csv"){
        write_csv(movies_sample(), file)
      }
      if (input$file_type == "tsv"){
        write_csv(movies_sample(), file)
      }
    }
  )
  
  
  #---- correlation ----
  r <- reactive({
    round(cor(movies[, input$x], movies[, input$y], use = "pairwise"), 2)
  })
  
  output$correlation <- renderText({
    paste("Correlation = ", r(), ". Note: if the relationship between the two variables is not linear, the correlation coefficient will not be meaningful.")
  })
  
  
  #---- movies table ----
  # select columns for movies table
  movies_table_sample <- reactive({
    movies_sample() |>
      select(c("title", "genre", "runtime", "mpaa_rating", "studio", "imdb_rating", "critics_rating", "audience_rating"))
  })
  
  # create movies table
  output$movie_table <- renderDataTable({
    if(input$show_table){
      data.table(movies_table_sample(), keep.rownames = F)
    }
  }, options = list(pageLength = 10)) # limit the table page to 10 entries
  
  
  #---- summary table ----
  summary_table_data <- reactive({
    movies |>
      filter(title_type %in% input$selected_title_type) |>
      group_by(mpaa_rating) |>
      summarise(mean_score_ratio = mean(score_ratio),
                sd_score_ratio = sd(score_ratio),
                sample_size = n())
  })
  
  output$summary_table <- renderTable({
    summary_table_data()
  }, striped = T, bordered = T)
  
}


#---- create app ----
shinyApp(ui, server)