library(meta)
library(metafor)
library(dplyr)

#1. import data
x <- readxl::read_xlsx('data/metaanalysis_data.xlsx')

m <- metagen(TE = SD_boys_play_male,
             seTE = Mean_boys_play_male,
             data=x,
             studlab=paste(Study),
             comb.fixed = TRUE,
             comb.random = FALSE)

#2. plot funnel 
m %>% funnel()

contour_levels <- c(0.90, 0.95, 0.99)
contour_colors <- c("darkblue", "green", "lightblue")
funnel(m, contour = contour_levels, col.contour = contour_colors)
legend("topright", c("p < 0.10", "p < 0.05", "p < 0.01"), bty = "n", fill = contour_colors)

#3. check importance
m %>% forest(sortvar=TE)

#4. Effect of gender
m %>% metareg(`Female authors` + `Male authors`)