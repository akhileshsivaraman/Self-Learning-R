#----- species_input_app.R ----
# module for the species input element of the FeederWatch App


#---- load packages ----
library(shiny)


#---- functions ----



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
species_input_server <- function(id, reviewedData){
  moduleServer(id, function(input, output, session){
    
    location_species <- eventReactive(input$button, {
      find_species(input$selected_species, reviewedData)
    }, ignoreNULL = F)
    
    list(
      selected_species = reactive(input$selected_species),
      location_species = location_species,
      button_trigger = reactive(input$button) # react to the value changing and return the value so that the event can be used as a trigger in other modules
    )
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
