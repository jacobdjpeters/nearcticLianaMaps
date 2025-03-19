## Link to Publication 

(coming soon)

## Project Abstract

Liana management is a promising natural climate solution (NCS) that could boost atmospheric carbon dioxide removal. Liana impacts and removal outcomes on tree growth has been studied extensively in the Neotropics, yet we know comparatively little of their spatial distribution in temperate regions, which is necessary to identify where and at what scale this NCS could be implemented. We present the first high resolution map of eight common lianas distribution across the Nearctic region of North America and explore variables influencing their distribution. Using Google Earth Engine and publicly available data, we classified habitat and distribution of wild grapevines, trumpet creeper, poison ivy, Virginia creeper, Oriental bittersweet, kudzu, wisteria, and English ivy. Using a unique cascading approach, we classify each taxon's suitable habitat range using primarily climatic information before predicting their current distribution within that range using higher resolution (100 meters) remote sensing data including satellite imagery, vegetation indices, and nighttime lights. We hypothesized that ranges will differ across taxa, with an elevated abundance at the urban-forest interface. We found that there are around 341 million hectares of forest that are suitable for lianas across the Nearctic, and estimate that around 200 million hectares of forest are occupied by lianas. Lianas are most frequent in the eastern United States---which appears to be largely related to increased precipitation, and liana occupancy is tied to urbanization. Our final maps are shared through an interactive Google Earth Engine web application that is freely available. These findings are intended to inform silvicultural treatments for large scale release of forest stands inhibited by disturbance-induced liana super-abundance, while providing a proof of concept for this approach to species distribution modeling. The observed extent of lianas indicates major opportunities for improving carbon sequestration and resilience of temperate North American forests.

## Liana "Infestation" Map

The image below shows combined species distribution models for the eight taxa for which we predicted the current distribution, limited to the Nearctic region of North America. 

In essence, the "redder" pixels in the image below correspond to higher likelihood of more liana taxa being present. 

Green pixels are forested areas that are unlikely to harbor lianas. 

![sdm overlap](https://github.com/jacobdjpeters/nearcticLianaMaps/blob/main/overlap_SDMs_forSlides.png)


## Workflow

Our workflow consists of the following: 
  * Download presence data from GBIF
  * Thin presence data if needed
  * Upload presence data to GEE assets
  * Run variable prep scripts
  * Test for variable correlation
  * Run HSM model script
  * Use results on variable importance and correlation to select variables
  * Run HSM model script with selected variables
  * Export suitable habitat range polygons to GEE asset
  * Run SDM model script (limiting predictor variables to suitable range)
  * Use results on variable importance and correlation to select variables
  * Run SDM model script with selected variables
  * Export distribution models to GEE assets (pixels contain the probability of occupancy)
  * Feed distribution models to GEE app.
  * Share!

## Google Earth Engine Web App
To view the interactive distribution models on our GEE app, [click here](https://ee-jacobpeters.projects.earthengine.app/view/northamericanlianas)

## Google Earth Engine Scripts

Google Earth Engine Scripts shared here demonstrate example code for variable prep and running liana distribution models. 

These examples use Oriental bittersweet (Celastrus orbiculatus) presence data. 

### Habitat Suitability Models
[Habitat Suitability Model Script](https://code.earthengine.google.com/15ad91462765c04340fd35678dcebfdb)

[Habitat Suitability Model Variable Prep Script](https://code.earthengine.google.com/47588c365b1fa56a5f9cb3272522076c)

### Species Distribution Models

[Species Distribution Model Variable Prep Script](https://code.earthengine.google.com/e5302e3160e102c275609700e4905308)

[Species Distribution Model Script](https://code.earthengine.google.com/3b2289bf907bd8f28082dc199fbdfc1a)


## R scripts

[Presence Data Downloads from the Global Biodiversity Information Facility](https://github.com/jacobdjpeters/nearcticLianaMaps/blob/main/gbifDataCollection_exampleCode.R)
