## Load library
library(tidyverse)
library(ggtext) # for markdown
library(extrafont) # for "Arial" family

files <- c("BucCjAp.dc-megablast.fmt6.txt", "BucCjCc.dc-megablast.fmt6.txt",
           "ArsCjNv.dc-megablast.fmt6.txt", "ArsCjLc.dc-megablast.fmt6.txt",
           "HamCjAp.dc-megablast.fmt6.txt", "HamCjBt.dc-megablast.fmt6.txt")

brks <- list(list(c(0, 100000, 200000, 300000, 400000), c(0, 100000, 200000, 300000, 400000, 500000, 600000)),
             list(c(0, 100000, 200000, 300000, 400000), c(0, 100000, 200000, 300000, 400000)),
             list(c(0, 200000, 400000, 600000, 800000), c(0, 500000, 1000000, 1500000, 2000000, 2500000, 3000000, 3500000)),
             list(c(0, 200000, 400000, 600000, 800000), c(0, 200000, 400000, 600000, 800000)),
             list(c(0, 500000, 1000000, 1500000, 2000000), c(0, 500000, 1000000, 1500000, 2000000)),
             list(c(0, 500000, 1000000, 1500000, 2000000), c(0, 500000, 1000000, 1500000)))

lenlabs <- list(list(c("0 kbp", "100 Kbp", "200 Kbp", "300 Kbp", "400 Kbp"), c("0 kbp", "100 Kbp", "200 Kbp", "300 Kbp", "400 Kbp", "500 Kbp", "600 Kbp")),
                list(c("0 kbp", "100 Kbp", "200 Kbp", "300 Kbp", "400 Kbp"), c("0 kbp", "100 Kbp", "200 Kbp", "300 Kbp", "400 Kbp")),
                list(c("0 kbp", "200 Kbp", "400 Kbp", "600 Kbp", "800 Kbp"), c("0 Mbp", "0.5 Mbp", "1 Mbp", "1,5 Mbp", "2 Mbp", "2,5 Mbp", "3 Mbp", "3,5 Mbp")),
                list(c("0 kbp", "200 Kbp", "400 Kbp", "600 Kbp", "800 Kbp"), c("0 kbp", "200 Kbp", "400 Kbp", "600 Kbp", "800 Kbp")),
                list(c("0 Mbp", "0.5 Mbp", "1 Mbp", "1.5 Mbp", "2 Mbp"), c("0 Mbp", "0.5 Mbp", "1 Mbp", "1.5 Mbp", "2 Mbp")),
                list(c("0 Mbp", "0.5 Mbp", "1 Mbp", "1.5 Mbp", "2 Mbp"), c("0 Mbp", "0.5 Mbp", "1 Mbp", "1.5 Mbp")))

namelabs <- list(list("*Buchnera* of *C. japonica*", "*Buchnera* of *A. pisum*"),
                 list("*Buchnera* of *C. japonica*", "*Buchnera* of *C. cedri*"),
                 list("*Arsenophonus* of *C. japonica*", "*Arsenophonus nasoninae*"),
                 list("*Arsenophonus* of *C. japonica*", "*Arsenophonus lipoptenae*"),
                 list("*Hamiltonella* of *C. japonica*", "*Hamiltonella* of *A. pisum*"),
                 list("*Hamiltonella* of *C. japonica*", "*Hamiltonella* of *B. tabaci*"))

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
                         ncol = 2, nrow = 3, labels = LETTERS,
                         font.label = list(size = 8, color = "black", face = "bold", family = "Arial"),
                         hjust = 0, vjust = 0.5,
                         common.legend = TRUE, legend = "bottom") +
  theme(plot.margin = margin(2.0, 0.1, 0.1, 1.5, "mm"))

ggsave(filename = "SyntenyPlots.pdf",
       plot = out, device = cairo_pdf,
       width = 174, height = 230, units = "mm", dpi = 600)
