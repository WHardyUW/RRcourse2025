library(quarto)

for (s in 1:8) {
  quarto_render(
    input = "Assignment (1).qmd",
    execute_params = list(season = s),
    output_file = paste0("Season_", s, ".pdf")
  )
}
setwd("~/Desktop/Quatro 3")
source("render_all_seasons.R")
