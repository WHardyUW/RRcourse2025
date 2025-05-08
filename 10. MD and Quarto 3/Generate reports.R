library(quarto)

for(season in 1:8) {
  quarto_render(
    input          = "Assignment.qmd",
    execute_params = list(season = season),
    output_file    = paste0("Assignment_season_", season, ".pdf")
  )
}

