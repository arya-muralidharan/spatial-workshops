# Workshop 6: 2019/11/12
# Spatial Autocorrelation

library(geodaData)
library(sf)
library(spdep)
library(tmap)
library(ggplot2)

tmap_mode("view")
tm_shape(clev_pts) +
  tm_dots()

clev_coords <- st_coordinates(clev_pts) # get geometry without attributes - matrix for to work w spdep

# dnearneigh - set distance
dnearneigh(clev_pts, 0, 1000) %>% # set distance band of 1000 ft
  plot(., clev_coords) # spdep has been built to work with base R, not tmap :-(

# knearneigh - gimme the k nearest neighbors
# NOT symmestrc - B might be A's closest neightbor, but B's closest neighbor could be F
knearneigh(clev_pts) %>%
  knn2nb() %>%
  plot(., clev_coords)

# set fixed distance to each point has at least one neighbor
critical_thres <- knearneigh(clev_pts) %>%
  knn2nb() %>%
  nbdists(., clev_coords) %>%
  unlist() %>%
  max()

dist_critical_nb <- dnearneigh(clev_pts, 0, critical_thres)
plot(dist_critical_nb, clev_coords)

# how many neighbors does each point have?
number_neighbors <- card(dist_critical_nb)
# histogram!
ggplot() + 
  aes(number_neighbors) + 
  geom_histogram(breaks = seq(0, 35, by = 5),
                 color = "black", 
                 fill = "#ca2c92") + 
  labs(title = "Locations of House Sales in Cleveland, OH",
       x = "Number of Neighbors",
       y = "Frequency")

# let's do six neighbors for fun!
knearneigh(clev_pts, k = 6) %>%
  knn2nb() %>%
  plot(., clev_coords, cex = 0.5, lwd = 0.2)
