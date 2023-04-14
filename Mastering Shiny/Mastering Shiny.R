##### Mastering Shiny #####

##### Chapter 2 - Your first shiny app #####
# Shiny uses reactive programming to automatically update outputs when inputs change
library(shiny)

#### create app directory and file ####
# the simplest way to create a shiny app is to create a new directory for your app
# and put a single file called app.R into the directory
# the app.R file will tell shiny how the app should look and behave

# create directory and add a file called app.R
ui <- fluidPage(
  "Hello, world!"
) # define a UI
server <- function(input, output, session) {
} # define a server
shinyApp(ui, server) # creates a shiny object from a UI/server pair

# app.R does four things:
# 1. calls library(shiny) to load the package
# 2. defines the UI, which in this case is a page saying "Hello, world!"
# 3. specifies the behaviour of the app by defining a server function, which is empty in this case
# 4. executes shinyApp(ui, server) to construct and start a Shiny application from the UI and server pair

# no need to run the shinyApp() code to run the app - just click "run app" above

# You can easily create a new directory and an app.R file containing a basic 
# shiny app in one step by clicking File | New Project, then selecting 
# “New Directory” and “Shiny Web Application”. 
# Or, if you’ve already created the app.R file, you can quickly add the 
# app boilerplate by typing “shinyapp” and pressing Shift+Tab/use the snippet


#### adding UI controls ####
# build an app that lists all the built-in data frames in the datasets package
ui1 <- fluidPage(
  selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
  verbatimTextOutput("summary"),
  tableOutput("table")
)
# fluidPage sets up the basic visual structure of the page
# selectInput is an input control => lets the user interact with the app by providing a value, i.e. one of the choices
# verbatimTextOutput and tableOutput are output controls => tell shiny where to put rendered outputs
shinyApp(ui1, server)

# try it with another package
library(ape)
ui2 <- fluidPage(
  selectInput("ape", label = "functions", choices = ls("package:ape")),
  verbatimTextOutput("summary"),
  tableOutput("table")
)
shinyApp(ui2, server)


#### adding behaviour ####
# works by telling shiny how to perform a computation

# telling shiny how to fill in the summary and table outputs
server <- function(input, output, session) {
  output$summary <- renderPrint({
    dataset <- get(input$dataset, "package:datasets")
    summary(dataset)
  })
  output$table <- renderTable({
    dataset <- get(input$dataset, "package:datasets")
    dataset
  })
}
# output$ID provides shiny with a recipe for the output with the matching ID
# render functions wrap some code that you provide
# each render function works with a specific type of output that is passed to an output function
# renderPrint tells shiny to print text verbatim
# renderTable tells shiny to display the data frame in a table

shinyApp(ui1, server)
# outputs are reactive -> they automatically recalculate when their inputs change


#### reducing duplication with reactive expressions ####
# two traditional techniques to deal with duplicated code:
# 1. capture the value using a variable
# 2. capture the computation with a function
# these approaches don't work with shiny so we need to use reactive expressions
# wrap a block of code in reactive({}) and assigning it to a variable
# a reactive expression is called to a function and its result is cached until it needs to be updated
# removing duplicaitons speeds up the code
server <- function(input, output, session) {
  dataset <- reactive({
    get(input$dataset, "package:datasets")
  })
  output$summary <- renderPrint({
    summary(dataset())
  })
  output$table <- renderTable({
    dataset()
  })
}


#### Exercises ####
# create an app that greets the user by name
uiname <- fluidPage(
  textInput("name", "What's your name?"),
  textOutput("name")
)

servername <- function(input, output, session) {
  output$name <- renderText({
   paste0("Hello ", input$name) 
  })
}

shinyApp(uiname, servername)



# fix the code
ui <- fluidPage(
  sliderInput("x", label = "If x is", min = 1, max = 50, value = 30),
  "then x times 5 is",
  textOutput("product")
)

server <- function(input, output, session) {
  output$product <- renderPrint({
    x*5
  })
}

shinyApp(ui,server)


