nmmaps<-read.csv("https://www.cedricscherer.com/data/chicago-nmmaps-custom.csv")
head(nmmaps)       
str(nmmaps)
library(tidyverse)
nmmaps <- nmmaps |> 
  mutate(date = as.Date(date, format = "%Y-%m-%d"))
library(ggplot2)
ggplot(data=nmmaps,aes(x=date,y=temp)) +
  geom_point(alpha=0.5)+
  facet_wrap(~year,scales="free")+
  labs(x = "Date", y = "Temperature", title = "Temperature Variation by Year")+
  scale_x_date(date_labels = "%b", date_breaks = "1 month")+
  scale_y_continuous(limits = c(min(nmmaps$temp), max(nmmaps$temp)))


nmmaps$season <- factor(nmmaps$season, levels = c("Winter", "Spring", "Summer", "Autumn"))
season_colors <- c("Winter" = "lightblue",   
                   "Spring" = "lightgreen",  
                   "Summer" = "yellow", 
                   "Autumn" = "orange") 
ggplot(nmmaps, aes(x = date, y = temp, color = season)) +
  geom_point(alpha = 0.5) +
  labs(x = "Date", y = "Temperature", color = "Season", title = "Temperature Variation by Season")+
  scale_color_manual(values = season_colors)
 

correlation <- cor(nmmaps$temp, nmmaps$dewpoint)
rounded_cor <-round(correlation,3)
print(paste("Correlation coefficient between temperature and dewpoint:", rounded_cor))
ggplot(nmmaps, aes(x = temp, y = dewpoint)) +
  geom_point(alpha = 0.5) +
  labs(x = "Temperature", y = "Dew Point", title = "Temperature vs. Dew Point")



libraries <- c("ggplot2","sf","rworldmap","tidyverse","magrittr",
               "leaflet", "dplyr", "rvest", "xml2",
               "maps","mapdata","RgoogleMaps","lubridate","rnaturalearth","dplyr","rnaturalearthdata","RColorBrewer","httr")
lapply(libraries, require, character.only = TRUE)


url <- "https://ds.iris.edu/seismon/eventlist/index.phtml"

res <- GET(url)
html_con <- content(res, "text")
?content
html_ulke <- read_html(html_con)

tables <- html_ulke |> 
  html_nodes("table") |> 
  html_table() 
earthquake <- as.data.frame(tables)
str(earthquake)
earthquake %<>%
  mutate(Class = ifelse(MAG < 4.5, "Minor",
                        ifelse(MAG < 5.5, "Moderate", "Major")))
color_vector <- colorFactor(c("Gold", "Blue", "Dark Red"),
                            domain = earthquake$Class)
earthquake |> 
  leaflet() |> 
  addTiles() |> 
  addCircles(~LON, ~LAT,
             weight = 10,
             radius = 120,
             popup = paste0(
               "<b>Date: </b>",
               earthquake$DATE.and.TIME..UTC.,
               "<br>",
               "<b>Place: </b>",
               earthquake$ LOCATION................................Shows.interactive.map.,
               "<br>",
               "<b>Depth in km: </b>",
               earthquake$DEPTHkm,
               "<br>",
               "<b>Magnitude: </b>",
               earthquake$MAG),
             label = ~LOCATION................................Shows.interactive.map.,
             color = ~color_vector(Class)) |> 
  setView(lng = median(earthquake$LON),
          lat = median(earthquake$LAT),
          zoom = 2)

