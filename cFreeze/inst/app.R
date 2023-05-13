library(shiny)
library(ggplot2)
library(apsimx)
library(tidyverse)


ui <- fluidPage(
  titlePanel("cFreeze Package Demo"),
  numericInput("lon", label = h3("Longitude"), value = -118.000),
  numericInput("lat", label = h3("Latitude"), value = 43.000),
  
  br(),
  actionButton("submit_button", "Submit"),
  br(),
  actionButton("clear_button", "Clear"),
  
  plotOutput(outputId = "plot", height = "400") 
)

server <- function(input, output) {
  
  #create reactive values
  pctdfmdmd <- data.frame()
  pct <- reactiveValues()
  date <- reactiveValues()

  #Runs when submit bottom is pressed
  observeEvent(input$submit_button, {
    
    ##Downloading and Saving whether data from IEM
    ##Read 30 years IEM weather data
    cFreezedata <- get_iem_apsim_met(lonlat = c(input$lon, input$lat), 
                                     dates = c("1993-01-01", "2022-12-31"))
    
    x <- NULL
    pct <- NULL
    day <- cFreezedata$day
    
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
  observeEvent(input$clear_button, {
   date  <- pctdfmdmd$date
  })
  observeEvent(input$clear_button, {
    pct <- pctdfmdmd$pct 
  })
  
  
#Render the plot
  output$plot <- renderPlot({ 
    pct <- pctdfmdmd$pct 
    date  <- pctdfmdmd$date
    
    ggplot(pctdfmdmd) +
      geom_line(aes(x = date, y = pct)) 
  })
}

shinyApp(ui, server)