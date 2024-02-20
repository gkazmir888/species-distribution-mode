# gbif.R
# query species occurence data from GBIF
# clean up the data 
# save it to a csv file 
# create a map to display the species occurrence points 


#list of packages
packages <-c("tidyverse","rgbif","usethis","CoordinateCleaner", "leaflet", "mapview") 

# install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if(any(installed_packages==FALSE)){
  install.packages(packages[!installed_packages])
}

# Packages loading, with library function

invisible(lapply(packages, library, character.only=TRUE))

usethis:: edit_r_environ()

spiderBackbone<-name_backbone(name="Habronattus americanus")
speciesKey<-spiderBackbone$usageKey

occ_download(pred("taxonKey", speciesKey),format = "SIMPLE_CSV")

# <<gbif download>>
# Your download is being processed by GBIF:
#   https://www.gbif.org/occurrence/download/0005545-240216155721649
# Most downloads finish within 15 min.
# Check status with
# occ_download_wait('0005545-240216155721649')
# After it finishes, use
# d <- occ_download_get('0005545-240216155721649') %>%
#   occ_download_import()
# to retrieve your download.
# Download Info:
#   Username: jeremy2443
# E-mail: jeremym@lclark.edu
# Format: SIMPLE_CSV
# Download key: 0005545-240216155721649
# Created: 2024-02-20T16:40:21.023+00:00
# Citation Info:  
#   Please always cite the download DOI when using this data.
# https://www.gbif.org/citation-guidelines
# DOI: 10.15468/dl.vmnr5n
# Citation:
#   GBIF Occurrence Download https://doi.org/10.15468/dl.vmnr5n Accessed from R via rgbif (https://github.com/ropensci/rgbif) on 2024-02-20

d <- occ_download_get('0005545-240216155721649') %>%
  occ_download_import()


write_csv(d,"data/rawData.csv")

#cleaning 

fData <-d %>%
  filter(!is.na(decimalLatitude), !is.na(decimalLongitude))

fData <- fData |>
  filter(countryCode %in% c("US","CA","MX"))

fData <-fData |>. #does the same thin as the code above 
  filter(countryCode=="US" | countryCode=="CA" | countryCode=="MX")

fData <- fData |>
  filter(!basisOfRecord %in% c("FOSSIL_SPECIMEN","LIVING_SPECIMEN"))

fData <-fData %>%
  cc_sea(lon="decimalLongitude",lat="decimalLatitude")

#remove duplicates 

fData<-fData %>%
  distinct(decimalLongitude, decimalLatitude,speciesKey,datasetKey,.keep_all = TRUE)

#one fell swoop:
# cleanData <- d |>
#   filter(!is.na(decimalLatitude), !is.na(decimalLongitude)) |>
#   filter(countryCode %in% c("US","CA","MX")) |>
#   filter(!basisOfRecord %in% c("FOSSIL_SPECIMEN","LIVING_SPECIMEN")) |>
#   cc_sea(lon="decimalLongitude",lat="decimalLatitude") |>
#   distinct(decimalLongitude, decimalLatitude,speciesKey,datasetKey,.keep_all = TRUE)
  
  
  
  
  
  
  
  
  
  


