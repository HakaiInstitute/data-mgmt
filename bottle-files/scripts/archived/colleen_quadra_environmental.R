setwd("/Volumes/GoogleDrive/My\ Drive/Quadra_Microbial/seq_analysis")

hakai_chl<-read.csv("2019-10-09_HakaiData_chlorophyll_edit.csv",header=TRUE)
hakai_nuts<-read.csv("2019-10-09_HakaiData_nutrients_edit.csv",header=TRUE)
hakai_poms<-read.csv("2019-10-09_HakaiData_poms_edit.csv",header=TRUE)
hakai_ctd<-read.csv("qu39_qu24_qmic_ctd.csv", header=TRUE)


hakai_chl1 <- subset(hakai_chl, hakai_chl$site_id == "QU24" | hakai_chl$site_id == "QU39")

hakai_chl_mic <- subset(hakai_chl1, hakai_chl1$filter_type == "Bulk GF/F") 
hakai_chl_mic <- subset(hakai_chl_mic, hakai_chl_mic$line_out_depth != 20)
hakai_chl_mic <- subset(hakai_chl_mic, hakai_chl_mic$line_out_depth != 50)
hakai_chl_mic <- subset(hakai_chl_mic, hakai_chl_mic$line_out_depth != 10)

hakai_chl_mic$line_out_depth[hakai_chl_mic$line_out_depth %in% c(240, 260, 265)] <- 265



hakai_nuts1 <- subset(hakai_nuts, hakai_nuts$site_id != "QU5" )

hakai_nuts_mic <- subset(hakai_nuts1, hakai_nuts1$line_out_depth == "0" | hakai_nuts1$line_out_depth == "5" | hakai_nuts1$line_out_depth == "30" | hakai_nuts1$line_out_depth == "100" | hakai_nuts1$line_out_depth == "240" | hakai_nuts1$line_out_depth == "250" | hakai_nuts1$line_out_depth == "260" | hakai_nuts1$line_out_depth == "265")

hakai_nuts_mic$line_out_depth[hakai_nuts_mic$line_out_depth %in% c(240, 250, 260, 265)] <- 265


unique(hakai_nuts_mic$line_out_depth)
dim(hakai_nuts_mic)

hakai_ctd$Depth[hakai_ctd$Depth %in% c(240, 260, 264, 265)] <- 265

chl <- tbl_df(hakai_chl_mic)
nuts <- tbl_df(hakai_nuts_mic)
ctd <- tbl_df(hakai_ctd)

#rename some columns
chl <- chl %>% rename(Date = date) 
chl <- chl %>% rename(Depth = line_out_depth)

nuts <- nuts %>% rename(Date = date) 
nuts <- nuts %>% rename(Depth = line_out_depth)

ctd <- ctd %>% rename(site_id = Station)

chl$Date <- as.Date(chl$Date, format="%Y-%m-%d")
nuts$Date <- as.Date(nuts$Date, format="%Y-%m-%d")
ctd$Date <- as.Date(ctd$Date, format="%Y-%m-%d")

nuts$n_to_p <- (nuts$no2_no3_um / nuts$po4)


#### join in to a bit env data file for comparison with microbial data

chl$Depth<-as.numeric(as.character(chl$Depth))
nuts_chl <- nuts %>% full_join(chl, by=c("site_id","Date","Depth"))
nuts_chl$Depth<-as.numeric(as.character(nuts_chl$Depth))

nuts_chl_simple = nuts_chl %>%
  select(
    site_id,
    Date,
    Depth,
    chla_final,
    phaeo_final,
    no2_no3_um,
    po4,
    sio2,
    n_to_p
  ) 

env_all<-ctd %>% full_join(nuts_chl_simple, by=c("site_id","Date","Depth"))

env = env_all %>%
  select(
    SampleID,
    site_id,
    Date,
    Depth,
    Year,
    Month,
    Day,
    temperature,
    salinity,
    dissolved_oxygen_ml_l,
    chla_final,
    phaeo_final,
    no2_no3_um,
    po4,
    sio2,
    n_to_p
  ) 


#write.csv(env, "qmic_env.csv")


# Fix month levels in sample_data
env$Depth <- factor(
  env$Depth, 
  levels = c("0", "5", "30", "100", "265")
)

env$Date <- as.Date(env$Date, format="%Y-%m-%d")

ggplot(env, aes(y=chla_final,x=Date)) + 
  geom_area(fill="grey", stat = "summary", fun.y = "mean") + 
  facet_grid(Depth ~ .) 
  
  
ggplot(env, aes(y=chla_final,x=Date)) +  
  geom_line() + 
  geom_point(stat = "summary", fun.y = "mean") + #figure out how to remove error bar for the samples that had reps
  facet_grid(Depth ~ .) + 
  #geom_area(fill=alpha('slateblue',0.2)) +
  scale_x_date(date_labels = "%m-%Y", date_breaks="2 month") +
  theme(axis.text.x=element_text(angle=60, hjust=1))


##### nutrients ####


ggplot(env, aes(y=no2_no3_um,x=Date)) +  
  geom_line() + 
  geom_point() +
  facet_grid(Depth ~ .) + 
  #geom_area(fill=alpha('slateblue',0.2)) +
  scale_x_date(date_labels = "%m-%Y", date_breaks="1 month") +
  theme(axis.text.x=element_text(angle=60, hjust=1))

ggplot(env, aes(y=sio2,x=Date)) +  
  geom_line() + 
  geom_point() +
  facet_grid(Depth ~ .) + 
  #geom_area(fill=alpha('slateblue',0.2)) +
  scale_x_date(date_labels = "%m-%Y", date_breaks="1 month") +
  theme(axis.text.x=element_text(angle=60, hjust=1))

