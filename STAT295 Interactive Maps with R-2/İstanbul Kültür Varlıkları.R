libraries <- c("ggplot2","sf","rworldmap","tidyverse","magrittr",
               "leaflet", "dplyr", "rvest", "xml2",
               "maps","mapdata","RgoogleMaps","lubridate","rnaturalearth","dplyr","rnaturalearthdata","RColorBrewer","httr")
lapply(libraries, require, character.only = TRUE)


cultural_property<-read.csv("https://data.ibb.gov.tr/dataset/931478af-172a-41cf-9b53-39eded5f63ba/resource/8be73973-dc72-4e61-aea9-43c8f5ca4605/download/istanbul-kultur-varliklari-envanteri.csv")
head(cultural_property)
str(cultural_property)
unique(cultural_property$kultur_donemi)
prehistorya_antik<-c("PREHİSTORYA","ANTİK")
filtered_cultural_property<-cultural_property %>% 
  filter(kultur_donemi %in% prehistorya_antik)
filtered_cultural_property %>%
  leaflet() %>%
  addTiles() %>%
  setView(lng = median(filtered_cultural_property$longitude),
          lat = median(filtered_cultural_property$latitude),
          zoom = 9) %>%
  addMarkers(~longitude, ~latitude,
             label = ~anit_adi,
             popup = paste0(
               "<b> Yapım Tarihi(Construction Date): </b>",
               filtered_cultural_property$yapim_tarihi,
               "<br>",
               "<b> Kültür Dönemi (Cultural Era): </b>",
               filtered_cultural_property$kultur_donemi,
               "<br>",
               "<b> Anıt Türü(Monument Type) </b>",
               filtered_cultural_property$anit_turu,
               "<br>",
               "<b> Tespit Tarihi (Identification Date) </b>",
               filtered_cultural_property$tespit_tarihi))