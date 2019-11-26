# Workshop 7: 2019/11/19
# Spatial Autocorrelation

library(rgeoda)

library(geodaData)
library(sf)
library(here)

guerry_sf <- geodaData::guerry

plot(guerry_sf)

# lambert conformal conic projection
st_crs(guerry_sf)

guerry <- sf_to_geoda(guerry_sf, with_table = T)

# currently rgeoda is structured a lot like python
guerry$table
guerry$n_cols

queen_w <- queen_weights(guerry)

# check if the weights are symmetric
queen_w$is_symmetric 
# save to file
queen_w$SaveToFile("guerry_queen.gal", 
                   "guerry", 
                   "CODE_DE", 
                   guerry$GetIntegerCol("CODE_DE"))

# local moran
crm_prp <- guerry_sf$Crm_prp
lisa <- local_moran(queen_w, crm_prp)

# statistics for each of the districts
lms <- lisa$GetLISAValues() 
lisa$GetPValues()

# map local moran
lisa_colors <- lisa$GetColors() 
lisa_labels <- lisa$GetLabels()
lisa_clusters <- lisa$GetClusterIndicators()

plot(st_geometry(guerry_sf), 
     col=sapply(lisa_clusters, function(x){return(lisa_colors[[x+1]])}), 
     border = "#333333", lwd=0.2)
title(main = "Local Moran Map of Crm_prp")
legend('bottomleft', legend = lisa_labels, fill = lisa_colors, border = "#eeeeee")