##### Chapter 3 - Basic UI #####
#### Inputs ####
## common structure
# shiny encourages the separation of the code that generates your UI from the code that drives the app's behaviour
# the first argument for an input function is "inputID", which connects the front end with the back end
# if the UI has an input with the ID "name", it is saved under input$name for the server to access
# the second argument for most input functions is "label", which creates a human-readable label
# the third argument is usually "value", which lets you set the default value, if possible

#### free text inputs ####
# textInput() collects small amounts of text
# passwordInput() collects passwords (hides what the user is typing - but you'll need to ensure it remains secure)
# textAreaInput() collects paragraphs

ui <- fluidPage(
  textInput("name", "what's your name?"), # name is the variable under which the data stored
  passwordInput("password", "what's your password"),
  textAreaInput("story", "tell me about yourself", rows = 3)
)
server <- function(input, output){}
shinyApp(ui, server)

#### numeric inputs ####
# numericInput() uses text to collect numeric inputs
# sliderInput() uses a slider to collect numeric inputs
# supplying a vector in the value argument of sliderInput() allows the user to select a range
ui <- fluidPage(
  numericInput("num", "Number one", value = 0, min = 0, max = 100),
  sliderInput("num2", "Number two", value = 50, min = 0, max = 100),
  sliderInput("range", "Range", value = c(10, 20), min = 0, max = 100)
)
server <- function(input, output){}
shinyApp(ui, server)

#### dates ####
# dateInput()
# dateRangeInput()
# both functions provide a calendar to collect the data
# inputs default to US format but you can change it using the function argument
ui <- fluidPage(
  dateInput("dob", "When were you born?"),
  dateRangeInput("holiday", "When do you want to go on vacation next?")
)
server <- function(input, output){}
shinyApp(ui, server)

#### limited choices/multiple choice ####
# two options => selectInput() - dropdown - and radioButtons() - select
animals <- c("dog", "cat", "mouse", "bird", "other", "I hate animals")
ui <- fluidPage(
  selectInput("state", "What's your favourite state?", choices = state.name),
  radioButtons("animal", "What's your favourite animal?", choices = animals)
)
server <- function(input, output){}
shinyApp(ui, server)

# selectInput() has a "multiple" argument which allows the user to select multiple options

# radioButtons can be used to display options other than text
ui <- fluidPage(
  radioButtons("rb", "Choose one:",
               choiceNames = list( #choices only allows for plain text
                 icon("angry"),
                 icon("smile"),
                 icon("sad-tear")
               ),
               choiceValues = list("angry", "happy", "sad")
  )
)
server <- function(input, output){}
shinyApp(ui, server)
# radioButtons() doesn't allow the user to select multiple options
# but checkboxGroupInput() does
# checkboxInput() exists too and only permits the user to check one option

#### file uploads ####
# fileInput()
ui <- fluidPage(
  fileInput("upload", NULL)
)
server <- function(input, output){}
shinyApp(ui, server)

#### action buttons ####
# actionButton() and actionLink()
# [work well with the server functions observeEvent() and eventReactive()]
ui <- fluidPage(
  actionButton("click", "Click me!"),
  actionButton("drink", "Drink me!", icon = icon("cocktail"))
)
server <- function(input, output){}
shinyApp(ui, server)

# you can customise the appearance using the "class" argument
# class options => "btn-primary", "btn-success", "btn-warning", "btn-danger", "btn-lg", "btn-sm", "btn-xs" & "btn-block"
ui <- fluidPage(
  fluidRow(
    actionButton("click", "Click me!", class = "btn-danger"),
    actionButton("drink", "Drink me!", class = "btn-lg btn-success")
  ),
  fluidRow(
    actionButton("eat", "Eat me!", class = "btn-block")
  )
)
server <- function(input, output){}
shinyApp(ui, server)

## Exercises
ui <- fluidPage(
  textInput(inputId = "name", label = "Name", placeholder = "Your name")
)
server <- function(input, output){}
shinyApp(ui, server)

ui <- fluidPage(
  sliderInput(inputId = "date", label = "When should we deliver?",
              min = as.Date("2020-09-16"), 
              max = as.Date("2020-09-23"), 
              value = as.Date("2020-09-17"))
)
server <- function(input, output){}
shinyApp(ui, server)


