# Workshop 2: 2019/10/15
# Spatial Data Handling

#### PACKAGES ####
library(RSocrata)
library(sf)
library(tmap) # cartography - can also use ggplot2 (see tutorial)
library(lubridate)
library(tidyverse)

#### RECAP: 311 CALLS ####

# load data
vehicle_data <- read.socrata("https://data.cityofchicago.org/resource/suj7-cg3j.csv") # link updates

# filter out calls from september 2016
vehicle_final <- vehicle_data %>%
  filter(year(creation_date) == 2016, 
         month(creation_date) == 9) %>%
  select(comm = community_area,
         lon= longitude,
         lat = latitude) %>%
  filter(!is.na(lon), ! is.na(lat))

vehicle_points <- st_as_sf(vehicle_final,
         coords = c("lon", "lat"), # lon is x, lat is y, so lon first
         crs = 4326, # coordinate reference systems - spatialreference.org
         agr = "constant") 

plot(vehicle_points)

st_crs(vehicle_points)

vehicle_pts <- st_transform(vehicle_points, 32616) # update proj4string - make units meters

st_crs(vehicle_pts) # units = m

plot(st_buffer(vehicle_pts, 1000)) # make big 1 km circles

#### SPATIAL JOIN: COMMUNITY AREAS ####

# merge(x, y, by = "id)
# st_join(x, y)

# load data
chicago.comm <- read_sf("https://data.cityofchicago.org/resource/igwz-8jzy.geojson")

# check class
class(chicago.comm) # "sf" "tbl_df" "tbl" "data.frame"

st_crs(chicago.comm)
## Coordinate Reference System:
## EPSG: 4326 
## proj4string: "+proj=longlat +datum=WGS84 +no_defs"
# unprojected in decimal degrees bc +proj = longlat
# so we can't join yet!

comm_areas <- st_transform(chicago.comm, 32616) # make projections the same!

# spatial join!
comm_pts <- st_join(vehicle_pts, comm_areas)

count(comm_pts, community) %>%
  filter(community == "HYDE PARK") %>%
  plot()

count(comm_pts, community) %>%
  arrange(desc(n))