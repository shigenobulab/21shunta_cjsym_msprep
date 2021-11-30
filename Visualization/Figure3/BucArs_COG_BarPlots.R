## Load library
library(tidyverse)
library(extrafont) # for Arial font
library(socviz) # to use %nin%

## Load data
dat <- read.delim("BucArs_COG_summary.txt", header = FALSE, comment.char = "#")
colnames(dat) <- c("genus", "strain", "tag", "description", "number")
dat_df <- tibble(dat)

## Remove tags for eukaryotes
eu_tags <- c("W", "Y", "Z", "B")
dat_df_bac <- dat_df %>%
  filter(tag %nin% eu_tags)

## Draw barplot
dat_order <- transform(dat_df_bac,
                       description = factor(description, levels = rev(c(
                         'Cell cycle control, cell division, chromosome partitioning',
                         'Cell wall/membrane/envelope biogenesis',
                         'Cell motility',
                         'Post-translational modification, protein turnover, and chaperones',
                         'Signal transduction mechanisms',
                         'Intracellular trafficking, secretion, and vesicular transport',
                         'Defense mechanisms',
                         'RNA processing and modification',
                         'Translation, ribosomal structure and biogenesis',
                         'Transcription',
                         'Replication, recombination and repair',
                         'Energy production and conversion',
                         'Amino acid transport and metabolism',
                         'Nucleotide transport and metabolism',
                         'Carbohydrate transport and metabolism',
                         'Coenzyme transport and metabolism',
                         'Lipid transport and metabolism',
                         'Inorganic ion transport and metabolism',
                         'Secondary metabolites biosynthesis, transport, and catabolism',
                         'General function prediction only',
                         'Function unknown',
                         'Not in COGs'
                       ))),
                       strain = factor(strain, levels = rev(c(
                         "BCj", "BCc", "BAp", "ACj", "ALc", "ANv"
                       ))),
                       genus = factor(genus, levels = c(
                         "Buchnera", "Arsenophonus"
                       )))

p <- ggplot(data = dat_order,
            mapping = aes(x = description, y = number, fill = strain)) +
  geom_col(position = "dodge2") +
  labs(x = NULL, y = "Number of COG categories") +
  guides(fill = "none") +
  coord_flip() +
  facet_wrap(~ genus, ncol = 2, scales = "free_x") +
  theme_minimal(base_family = "Arial", base_line_size = 0.5) +
  theme(strip.text = element_text(size = 8, face = "bold"),
        axis.title.x = element_text(size = 8),
        axis.text.x = element_text(size = 6),
        axis.text.y = element_text(size = 6),
        panel.spacing.x = unit(20, "points") # separate two plots
  )
ggsave(filename = "COGcategories_Barplots.pdf",
       plot = p, device = cairo_pdf,
       width = 174, height = 80, units = "mm", dpi = 600)
