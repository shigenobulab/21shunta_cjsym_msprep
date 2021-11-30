# Load library
library(tidyverse)
library(extrafont) # for Arial font
library(scales) # for scale %
library(ggtext) # for markdown

# Load data
dat <- read_csv("Cjap_16S_amplicon.csv")
dat <- as_tibble(dat) # convert dat to tibble format

# Draw 16S amplicon analysis barchart
dat <- dat %>%
  group_by(ID, `Amplified region`) %>%
  mutate(pct = `Symbiont abundance` / sum(`Symbiont abundance`))

f_labs <- c(`V1V2` = "Amplified region: V1-V2",
            `V3V4` = "Amplified region: V3-V4")

out <- ggplot(data = dat,
       mapping = aes(x = factor(ID), y = pct, 
                     fill = factor(Symbiont, levels = c("Others", "Serratia", "Hamiltonella", "Arsenophonus", "Buchnera")))) +
  geom_bar(stat = "identity", position = "fill") +
  scale_fill_brewer(palette = "Set1", direction = -1,
                    labels = c("Others", "*Serratia*", "*Hamiltonella*", "*Arsenophonus*", "*Buchnera*")) +
  facet_wrap(~ `Amplified region`, ncol = 2, labeller = as_labeller(f_labs)) +
  scale_x_discrete(limits = rev) +
  scale_y_continuous(labels = scales::percent, expand = c(0, 0), limits = c(0, 1)) + # truncate space from plot
  labs(x = NULL, y = "Relative abundance",
       fill = "") +
  guides(fill = guide_legend(reverse = TRUE)) +
  theme_minimal(base_family = "Arial", base_line_size = 0.5) +
  theme(legend.position = "bottom",
        legend.key.size = unit(8, "points"),
        legend.text = element_markdown(size = 8),
        strip.text = element_text(size = 8, face = "bold"),
        axis.title.x = element_text(size = 8),
        axis.text.x = element_text(size = 6),
        axis.text.y = element_text(size = 6),
        panel.spacing.x = unit(20, "points"), # separate two plots
        plot.margin = margin(0, 5, 0, 5, unit = "mm")) + # make margin for whole plot
  coord_flip()

ggsave(filename = "AmpliconBarPlot_Cjaponica.pdf",
       plot = p, device = cairo_pdf,
       width = 174, height = 85, units = "mm", dpi = 600)