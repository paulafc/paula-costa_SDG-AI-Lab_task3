##########################
# Create quick maps     #
# Paula Costa           #
#########################

rm(list=ls())
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, readxl, writexl, sf, leaflet, htmlwidgets, dplyr)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
source("Utils.R")

# VARIABLES ---------------------------------------------------------------

#geodatabase
data.gdb<-c("import/task3.gdb")

#features
stop.point<-"la_palma_health_facility_Clip"

## Network Analysis output from ArcGIS Pro
# Best road route
na_road_routes<-"na_road_routes"
# distance/time analysis
na_time_line<-"na_time_lines"


# READ DATA ---------------------------------------------------------------

shp.stops <- st_read(dsn = data.gdb, layer = stop.point)
shp.route <- st_read(dsn = data.gdb, layer = na_road_routes)
shp.line <- st_read(dsn = data.gdb, layer = na_time_line)

#drop Z
shp.route<-st_zm(shp.route, drop = T, what = "ZM")
shp.line<-st_zm(shp.line, drop = T, what = "ZM")


# PLOT MAP ----------------------------------------------------------------
m<-analysis_network_map(shp.stops,shp.route,shp.line)
m
#Export map
saveWidget(m, file=("Paula_Costa_task3_Map.html"))
