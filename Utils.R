

# MAP FUNCTION ------------------------------------------------------------
# Function to plot network analysis map
# Input: points, driving route and travel time lines.
analysis_network_map <- function(shp.stops,shp.route,shp.line){
  #Create lat long column from stop points
  shp.stops$lng<-st_coordinates(shp.stops)[,1]
  shp.stops$lat<-st_coordinates(shp.stops)[,2]
  # Pallet settings
  factpal <- colorFactor(c("black","red" ,"blue"), shp.stops$fclass)
  pal <- colorBin(palette = "RdYlBu",domain = shp.line$Total_TravelTime, bins = 6,reverse = T)
  qpal <- colorQuantile("RdYlBu", shp.line$Total_TravelTime, n = 5)
  
  # plot map
  m <- leaflet() %>%
    setMaxBounds(min(shp.stops$lng),
                 min(shp.stops$lat),
                 max(shp.stops$lng),
                 max(shp.stops$lat)) %>% 
    addTiles()
  
  m %>% 
    addPolylines(data =shp.line,
                 stroke = T ,
                 color = ~pal(Total_TravelTime), weight = 2) %>% 
    addPolylines(data =shp.route,
                 color="green") %>% 
    addCircles(data = shp.stops,
               stroke = T ,color = factpal, weight = 2,
               fillColor = ~factpal(shp.stops$fclass), fillOpacity = 1,radius = 50, 
               label = ~name) %>% 
    
    addLegend("bottomright", pal = pal, values = shp.line$Total_TravelTime,
              title = "Travel time to healthcare facility",
              labFormat = labelFormat(suffix = " min"),
              opacity = 1) %>% 
    addLegend("bottomright", pal = factpal, values = shp.stops$fclass,
              title = "Type of healthcare facility",
              opacity = 1) %>% 
    addLegend("bottomright", 
              colors = "green",
              labels = "Driving route",
              #title = "Driving network",
              opacity = 1)
}