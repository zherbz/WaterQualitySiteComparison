library(shiny)
library(ggplot2)
library(WaterML)
library(leaflet)
library(magrittr)
library(reshape)

#Retrive stream data from WaterML (CUAHSI) - define service 
#(IUTAH - USGS Gage 10163000 Provo River at Provo, UT)

services <- GetServices()
server <- "http://data.iutahepscor.org/RedButteCreekWOF/cuahsi_1_1.asmx?WSDL"

#WaterML - Get the variables and sites on the Provo River
variables <- GetVariables(server)
sites <- GetSites(server)

#get full site info for all sites using the GetSiteInfo method
siteinfo_900 <- GetSiteInfo(server,"iutah:RB_900W_BA")
siteinfo_1300 <- GetSiteInfo(server,"iutah:RB_1300E_A")
#Site Name
sitename_1300 <- (c(siteinfo_1300[1,1],as.numeric (siteinfo_1300[1,5]),as.numeric (siteinfo_1300 [1,6])))
sitename_900 <- (c(siteinfo_900[1,1],as.numeric (siteinfo_900[1,5]), as.numeric (siteinfo_900 [1,6])))

#get full site info for all sites using the GetSiteInfo method
ThirteenE_DO <- GetValues(server,siteCode="iutah:RB_1300E_A",variableCode="iutah:ODO", startDate = "2017-04-01",
                            endDate = "2017-10-31")
colnames(ThirteenE_DO)[2] = "Dissolved_Oxygen_mg/L"

NineSouth_DO <- GetValues(server,siteCode="iutah:RB_900W_BA",variableCode="iutah:ODO", startDate = "2017-04-01",
                       endDate = "2017-10-31")
colnames(NineSouth_DO)[2] =  "Dissolved_Oxygen_mg/L"

ThirteenE_temp <- GetValues(server,siteCode="iutah:RB_1300E_A",variableCode="iutah:WaterTemp_EXO", startDate = "2017-04-01",
                           endDate = "2017-10-31")
colnames(ThirteenE_temp)[2] = "Temperature_C"

NineSouth_temp <- GetValues(server,siteCode="iutah:RB_900W_BA",variableCode="iutah:WaterTemp_ISCO", startDate = "2017-04-01",
                          endDate = "2017-10-31")
colnames(NineSouth_temp)[2] = "Temperature_C"

#Remove Duplicates in DO data
NineSouth_DO<- NineSouth_DO[!duplicated(NineSouth_DO$time), ]
ThirteenE_DO<- ThirteenE_DO[!duplicated(ThirteenE_DO$time), ]
#Merge Data on Data

NineSouth_df<- merge(NineSouth_temp,NineSouth_DO, by = "time")
NineSouth_df <- NineSouth_df[-c(3:9,11:17,19:25)]
NineSouth_df$SiteName <- sitename_900 [1]

ThirteenE_df<- merge(ThirteenE_DO,ThirteenE_temp, by = "time")
ThirteenE_df <- ThirteenE_df[-c(3:9,11:17,19:25)]
ThirteenE_df$SiteName <- sitename_1300 [1]

df <- rbind (NineSouth_df, ThirteenE_df, deparse.level = 2)
######Added: Convert data class from POSIX to as date POSIX
df$time <- as.Date.POSIXct(df$time) 

#Merge Site Names
sitename_df <- data.frame(rbind(sitename_900,sitename_1300))
colnames(sitename_df) <- c("SiteName", "Lat", "Long")
sitename_df$Lat <- as.numeric(levels(sitename_df$Lat))[sitename_df$Lat]
sitename_df$Long <- as.numeric(levels(sitename_df$Long))[sitename_df$Long]
row.names(sitename_df) <- NULL

#######Added: Remove no longer needed variables from global environment
rm(NineSouth_df,NineSouth_df,NineSouth_DO,NineSouth_temp,NineSouth_turb,ThirteenE_df,ThirteenE_DO,ThirteenE_temp,ThirteenE_turb)

