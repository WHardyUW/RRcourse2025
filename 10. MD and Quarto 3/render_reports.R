library(latexpdf)

for (i in 1:8) {
  data_path <- paste0("../Data/season_", i, ".RData")
  
  quarto_render("My_assignment.qmd",
                execute_params = list(
                  season_no = i,
                  data_file = data_path
                ),
                output_file = paste0("got_season_", i, ".pdf")
  )
}

