#---- Lesson 2: Build a user interface ----
# https://shiny.rstudio.com/tutorial/written-tutorial/lesson2/
library(shiny)

#---- UI ----
ui <- fluidPage(
  titlePanel("My Shiny App"),
  
  sidebarLayout(
    
    sidebarPanel(
      h2("Installation"),
      p("Shiny is available on CRAN so you can install it in the usual way from your R console:"),
      code("install.packages('shiny')"),
      br(),
      br(),
      img(src = "rstudio.png", height = 70, width = 200)
    ),
    
    mainPanel(
      h2("Introducing Shiny"),
      p("Shiny is a new package from RStudio that makes it", 
        em("incredibly easy"),
        "to build interactive web applications with R."),
      br(),
      p("For an introduction and live examples, visit the",
        a(href = "https://shiny.rstudio.com/tutorial/", "Shiny homepage.")),
      br(),
      br(),
      h2("Features"),
      tags$ul(
        tags$li("Build useful web applications with only a few lines of code - no JavaScript required."),
        tags$li("Shiny applications are automatically live in the same way that spreadsheets are live. Outputs change instantly as users modify inputs, without requiring a reload of the browser."))
    )
  )
)
# fluidPage creates a display that automatically adjusts to the dimensions of the browser window
# you lay out the UI by placing elements in here
# two common elements are titlePanel() & sidebarLayout()
# sidebarLayout() takes two arguments: sidebarPanel() & mainPanel(), which place content into their respective panels


#---- HTML content ----
# you can add content to a shiny app by placing it inside a *Panel() function
# Shiny has functions that serve as equivalents to HTML tags. We can place content inside these functions to edit them and these functions sit inside a *Panel() function
# e.g. titlePanel(h1("my title"))
# similarly, HTML attributes can be set as arguments within a Shiny tag function, e.g. h4("something new", align = "center")
# full glossary of Shiny tag functions: https://shiny.rstudio.com/articles/tag-glossary.html
# note: some tags share a name with other R functions so they can only be accessed by calling tags$function

#---- Images ----
# img() function
# as with HTML, we specify the src and we can pass other HTML friendly parameters like height and width
# files passed to src must be in a folder named "www" in the same directory as App.R
# Shiny actually shares any file placed in "www" with the browser so it is a good place for style sheets and other things the browser needs to build your app



#---- Server ----
server <- function(input, output) {
  
}


#---- Run the app ----
shinyApp(ui = ui, server = server)