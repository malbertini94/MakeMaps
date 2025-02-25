##############################################
#                BOUNDARIES                  #
##############################################

#Uncomment to install missing packages
#install.packages("tidyverse")
#install.packages("magrittr")
#install.packages("sf")
#install.packages("mapview")
#install.packages("rstudioapi")
#install.packages("ggspatial")

# Useful applications for coding
library(tidyverse)  # include many packages such as dplyr, readxl etc
library(magrittr)   # operator  %>%

# Deal with Geocoding
library(sf)         # loads classes and functions for vector spatial data.

# Maps
library(mapview)    # load some pre-defined background for maps 
library(ggspatial)  # Better maps

#Directories
library(rstudioapi) #for handling directories


# Get the directory of the folder where the script is saved: must be the same as data
wd<-dirname(rstudioapi::getSourceEditorContext()$path)
setwd(wd)

#CSV: 4326, NUTS 2021, from: EUROSTAT https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/nuts
dir.create("Data")
unzip(zipfile = "NUTS_RG_20M_2021_4326.shp.zip", exdir = "Data")
shape <- st_read("Data/NUTS_RG_20M_2021_4326.shp")

#Select nuts
nuts3 <- shape[shape$LEVL_CODE==3,]
nuts2 <- shape[shape$LEVL_CODE==2,]
nuts1 <- shape[shape$LEVL_CODE==1,]

###### Customizable Map: nuts3

## Easy Maps
mapview(nuts3)
mapview(nuts2)
mapview(nuts1)

## Better map 
#Zoom in a specific country. Remove if all europe
zoom_to <- c(14, 50) #Modify these: Lat-long coords for centering
zoom_level <- 2        #Modify this: select zooming

lon_span <- 360 / 2^zoom_level #don't change any of these
lat_span <- 180 / 2^zoom_level

lon_bounds <- c(zoom_to[1] - lon_span / 2, zoom_to[1] + lon_span / 2)
lat_bounds <- c(zoom_to[2] - lat_span / 2, zoom_to[2] + lat_span / 2)

# Simple shapes
map1 <- ggplot(data = nuts3) +                   #your data
  geom_sf() +                                   #Tells R is geodata
  coord_sf(xlim= lon_bounds, ylim=lat_bounds) + #Your zooming decided above
  annotation_scale(location = "br",             #Specifics of the distance bars on the bottom right
                   width_hint = 0.5, 
                   height = unit(0.2, "cm"), 
                   pad_y = unit(0.15, "cm")) + 
  annotation_north_arrow(location = "bl",       #Specifics of the north arrow on the bottom left
                         which_north = "true", 
                         style = north_arrow_fancy_orienteering, 
                         height = unit(1, "cm"), 
                         width = unit(1, "cm"), 
                         pad_y = unit(0.15, "cm")) + 
  theme(panel.background=element_blank(),       #Background: set to blank
        legend.position = c(0, .95),            #Legend specifics
        legend.justification = c("left", "top"),
        legend.box.just = "left",
        legend.margin = margin(6, 6, 6, 6),
        legend.key.size = unit(0.23, 'cm'),
        legend.title = element_text(size=0),
        axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        plot.background=element_blank()) 
map1

#Merge some data to represent on map
data <- merge(nuts3, y, by = "NUTS_ID", # If same name
        by.x = "NUTS_ID", by.y = "--", # if different name
        all.x = TRUE ) # Keep only those that merge with your shapes

#Make map with data
map2 <- ggplot(data = nuts3) +                  #your data: here should be the name of the merged dataset
  geom_sf(aes(fill = URBN_TYPE),                #Variable of interest
          lwd = 0.1) +                          #line-width of the shapes lines
  scale_fill_viridis_c(option="plasma") +       #inferno/magma/viridis/cividis/rocket/mako/turbo 
  coord_sf(xlim= lon_bounds, ylim=lat_bounds) + #Your zooming decided above
  annotation_scale(location = "br",             #Specifics of the distance bars on the bottom right
                   width_hint = 0.5, 
                   height = unit(0.2, "cm"), 
                   pad_y = unit(0.15, "cm")) + 
  annotation_north_arrow(location = "bl",       #Specifics of the north arrow on the bottom left
                         which_north = "true", 
                         style = north_arrow_fancy_orienteering, 
                         height = unit(1, "cm"), 
                         width = unit(1, "cm"), 
                         pad_y = unit(0.15, "cm")) + 
  theme(panel.background=element_blank(),       #Background: set to blank
        legend.position = c(0, .95),            #Legend specifics
        legend.justification = c("left", "top"),
        legend.box.just = "left",
        legend.margin = margin(6, 6, 6, 6),
        legend.key.size = unit(0.23, 'cm'),
        legend.title = element_text(size=0),
        axis.line=element_blank(),             
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        plot.background=element_blank()) 
map2
