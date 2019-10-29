# Workshop 4: 2019/10/29
# Basic Mapping

library(geodaData)
library(sf)
library(tmap)

plot(nyc_sf) # all attributes
plot(nyc_sf["geometry"]) # just outlines

?nyc_sf # see metadata - units are in ft
st_crs(nyc_sf) # check proj if no metadata

tm_shape(nyc_sf) +
  tm_polygons() +
  tm_shape(st_centroid(nyc_sf)) + # st_centroid() calculates the center of the polygons
  tm_dots()

tm_shape(nyc_sf) +
  tm_polygons("rent2008")

#### INTERACTIVE ####

tmap_mode("view") # to run interactive basemap

tm_shape(nyc_sf) +
  tm_polygons("rent2008") + 
  tm_basemap(server = "Stamen.Watercolor") # the Thunderforest maps don't work :-(

leaflet::providers # see available basemaps

#### REGULAR ####

tmap_mode("plot") # back to non-interactive mode

tm_shape(nyc_sf) +
  tm_polygons("rent2008") # basemap function doesn't work in plot mode

tm_shape(nyc_sf) +
  tm_fill(col = "rent2008",                  # tm_fill + tm_borders = tm_polygons
          alpha = 0.8,                       # helpful to split to customize
          palette = c("#ffc9a3", "#c90000"),
          title = "Average Rent",
          legend.hist = T) +                 # only works when in "plot" mode
  tm_borders() + 
  tm_compass(type = "radar", 
             size = 3, 
             position = c(0.125, 0.6)) +
  tm_scale_bar(color.light = "#ffc9a3", 
               color.dark = "#c90000",
               position = c(0.05, 0.8)) +
  # tm_style_albatross() +                   # can play around with other styles
  tm_layout(main.title = "Rent in NYC Boroughs, 2008",
            legend.outside = T,
            legend.hist.width = 0.8)
