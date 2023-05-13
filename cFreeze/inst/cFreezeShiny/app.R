library(shiny)
library(ggplot2)
library(apsimx)
library(tidyverse)


ui <- fluidPage(
  titlePanel("cFreeze Package Demo (it takes a moment to load!)"),
  sidebarPanel(
    numericInput("lon", label = h3("Longitude (from -71 to -124)"), value = -118),
    numericInput("lat", label = h3("Latitude (from 40 to 48"), value = 43),
    
  ),
  mainPanel(
    plotOutput(outputId = "plot")
    
  ),
  
  fillPage = TRUE # fill the whole screen with the app
)

server <- function(input, output, session) {
  
  #Render the plot
  output$plot <- renderPlot({ 
    
    
    #   observeEvent(input$submit_button, {
    ##Get weather data from IEM
    cFreezedata <- get_iem_apsim_met(lonlat = c(input$lon, input$lat), 
                                     dates = c("1993-01-01", "2022-12-31"))
    
    ##Calculate percent days with freeze (below 0C)
    pctcal <- lapply(split(cFreezedata, cFreezedata$day), function(x){
      data.frame(day = x$day[1], pct = 100 * length(x$mint[x$mint <= 0])/length(x$mint))
    })
    
    ##Apply rbind to create a single data frame from the list above
    pctdf <- do.call(rbind, pctcal)
    
    ##Add date, month and mday
    pctdfmd <- pctdf %>% 
      mutate(date = doy2date(day)) %>%
      mutate(month = month(date)) %>%
      mutate(mday = day(date))
    
    ##Add month-day format character
    pctdfmdmd <- pctdfmd %>%
      mutate(monthabb = month.abb[pctdfmd$month]) %>%
      unite(monthday, monthabb, mday, remove = FALSE, sep = "-") %>%
      filter(day != 366)
    
    ggplot(pctdfmdmd)+
      geom_line(aes(x = date, y = pct)) +
      scale_x_date(date_labels = "%b-%d", 
                   date_breaks = "2 month") +
      labs(title = "Percent days in 30 years with temps below 0C")
  })
  #  })
}

shinyApp(ui, server)