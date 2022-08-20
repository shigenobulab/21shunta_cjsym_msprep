## Load library
library(tidyverse)
library(extrafont) # for Arial font
library(ggrepel) # for geom_text_repel()
library(scales) # for log scale 

## Check Brewer Color
library(RColorBrewer)
display.brewer.all()
brewer.pal(9, "Set1")

##

dat <- read.delim('Release_220812-CJraven_blob/blobtools_outputs/Cj_raven_02.blobDB.table.txt',
                  comment.char = '#', header = FALSE)
dat <- as_tibble(dat)
colnames(dat) <- c('name', 'length', 'GC', 'N', 'bam0',
                   'phylum_t_6_s', 'phylum_s_7_s', 'phylum_c_8')
dat['GC'] <- dat['GC'] * 100

dat <- dat %>%
  mutate(
    highlight = case_when(
      name == 'Utg156556' ~ 'A', # Buchnera
      name == 'Utg140514' ~ 'B', # pTrp
      name == 'Utg142168' ~ 'C', # Arsenophonus
      name == 'Utg140546' ~ 'D', # Hamiltonella
      name == 'Utg153666' ~ 'E', # Mitochondrion
      phylum_t_6_s == 'Arthropoda' ~ 'F', # Host
      TRUE ~ 'G' # Others
    ))

color_color <- c('#377EB8', '#377EB8', '#E41A1C', 
                '#4DAF4A', '#984EA3', '#984EA3', '#999999')
color_label <- c('Buchnera', 'pTrp', 'Arsenophonus', 
                'Hamiltonella', 'Mitochondrion', 'Host', 'Others')

p <- ggplot(data = dat, 
            mapping = aes(x = GC, y = bam0, size = length, color = highlight)) +
  geom_point(shape = 16, alpha = 0.5) + # shape = 16 : no border
  scale_size(range = c(1, 10),
             breaks = c(10000, 400000, 800000, 2000000), 
             name = 'Contig size [bp]',
             labels = comma) + 
  scale_y_log10(labels = trans_format('log10', math_format(10^.x)),
                limits = c(10^1, 10^4)) +
  scale_color_manual(values = fill_color, labels = fill_label) +
  labs(x = 'GC content (%)',
       y = 'Contig coverage') +
  guides(color = 'none') +
  theme_minimal(base_family = "Arial", base_line_size = 1) +
  theme(legend.title = element_text(size = 8),
        legend.text = element_text(size = 6),
        axis.title.x = element_text(size = 8),
        axis.title.y = element_text(size = 8),
        axis.text.x = element_text(size = 6),
        axis.text.y = element_text(size = 6),
        plot.margin = margin(2, 2, 2, 2, unit = "mm"))

p

ggsave(filename = "SuplFig_MetagenomicBinning.pdf",
       plot = p, device = cairo_pdf,
       width = 120, height = 90, units = "mm", dpi = 600)

