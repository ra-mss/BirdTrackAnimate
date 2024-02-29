#install.packages(c("tidyverse", "rnaturalearth", "gganimate", "gifski"))
library(tidyverse)
library(gganimate)
library(gifski)
library(rnaturalearth)

track_db <- read.csv("C:/Users/Ramses/Desktop/bird_migration.csv", row.names = NULL)

#Separar columnas date y time
track_db[c('date', 'time')] <- str_split_fixed(track_db$date_time, ' ', 2)

#Elegir columnas a usar, y pasar a formato Date la columna 'date'
track_db <- track_db[c('X', 'bird_name', 'date', 'time', 'latitude', 'longitude')]
track_db$date <- as.Date(with(track_db, paste(date)), "%Y-%m-%d")

#Mapa estático
world <- ne_countries(scale = 'medium', type = 'map_units', returnclass = 'sf') #Mapa mundi

legend_title <- "Bird name"

ggplot() +
  geom_sf(data = world) + theme_test() +
  geom_point(data=track_db, 
             aes(x = longitude, y = latitude, col=bird_name), pch=19, size=1) +
  scale_color_manual(legend_title, values = c("#5CBED4", "#544082", "#E94889")) +
  xlab("Longitude") + ylab("Latitude") +
  labs(title = "Seabird tracking", subtitle = "Data: LifeWatch") +
  coord_sf(xlim = c(-24,20), ylim = c(3,56)) 

#Mapa con las características deseadas, agrega los puntos utilizando los valores de 'x' y 'y' para las columnas de longitud y latitud, respect 
p <- ggplot()+
  geom_sf(data = world) + theme_test() + 
  geom_point(data=track_db, 
             aes(x = longitude, y = latitude, col=bird_name), 
             pch=19, size=2) + 
  scale_color_manual(legend_title, values = c("#5CBED4", "#544082", "#E94889")) +
  xlab("Longitude") + ylab("Latitude") + 
  #theme(axis.title.x = element_text(hjust = 0.5), axis.title.y = element_text(vjust = 0.5)) +
  coord_sf(xlim = c(-24,20), ylim = c(3,56)) +transition_time(date) + 
  #shadow_wake(wake_length = 0.05, size = NULL, alpha = 0.2) +
  labs(title = "Seabird tracking  |  |  Date: {frame_time}", subtitle = "Data: LifeWatch")

plot(p)

#Configurar los frames y fps del gif  
animate(p, nframes = 1000, fps = 30, renderer = gifski_renderer("map.gif"))
