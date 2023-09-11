#---- Modular R6 app ----

#---- load packages ----
library(shiny)
library(tidytuesdayR)
library(tidyverse)
library(sf)
library(rnaturalearth)
library(ggpubr)
library(RColorBrewer)
library(bslib)


#---- load data ----
feederwatch <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-01-10/PFW_2021_public.csv')
site <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-01-10/PFW_count_site_data_public_2021.csv')
species <- read.csv("2023-1-10 PFW-species-translation-table.csv")

#---- cleaning data ----
# select relevant columns
speciesObserved <- feederwatch %>%
  select(c(species_code,
           how_many,
           valid,
           reviewed,
           latitude,
           longitude,
           Month,
           Year))


# select relevant columns
speciesNames <- species %>%
  select(c(species_code, scientific_name))


# join the relevant columns using species_code as the key
speciesData <- inner_join(speciesObserved,
                          speciesNames,
                          by = "species_code")


# filter for species that were observed and the observations validated by an expert reviewer
validatedObservations <- speciesData %>%
  filter(valid == 1,
         reviewed == 1) %>%
  select(c(scientific_name, how_many)) %>%
  group_by(scientific_name) %>%
  tally(how_many) %>%
  `colnames<-`(c("Species Name", "Number of Observations"))


# where were species observed
world <- ne_countries(scale = "medium", returnclass = "sf")

# filter for reviewed and valid data
reviewedData <- speciesData %>%
  filter(reviewed == 1, 
         valid == 1)

# get names of species
species_names <- unique(reviewedData$scientific_name)

# create colour palette
colourPalette <- get_palette(palette = "jco", 10)
colourPalette <- colorRampPalette(colourPalette)(length(species_names))
species_df <- tibble(species_names, colourPalette)

#---- functions ----
# function to find a species' location
source("Functions/find_species.R")

# function to plot the species' location
source("Functions/plot_species.R")



#---- load modules and classes ----
source("Modules/species_input.R")
source("Modules/value_box.R")
source("Modules/about_tab.R")
source("Modules/data_tab.R")
source("Modules/main_panel_content.R")
source("Logic/SpeciesManager.R")


#---- UI ----
thematic::thematic_shiny(fg = "#022C3C",
                         bg = NA, 
                         accent = NA,
                         font = "auto",
                         qualitative = NA)

ui <- page_navbar(
  title = "Tidy Tuesday: Project FeederWatch",
  
  theme = bs_theme(bg = "#F7F7F7",
                   fg = "#022C3C",
                   primary = "#561643",
                   secondary = "#F4D58D",
                   base_font = font_google("Manrope")),
  
  fillable = F,
  
  nav_panel(title = "Project FeederWatch",
            layout_sidebar(
              sidebar = sidebar(
                title = "Select a species",
                species_input_UI("species_input_module", species_names = species_names),
                br(),
                value_box_UI("species_value_box_module")
              ),
              
              main_panel_content_UI("main_panel_content")
            )
    
  ),
  
  nav_panel(title = "About",
            class = "p-3 border rounded",
            about_tab_UI("about_tab")
  ),
  
  nav_panel(title = "Data",
            class = "p-3 vw-99 border rounded",
            data_tab_UI("data_tab")
  )
  
)


#---- server ----
server <- function(input, output, session){
  species_manager <- SpeciesManager$new(reviewedData)
  r <- reactiveValues() # create a reactive values object to store triggers
  
  a <- species_input_server("species_input_module", 
                            species_manager = species_manager, 
                            reviewedData = reviewedData
  )
  
  value_box_server("species_value_box_module", 
                   species_manager = species_manager
  )
  
  main_panel_content_server("main_panel_content", 
                            species_manager = species_manager,
                            species_df = species_df,
                            world = world
  )
  
  data_tab_server("data_tab",
                  reviewedData = reviewedData)
}


#---- create app ----
shinyApp(ui, server)