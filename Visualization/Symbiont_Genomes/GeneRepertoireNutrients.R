## Load library
library(tidyverse)
library(ggforce) # for arrange the panel heights: facet_col
library(extrafont) # for "Arial" family
library(RColorBrewer) #

## Load data
dat <- read.delim("NutrientGenes.txt", header = TRUE)
dat <- as_tibble(dat)

## Draw plots
dat <- dat %>%
  mutate(pct = Number / Max)

out <- ggplot(data = dat, 
              mapping = aes(x = factor(Symbiont, levels = c("BucCj", "BucAp", "ArsCj", "ArsNv", "HamCj", "HamAp", "Ecoli")),
                            y = Nutrient, fill = pct)) +
  geom_tile() +
  scale_fill_distiller(palette = "Blues", direction = 1,
                       labels = c("0", "25", "50", "75", "100")) +
  scale_x_discrete(position = "top",
                   labels = c("Buchnera Cj", "Buchnera Ap", "Arsenophonus Cj", "A. nasoniae", "Hamiltonella Cj", "Hamiltonella Ap", "E. coli"),
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

ggsave(filename = "GeneRepertoireNutrients.pdf",
       plot = out, device = cairo_pdf,
       width = 174, height = 90, units = "mm", dpi = 600)
