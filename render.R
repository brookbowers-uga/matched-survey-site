Sys.setenv(RSTUDIO_PANDOC="E:\\Program Files\\RStudio\\bin\\pandoc")
renderReport <- function(fileName,params) {
  rmarkdown::render("New.Rmd", output_file=fileName,params = params)
}
