setwd("C:/Users/86177/Desktop/Git/RRcourse2025/10. MD and Quarto 3")


library(quarto)

for (s in 1:8) {
  quarto::quarto_render(
    input = "Assignment.qmd",
    execute_params = list(season = s),
    output_file = paste0("season_", s, ".html")
  )
}

