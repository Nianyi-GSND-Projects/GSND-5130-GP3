setwd(dirname(rstudioapi::getSourceEditorContext()$path));

# Preambles ================

library(dplyr)
library(tidyr)
library(ggplot2)

# Preparation ================

accent <- read.csv("./accent.csv")
vowel <- read.csv("./vowel.csv")
consonant <- read.csv("./consonant.csv")

# Plot ========

consonant[, -1] |>
	as.matrix() |>
	heatmap(, Colv = NA, Rowv = NA, labRow = consonant$culture)

vowel[, -1] |>
	as.matrix() |>
	heatmap(, Colv = NA, Rowv = NA, labRow = vowel$culture)
