#----- main_panel_content.R -----
# module including the content of the main panel for the FeederWatch App

#---- load packages ----
library(shiny)
library(tidyverse)
library(bslib)


#---- functions ----



#---- main_panel_content_UI ----
main_panel_content_UI <- function(id){
  tagList(
    h2("Map"),
    p("With this dashboard, you can quickly visualise where species of bird were observed in North America by the FeederWatch community over Winter 2020/2021. Select a species of interest in the menu on the left then click the button and the map below will update."),
    textOutput(NS(id, "graph_title")),
    card(plotOutput(NS(id, "species_location")), full_screen = T),
    br(),
    h3("Plotted Data"),
    p("The table below describes the data shown in the map"),
    card(DT::dataTableOutput(NS(id, "species_table")))
  )
}


#---- main_panel_content_server ----
main_panel_content_server <- function(id, species_manager, species_df = NULL, world = NULL){
  moduleServer(id, function(input, output, session){
    
    graph_title_event <- eventReactive(species_manager$button_trigger, {
      paste0("Sites where ", species_manager$selected_species, " has been observed")
    }, ignoreNULL = F)
    
    output$graph_title <- renderText({
      graph_title_event()
    })
    
    species_plot <- eventReactive(species_manager$button_trigger, {
      plot_species(species_manager$selected_species, species_manager$location_species, species_df, world)
    }, ignoreNULL = F)
    
    output$species_location <- renderPlot({
      species_plot()
    })
    
    output$species_table <- DT::renderDataTable({
      species_manager$location_species |>
        select(c("how_many", "latitude", "longitude", "Month", "Year")) |>
        rename("Number spotted" = "how_many") |>
        arrange(Year, Month)
    }, options = list(pageLength = 20), rownames = F, fillContainer = TRUE)
    
  })
}


#---- main_panel_content_app ----
main_panel_content_app <- function(){
  ui <- fluidPage(
    main_panel_content_UI("main_panel_content")
  )
  
  server <- function(input, output, session){
    main_panel_content_server("main_panel_content")
  }
  
  shinyApp(ui, server)
}