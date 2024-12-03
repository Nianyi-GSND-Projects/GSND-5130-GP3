# Preambles ================

library(dplyr)
library(tidyr)
library(ggplot2)

# Preparation ================

data <- read.csv("./formatted-data.csv")

# Accent ================

# Focus only on accent-related features.
accents <- data |> subset(select = c(1, 3:5))
# Show a brief summary of 
accents |>
	group_by(culture) |>
	summarise(
		accentedCount = sum(isAccented == 1, na.rm = TRUE),
		totalCount = n(),
		ratio = accentedCount / totalCount,
		avgPosition = mean(accentPosition[!is.nan(accentPosition)], na.rm = TRUE)
	) |>
	subset(select = c(1, 4, 5))

# Vowel realization ====================

# Focus only on vowel realization features.
realizations <- data |>
	subset(select = c(1, 6:nrow(data))) |>
	group_by(culture) |>
	summarise(across(everything(), sum, na.rm = TRUE))

# Visualize the relation between culture and vowel realization.
realizations |> pivot_longer(
	cols = -culture, # Exclude the 'culture' column
	names_to = "vowel", # New column for vowel names
	values_to = "count"
) |>
	ggplot(aes(x = culture, y = vowel, fill = count)) +
	geom_tile(color = "white") + # Grid lines
	scale_fill_gradient(low = "white", high = "blue") + # Color gradient for counts
	labs(
		title = "Distribution of Vowel Realization by Perceived Culture",
		x = "Perceived culture",
		y = "Vowel realization",
		fill = "Count"
	) +
	theme_minimal() +
	theme(axis.text.x = element_text(angle = 45, hjust = 1))
