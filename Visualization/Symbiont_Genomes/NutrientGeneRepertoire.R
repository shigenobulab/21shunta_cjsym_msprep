## Load library
library(tidyverse)
library(ggforce) # for arrange the panel heights: facet_col
library(extrafont) # for "Arial" family

## Check Brewer Color
library(RColorBrewer)
display.brewer.all()
brewer.pal(11, "RdYlBu")

## Load data
dat <- read.delim("220819_CjapSymNutrientGenes.txt", header = TRUE)
dat <- as_tibble(dat)

## Draw plots
dat <- dat %>%
  mutate(
    pct = Number / Max,
    highlight = case_when(
      between(pct, 0.0, 0.24) ~ "A",
      between(pct, 0.25, 0.49) ~ "B",
      between(pct, 0.5, 0.74) ~ "C",
      between(pct, 0.75, 0.99) ~ "D",
      between(pct, 1.0, 1.0) ~ "E"
    ))

fill_color <- c("#D73027", "#FDAE61", "#FFFFBF", "#ABD9E9", "#4575B4")
fill_label <- c("0-24", "25-49", "50-74", "75-99", "100")

out <- ggplot(data = dat, 
              mapping = aes(x = factor(Symbiont, levels = c("BucCj", "BucCc", "BucAp", "ArsCj", "ArsLc", "ArsNv", "Ecoli")),
                            y = Nutrient, fill = highlight)) +
  geom_tile(color = "white",
            lwd = 0.5,
            linetype = 1) +
  scale_fill_manual(values = fill_color,
                    labels = fill_label) +
  scale_x_discrete(position = "top",
                   labels = c("Ce. japonica", "Ci. cedri", "A. pisum", "Ce. japonica", "L. cervi", "A. nasoniae", "E. coli"),
                   expand = c(0, 0)) +
  scale_y_discrete(limits = rev, expand = c(0, 0)) +
  facet_col(~ factor(Type, levels = c("Essential amino acids", "Non-essential amino acids", "B vitamins")),
            scales = "free_y", space = "free") +
  labs(x = NULL, y = NULL,
       fill = "Completeness (%)") +
  theme_minimal(base_family = "Arial", base_line_size = 1) +
  theme(legend.position = "bottom",
        legend.key.size = unit(8, "points"),
        legend.title = element_text(size = 8),
        legend.text = element_text(size = 6),
        strip.text = element_text(size = 8, face = "bold"),
        axis.text.x = element_text(size = 8, face = "italic"),
        axis.text.y = element_text(size = 6),
        plot.margin = margin(2, 2, 2, 2, unit = "mm"),
        panel.grid = element_blank())

ggsave(filename = "Fig3F_GeneRepertoire2.pdf",
       plot = out, device = cairo_pdf,
       width = 172, height = 90, units = "mm", dpi = 600)
