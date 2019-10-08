# Workshop 1: 2019/10/08
# Spatial Data Handling

#### PACKAGES ####
library(RSocrata)
library(sf)
library(tmap)
library(lubridate)
library(tidyverse)

#### 311 CALLS ####

# load data
vehicle_data <- read.socrata("https://data.cityofchicago.org/resource/suj7-cg3j.csv") # link updates

# some checks
head(vehicle_data) # first six rows of data.frame
dim(vehicle_data) # num observations and num rows
class(vehicle_data) # returns type - data.frame
glimpse(vehicle_data) # dplyr: gives the dropdown from the environment

# wow, piping!
vehicle_data %>% 
  filter(year(creation_date) == 2005)
# col names / variable names
names(vehicle_data)

# only september 2016
vehicle_data$creation_date %>%
  month() %>%
  unique()
vehicle_sept16 <- vehicle_data %>%
  filter(year(creation_date) == 2016, 
         month(creation_date) == 9)

# get spatial variables 
vehicle_final <- vehicle_sept16 %>%
  select(comm = community_area,
         lon = longitude, # latitude and longitude are polar/spherical
         lat = latitude) # x and y are rectangular/flat surface, but sometimes they're the same

vehicle_coord <- vehicle_final %>% # missing values in coordinates are NOT allowed
  filter(!is.na(lon),
         !is.na(lat))

vehicle_points <- st_as_sf(vehicle_coord, 
                           coords = c("lon", "lat"), 
                           crs = 4326, # coordinate reference system
                           agr = "constant") # attibute-geometry-relationship 
                                             # specifies how the attribute information (the data) 
                                             # relate to the geometry (the points)

class(vehicle_points) # "sf" "data.frame"

# plot
plot(vehicle_points) # ooh pretty

st_crs(vehicle_points)
## Coordinate Reference System:
## EPSG: 4326 
## proj4string: "+proj=longlat +datum=WGS84 +no_defs"

# The proj4string is a slightly more informative description than the simple EPSG code 
# confirms the data are not projected (longlat) using the WGS84 datum 
# for the decimal degree coordinates.


#### COMMUNITY AREAS ####

# load data
chicago.comm <- read_sf("https://data.cityofchicago.org/resource/igwz-8jzy.geojson")

class(chicago.comm) # "sf" "tbl_df" "tbl" "data.frame"

st_crs(chicago.comm)
## Coordinate Reference System:
## EPSG: 4326 
## proj4string: "+proj=longlat +datum=WGS84 +no_defs"
# unprojected in decimal degrees

plot(chicago.comm)

head(chicago.comm)