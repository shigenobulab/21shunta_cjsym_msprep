## Load library
library(tidyverse)
library(circlize) # draw circular genome
library(RColorBrewer)
library(extrafont) # for Arial font

infile <- c("BucCj_pgl.gff", "ArsCj_pgl.gff", "HamCj_pgl.gff")

coltag <- c("seqid", "source", "type", "start", "end", "score", "strand", "phase", "attributes")

prefix <- c("gnl|Prokka|BucCj_NOSY1_1", "gnl|Prokka|ArsCj_NOSY1_1", "gnl|Prokka|HamCj_NOSY1_1")

seq_xlim <- c(414725, 853149, 2500000)

seq_len <- c(414725, 853149, 2258324)

outfile <- c("BuchneraChromosomePlot.pdf", "ArsenophonusChromosomePlot.pdf", "HamiltonellaChromosomePlot.pdf")

scale_seq <- list(c(0, 400000, 100000), c(0, 800000, 200000), c(0, 2000000, 500000))

scale_label <- list(c("0.0 Mb", "0.1", "0.2", "0.3", "0.4", ""),
                    c("0.0 Mb", "0.2", "0.4", "0.6", "0.8", ""),
                    c("0.0 Mb", "0.5", "1.0", "1.5", "2.0", ""))

symbiont <- list("Buchnera", "Arsenophonus", "Hamiltonella")

for (i in 1:3){
  dat <- read.delim(infile[i], header = FALSE, comment.char = "#") # load gff3 file
  colnames(dat) <- coltag
  dat <- subset(dat, seqid == prefix[i])
  dat <- as_tibble(dat)
  
  gene_plus <- dat %>%
    filter(type == "gene", strand == "+") 
  gene_minus <- dat %>%
    filter(type == "gene", strand == "-")
  trna <- dat %>%
    filter(type == "tRNA")
  rrna <- dat %>%
    filter(type == "rRNA")
  pseudogene <- dat %>%
    filter(type == "pseudogene")
  
  contents <- list(gene_plus, gene_minus, trna, rrna, pseudogene)
  rect_colors <- c(brewer.pal(4, "Set1"), 'black') # Set colors
  
  cairo_pdf(file = outfile[i], width = 2.0, height = 2.0, family = "Arial") 
  par(mar = c(0, 0, 0, 0), ps = 8)
  circos.par(gap.degree = 0, # Gap between two neighbour sectors
             cell.padding = c(0, 0, 0, 0), # Padding of the cell
             start.degree = 90, # sectors start from the top center of the circle
             circle.margin = c(0.1, 0.1, 0.1, 0.1)) # left, right, bottom, top sides of the circle
  circos.initialize(sectors = 1, xlim = c(0, seq_xlim[i])) 
  circos.track(ylim = c(0, 1), track.height = mm_h(1), bg.border = NA)
  circos.xaxis(major.at = c(seq(scale_seq[[i]][1], scale_seq[[i]][2], scale_seq[[i]][3]), seq_len[i]), 
               labels = scale_label[[i]], 
               col = "black", direction = "outside", minor.ticks = 0, major.tick.length = mm_y(0.5), labels.cex = 0.75)
  
  for (j in 1:5) {
    circos.track(ylim = c(0, 1), track.height = mm_h(1), bg.border = NA) # prepare track
    circos.rect(xleft = contents[[j]]$start, xright = contents[[j]]$end, ybottom = 0, ytop = 1, col = rect_colors[j], border = NA) # plot
  }
  
  text(0, 0.1, paste(symbiont[i], "CJ", sep = " "), cex = 1.0)
  text(0, -0.1, paste(scales::comma(seq_len[i]), "bp", sep = " "), cex = 1.0)
  
  circos.clear() # If you have already run "circos.initialize()" before running "circos.par()"
  dev.off()
  
}