#### Outputs ####
# outputs in the UI create placeholders that are later filled by the server function
# first argument is a unique ID - if the UI creates an output with the ID "plot", you can access it with output$plot in the server function
# every output function has a corresponding render function

#### text ####
# textOutput() gives regular text
# verbatimTextOutput() gives the result of a block of code
ui <- fluidPage(
  textOutput("text"), #"text" is the outputID
  verbatimTextOutput("code")
)
server <- function(input, output, session) {
  output$text <- renderText("Hello friend!")
  output$code <- renderPrint(summary(1:10))
}
shinyApp(ui, server)
# renderText() combines the result into a single string
# renderPrint() prints the result
renderText("foo")()
renderPrint("foo")()

#### tables ####
# tableOutput() and renderTable() produce a static table of data - all the data are shown at once
# dataTableOutput() and renderDataTable() produce a dynamic table - a certain number of rows are shown
ui <- fluidPage(
  tableOutput("static"),
  dataTableOutput("dynamic")
)
server <- function(input, output, session) {
  output$static <- renderTable(head(mtcars))
  output$dynamic <- renderDataTable(mtcars, options = list(pageLength = 5))
}
shinyApp(ui, server)

## plots
# any type of R graphic
ui <- fluidPage(
  plotOutput("plot", width = "400px")
)
server <- function(input, output, session) {
  output$plot <- renderPlot(plot(1:5), res = 96) #res=96 matches most closely what is produced in RStudio
}
shinyApp(ui, server)
# plots are outputs that can also act as inputs through options like click, etc

# plotting a phylogenetic tree
library(ape)
t7 <- read.tree(text = "((((((B,D),C),A),E),F),(H,(I,(J,(K,(L,(M)))))));")
tailt7 <- c(2,2,2,1,1,
            1,1,1,1,2,
            2,2,2,2,2,
            2,1,1,1,1,
            1,1,1)
nodecolourt7 <- c("#C61FDB","#2222B2","#2222B2","#2222B2","#2222B2",
                  "#B22222","#B22222","#B22222","#B22222","#B22222",
                  "#2222B2","#2222B2")
tipcolourt7 <- c("#B22222","#B22222", "#2222B2","#2222B2","black",
                 "black","black","black","#B22222","#B22222",
                 "#2222B2","#2222B2")
nodeshapet7 <- c(22,22,22,21,21,21,22,22,21,21,21,21)
tipshapet7 <- c(21,21,21,21,22,22,22,22,21,21,21,21)
plot.phylo(t7, type = "cladogram", edge.width = 3, 
           show.tip.label = T, edge.lty = tailt7,
           tip.color = tipcolourt7, cex = 2, label.offset = 0.9)
uitree <- fluidPage(
  plotOutput("tree", width = "400px", height = "700px")
)
servertree <- function(input, output, session) {
  output$tree <- renderPlot(plot.phylo(t7, type = "cladogram", edge.width = 3, 
                                       show.tip.label = T, edge.lty = tailt7,
                                       tip.color = tipcolourt7, cex = 2, label.offset = 0.9), 
                            res = 96)
}
shinyApp(uitree, servertree)


#### Layouts ####
# fluidPage() provides the layout style used by most apps
# other layout families exist like dashboards and dialog boxes

## overview
# layouts are created by a hierarchy of function calls
# the heirarchy is matched by the hierarchy in the output

## page functions
# fluidPage() sets up all the HTML, CSS and JS that Shiny needs
# uses a layout system called bootstrap
# we put inputs and outputs into fluidPage() to describe how the app will look

#### page with sidebar ####
# sidebarLayout(), titlePanel(), sidebarPanel() and mainPanel()
# using these functions we can create a two-column layout with inputs on the left and outputs on the right
# central limit theorem app
ui <- fluidPage(
  titlePanel("Central limit theorem"), #app title/description
  sidebarLayout(
    sidebarPanel( #inputs
      numericInput(inputId = "m", label = "number of samples:", value = 2, min = 1, max = 100)), 
    mainPanel( #outputs
      plotOutput("hist")
    )
  )
)
server <- function(input, output, session) {
  output$hist <- renderPlot({
    means <- replicate(n = 1e4, expr = mean(runif(input$m)))
    hist(means, breaks = 20)
  }, res = 96)
}
shinyApp(ui, server)

