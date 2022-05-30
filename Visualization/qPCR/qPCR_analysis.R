## Load libraries
library(tidyverse)
library(ggsignif)
library(extrafont) # To use "Arial" font
#font_import() # After once running, I don't need running again
#loadfonts() # After once running, I don't need running again

## Load data
dat <- read_tsv("20210527_kod_yrmt_analyzed - Abs Quant.txt")
dat_df <- as_tibble(dat) #convert to tibble

## Divide into groups
dat_host <- dat_df %>% filter(`Gene Name` == "CjRpL7")

dat_buc <- dat_df %>%
  filter(`Gene Name` == "CjBucDnaK") %>%
  select(`Sample Name`, `Gene Name`, Cq, Notes) %>%
  mutate(dCq = Cq - dat_host$Cq,
         rep_mean = mean(dCq[1:10]),
         ddCq = dCq - rep_mean,
         ddCq2 = 2 ^ -ddCq)

dat_ars <- dat_df %>%
  filter(`Gene Name` == "CjArsDnaK") %>%
  select(`Sample Name`, `Gene Name`, Cq, Notes) %>%
  mutate(dCq = Cq - dat_host$Cq,
         rep_mean = mean(dCq[1:10]),
         ddCq = dCq - rep_mean,
         ddCq2 = 2 ^ -ddCq)

## Statistics
# Extract data
buc_rep <- dat_buc %>% filter(`Sample Name` == "Reproductive") %>% select(ddCq) %>% unlist(use.names = FALSE)
buc_sol <- dat_buc %>% filter(`Sample Name` == "Soldier") %>% select(ddCq) %>% unlist(use.names = FALSE)
ars_rep <- dat_ars %>% filter(`Sample Name` == "Reproductive") %>% select(ddCq) %>% unlist(use.names = FALSE)
ars_sol <- dat_ars %>% filter(`Sample Name` == "Soldier") %>% select(ddCq) %>% unlist(use.names = FALSE)

a <- sum(dat_buc$ddCq2[1:10])/10
b <- sum(dat_buc$ddCq2[11:20])/10
b/a

c <- sum(dat_ars$ddCq2[1:10])/10
d <- sum(dat_ars$ddCq2[11:20])/10
d/c

# Shapiro-Wilk test: to test null hypothesis that a sample came from a normally distributed population
# p > 0.05 = normal distribution
shapiro.test(buc_rep) 
shapiro.test(buc_sol) 
shapiro.test(ars_rep)
shapiro.test(ars_sol)

# T-test: to test null hypothesis that the means of two samples are not significantly different
t_buc <- t.test(buc_rep, buc_sol, var.equal = FALSE) # Welch
t_buc
t_ars <- t.test(ars_rep, ars_sol, var.equal = FALSE) # Welch
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
              mapping = aes(x = factor(`Sample Name`), y = ddCq2))
p_buc2 <- p_buc1 +
  geom_boxplot(outlier.shape = NA) + # remove outlier to prevent overlap with geom_jitter points
  geom_jitter(position = position_jitter(width = 0.3), size = 0.5)
ymax_buc <- ggplot_build(p_buc2)$layout$panel_params[[1]]$y.range[2] # extract ylim max value from ggplot
p_buc3 <- p_buc2 +
  scale_y_continuous(limits = c(0, ymax_buc * 1.2)) +
  geom_signif(y_position = ymax_buc * 1.1, xmin = 1, xmax = 2, 
              tip_length = 0.05, textsize = measurements::conv_unit(8, "point", "mm"),
              annotations = sig_chr(t_buc$p.value))
p_buc4 <- p_buc3 +
  theme_classic(base_family = "Arial", base_line_size = 0.5) +
  labs(x = NULL,
       y = "Relative expression",
       title = "Buchnera") +
  theme(plot.title = element_text(color = "black", size = 7, face = "bold.italic", hjust = 0.5),
        axis.title.y = element_text(color = "black", size = 6),
        axis.text.y = element_text(color = "black", size = 6),
        axis.text.x = element_text(color = "black", size = 6),
        plot.margin = margin(0, 2, 0, 0, unit = "mm"))

p_ars1 <- ggplot(data = dat_ars, 
                 mapping = aes(x = factor(`Sample Name`), y = ddCq2))
p_ars2 <- p_ars1 +
  geom_boxplot(outlier.shape = NA) + # remove outlier to prevent overlap with geom_jitter points
  geom_jitter(position = position_jitter(width = 0.3), size = 0.5)
ymax_ars <- ggplot_build(p_ars2)$layout$panel_params[[1]]$y.range[2] # extract ylim max value from ggplot
p_ars3 <- p_ars2 +
  scale_y_continuous(limits = c(0, ymax_ars * 1.2)) +
  geom_signif(y_position = ymax_ars * 1.1, xmin = 1, xmax = 2, 
              tip_length = 0.05, textsize = measurements::conv_unit(8, "point", "mm"),
              annotations = sig_chr(t_ars$p.value))
p_ars4 <- p_ars3 +
  theme_classic(base_family = "Arial", base_line_size = 0.5) +
  labs(x = NULL,
       y = "Relative expression",
       title = "Arsenophonus") +
  theme(plot.title = element_text(color = "black", size = 7, face = "bold.italic", hjust = 0.5),
        axis.title.y = element_text(color = "black", size = 6),
        axis.text.y = element_text(color = "black", size = 6),
        axis.text.x = element_text(color = "black", size = 6),
        plot.margin = margin(0, 0, 0, 2, unit = "mm"))

out <- ggpubr::ggarrange(p_buc4, p_ars4)

ggsave(filename = "Fig.S1_SymbiontAbundanceCastes.pdf",
       plot = out, device = cairo_pdf,
       width = 85, height = 45, units = "mm", dpi = 500)

