#----- about_tab.R ----
# module for the about tab of the FeederWatch App


#---- load packages ----
library(shiny)


#---- about_tab_UI ----
about_tab_UI <- function(id){
  tagList(
    h3("What is Project FeederWatch?"),
    p(a(href = "https://feederwatch.org", "Project FeederWatch"),
      "is a November-April survey of birds that visit backyards, nature centers, community areas, and other locales in North America."),
    p("Citizen scientists count birds for as long as they like on days of their choosing, then enter the bird counts online. The counts allow us to track what is happening to birds and contribute to a continental dataset of bird distribution and abundance."),
    p("Project FeederWatch is operated by the Cornell Lab of Ornithology and Birds Canada."),
    br(),
    h3("Why are these data important?"),
    p("With each season, FeederWatch increases in importance as a unique monitoring tool for more than 100 bird species that winter in North America."),
    p("What sets FeederWatch apart from other monitoring programs is the detailed picture that FeederWatch data provide about weekly changes in bird distribution and abundance across the United States and Canada. Importantly, FeederWatch data tell us where birds", 
      tags$b("are"),
      "as well as where they",
      tags$b("are not."),
      "This crucial information enables scientists to piece together the most accurate population maps."),
    p("Because FeederWatchers count the number of individuals of each species they see several times throughout the winter, FeederWatch data are extremely powerful for detecting and explaining gradual changes in the wintering ranges of many species. In short, FeederWatch data are important because they provide information about bird population biology that cannot be detected by any other available method.")
  )
}


#---- about_tab_server ----
about_tab_server <- function(id){
  moduleServer(id, function(input, output, session){})
}


#---- about_tab_app ----
about_tab_app <- function(){
  ui <- fluidPage(
    about_tab_UI("about_tab")
  )
  
  server <- function(input, output, session){
    about_tab_server("about_tab")
  }
  
  shinyApp(ui, server)
}
