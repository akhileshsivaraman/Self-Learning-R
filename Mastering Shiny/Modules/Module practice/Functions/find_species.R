#---- find_species() ----
# function to fitler through reviewed data, selecting only the species of interest and return a tibble

find_species <- function(species, reviewedData) {
  filter(reviewedData, scientific_name == species)
}