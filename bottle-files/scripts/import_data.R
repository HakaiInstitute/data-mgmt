library(tidyverse)
library(devtools)
library(lubridate)
library(knitr)
library(here)
library(car)
library(hakaiApi)
client <- hakaiApi::Client$new()

# Read in discrete samples from all sites, for all of time
chl_endpoint = sprintf("%s/%s", client$api_root, 
                       'eims/views/output/chlorophyll?limit=-1')
chl_all_cols <- client$get(chl_endpoint) 
write_csv(chl_all_cols, here("raw_data", "cha_all_cols.csv"))

nuts_endpoint = sprintf("%s/%s", client$api_root, 'eims/views/output/nutrients?limit=-1')
nuts_all_cols <- client$get(nuts_endpoint)
write_csv(nuts_all_cols, here("raw_data", "nuts_all_cols.csv"))

poms_endpoint = sprintf("%s/%s", client$api_root, 'eims/views/output/poms?limit=-1') 
poms_all_cols <- client$get(poms_endpoint)
write_csv(poms_all_cols, here("raw_data", "poms_all_cols.csv"))

# Read in CTD from all time
ctd_qu39_endpoint <- sprintf("%s/%s", client$api_root, "ctd/views/file/cast/data?station=QU39&limit=-1")

qu39_ctd <- client$get(ctd_qu39_endpoint) 

qu39_ctd <- qu39_ctd %>%
  mutate(
    year = year(start_dt),
    date = as_date(start_dt),
    day = yday(start_dt))

write_csv(qu39_ctd, here("raw_data", "qu39_ctd.csv"))

# Import DOC data
