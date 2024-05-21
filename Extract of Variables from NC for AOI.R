##########GNU 3:0######
#Authors: Zeeshan Virk, Zafar Iqbal


library(rgdal)
library(ncdf4)
library(raster)



rm(list=ls())
#################Extraction of nc files####################



######## Location of Shape File #####################
setwd("C:/Users/zvirk20/OneDrive - Oulun yliopisto/WATNEX/Data/Data/Met.no/Gridded Preciptation Data/Otta <- Boundary")   #Folder where output will be written
datr<-readOGR("Otta_Boundary.shp") ## Otta Boundary 
shp <- spTransform(datr, CRS("+proj=utm +zone=33 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")) ## Transform the coordinates from WGS to UTM, skip this if your shape file is already in UTM



setwd("C:/Users/zvirk20/OneDrive - Oulun yliopisto/WATNEX/Data/Data/Met.no/Gridded Preciptation Data/NC Files")
fln<-list.files(pattern = ".nc")
########### Extract Data from NC file ###############################################
for(f in 1:length(fln)) { #this for loop is cycling the list of files of in the NC files folder. and fln has stored all the NC files.
  
  pre<-brick(fln[f],varname="tg") ###Variable Name rr for precipitation, tg for mean temperature, tm and tx for minimum and maximum temperature. The brick command is used to break down the raster into small gridded items onto which analysis can be carried out (Check) 
  bb <- mask(pre, shp) #Here we are extracting our area for from the entire norwegian dataset.
  dat<-rasterToPoints(bb) #This is for converting the raster grid to points
  
  
  
  if(f==1) Dat<-dat # Data from first file into an empty variable
  if(f>1) Dat<-cbind(Dat, dat[,3:ncol(dat)]) # Binds the data from all files. First 2 columns are coordinates and are thus ignored
  print(f)
  flush.console()
}
setwd(" C:/Users/zvirk20/OneDrive - Oulun yliopisto/WATNEX/Data/Data/Met.no/CSV Data/Final")



write.csv(Dat,"OttaDailytTempMean(1960-2020).csv")