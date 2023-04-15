#---- Chapter 4: ER Injuries ----

#---- load libraries ----
library(shiny)
library(tidyverse)
library(vroom)


#---- load data ----
injuries <- vroom("neiss/injuries.tsv")
population <- vroom("neiss/population.tsv")
products <- vroom("neiss/products.tsv")


#---- functions ----
# function to select the top 5 factors and then combine the rest
count_top <- function(df, var, n = 5) {
  df %>%
    mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
    group_by({{ var }}) %>%
    summarise(n = as.integer(sum(weight)))
}

#---- code not needed in the app ----
prod_codes <- setNames(products$prod_code, products$title)


#---- UI ----
ui <- fluidPage(
  fluidRow(
    column(8,
           selectInput("code", "Product", # allow the user to select a product
                       choices = prod_codes,
                       width = "100%")
    ),
    column(2,
           selectInput("y", "Y-axis", c("rate", "count"))) # allow the user to select whether they want to plot the count of injuries or the rate at which injuries occur
  ),
  
  fluidRow(
    column(4, tableOutput("diag")),
    column(4, tableOutput("body_part")),
    column(4, tableOutput("location"))
  ),
  
  fluidRow(
    column(12, plotOutput("age_sex"))
  ),
  
  fluidRow(
    column(2, actionButton("story", "Tell me a story")), # an action button to dictate when the narrative is updated
    column(10, textOutput("narrative"))
  )
)


#---- server ----
server <- function(input, output, session) {
  
  selected <- reactive(injuries |>
                         filter(prod_code == input$code)) # filter the injuries data for the selected product
  
  output$diag <- renderTable(
    count_top(selected(), diag), 
    width = "100%"
  ) # diagnosis table
  
  output$body_part <- renderTable(
    count_top(selected(), body_part),
    width = "100%"
  ) # body part table
  
  output$location <- renderTable(
    count_top(selected(), location),
    width = "100%"
  ) # location table
  
  summary <- reactive({
    selected() |>
      count(age, sex, wt = weight) |>
      left_join(population, by = c("age", "sex")) |>
      mutate(rate = n / population * 1e4)
  }) # data of the selected product standardised for population size and grouped by sex
  
  output$age_sex <- renderPlot({ 
    if (input$y == "count") {
      summary() %>%
        ggplot(aes(age, n, colour = sex)) +
        geom_line() +
        labs(y = "Estimated number of injuries")
    } else {
      summary() %>%
        ggplot(aes(age, rate, colour = sex)) +
        geom_line(na.rm = TRUE) +
        labs(y = "Injuries per 10,000 people")
    }
  }, res = 96) # plot count or rate based on what the user has selected
  
  narrative_sample <- eventReactive( 
    list(input$story, selected()), # only update the narrative_sample when input$story changes
    selected() |> # pull a narrative from the data sampled for the product selected
      pull(narrative) |>
      sample(1)
  )
  output$narrative <- renderText(narrative_sample()) # render the text of the narrative sampled

}


#---- create app ----
shinyApp(ui, server)