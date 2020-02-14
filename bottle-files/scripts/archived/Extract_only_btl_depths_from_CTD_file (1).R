# Extract only the CTD scans corresponding to nisking bottle depths. Uses the closest scan if there is no exact match
# Set the depths of niskin bottle samples
# Create an index of rows that contain scans at the chosen depths
# Subset the data frame using the index for row selection
# Write the output to a .csv file in the working directory

#depths<-c(0,5,10,20,30,40,50,75,150,300,450,500)
#idx<-sapply(depths, function(x) which.min(abs(df$Depth-x)))
#btldata<-df[idx,]
#write.csv(btldata,"btldata.csv",row.names=F)

# For a multicast CTD file, loop the function above
# First read in data

library(readxl)
df<-read_excel("bigdata.xlsx")

# Then produce a unique list of casts, make an empty data frame to temporarily hold each cast's data, and set the niskin depths

casts<-unique(df$Cast_PK)
btl_depths_df<-data.frame()
#depths<-c(0,5,10,20,30,40,50,75,100,150,200,300)

# Now run a loop that subsets each cast's data for just the scans at or nearest to the niskin bottle depths

for(i in 1:length(casts)){
	castdata<-df[df$Cast_PK==casts[i],]
	idx<-sapply(depths, function(x) which.min(abs(castdata$Depth-x)))
	btldata<-castdata[idx,]
	btldata$Depth_match<-depths # This line provides the matched depth for each scan, to allow for merging with bottle data files by target depth
	btl_depths_df<-rbind(btl_depths_df,btldata)	
}

write.csv(btl_depths_df, 'CTD_scans_at_bottle_depths.csv', row.names = F)
