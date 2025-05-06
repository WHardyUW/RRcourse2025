#install.packages("tinytex")
#tinytex::install_tinytex()

library(quarto)
setwd("C:/Users/Wercia/OneDrive/Desktop/2025/RR/RR_git3/RRCourse2025/10. MD and Quarto 3")


for (s in 1:8) {
  quarto::quarto_render(
    input = "Assignment.qmd",
    output_format = "pdf",
    output_file = paste0("Season_", s, "_report.pdf"),
    execute_params = list(season = s)
  )
}

