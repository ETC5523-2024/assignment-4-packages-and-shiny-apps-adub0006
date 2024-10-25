#' Transport Emissions Data
#'
#' This dataset contains information about carbon emissions per kilometer for various transport modes.
#'
#' @format A data frame with 4 variables:
#' \describe{
#'   \item{entity}{Transport mode (e.g., Bus, Diesel Car, etc.)}
#'   \item{code}{An optional code column}
#'   \item{year}{The year the data was collected}
#'   \item{emissions_per_km}{Emissions per kilometer, measured in gCO2/km}
#' }
#' @source Compiled from Assignment Data
#' @export
"cleaned_data"
