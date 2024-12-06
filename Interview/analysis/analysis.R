setwd(dirname(rstudioapi::getSourceEditorContext()$path));

# Preambles ================

library(dplyr)
library(tidyr)
library(ggplot2)

# Preparation ================

accent <- read.csv("./accent.csv")
vowel <- read.csv("./vowel.csv")
consonant <- read.csv("./consonant.csv")
