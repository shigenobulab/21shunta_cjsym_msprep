## Load libraries
library(tidyverse)
library(ggsignif)
library(extrafont) # To use "Arial" font
font_import() # After once running, I don't need running again
loadfonts() # After once running, I don't need running again

## Load data
dat <- read_tsv("20210527_kod_yrmt_analyzed - Abs Quant.txt")
dat_df <- as_tibble(dat) #convert to tibble

## Divide into groups
dat_host <- dat_df %>% filter(`Gene Name` == "CjRpL7")

dat_buc <- dat_df %>%
  filter(`Gene Name` == "CjBucDnaK") %>%
  select(`Sample Name`, `Gene Name`, Cq, Notes) %>%
  mutate(dCq = Cq - dat_host$Cq,
         dCq2 = 2^-dCq)

dat_ars <- dat_df %>%
  filter(`Gene Name` == "CjArsDnaK") %>%
  select(`Sample Name`, `Gene Name`, Cq, Notes) %>%
  mutate(dCq = Cq - dat_host$Cq,
         dCq2 = 2^-dCq)

## Statistics
# Extract data
buc_rep <- dat_buc %>% filter(`Sample Name` == "Reproductive") %>% select(dCq2) %>% unlist(use.names = FALSE)
buc_sol <- dat_buc %>% filter(`Sample Name` == "Soldier") %>% select(dCq2) %>% unlist(use.names = FALSE)
ars_rep <- dat_ars %>% filter(`Sample Name` == "Reproductive") %>% select(dCq2) %>% unlist(use.names = FALSE)
ars_sol <- dat_ars %>% filter(`Sample Name` == "Soldier") %>% select(dCq2) %>% unlist(use.names = FALSE)

# Shapiro-Wilk test: to test null hypothesis that a sample came from a normally distributed population
# p > 0.05 = normal distribution
shapiro.test(buc_rep) 
shapiro.test(buc_sol) 
shapiro.test(ars_rep)
shapiro.test(ars_sol)

# F-test: to test null hypothesis that population variances between two samples are equal
# p > 0.05 = equal variance
var.test(buc_rep, buc_sol)
var.test(ars_rep, ars_sol)

# T-test: to test null hypothesis that the means of two samples are not significantly different
t_buc <- t.test(buc_rep, buc_sol, var.equal = FALSE) # Welch
t_buc
t_ars <- t.test(ars_rep, ars_sol, var.equal = TRUE) # Student
t_ars

# make function to return significant characters
sig_chr <- function(a){
  if (a < 0.001) {
    return("***")
  } else if (a < 0.01) {
    return("**")
  } else if (a < 0.05) {
    return("*")
  } else return ("n.s.")
}

## draw ggplot

p_buc1 <- ggplot(data = dat_buc, 
              mapping = aes(x = factor(`Sample Name`), y = dCq2))
p_buc2 <- p_buc1 +
  geom_boxplot(outlier.shape = NA) + # remove outlier to prevent overlap with geom_jitter points
  geom_jitter(position = position_jitter(width = 0.2))
ymax_buc <- ggplot_build(p_buc2)$layout$panel_params[[1]]$y.range[2] # extract ylim max value from ggplot
p_buc3 <- p_buc2 +
  scale_y_continuous(limits = c(0, ymax_buc * 1.2)) +
  geom_signif(y_position = ymax_buc * 1.1, xmin = 1, xmax = 2, 
              tip_length = 0.05, textsize = measurements::conv_unit(8, "point", "mm"),
              annotations = sig_chr(t_buc$p.value))
p_buc4 <- p_buc3 +
  theme_classic(base_family = "Arial", base_line_size = 0.5) +
  labs(x = NULL,
       y = expression(italic("Buchnera DnaK") ~ "per host" ~ italic("RpL7"))) +
  theme(axis.title.y = element_text(color = "black", size = 8),
        axis.text.y = element_text(color = "black", size = 6),
        axis.text.x = element_text(color = "black", size = 8),
        plot.margin = margin(5, 5, 5, 5, unit = "mm"))

p_ars1 <- ggplot(data = dat_ars, 
                 mapping = aes(x = factor(`Sample Name`), y = dCq2))
p_ars2 <- p_ars1 +
  geom_boxplot(outlier.shape = NA) + # remove outlier to prevent overlap with geom_jitter points
  geom_jitter(position = position_jitter(width = 0.2))
ymax_ars <- ggplot_build(p_ars2)$layout$panel_params[[1]]$y.range[2] # extract ylim max value from ggplot
p_ars3 <- p_ars2 +
  scale_y_continuous(limits = c(0, ymax_ars * 1.2)) +
  geom_signif(y_position = ymax_ars * 1.1, xmin = 1, xmax = 2, 
              tip_length = 0.05, textsize = measurements::conv_unit(8, "point", "mm"),
              annotations = sig_chr(t_ars$p.value))
p_ars4 <- p_ars3 +
  theme_classic(base_family = "Arial", base_line_size = 0.5) +
  labs(x = NULL,
       y = expression(italic("Arsenophonus DnaK") ~ "per host" ~ italic("RpL7"))) +
  theme(axis.title.y = element_text(color = "black", size = 8),
        axis.text.y = element_text(color = "black", size = 6),
        axis.text.x = element_text(color = "black", size = 8),
        plot.margin = margin(5, 5, 5, 5, unit = "mm"))

out <- ggpubr::ggarrange(p_buc4, p_ars4,
                         ncol = 2, labels = LETTERS,
                         font.label = list(size = 12, color = "black", face = "bold", family = "Arial"),
                         hjust = -1, vjust = 1.3)

ggsave(filename = "SymbiontAbundanceCastes.pdf",
       plot = out, device = cairo_pdf,
       width = 174, height = 85, units = "mm", dpi = 500)
