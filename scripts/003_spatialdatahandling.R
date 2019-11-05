# Workshop 3: 2019/10/22
# Spatial Data Handling

library(geodaData)
library(sf)
library(tidyverse)
library(tmap)

data("chicago_comm")
data("vehicle_pts")

# project
chicago_comm <- st_transform(chicago_comm, 32616)
vehicle_pts <- st_transform(vehicle_pts, 32616)

# join - order matters
comm_pts <- st_join(vehicle_pts, chicago_comm)

count(comm_pts, is.na(community))
counts_by_area <- count(comm_pts, community) %>%
  st_drop_geometry() %>%
  rename(number_vehicles = n)

# attribute join
chicago_comm <- left_join(chicago_comm, counts_by_area) %>%
  mutate(community = as.character(community))

tm_shape(chicago_comm) +
  tm_polygons("number_vehicles")