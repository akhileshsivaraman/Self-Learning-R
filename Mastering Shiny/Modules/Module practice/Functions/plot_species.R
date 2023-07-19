#---- plot_species() ----
# function to plot the observations of the species of interest

plot_species <- function(species, location, species_df, world) {
  species_colour <- species_df |>
    filter(species_names == species) |>
    pull(colourPalette)
  
  ggplot(data = world) +
    geom_sf(fill = "white") +
    geom_point(data = location, aes(longitude, latitude, size = how_many), shape = 21, alpha = 0.4, fill = species_colour) +
    coord_sf(xlim = c(-150, -50), ylim = c(20, 70), expand = FALSE, clip = "on") +
    theme(panel.background = element_rect(fill = "white"),
          axis.title = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          legend.position = c(0.1, 0.15),
          legend.key = element_rect(fill = "white")) +
    labs(size = "Number observed")
}