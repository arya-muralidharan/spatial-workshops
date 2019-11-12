# Workshop 5: 2019/11/05
# Basic Mapping & Spatial Autocorrelation

library(geodaData)
library(sf)
library(tmap)
library(sfExtras)
library(spdep) # for spatial autocorrelation, spatial weights, etc.

# initial exploration
head(ncovr)
plot(ncovr)
st_crs(ncovr)

# recap: tmap
tm_shape(ncovr) +
  tm_polygons("HR60") # homicide rate - not the best way to visualize this
                      # because it's hard to see if tiny areas have a high homicide rate


# CONTIGUITY

ncovr_rook <- sfExtras::st_rook(ncovr)
ncovr_queen <- sfExtras::st_queen(ncovr)

# check average number of neighbors
rook_neighbors <- lengths(ncovr_rook)
mean(rook_neighbors) # 5.571475
queen_neighbors <- lengths(ncovr_queen)
mean(queen_neighbors) # 5.889141

# convert lists of neighbors to "nb" objects to make maps
rook_nb <- st_as_nb(ncovr_rook)
summary(rook_nb)
# 1 most connected region:
#   606 with 13 links
queen_nb <- st_as_nb(ncovr_queen)
summary(queen_nb)
# 1 most connected region:
#   1371 with 14 links

# create coords of polygon centroids
ncovr_centroid_coords <- st_centroid_coords(ncovr)

# plot(nb_object, coords_of_polygon_centroids)
plot(queen_nb, 
     ncovr_centroid_coords,
     lwd = 0.2,
     cex = 0.2,
     col = "blue",
     add = T)
plot(ncovr["geometry"])
