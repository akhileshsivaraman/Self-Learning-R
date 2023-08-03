#----- species_input_app.R ----
# module for the species input element of the FeederWatch App


#---- load packages ----
library(shiny)

#---- load classes ----
source("Logic/SpeciesManager.R")

#---- species_input_UI ----
species_input_UI <- function(id, species_names = NULL){
 tagList(
   selectInput(NS(id, "selected_species"),
               label = "Select a species to see where they were spotted",
               choices = species_names, # check this is the right thing to do
               selectize = T,
               multiple = F,
               selected = "Spinus pinus"
               ),
   actionButton(NS(id, "button"),
                label = "View sightings"))
}


#---- species_input_server ----
species_input_server <- function(id, species_manager, reviewedData){ # place the R6 class in the server then call its methods/fields below and we don't return anything
  moduleServer(id, function(input, output, session){
    observeEvent(input$button, {
      species_manager$set_vars(input$selected_species, input$button)
      species_manager$location_species
    }, ignoreNULL = F)
  })
}


#---- species_input_app ----
species_input_app <- function(){
  ui <- fluidPage(
    species_input_UI("species_input_module", species_names)
  )
  
  server <- function(input, output, session){
    species_input_server("species_input_module")
  }
  
  shinyApp(ui, server)
}
