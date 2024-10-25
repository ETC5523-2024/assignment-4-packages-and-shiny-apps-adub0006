
# ecoTransit

Explore the ecoTransit package and Shiny app on the [pkgdown site]
( https://etc5523-2024.github.io/assignment-4-packages-and-shiny-apps-adub0006/).

<!-- badges: start -->
![License](https://img.shields.io/github/license/ETC5523-2024/assignment-4-packages-and-shiny-apps-adub0006)
<!-- badges: end -->

The goal of **ecoTransit** is to provide an interactive platform for users to explore and compare the carbon footprints of different transportation modes. The package includes a Shiny app that allows users to visualize the emissions for various modes of transport (e.g., car, bus, train, bicycle) based on the distance traveled. This helps individuals make more environmentally friendly transportation choices.

## Installation


```r
pak::pak("https://github.com/ETC5523-2024/assignment-4-packages-and-shiny-apps-adub0006.git")

```
**Example**

Here’s a basic example showing how to launch the Shiny app:

```r
library(ecoTransit)
# Launch the Shiny app
launch_app()

```

**Features**

- Explore carbon emissions of different transportation modes.
- Input the distance traveled to see corresponding CO2 emissions.
- Interactive Shiny app with user-friendly visualizations.

## License

MIT License © 2024 Avni Dubey






