#' Launch the Shiny App
#'
#' This function launches the Shiny app for exploring transport emissions.
#' @export
run_app <- function() {
  # Get the path to the shiny app directory inside the package
  app_dir <- system.file("shiny_app", package = "ecoTransit")
  if (app_dir == "") {
    stop("Could not find shiny_app directory. Try re-installing `ecoTransit`.", call. = FALSE)
  }

  # Load the data from the package (assuming data is saved as cleaned_data.rda in the data folder)
  data("cleaned_data", package = "ecoTransit")

  # Launch the Shiny app from the app directory
  shiny::runApp(app_dir, display.mode = "normal")
}
