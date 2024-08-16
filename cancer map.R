# Install packages if not already installed
install.packages("leaflet")
install.packages("sf")
install.packages("dplyr")  # For data manipulation
install.packages("htmlwidgets") # Install htmlwidgets if not already installed

# Load necessary libraries
library(leaflet)
library(sf)
library(dplyr)
library(htmlwidgets)

# Load the shapefile for DRC (you need the shapefile in your working directory)
drc_shapefile <- st_read("path/to/drc_shapefile.shp")

# Generate sample data for breast cancer patients in DRC (instead of Nairobi)
set.seed(123)  # For reproducibility
drc_patients <- data.frame(
  longitude = runif(100, min = 12, max = 31),  # Longitude range for DRC
  latitude = runif(100, min = -13, max = 5),   # Latitude range for DRC
  intensity = runif(100, min = 1, max = 10)  # Represents number of patients
)

# Convert to a spatial data frame
drc_patients_sf <- st_as_sf(drc_patients, coords = c("longitude", "latitude"), crs = 4326)

# Prepare data for the heatmap
heat_data <- drc_patients %>%
  select(latitude, longitude, intensity) %>%
  as.matrix()

# Create the leaflet map focused on DRC
drc_map <- leaflet() %>%
  addTiles() %>%
  addPolygons(data = drc_shapefile, color = "blue", weight = 2, fillOpacity = 0.2) %>%  # Add DRC boundaries
  addHeatmap(
    data = heat_data,
    radius = 30,  # Adjust radius for better visualization
    blur = 20,    # Adjust blur for smooth heat transition
    maxZoom = 10, # Adjust zoom level for a wider view of DRC
    gradient = c('0.1' = 'black', '0.5' = '#4c4c4c', '1' = '#ffffff')  # Darker color gradient for hotspots
  ) %>%
  setView(lng = 23.5, lat = -2.5, zoom = 5)  # Center the map on DRC

# Display the map
drc_map

# Save the map to an HTML file
saveWidget(drc_map, file = "drc_breast_cancer_heatmap.html", selfcontained = TRUE)
