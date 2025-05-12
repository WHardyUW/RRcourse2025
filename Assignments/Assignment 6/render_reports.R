library(quarto)

for (s in 1:8) {
  quarto_render("Assignment.qmd",
                execute_params = list(season = s),
                output_file = paste0("Season_", s, ".pdf"))
}