ggplot(env, aes(y=po4,x=Date)) +  
  geom_line() + 
  geom_point() +
  facet_grid(Depth ~ .) + 
  #geom_area(fill=alpha('slateblue',0.2)) +
  scale_x_date(date_labels = "%m-%Y", date_breaks="1 month") +
  theme(axis.text.x=element_text(angle=60, hjust=1))

ggplot(env, aes(y=n_to_p, x=Date)) +  
  geom_line() + 
  geom_point() +
  facet_grid(Depth ~ .) + 
  #geom_area(fill=alpha('slateblue',0.2)) +
  scale_x_date(date_labels = "%m-%Y", date_breaks="1 month") +
  theme(axis.text.x=element_text(angle=60, hjust=1))

#### CTD ####
ggplot(env, aes(y=dissolved_oxygen_ml_l,x=Date)) +  
  geom_line() + 
  geom_point() +
  facet_grid(Depth ~ .) + 
  #geom_area(fill=alpha('slateblue',0.2)) +
  scale_x_date(date_labels = "%m-%Y", date_breaks="1 month") +
  theme(axis.text.x=element_text(angle=60, hjust=1))

ggsave("DO.pdf", plot = last_plot(), width = 10, height = 10, units = "in", device = cairo_pdf)


ggplot(env, aes(y=temperature,x=Date)) +  
  geom_line() + 
  geom_point() +
  facet_grid(Depth ~ .) + 
  #geom_area(fill=alpha('slateblue',0.2)) +
  scale_x_date(date_labels = "%m-%Y", date_breaks="1 month") +
  theme(axis.text.x=element_text(angle=60, hjust=1))

ggsave("temperature.pdf", plot = last_plot(), width = 10, height = 10, units = "in", device = cairo_pdf)

ggplot(env, aes(y=temperature,x=Date)) +  
  geom_line() + facet_grid(Depth~.)

Week = week(env$Date)
env<-cbind(env, Week)
  

 
#remove 2015 and 2019 dates for a clean plot

env1518<-env %>%
  filter(Date > "2015-01-01" & Date < "2019-01-01")

ggplot(env1518, aes(y=temperature,x=Date, color = Depth)) +  
  geom_point() + 
  geom_line()


ggplot(env1518, aes(y=sio2,x=Date, color = Depth)) + 
  geom_point(alpha = 0.3) + 
  #geom_line() + 
  geom_smooth(span = 0.1) + 
  facet_grid(Depth~.)


ggplot(env1518, aes(y=no2_no3_um,x=Date, color = Depth)) + 
  geom_point(alpha = 0.3) + 
  #geom_line() + 
  geom_smooth(span = 0.1) + 
  facet_grid(Depth~.)

ggplot(env1518, aes(y=po4,x=Date, color = Depth)) + 
  geom_point(alpha = 0.3) + 
  #geom_line() + 
  geom_smooth(span = 0.1) + 
  facet_grid(Depth~.)

ggplot(env1518, aes(y=chla_final,x=Date, color = Depth)) + 
  geom_point(alpha = 0.3) + 
  #geom_line() + 
  geom_smooth(span = 0.1) + 
  facet_grid(Depth~.)

ggplot(env1518, aes(y=salinity,x=Date, color = Depth)) + 
  geom_point(alpha = 0.3) + 
  geom_line() + 
  #geom_smooth(span = 0.1) + 
  facet_grid(Depth~.)


ggplot(data = df, aes(x = x, group = 1)) + 
  geom_line(aes(y = y1, colour = "y1")) + 
  geom_line(aes(y = y2, colour = "y2")) +     
  scale_colour_manual("", breaks = c("y1", "y2"), values = c("blue", "red")) +
  geom_smooth(aes(y = y1, ymin = y1_lwr, ymax = y1_upr, colour = "y1"), 
              stat="identity", fill="blue", alpha=0.2) + 
  geom_smooth(aes(y = y2, ymin = y2_lwr, ymax = y2_upr, colour = "y2"), 
              stat="identity", fill="red", alpha=0.2)


### POMS ####
hakai_poms1 <- subset(hakai_poms, hakai_poms$site_id == "QU24" | hakai_poms$site_id == "QU39")

hakai_poms_mic <- subset(hakai_poms1, hakai_poms1$acidified == "TRUE") 
hakai_poms_mic <- subset(hakai_poms_mic, hakai_poms_mic$line_out_depth != 10)

unique(hakai_poms_mic$line_out_depth)

hakai_poms_mic$line_out_depth[hakai_poms_mic$line_out_depth %in% c(240, 260, 265)] <- 265

poms <- tbl_df(hakai_poms_mic)

#rename some columns
poms <- poms %>% rename(Date = date) 
poms <- poms %>% rename(Depth = line_out_depth)
poms$Date <- as.Date(poms$Date, format="%Y-%m-%d")


ggplot(poms, aes(y=ug_c,x=Date)) +  
  geom_line() + 
  geom_point() +
  facet_grid(Depth ~ .) + 
  #geom_area(fill=alpha('slateblue',0.2)) +
  scale_x_date(date_labels = "%m-%Y", date_breaks="1 month") +
  theme(axis.text.x=element_text(angle=60, hjust=1))

poms$c_n <- (poms$ug_c / poms$ug_n)

env_pca_df<-env[,8:16]
env_df<-as.data.frame(env_pca_df)


env_uni<-distinct(env)
env_only<-env_uni[,8:16]
row.names(env_only) <- env_uni$SampleID

dim(env)
df_pca <- prcomp(env[,8:16], na.omit)



