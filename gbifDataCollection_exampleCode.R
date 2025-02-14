
#This script is for downloading presence points from GBIF and writing them to files. 


install.packages(c("readxl", "knitr", "data.table", "randomForest", 
                   "randomForestExplainer", "randomForestSRC", "raster", "rgdal", 
                   "rgbif", "gbifdb","sp", "sf", "gridExtra", "grid", "pdp", "vip", 
                   "stars", "ggmap", "maptools", "mapdata", "viridis", "rgeos", 
                   "CENFA", "dismo", "sdmvspecies",
                   "RasterVis", "terra", "CoordinateCleaner", "countrycode"))


require(readxl)
require(dismo)
require(knitr)
require(data.table)
require(randomForest)
require(randomForestExplainer)
require(randomForestSRC)
require(raster)
require(terra)
require(rgdal)
require(sp)
require(sf)
require(stars)
require(gridExtra)
require(grid)
require(pdp)
require(vip)
require(ggmap)
require(maptools)
require(mapdata)
require(viridis)
require(rgeos)
require(CENFA)
require(sdmvspecies)
require(rasterVis)
require(ROCR)
require(rgbif)
require(CoordinateCleaner)
require(countrycode)

path <- "folderPath/"

# load nearctic
nearctic <- vect(paste0(path, "ecoRegions2017_nearcticRealm.shp"))


# we create a function that will do the following: 
# 1. download and clean data, write shapefiles.
# 2. spatially thin data, write shapefiles. 



GBIFDataPrep <- function(speciesName, # species name for searching GBIF. 
                         familyName, # familyName for cleaning data.
                         country="US", # to supply geographic boundary for search. Default is "US", we use US, CA, MX
                         date, #date. character 
                         roi, #for setting crs of presence points. 
                         maskLayer = NULL, # if masking (to forest, high elevations, etc.), specify a spatRaster to mask to. 
                         columnNames=c("species", 
                                       "specificEpithet", 
                                       "decimalLongitude", 
                                       "decimalLatitude",
                                       "countryCode",
                                       "gbifID", 
                                       "family", 
                                       "taxonRank",
                                       "coordinateUncertaintyInMeters", 
                                       "year", 
                                       "basisOfRecord",
                                       "institutionCode", 
                                       "datasetName"), # what columns we want from the GBIF record. Feel free to modify. 
                         geometry=NULL, # NULL by default. See occ_search for info there. 
                         folderPath, # file path for folder where files will be written. 
                         nthin, #number of points to thin to. 
                         name # the unique part of the file name that you want for the taxon, without extension (those are added automatically)   ## note that the other filename parts like "InForest" will be added automatically as well. 
){
  
  
  #obtain data from GBIF via rgbif
  datList <- list(NULL) # make list for storing data
  k <- 1 # counter for storing data frames in datList. 
  for(i1 in country){ # loop through country list
    message("for ", i1) # track it.
    dat <- occ_search(scientificName = speciesName, limit = 10000, hasCoordinate = T,
                      country=i1,
                      geometry=geometry)
    if(dat[[1]]$count > 0){
      data <- as.data.table(dat$data)
      data <- data[, ..columnNames]
      #convert country code from ISO2c to ISO3c
      data$countryCode <-  countrycode(data$countryCode, origin =  'iso2c', destination = 'iso3c')
      data <- data[!is.na(decimalLongitude) & !is.na(decimalLatitude)]
      
      flags <- clean_coordinates(x = data, 
                                 lon = "decimalLongitude", 
                                 lat = "decimalLatitude",
                                 countries = "countryCode",
                                 species = "species",
                                 tests = c("capitals", 
                                           "centroids", 
                                           "equal",
                                           "gbif", 
                                           "institutions",
                                           "zeros")) # most test are on by default
      
      #Exclude problematic records
      data$flags <- flags$.summary
      dat_cl <-  data[flags!=FALSE]
      datList[[k]] <- dat_cl
    }
    k <- k+1
  }
  dat_cl <- do.call("rbind", datList) # merge data frames. 
  
  # select accuracy of points. no more than 30m error.
  dat_cl <- dat_cl[coordinateUncertaintyInMeters <= 30] # keep points with "good" accuracy. 
  
  dat_cl <- dat_cl[basisOfRecord == "HUMAN_OBSERVATION" | 
                     basisOfRecord == "OBSERVATION"]
  # temporal outliers. remove old stuff. 
  dat_cl <- dat_cl[year >= 1945]
  # make sure no incorrect family ID. 
  dat_cl <- dat_cl[family==familyName]
  # get coords, make spdf.
  coords <- cbind(dat_cl$decimalLongitude,
                  dat_cl$decimalLatitude) # get coords of clean data. 
  pres <- SpatialPointsDataFrame(coords, data=dat_cl, proj4string = CRS("+init=epsg:4326")) # make spdf
  pres <- spTransform(pres, crs(roi))
  pres <- vect(pres) #convert to spatVector
  crs(pres) <- crs(roi) # specify crs. 
  pres <- crop(pres, roi) # crop to your ROI 
  print(paste0("crs check: ", crs(pres)))
  #writeVector(pres,
  #        paste0(folderPath, name, "Clean_", type, "_", date, ".shp"),
  #        overwrite=TRUE) # if you want to write a file without thinning or masking. 
  
  
  # mask if desired
  if(!is.null(maskLayer)){
    print("masking to maskLayer... ")
    values(pres) <- extract(maskLayer, pres) # extract mask values
    pres <- pres[pres$discrete_classification==1] # select where land cover ==1 (forest)
    
  }
  
  
  
  
  # Prepare to thin presence
  pres$random <- runif(length(pres)) # add random numbers to all original presence data. 
  pres <- pres[order(pres$random)] # randomly sort. 
  pres$id <- 1:length(pres) #assign a sequential ID. This will match "from" and "to" below. 
  
  
  # some of them have way too many points. 
  # if greater than 40k points, randomly thin to 30k. 
  if(length(pres)>40000){
    message("There are ", length(pres), " points. Randomly thinning to 30k.")
    pres<- pres[pres$id<=30000]
    message("thinned to ", length(pres), " points.")
  }
  
  
  # for all taxa: thin points within 1km of another reduces sampling bias. 
  presPrj <- as(pres, "Spatial") # convert to sp
  presPrj <- spTransform(presPrj, CRS("+init=epsg:5070")) # reproject to an equal area projection in meters. I think this helps the dist function run faster. 
  presPrj <- vect(presPrj) # put back as spatVector. 
  
  
  # create reference table for thinning operation. gc() after each function because it is a hoss. 
  message("calculating distances ...")
  dTable <- data.table(terra::distance(presPrj, pairs=TRUE, symmetrical=TRUE)); gc() # clean garbage after. 
  dTable <- dTable[value<=50000000]; gc() # remove far distance pairs. 		
  dTable <- dTable[order(value), head(value, n=25), by=.(from)]; gc() # get top 25 closest for each point. 
  colnames(dTable) <- c("id", "dist") # returns ID and distances. 
  dTable$dist <- as.numeric(dTable$dist)#/1000 # convert to km for easy reading. 
  gc() # collect garbage.  
  
  presRef <- cbind(pres$id, pres$random)
  colnames(presRef) <- c("id", "random")
  dTable <- merge(dTable, presRef, by="id", all.x=FALSE, all.y=FALSE)
  
  pointsToRemove <- sort(unique(dTable[dist<=15]$random)) # make list of points to thin. 
  
  # randomly thin points so no point has another within 15m of it. 
  message("thinning to 15m to reduce sample bias ...")
  pres <- pres[! pres$random %in% pointsToRemove, ] # thin. 
  dTable <- dTable[! random %in% pointsToRemove, ] # remove from distance ref table.  
  
  
  
  # if there are more than 'nthin' presence points, begin thinning. 
  if(length(pres)>=nthin){
    
    nToRemove <- length(pres) - nthin 
    message("thinning", nToRemove, "points from", name)
    
    
    
    for(range in seq(30, 50000, by=15)){ # start at 30m -- already thinned slightly for sampling bias.  
      
      if(any(dTable$dist<range)){ # if any distance values are less than given m range. 
        
        message("thinning at", range, "m")
        
        if(length(unique(dTable[dist<=range]$random))<nToRemove){ # if there are fewer points to thin at this range than are needed to be removed, thin all pairs. 
          message("going with: thin all pairs")
          pointsToRemove <- sort(unique(dTable[dist<=range]$random)) # make list of points to thin. 
          
          pres <- pres[! pres$random %in% pointsToRemove, ] # thin. 
          dTable <- dTable[! random %in% pointsToRemove, ] # remove from distance table.  
          
          nToRemove <- length(pres) - nthin  # update for remaining nToRemove. 
          message("thinned ", length(pointsToRemove), " points. ", length(pres), " remain.")
        }else{ # else, remove as many as we can
          message("going with: else")
          pointsToRemove <- sort(unique(dTable[dist<=range]$random)) # make list of points to thin.
          
          
          pres <- pres[! pres$random %in% pointsToRemove[1:nToRemove], ] # thin. 
          dTable <- dTable[! random %in% pointsToRemove[1:nToRemove], ] # remove from distance table.   
          
          message("thinned ", nToRemove, " points. ", length(pres), " remain.")
          # I think once this else part runs, it should be done. 
          
        }
        
        if(length(pres)<=nthin){
          message("Done thinning.")
          break} # if we reach goal, break.
        
      }
      
      if(length(pres)<=nthin){
        message("Done thinning.")
        break} # if we reach goal, break. 
      
    }
  }
  
  if(is.null(maskLayer)){presType <- "CleanThin"}
  else{
    presType <- "CleanThinMasked"
  }
  
  
  writeVector(pres,
              paste0(folderPath, name, "_", presType, "_", date, ".shp"),
              overwrite=TRUE)
  
  
  
  
}



