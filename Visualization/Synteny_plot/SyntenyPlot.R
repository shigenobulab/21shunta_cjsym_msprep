## Load library
library(tidyverse)
library(ggtext) # for markdown
library(extrafont) # for "Arial" family

files <- c("BucCj_chr_2_Buchnera_Apisum_chr_fmt6_dc-megablast.txt", 
           "BucCj_chr_2_Buchnera_Ccedri_chr_fmt6_dc-megablast.txt",
           "ArsCj_chr_2_Arsenophonus_nasoninae_chr_fmt6_dc-megablast.txt", 
           "ArsCj_chr_2_Arsenophonus_lipoptenae_chr_fmt6_dc-megablast.txt",
           "HamCj_chr_2_Hamiltonella_Apisum_chr_fmt6_dc-megablast.txt", 
           "HamCj_chr_2_Hamiltonella_Btabaci_chr_fmt6_dc-megablast.txt")

brks <- list(list(c(0, 100000, 200000, 300000, 400000), c(0, 100000, 200000, 300000, 400000, 500000, 600000)),
             list(c(0, 100000, 200000, 300000, 400000), c(0, 100000, 200000, 300000, 400000)),
             list(c(0, 200000, 400000, 600000, 800000), c(0, 500000, 1000000, 1500000, 2000000, 2500000, 3000000, 3500000)),
             list(c(0, 200000, 400000, 600000, 800000), c(0, 200000, 400000, 600000, 800000)),
             list(c(0, 500000, 1000000, 1500000, 2000000), c(0, 500000, 1000000, 1500000, 2000000)),
             list(c(0, 500000, 1000000, 1500000, 2000000), c(0, 500000, 1000000, 1500000)))

lenlabs <- list(list(c("0.0 Mb", "0.1 Mb", "0.2 Mb", "0.3 Mb", "0.4 Mb"), c("0.0 Mb", "0.1 Mb", "0.2 Mb", "0.3 Mb", "0.4 Mb", "0.5 Mb", "0.6 Mb")),
                list(c("0.0 Mb", "0.1 Mb", "0.2 Mb", "0.3 Mb", "0.4 Mb"), c("0.0 Mb", "0.1 Mb", "0.2 Mb", "0.3 Mb", "0.4 Mb")),
                list(c("0.0 Mb", "0.2 Mb", "0.4 Mb", "0.6 Mb", "0.8 Mb"), c("0.0 Mb", "0.5 Mb", "1.0 Mb", "1,5 Mb", "2.0 Mb", "2,5 Mb", "3.0 Mb", "3,5 Mb")),
                list(c("0.0 Mb", "0.2 Mb", "0.4 Mb", "0.6 Mb", "0.8 Mb"), c("0.0 Mb", "0.2 Mb", "0.4 Mb", "0.6 Mb", "0.8 Mb")),
                list(c("0.0 Mb", "0.5 Mb", "1.0 Mb", "1.5 Mb", "2.0 Mb"), c("0.0 Mb", "0.5 Mb", "1.0 Mb", "1.5 Mb", "2.0 Mb")),
                list(c("0.0 Mb", "0.5 Mb", "1.0 Mb", "1.5 Mb", "2.0 Mb"), c("0.0 Mb", "0.5 Mb", "1.0 Mb", "1.5 Mb")))

namelabs <- list(list("*Buchnera* of *Ce. japonica*", "*Buchnera* of *A. pisum*"),
                 list("*Buchnera* of *Ce. japonica*", "*Buchnera* of *Ci. cedri*"),
                 list("*Arsenophonus* of *Ce. japonica*", "*Arsenophonus nasoninae*"),
                 list("*Arsenophonus* of *Ce. japonica*", "*Arsenophonus lipoptenae*"),
                 list("*Hamiltonella* of *Ce. japonica*", "*Hamiltonella* of *A. pisum*"),
                 list("*Hamiltonella* of *Ce. japonica*", "*Hamiltonella* of *B. tabaci*"))

for (i in 1:6){
  dat <- read.delim(files[i], header = FALSE)
  colnames(dat) <- c("query", "subject", "identity", "align-len", "mismatch", "gap_open",
                     "q_start", "q_end", "s_start", "s_end", "evalue", "bit-score", "qlen", "slen")
  dat <- as_tibble(dat)
  
  pname <- paste("p", i, sep = "")
  assign(pname,
         dat %>%
           ggplot() +
           geom_segment(mapping = aes(x = q_start, xend = q_end, y = s_start, yend = s_end, color = identity)) +
           labs(x = paste(namelabs[[i]][[1]], "chromosome", scales::comma(dat$qlen[1]), "bp", sep = " "),
                y = paste(namelabs[[i]][[2]], "chromosome", scales::comma(dat$slen[1]), "bp", sep = " "),
                color = "Identity (%)") +
           scale_x_continuous(limits = c(0, dat$qlen[1]), breaks = brks[[i]][[1]], labels = lenlabs[[i]][[1]], expand = c(0, 0)) +
           scale_y_continuous(limits = c(0, dat$slen[1]), breaks = brks[[i]][[2]], labels = lenlabs[[i]][[2]], expand = c(0, 0)) +
           scale_color_gradientn(colors = rainbow(5, rev = TRUE), limits = c(0, 100))+
           theme_bw(base_family = "Arial", base_line_size = 0.5) +
           theme(axis.title.x = element_markdown(size = 7),
                 axis.title.y = element_markdown(size = 7),
                 axis.text.x = element_text(size = 6),
                 axis.text.y = element_text(size = 6),
                 legend.title = element_text(size = 7),
                 legend.text = element_text(size = 6),
                 legend.position = "right",
                 legend.key.height = unit(2, "mm"),
                 plot.margin = unit(c(5, 5, 5, 5), "mm"))
  )
}

out <- ggpubr::ggarrange(p1, p2, p3, p4, p5, p6,
                         ncol = 2, nrow = 3,
                         common.legend = TRUE, legend = "bottom") +
  theme(plot.margin = margin(2.0, 0.1, 0.1, 1.5, "mm"))

ggsave(filename = "FigS3_SyntenyPlots.pdf",
       plot = out, device = cairo_pdf,
       width = 174, height = 230, units = "mm", dpi = 600)
