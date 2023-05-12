library(shiny)
library(ggplot2)
library(apsimx)
library(tidyverse)

ui <- fluidPage(
titlePanel("cFreeze Package Demo"),
    numericInput("lon", label = h3("Longitude"), value = -118.000),
    numericInput("lat", label = h3("Latitude"), value = 43.000),
    submitButton("Submit"),
  
plotOutput(outputId = "value", height = "400") 
)

server <- function(input, output) {
  
  #create data frames
  cFreezedata <- data.frame()
  pctcal <- data.frame()
  pctdf <- data.frame()
  pctdfmd <- data.frame()
  pctdfmdmd <- data.frame()
  pct <- NULL
  date <- NULL
  
  observeEvent(input$submit_button, {
    
    ##Downloading and Saving whether data from IEM
    ##Read 30 years IEM weather data
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
  })
    output$value <- renderPlot({ 
      ggplot(pctdfmdmd) +
        geom_line(aes(x = date, y = pct)) 
      })
}

shinyApp(ui, server)
