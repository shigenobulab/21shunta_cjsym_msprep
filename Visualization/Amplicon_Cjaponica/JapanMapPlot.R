# Load library
library(tidyverse)
library(maps) # for loading world map
library(ggthemes) # for theme_map()
library(ggrepel) # for geom_text_repel()
library(extrafont) # for Arial font
library(scales) # for scale %
library(ggtext) # for markdown

# Load data
dat <- read_csv("Cjap_16S_amplicon.csv")
dat <- as_tibble(dat) # convert dat to tibble format

# Extract data for mapping
world <- map_data("world")

for_map <- dat %>%
  distinct(Longitude, Latitude, `Host plant`) %>%
  mutate(ID = c("1", "2,3,4", "5,6,7", "8,9,10", "11,12,13", "14", "15,16,17", "18,19,20", "21,22,23", "24,25,26"))

# Cut Okinawa
xlim = c(128, 146) # Longitude
ylim = c(30, 46) # Latitude

# Draw map
p <- ggplot() +
  geom_polygon(data = world %>% filter(region == "Japan"),
               mapping = aes(x = long, y = lat, group = group), 
               fill = "white", color = "black", size = 0.1) + # draw japan map
  coord_map(projection = "albers", lat0 = 30, lat1 = 46) + # correct shape
  geom_point(data = for_map,
             mapping = aes(x = Longitude, y = Latitude, 
                           color = factor(`Host plant`, levels = c("Sasa senanensis", "Pleioblastus chino", "Pleioblastus simonii"))),
             alpha = 0.5) + # plot sampling location
  labs(color = "") +
  scale_color_brewer(palette = "Dark2", labels = c("S. senanensis", "P. chino", "P. simonii")) +
  geom_text_repel(data = for_map,
                  mapping = aes(x = Longitude, y = Latitude, 
                                label = ID),
                  size = measurements::conv_unit(6, "point", "mm"),
                  family = "Arial") + # labeling
  xlim(xlim) + ylim(ylim) + 
  theme_minimal() + theme_map() + # simple design for map drawing
  theme(legend.position = c(0, 1),
        legend.justification = c(0, 1),
        legend.title = element_text(size = 8, family = "Arial"),
        legend.text = element_text(size = 8, face = "italic", family = "Arial")) +
  guides(color = guide_legend(nrow = 3))

ggsave(filename = "JapanMapPlot.pdf",
       plot = p, device = cairo_pdf,
       width = 70, height = 70, units = "mm", dpi = 600)