# swapping the position of the sidebar
ui <- fluidPage(
  titlePanel("Central limit theorem"),
  sidebarLayout(
    sidebarPanel(plotOutput("hist")), 
    mainPanel(numericInput(inputId = "m", label = "number of samples:", value = 2, min = 1, max = 100))
    )
) 
server <- function(input, output, session) {
  output$hist <- renderPlot({
    means <- replicate(n = 1e4, expr = mean(runif(input$m)))
    hist(means, breaks = 20)
  }, res = 96)
}
shinyApp(ui, server)


#### multi-row ####
# create rows with fluidRow() and columns with column()
# first argument for column() is width and the width of each row must add up to 12
# narrow columns can be used as spacers
#e.g.
fluidPage(
  fluidRow(
    column(width = 4),
    column(width = 8)
  ),
  fluidRow(
    column(width = 6),
    column(width = 6)
  )
)

#### themes ####
# shinythemes package contains some ready to go themes
# it is possible to build your own (but it is time consuming)
theme <- function(theme){
  fluidPage(
    theme = shinythemes::shinytheme(theme),
    sidebarLayout(
      sidebarPanel(
        textInput("txt", "text input:", "text here"),
        sliderInput("slider", "slider input:", 1, 100, 30)
      ),
      mainPanel(
        h1("header 1"),
        h2("header 2"),
        p("some text")
      )
    )
  )
}
# applying the theme argument to fluidPage()
theme("darkly") # hit run app
# executing these lines shows the HTML code used to create the app in the console
theme("flatly")
theme("sandstone")
theme("united")

ui <- fluidPage(
  theme = shinythemes::shinytheme("flatly"),
  sidebarLayout(
    sidebarPanel(
      textInput("txt", "text input:", "text here"),
      sliderInput("slider", "slider input:", 1, 100, 30)
    ),
    mainPanel(
      h1("header 1"),
      h2("header 2"),
      p("some text")
    )
  )
)

server <- function(input, output, session){
  
}
shinyApp(ui, server)


##### Chapter 4 - Basic Reactivity #####
# in shiny, you express server logic using reactive programming - back end
# reactive programming = specifying a grarph of dependencies so that when an input changes, outputs automatically update
# the server is more complicated than the UI because each user gets their own version of the app
# almost all reactive programming will take place inside the server function
#### Input ####
# input is a list-like object that contains all the input data sent from the browser
# items in the list are named by inputID in UI input functions
# access items with input$inputID
# input objects are read-only so you cannot modify them inside the server function
# to read an input, you must be in a reactive context created by a function like renderText() or reactive()
#### Output ####
# output is a list-like object
# items are named by outputID
# for sending output rather than receiving input
# used in concert with a render function
# render functions set up a reactive context that tracks what in input the output uses
# and it converts outputs of R code into HTML suitable for web pages
#### Reactive programming ####
# shiny automatically works out when to update
ui <- fluidPage(
  textInput("name", "what is your name?"),
  textOutput("greeting")
)
server <- function(input, output, session){
  output$greeting <- renderText(paste0("hello ", input$name, "!"))
}
shinyApp(ui, server)
# the code tells shiny how it could create the string, it doesn't tell shiny to create the string

## imperative vs declarative programming
# imperative = issue a command and it's carried out immeidately
# declarative = express higher-level goals or describe constraints and someone else works out how and when to make the thing

## laziness
# declarative programming in shiny allows apps to be lazy
# this means shiny apps to the minimum amount of work required to update the output
# but this means that small errors can go unnoticed by R

## the reactive graph
# code is only run when needed so the order of execution is not top to bottom as normal
# the reactive graph describes the order of execution
# in the above app, the reactive graph is:
# name -> greeting
# this tells you that when name is updated greeting needs to be updated
# good idea to draw the graph as you make more complex apps (reactlog can be used to draw the graph for us)

## reactive expressions
# reduce duplications in reactive code by introducing additional notes to the reactive graph
# including a reactive expression, the reactive graph looks like this:
# name -> text -> greeting

#### Reactive expressions ####