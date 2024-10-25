library(shiny)
library(ggplot2)
library(dplyr)
library(DT)
library(bslib)  # For Bootstrap theming

# Load the cleaned data from the package
data("cleaned_data", package = "ecoTransit")

# Rename the column for easier reference
cleaned_data <- cleaned_data %>%
  rename(emissions_per_km = `transport emissions per kilometer travelled`)

# Define the UI
ui <- fluidPage(
  theme = bs_theme(version = 4, bootswatch = "lux"),  # Apply Lux theme

  # Add custom CSS
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")  # Assuming you create style.css in www folder
  ),

  titlePanel("Transport Emissions Explorer"),

  sidebarLayout(
    sidebarPanel(
      helpText("Use the slider below to filter transport modes by their emissions (gCO2/km)."),
      helpText("You can reset the filters using the 'Reset Filters' button."),

      # Select input for transport mode
      selectInput("transport_entity",
                  label = "Select Transport Mode",
                  choices = unique(cleaned_data$entity),
                  selected = "Bus (average)"),

      # Slider input for emission range
      sliderInput("emission_range",
                  label = "Filter by Emissions (gCO2/km)",
                  min = min(cleaned_data$emissions_per_km, na.rm = TRUE),
                  max = max(cleaned_data$emissions_per_km, na.rm = TRUE),
                  value = c(min(cleaned_data$emissions_per_km, na.rm = TRUE),
                            max(cleaned_data$emissions_per_km, na.rm = TRUE))),

      # Reset filters button
      actionButton("reset", "Reset Filters"),

      # Description of outputs
      helpText("The plot shows emissions per kilometer for the selected transport mode."),
      helpText("The data table displays the raw data filtered by the emissions range.")
    ),

    # Main panel with plot and data table
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", plotOutput("emissionPlot")),
        tabPanel("Data Table", DTOutput("dataTable"))
      )
    )
  )
)

# Define the server logic
server <- function(input, output, session) {

  # Reactive filtered data based on input selections
  filtered_data <- reactive({
    cleaned_data %>%
      filter(entity == input$transport_entity,  # Filter by transport mode
             emissions_per_km >= input$emission_range[1],  # Filter by emission range
             emissions_per_km <= input$emission_range[2])
  })

  # Render the plot
  output$emissionPlot <- renderPlot({
    data <- filtered_data()

    if (nrow(data) == 0) {
      plot(1, type = "n", ann = FALSE)
      text(1, 1, "No data available for the selected filters", cex = 1.5)
    } else {
      ggplot(data, aes(x = entity, y = emissions_per_km, fill = entity)) +
        geom_bar(stat = "identity") +
        theme_minimal() +
        labs(x = "Transport Mode", y = "Emissions (gCO2/km)",
             title = "Emissions per Kilometer for Selected Transport Mode") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    }
  })

  # Render the data table
  output$dataTable <- renderDT({
    datatable(filtered_data(), options = list(pageLength = 5))
  })

  # Reset filters when the button is clicked
  observeEvent(input$reset, {
    updateSelectInput(session, "transport_entity", selected = "Bus (average)")
    updateSliderInput(session, "emission_range",
                      value = c(min(cleaned_data$emissions_per_km, na.rm = TRUE),
                                max(cleaned_data$emissions_per_km, na.rm = TRUE)))
  })
}

# Run the app
shinyApp(ui = ui, server = server)
