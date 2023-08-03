#----- data_tab.R -----
# module for the data tab of the FeederWatch App

#---- load packages ----
library(shiny)
library(DT)


#---- data_table_UI ----
data_tab_UI <- function(id) {
  tagList(
    DT::dataTableOutput(NS(id, "full_data"))
  )
}


#---- data_tab_server ----
data_tab_server <- function(id, reviewedData = NULL) {
  moduleServer(id, function(input, output, session) {
    output$full_data <- DT::renderDataTable({
      reviewedData
    }, options = list(pageLength = 50), rownames = F)
  })
}


#---- data_tab_app ----
data_tab_app <- function() {
  ui <- fluidPage(
    data_tab_UI("data_tab")
  )
  
  server <- function(input, output, session) {
    data_tab_server("data_tab", reviewedData) # make sure you have loaded reviewedData before running
  }
  
  shinyApp(ui, server)
}
