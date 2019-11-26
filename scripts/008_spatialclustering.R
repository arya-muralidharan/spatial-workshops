# Workshop 8: 2019/11/26
# Spatial Clustering

library(rgeoda)
library(sf)
library(geodaData)

guerry_sf <- geodaData::guerry
guerry <- sf_to_geoda(guerry_sf, with_table = TRUE)

data <- list(guerry$table$Crm_prs, 
             guerry$table$Crm_prp, 
             guerry$table$Litercy, 
             guerry$table$Donatns, 
             guerry$table$Infants, 
             guerry$table$Suicids)

queen_w <- queen_weights(guerry)

?skater

guerry_clusters <- skater(4, queen_w, data) # number of clusters, number of obs per cluster

# finish later! which i can do now that i've installed rgeoda!!