# Now the function is made
# Loop the function for taxa you want. 
# In my case, im getting lianas. 



# triple check make sure these are aligned. 
# note that "Genera*" returns results for that genus. 
lianas <- c("Vitis*"
            ,"Pueraria montana"
            ,"Celastrus orbiculatus"
            ,"Lonicera japonica"
            ,"Wisteria*"
            ,"Parthenocissus quinquefolia"
            ,"Campsis radicans"
            ,"Toxicodendron radicans"
            ,"Hedera helix"
)
famNames <- c("Vitaceae"
              ,"Fabaceae"
              ,"Celastraceae"
              ,"Caprifoliaceae"
              ,"Fabaceae"
              ,"Vitaceae"
              ,"Bignoniaceae"
              ,"Anacardiaceae"
              ,"Araliaceae"
)
names <- c("visp"
           ,"pumo"
           ,"ceor"
           ,"loja"
           ,"wisp"
           ,"paqu"
           ,"cara"
           ,"tora"
           ,"hehe"
)


# download from GBIF
for(i in 1:length(lianas)){
  
  message("starting ", lianas[i], " ... ") # print progress
  
  GBIFDataPrep(speciesName=lianas[i],
               familyName=famNames[i],
               country=c("US", "CA", "MX"),
               maskLayer = forest100,
               date="19991231" ,
               roi=nearctic, # for setting crs of points
               folderPath=paste0(path, "/presenceData/"),
               nthin=999, # number to thin to. 
               name=names[i])
  gc()
}





