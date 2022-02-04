#developing the mountain pond ice on table#

#Amanda Gavin
#February 4, 2022
#Pulling from "01teleconnections_20211027" to create a Mountain Pond source code that is 
#stored on Git and can be used for other analyses, etc.. 


# Set Up ------------------------------------------------------------------

#clear previous
#rm(list = ls())
library(lubridate)
library(tidyr)



# Bring in Dataframe and Format ------------------------------------------------------

mtnice <- read.csv(file="/Users/Amanda/Documents/PhD Research/Teleconnections_1/MountainPondData/ice_duration_dates_gavin.csv" 
                , header=TRUE,sep = ",")

#format date
mtnice$date = as.POSIXct(mtnp$date, format = "%m/%d/%Y")

#changing "Ice-on" instead of "ice-on"
unique(mtnice$ice_event)

mtnice$ice_event = ifelse(mtnice$ice_event == "Ice_out", "ice_out", mtnice$ice_event)


#fix the Cranberry case inconsistencies
mtnice$lake = ifelse(mtnice$lake == "Cranberry ", "Cranberry", mtnice$lake)
unique(mtnice$lake)



#format mtnice from long to wide
str(mtnice)

#removing rows 67 and 68 that are duplicating with 70 and 69 respsectively.
#horns pond. *can come back later to check which ones are right 
#only 68 and 69 are for ice on and they are a week apart. 
#will likely be changing these anyway. 2/4/2022

mtnice <- mtnice[-c(67,68),]

mtnice <- spread(mtnice, ice_event, date)




mtnp$jday = yday(mtnp$date) #create a julian day

mtnp$year = as.numeric(mtnp$year_spr) #change year to numeric




#make a separate df for just ice on
mtni = subset(mtnp, mtnp$ice_event == "ice_on")

#creating a julian day that makes sense for ice on that occurs in january
#if we use just raw julian days, january + go back to 0. 
#choosing to add 365 to all days less than 100, to make the julian day a continuation
#of the previous year. 

mtni$jday = ifelse(mtni$jday < 100, mtni$jday+365, mtni$jday)

unique(mtni$jday)

#removing NAs of values that are not in regular dataset, doubled checked w raw data
mtni = subset(mtni, !is.na(mtni$jday))

mtni$ice_year = mtni$year_spr - 1