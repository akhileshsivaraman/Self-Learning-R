#----- SpeciesManager -----
library(R6)


#---- create class ----
SpeciesManager <- R6::R6Class(
  classname = "SpeciesManager",
  
  private = list(
    reviewedData = NULL
  ),
  
  public = list(
    selected_species = NULL,
    button_trigger = NULL,
    
    set_vars = function(selected_species, button_trigger){
      self$selected_species <- selected_species
      self$button_trigger <- button_trigger
    },
    
    initialize = function(reviewedData){
      private$reviewedData = reviewedData
    }
  ),
  
  active = list(
    location_species = function(reviewedData) {
      if (is.null(self$selected_species)){
        NULL
      } else {
        filter(private$reviewedData, scientific_name == self$selected_species) 
      }
    }
  )
)