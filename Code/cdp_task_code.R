######################################################
######   CDP TECHNICAL TASK - ISABELLA MORGANTE ######
######################################################

# Set working directory
setwd("~/Documents/CDP_Task/Code/")
rm(list=ls(all=TRUE))
graphics.off()

# Packages
require(ggplot2)
require(dplyr)

# Load data 
cdp_data <- read.csv(file = "../Data/Electricity generation by source - top 5.csv", header = TRUE)

# Explore data 
head(cdp_data) #first few rows
str(cdp_data) #structure

# add info about dealing with NAs and checking consistent units
## Check similarities in text etc. -- cleaning for typos blah blah 

# Change column name to avoid dots
names(cdp_data)[names(cdp_data) == "Electricity.Generation..GWh."] <- "ElectricityGeneration_GWh"


################################################################################
## QUESTION 1
## Calculate the total electricity generation per year. How does this change overtime?
################################################################################

# Sum  all source electricity for each country
total_electricity <- aggregate(cdp_data$ElectricityGeneration_GWh, by=list(Year = cdp_data$Year, Country = cdp_data$Country),FUN=sum, na.rm=TRUE) 
names(total_electricity)[names(total_electricity) == "x"] <- "ElectricityGeneration_GWh"
#total_electricity <- total_electricity[!total_electricity$Country=='World',]

## Plot total electricity by time 
p_totals <- ggplot(total_electricity, aes(x = Year, y = TotalElectricityGeneration_GWh, fill = Country)) + 
  geom_point(aes(color=Country)) +
  geom_line(aes(color=Country))+ 
  theme_bw() +
  ylab("Total Electricity Generation [GWh]") 
  
p_totals

################################################################################
## QUESTION 2
## What percentage of electricity is generated from fossil fuel sources per year?
################################################################################

# Choose country to explore
country <- "China"
country_data <- subset(cdp_data, cdp_data$Country == country)
#country_data <- na.omit(country_data) #### FIX the NA stuff

# Plot different sources over time
p_sources <- ggplot(country_data, aes(x = Year, y = ElectricityGeneration_GWh, fill = Source)) + 
  geom_point(aes(color=Source)) +
  geom_line(aes(color=Source))+ 
  theme_bw() +
  ylab("Electricity Generation [GWh]") 

p_sources

# Combine fossil fuels 
FF_electricity <- subset(country_data, country_data$Source == "Coal" | country_data$Source == "Natural gas" | country_data$Source == "Oil")
####FF <- filter(country_data, Source == "Coal" | Source == "Natural gas" | Source == "Oil")
FF_electricity <- aggregate(FF_electricity$ElectricityGeneration_GWh, by=list(Year = FF_electricity$Year), FUN=sum, na.rm=TRUE) 
names(FF_electricity)[names(FF_electricity) == "x"] <- "ElectricityGeneration_GWh"
FF_electricity$Source <- "Fossil Fuel"

# Find FF as a percentage of total generation
country_total <- subset(total_electricity, total_electricity$Country == country)
country_total$Country <- NULL
country_total$Source <- "Total"

# Combine FF and Total
percent_FF <- rbind(country_total, FF_electricity)

percent_FF <- 

## FF vs Other sources
# Combine other sources
other_electricity <- subset(country_data, country_data$Source != "Coal" & country_data$Source != "Natural gas" & country_data$Source != "Oil")
other_electricity <- aggregate(other_electricity$ElectricityGeneration_GWh, by=list(Year = other_electricity$Year), FUN=sum, na.rm=TRUE) 
names(other_electricity)[names(other_electricity) == "x"] <- "ElectricityGeneration_GWh"
other_electricity$Source <- "Other Energy Source"

# Combine all dfs
FF_other_electricity <- rbind(FF_electricity, other_electricity)

# Plot 
p_FF_other <- ggplot(FF_other_electricity, aes(x = Year, y = ElectricityGeneration_GWh, fill = Source)) + 
  geom_point(aes(color=Source)) +
  geom_line(aes(color=Source))+ 
  theme_bw() +
  ylab("Electricity Generation [GWh]") 

p_FF_other

# total, FF and other 


