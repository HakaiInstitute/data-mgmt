library(tidyverse)
library(devtools)
library(lubridate)
library(knitr)
library(here)
library(car)

f <- function(x) {
  format(x + as.Date("2014-01-01") -1, format = "%B %d")
}

devtools::install_github("HakaiInstitute/hakai-api-client-r", subdir='hakaiApi', force = TRUE)

library('hakaiApi')

# Get the api request client, run this line independently before the rest of the code
client <- hakaiApi::Client$new() # Follow stdout prompts to get an API token

# Make a data request for chlorophyll data
qu39_chl_endpoint = sprintf("%s/%s", client$api_root, 
                            'eims/views/output/chlorophyll?date>=2014-01-01&date<2019-08-02&work_area%26%26{"QUADRA"}%26site_id%26%26{"QU39"}')

qu5_chl_endpoint = sprintf("%s/%s", client$api_root,
                           'eims/views/output/chlorophyll?date>=2014-01-01&date<2014-08-02&work_area%26%26{"QUADRA"}%26site_id%26%26{"QU5"}')

qu24_chl_endpoint = sprintf("%s/%s", client$api_root,
                            'eims/views/output/chlorophyll?date>=2014-08-01&date<2015-03-19&work_area%26%26{"QUADRA"}%26site_id%26%26{"QU24"}')


qu39_chl_data <- client$get(qu39_chl_endpoint)

qu5_chl_data <- client$get(qu5_chl_endpoint)

qu24_chl_data <- client$get(qu24_chl_endpoint)

# Print out the data
# print(data)

# concatenate data

# Make a data request for nutrient data
qu39_nuts_endpoint = sprintf("%s/%s", client$api_root, 'eims/views/output/nutrients?date>=2014-01-01&date<2019-08-02&work_area%26%26{"QUADRA"}%26site_id%26%26{"QU39"}')

qu5_nuts_endpoint = sprintf("%s/%s", client$api_root, 'eims/views/output/nutrients?date>=2014-01-01&date<2014-08-02&work_area%26%26{"QUADRA"}%26site_id%26%26{"QU5"}')

qu24_nuts_endpoint = sprintf("%s/%s", client$api_root, 'eims/views/output/nutrients?date>=2014-08-01&date<2015-03-19&work_area%26%26{"QUADRA"}%26site_id%26%26{"QU24"}')

qu39_nuts_data <- client$get(qu39_nuts_endpoint)

qu5_nuts_data <- client$get(qu5_nuts_endpoint)

qu24_nuts_data <- client$get(qu24_nuts_endpoint)

# Make a data request for CTD data
qu24_endpoint <-
  sprintf("%s/%s",
          client$api_root,
          "ctd/views/file/cast/data?station=QU24&limit=-1")


qu24 <- client$get(qu24_endpoint) %>%
  mutate(
    year = year(start_dt),
    date = as_date(start_dt),
    yday = yday(start_dt),
    week = week(start_dt)
  )

qu24_ctd = qu24 %>%
  select(
    year,
    date,
    week,
    yday,
    station,
    cast_number,
    conductivity,
    temperature,
    depth,
    salinity,
    dissolved_oxygen_ml_l,
    rinko_do_ml_l,
    par,
    flc,
    ctd_cast_pk,
    pressure
  ) 

#Code from Alex to pull out discrete depths from CTD data. 

casts<-unique(qu24_ctd$ctd_cast_pk)
btl_depths_df<-data.frame()
depths<-c(0,5,30,100,240)

for(i in 1:length(casts)){
  castdata<-qu24_ctd[qu24_ctd$ctd_cast_pk==casts[i],]
  idx<-sapply(depths, function(x) which.min(abs(castdata$depth-x)))
  btldata<-castdata[idx,]
  btldata$Depth_match<-depths # This line provides the matched depth for each scan, to allow for merging with bottle data files by target depth
  btl_depths_df<-rbind(btl_depths_df,btldata)	
}

write.csv(btl_depths_df, "qu24_ctd.csv")

