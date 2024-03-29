#----- value_box.R -----
# module for the value box in the FeederWatch App


#---- load packages ----
library(shiny)
library(bslib)
library(dplyr)


#---- value_box_UI ----
value_box_UI <- function(id){
  tagList(
    value_box(
      title = textOutput(NS(id, "value_box_title")),
      value = textOutput(NS(id, "total_sightings")),
      p("times in Winter 2020/21"),
      showcase = bsicons::bs_icon("binoculars"),
      showcase_layout = showcase_left_center(width = 0.3, max_height = 0.45)
      )
    )
}


#---- value_box_server ----
value_box_server <- function(id, selected_species = NULL, location_species = NULL, button_trigger = NULL){
  moduleServer(id, function(input, output, session){
    
    output$total_sightings <- renderText({
      location_species() |>
        select(c("how_many", "latitude", "longitude", "Month", "Year")) |>
        rename("Number spotted" = "how_many") |>
        arrange(Year, Month) |>
        tally(`Number spotted`) |>
        as.integer()
    })
    
    value_box_title_event <- eventReactive(button_trigger(), { # button_trigger() because the event that triggers the code is the value of the actionButton changing
      paste0(selected_species(), " was spotted") # selected_species() because we want the value of the reactive
    }, ignoreNULL = F)
    
    output$value_box_title <- renderText({
      value_box_title_event()
    })
    
  })
}


#---- value_box_app ----
value_box_app <- function(){
  ui <- fluidPage(
    value_box_UI("species_value_box")
    )
  
  server <- function(input, output, session){
    value_box_server("species_value_box")
  }
  
  shinyApp(ui, server)
}