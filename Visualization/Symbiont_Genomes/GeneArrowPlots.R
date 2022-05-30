## Load library
library(tidyverse)
library(gggenes) # draw gene arrow maps with ggplot2
library(RColorBrewer)
library(extrafont) # for Arial font

## Load data
dat <- read.delim("BucCj_pLeuTrp_gggene_fmt.txt", header = FALSE)
colnames(dat) <- c("molecule", "start", "end", "orientation", "gene")
dat <- as_tibble(dat)

## Draw gene arrow maps
p <- ggplot(data = dat,
       mapping = aes(xmin = start, xmax = end, y = molecule,
                     fill = factor(gene, levels = c("yghA", "repA", "leuA", "leuB",
                                                    "leuC", "leuD", "trpE", "trpG")), 
                     forward = orientation)) +
  geom_gene_arrow(arrowhead_width = unit(1, "mm"), arrowhead_height = unit(3, "mm")) +
  guides(fill = guide_legend(ncol = 2)) + # to form 2 columns
  facet_wrap(~ molecule, scales = "free_y", ncol = 1) +
  scale_fill_brewer(palette = "Set3") +
  labs(y = NULL, fill = "gene") +
  xlim(c(0, 10000)) +
  theme_genes() +
  theme(legend.position = "right",
        legend.key.size = unit(3, "mm"),
        legend.title = element_text(size = 8),
        legend.text = element_text(size = 6, face = "italic"),
        axis.text.x = element_text(size = 6),
        axis.text.y = element_text(size = 8))

ggsave(filename = "Fig3D_CjBucpLeuTrpGeneOrder.pdf",
       plot = p, device = cairo_pdf,
       width = 174, height = 35, units = "mm", dpi = 600)
