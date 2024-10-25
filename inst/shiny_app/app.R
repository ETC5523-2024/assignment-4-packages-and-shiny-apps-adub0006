library(shiny)
library(ggplot2)
library(dplyr)
library(DT)
library(plotly)
library(bslib)

# Load the cleaned data from your package
data("cleaned_data", package = "ecoTransit")
cleaned_data <- cleaned_data %>% rename(emissions_per_km = `transport emissions per kilometer travelled`)

# Define UI
ui <- fluidPage(
  theme = bs_theme(version = 4, bootswatch = "cosmo"),  # Custom theme
  titlePanel("Transport Emissions Explorer"),

  sidebarLayout(
    sidebarPanel(
      selectInput("transport_entity",
                  label = "Select Transport Mode",
                  choices = unique(cleaned_data$entity),
                  selected = "Bus (average)"),
      sliderInput("emission_range",
                  label = "Filter by Emissions (gCO2/km)",
                  min = min(cleaned_data$emissions_per_km, na.rm = TRUE),
                  max = max(cleaned_data$emissions_per_km, na.rm = TRUE),
                  value = c(min(cleaned_data$emissions_per_km, na.rm = TRUE),
                            max(cleaned_data$emissions_per_km, na.rm = TRUE))),
      actionButton("reset", "Reset Filters"),
      HTML("<p><strong>Entity:</strong> The type of transport mode (e.g., bus, car).</p>"),
      HTML("<p><strong>Emissions per kilometer:</strong> The amount of carbon dioxide emitted per kilometer (gCO2/km).</p>")
    ),

    mainPanel(
      tabsetPanel(
        tabPanel("Plot", plotlyOutput("emissionPlot")),
        tabPanel("Data Table", DTOutput("dataTable"))
      ),
      HTML("<p>The plot shows the amount of emissions (gCO2/km) for the selected transport mode.
           Use the slider to filter emissions and the dropdown to change the transport mode.
           The Data Table tab shows the underlying data.</p>")
    )
  )
)

# Define server
server <- function(input, output, session) {

  filtered_data <- reactive({
    cleaned_data %>%
      filter(entity == input$transport_entity,
             emissions_per_km >= input$emission_range[1],
             emissions_per_km <= input$emission_range[2])
  })

  output$emissionPlot <- renderPlotly({
    data <- filtered_data()
    if (nrow(data) == 0) {
      plot_ly() %>% layout(title = "No data available for the selected filters")
    } else {
      plot_ly(data, x = ~entity, y = ~emissions_per_km, type = 'bar', color = ~entity)
    }
  })

  output$dataTable <- renderDT({
    datatable(filtered_data())
  })

  observeEvent(input$reset, {
    updateSelectInput(session, "transport_entity", selected = "Bus (average)")
    updateSliderInput(session, "emission_range", value = c(min(cleaned_data$emissions_per_km), max(cleaned_data$emissions_per_km)))
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)
