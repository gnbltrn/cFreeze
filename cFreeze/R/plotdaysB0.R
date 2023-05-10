# Generated from create-cFreeze.Rmd: do not edit by hand

#' Plot Percent Days Below 0C 
#' 
#' Takes GPS coordinates, extracts last 30 years weather data from Iowa Environmental Mesonet (IEM) and returns a plot with the percent of days with minimum temperatures below 0C. Note Google maps provides lat, long in that order.  For this package you need to enter long, lat in that order. You must have packages apsimx and tidyverse installed.  
#'
#' @param lon GPS longitude
#' @param lat GPS latitude 
#' @export 
##Function 1. Plot pct days below 0C 
plotdaysB0 <- function(lon, lat) {

  library(apsimx)
  library(ggplot2)
  library(lubridate)
  library(tidyverse)
  
##Downloading and Saving whether data from IEM
##Read 30 years IEM weather data
cFreezedata <- get_iem_apsim_met(lonlat = c(lon, lat), 
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

##Ploting
plotB0 <- ggplot(pctdfmdmd)+
  geom_line(aes(x = date, y = pct)) +
  scale_x_date(date_labels = "%b-%d", 
               date_breaks = "2 month")

return(plotB0)
}




#' Last Day To Harvest With No Historical Freeze
#' 
#' Returns the last day to harvest with no history of freezing temperatures, based on GPS coordinates the and last 30 years weather data from Iowa Environmental Mesonet (IEM). Note Google maps provides lat, long in that order. For this package you need to enter long, lat in that order. You must have packages apsimx and tidyverse installed.
#' 
#' @param lon GPS longitude
#' @param lat GPS latitude 
#' @export
##Function 2. Find the last day to harvest with no Freeze
nofreeze <- function(lon, lat) {

##load libraries    
library(apsimx)
library(ggplot2)
library(lubridate)
library(tidyverse)

##Downloading and Saving whether data from IEM
##Read 30 years IEM weather data
cFreezedata <- get_iem_apsim_met(lonlat = c(lon, lat), 
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
  
##Find the last day to harvest
pctnon0 <- pctdfmdmd %>%
  filter(month > 6) %>%
  filter(pct > 0)
  
return(pctnon0[1,5])
  
}
  

#' Last Day To Harvest With 10pct Historical Freeze
#' 
#' Returns the last day to harvest with 10pct history of freezing temperatures, based on GPS coordinates the and last 30 years weather data from Iowa Environmental Mesonet (IEM). Note Google maps provides lat, long in that order. For this package you need to enter long, lat in that order. You must have packages apsimx and tidyverse installed.
#' 
#' @param lon GPS longitude
#' @param lat GPS latitude 
#' @export

##Function 3. Find the last day to harvest with 10pct chance Freeze
freeze10 <- function(lon, lat) {
  
  ##load libraries    
  library(apsimx)
  library(ggplot2)
  library(lubridate)
  library(tidyverse)
  
  ##Downloading and Saving whether data from IEM
  ##Read 30 years IEM weather data
  cFreezedata <- get_iem_apsim_met(lonlat = c(lon, lat), 
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
  
  ##Find the last day to harvest
  pct10 <- pctdfmdmd %>%
    filter(month > 6) %>%
    filter(pct > 10)
  
  return(pct10[1,5])
  
}


#' Last Day To Harvest With 20pct Historical Freeze
#' 
#' Returns the last day to harvest with 20pct history of freezing temperatures, based on GPS coordinates the and last 30 years weather data from Iowa Environmental Mesonet (IEM). Note Google maps provides lat, long in that order. For this package you need to enter long, lat in that order. You must have packages apsimx and tidyverse installed.
#' 
#' @param lon GPS longitude
#' @param lat GPS latitude 
#' @export
##Function 4. Find the last day to harvest with 20pct chance Freeze
freeze20 <- function(lon, lat) {
  
  ##load libraries    
  library(apsimx)
  library(ggplot2)
  library(lubridate)
  library(tidyverse)
  
  ##Downloading and Saving whether data from IEM
  ##Read 30 years IEM weather data
  cFreezedata <- get_iem_apsim_met(lonlat = c(lon, lat), 
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
  
  ##Find the last day to harvest
  pct20 <- pctdfmdmd %>%
    filter(month > 6) %>%
    filter(pct > 20)
  
  return(pct20[1,5])
  
}


#' Find the Percent Historical Freeze For Any Given Month and Day
#' 
#' Returns the percent of days with freezing temperatures in the last years, based on GPS coordinates and weather data from Iowa Environmental Mesonet (IEM). Note Google maps provides lat, long in that order. For this package you need to enter long, lat in that order. You must have packages apsimx and tidyverse installed.
#' 
#' @param lon GPS longitude
#' @param lat GPS latitude
#' @param Month numeric values 1:12
#' @param Mday numeric values 1:31 for a given month, excluding Feb-29
#'   
#' @export
##Function 5. Find the pct freeze for any date in Month-Day format
freeze <- function(lon, lat, Month, Mday) {
  
  ##load libraries    
  library(apsimx)
  library(ggplot2)
  library(lubridate)
  library(tidyverse)
  
  ##Downloading and Saving whether data from IEM
  ##Read 30 years IEM weather data
  cFreezedata <- get_iem_apsim_met(lonlat = c(lon, lat), 
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
  
  ##Find the last day to harvest
  pctany <- pctdfmdmd %>%
    filter(month == Month) %>%
    filter(mday == Mday)

  return(pctany$pct)
}


