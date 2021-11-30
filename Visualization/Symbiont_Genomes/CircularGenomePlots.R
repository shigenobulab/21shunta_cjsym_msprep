## Load library
library(tidyverse)
library(circlize) # draw circular genome
library(RColorBrewer)
library(extrafont) # for Arial font

# Buchnera Chromosome
dat <- read.delim("CjBuc_chr.gff", header = FALSE, comment.char = "#") # load gff3 file
colnames(dat) <- c("seqid", "source", "type", "start", "end", "score", "strand", "phase", "attributes")
dat <- subset(dat, seqid == "CjBuc_Chr_pilon_pilon")
dat <- as_tibble(dat) 

cds_plus <- dat %>%
  filter(type == "CDS", strand == "+") 
cds_minus <- dat %>%
  filter(type == "CDS", strand == "-")
trna <- dat %>%
  filter(type == "tRNA")
rrna <- dat %>%
  filter(type == "rRNA")

contents <- list(cds_plus, cds_minus, trna, rrna)
rect_colors <- brewer.pal(4, "Set1") # Set colors
seq_len <- 414724

cairo_pdf(file = "BuchneraChromosomePlot.pdf", width = 1.9, height = 1.9, family = "Arial") 
par(mar = c(0, 0, 0, 0), ps = 8)
circos.par(gap.degree = 0, # Gap between two neighbour sectors
           cell.padding = c(0, 0, 0, 0), # Padding of the cell
           start.degree = 90, # sectors start from the top center of the circle
           circle.margin = c(0.1, 0.1, 0.1, 0.1)) # left, right, bottom, top sides of the circle
circos.initialize(sectors = 1, xlim = c(0, seq_len)) 
circos.track(ylim = c(0, 1), track.height = mm_h(1), bg.border = NA)
circos.xaxis(major.at = c(seq(0, 400000, 50000), seq_len), 
             labels = c("0 kbp", "50", "100", "150", "200", "250", "300", "350", "400", ""), 
             col = "black", direction = "outside", minor.ticks = 0, major.tick.length = mm_y(0.5), labels.cex = 0.75)

for (i in 1:4) {
  circos.track(ylim = c(0, 1), track.height = mm_h(1), bg.border = NA) # prepare track
  circos.rect(xleft = 0, xright = seq_len, ybottom = 0, ytop = 1, col = adjustcolor(rect_colors[i], alpha = 0.2), border = NA) # background
  circos.rect(xleft = contents[[i]]$start, xright = contents[[i]]$end, ybottom = 0, ytop = 1, col = rect_colors[i], border = NA) # plot
}

text(0, 0.15, expression(italic("Buchnera")~" CjN"), cex = 1.0)
text(0, 0, "(chromosome)", cex = 1.0)
text(0, -0.15, paste(scales::comma(seq_len), "bp", sep = " "), cex = 1.0)

circos.clear() # If you have already run "circos.initialize()" before running "circos.par()"
dev.off()

# Arsenophonus Chromosome
dat <- read.delim("CjArs_chr.gff", header = FALSE, comment.char = "#") # load gff3 file
colnames(dat) <- c("seqid", "source", "type", "start", "end", "score", "strand", "phase", "attributes")
dat <- subset(dat, seqid == "CjArs_Chr_pilon_pilon")
dat <- as_tibble(dat) 

cds_plus <- dat %>%
  filter(type == "CDS", strand == "+") 
cds_minus <- dat %>%
  filter(type == "CDS", strand == "-")
trna <- dat %>%
  filter(type == "tRNA")
rrna <- dat %>%
  filter(type == "rRNA")

contents <- list(cds_plus, cds_minus, trna, rrna)
rect_colors <- brewer.pal(4, "Set1") # Set colors
seq_len <- 853220

cairo_pdf(file = "ArsenophonusChromosomePlot.pdf", width = 1.9, height = 1.9, family = "Arial") 
par(mar = c(0, 0, 0, 0), ps = 8)
circos.par(gap.degree = 0, # Gap between two neighbour sectors
           cell.padding = c(0, 0, 0, 0), # Padding of the cell
           start.degree = 90, # sectors start from the top center of the circle
           circle.margin = c(0.1, 0.1, 0.1, 0.1)) # left, right, bottom, top sides of the circle
