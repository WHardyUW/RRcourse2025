# Load the 'quarto' package to render .qmd documents
library(quarto)


# Set working directory to the folder with Assignment.qmd
setwd("D:/GitProjects/RR25/RRcourse2025/10. MD and Quarto 3")

# Loop through all 8 seasons
for (season in 1:8) {
  # Render to PDF
  quarto_render(
    input = "Assignment.qmd",
    execute_params = list(season = season),
    output_format = "pdf",
    output_file = paste0("Season_", season, "_Report.pdf")
  )
  
  # Render to HTML
  quarto_render(
    input = "Assignment.qmd",
    execute_params = list(season = season),
    output_format = "html",
    output_file = paste0("Season_", season, ".html")
  )
}