circos.initialize(sectors = 1, xlim = c(0, seq_len)) 
circos.track(ylim = c(0, 1), track.height = mm_h(1), bg.border = NA)
circos.xaxis(major.at = c(seq(0, 800000, 100000), seq_len), 
             labels = c("0 kbp", "100", "200", "300", "400", "500", "600", "700", "800", ""), 
             col = "black", direction = "outside", minor.ticks = 0, major.tick.length = mm_y(0.5), labels.cex = 0.75)

for (i in 1:4) {
  circos.track(ylim = c(0, 1), track.height = mm_h(1), bg.border = NA) # prepare track
  circos.rect(xleft = 0, xright = seq_len, ybottom = 0, ytop = 1, col = adjustcolor(rect_colors[i], alpha = 0.2), border = NA) # background
  circos.rect(xleft = contents[[i]]$start, xright = contents[[i]]$end, ybottom = 0, ytop = 1, col = rect_colors[i], border = NA) # plot
}

text(0, 0.15, expression(italic("Arsenophonus")~" CjN"), cex = 1.0)
text(0, 0, "(chromosome)", cex = 1.0)
text(0, -0.15, paste(scales::comma(seq_len), "bp", sep = " "), cex = 1.0)

circos.clear() # If you have already run "circos.initialize()" before running "circos.par()"
dev.off()

# Hamiltonella Chromosome
dat <- read.delim("CjHam_chr.gff", header = FALSE, comment.char = "#") # load gff3 file
colnames(dat) <- c("seqid", "source", "type", "start", "end", "score", "strand", "phase", "attributes")
dat <- subset(dat, seqid == "CjHam_Chr_pilon_pilon")
dat <- as_tibble(dat) 

cds_plus <- dat %>%
  filter(type == "CDS", strand == "+") 
cds_minus <- dat %>%
  filter(type == "CDS", strand == "-")
trna <- dat %>%
  filter(type == "tRNA")
rrna <- dat %>%
  filter(type == "rRNA")

contents <- list(cds_plus, cds_minus, trna, rrna)
rect_colors <- brewer.pal(4, "Set1") # Set colors
seq_len <- 2257777

cairo_pdf(file = "HamiltonellaChromosomePlot.pdf", width = 1.9, height = 1.9, family = "Arial") 
par(mar = c(0, 0, 0, 0), ps = 8)
circos.par(gap.degree = 0, # Gap between two neighbour sectors
           cell.padding = c(0, 0, 0, 0), # Padding of the cell
           start.degree = 90, # sectors start from the top center of the circle
           circle.margin = c(0.1, 0.1, 0.1, 0.1)) # left, right, bottom, top sides of the circle
circos.initialize(sectors = 1, xlim = c(0, 2350000)) 
circos.track(ylim = c(0, 1), track.height = mm_h(1), bg.border = NA)
circos.xaxis(major.at = c(seq(0, 2250000, 250000), seq_len), 
             labels = c("0 kbp", "250", "500", "750", "1,000", "1,250", "1,500", "1,750", "2,000", "2,250", ""), 
             col = "black", direction = "outside", minor.ticks = 0, major.tick.length = mm_y(0.5), labels.cex = 0.75)

for (i in 1:4) {
  circos.track(ylim = c(0, 1), track.height = mm_h(1), bg.border = NA) # prepare track
  circos.rect(xleft = 0, xright = seq_len, ybottom = 0, ytop = 1, col = adjustcolor(rect_colors[i], alpha = 0.2), border = NA) # background
  circos.rect(xleft = contents[[i]]$start, xright = contents[[i]]$end, ybottom = 0, ytop = 1, col = rect_colors[i], border = NA) # plot
}

text(0, 0.15, expression(italic("Hamiltonella")~" CjN"), cex = 1.0)
text(0, 0, "(chromosome)", cex = 1.0)
text(0, -0.15, paste(scales::comma(seq_len), "bp", sep = " "), cex = 1.0)

circos.clear() # If you have already run "circos.initialize()" before running "circos.par()"
dev.off()
