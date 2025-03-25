## Link to Publication 

(coming soon)

## Project Abstract

Liana (woody vine) management is a promising natural climate solution (NCS) that could boost atmospheric carbon dioxide removal. Liana impacts and removal outcomes on tree growth has been studied extensively in the Neotropics, yet we know comparatively little of their spatial distribution in temperate regions, which is necessary to identify where and at what scale this NCS could be implemented. We present the first high resolution map of eight common lianas across the Nearctic region of North America, explore variables influencing their distribution, estimate forested area that are infested by lianas, and subsequently predict outcomes of liana management scenarios in terms of carbon dioxide removal. Using Google Earth Engine and publicly available data with machine learning techniques, we focus our efforts on wild grapevines, trumpet creeper, poison ivy, Virginia creeper, Oriental bittersweet, kudzu, wisteria, and English ivy. With a unique cascading approach, we classify each taxon's suitable habitat range using primarily climate data before predicting their current distribution within that range using higher resolution (100 meters) remote sensing data including satellite imagery, vegetation indices, and nighttime lights. We estimate that there are over 300 million hectares of forest that are suitable for lianas (i.e., susceptible) across the Nearctic, and that around 200 million hectares of forest are likely occupied by lianas. Their distribution is largely concentrated in the eastern United States and is largely linked to urbanization. Our final maps are shared through an interactive Google Earth Engine web application that is freely available. These findings are intended to inform silvicultural treatments for releasing forest stands inhibited by disturbance-induced liana abundance, and provide a proof of concept for this approach to large scale, high resolution species distribution modeling. Finally, these maps allow us to share preliminary estimates of large-scale carbon sequestration benefits for liana removal scenarios, which suggest that liana management could boost North American forest carbon sequestration by almost three percent, or the equivalent of removing 45 million gasoline-powered vehicles from our roadways. This finding indicates major opportunities for improving carbon sequestration and resilience of temperate North American forests.

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
[Habitat Suitability Model Script](https://code.earthengine.google.com/2212a5150208f052b4a7d14c01407abb?noload=true)

[Habitat Suitability Model Variable Prep Script](https://code.earthengine.google.com/47588c365b1fa56a5f9cb3272522076c?noload=true)

### Species Distribution Models

[Species Distribution Model Script](https://code.earthengine.google.com/ea64c0c3d88ec2a206ef6577b475c132?noload=true)

[Species Distribution Model Variable Prep Script](https://code.earthengine.google.com/08ae23a17699a166a7dbc4812fc2bd51?noload=true)

## R scripts

[Presence Data Downloads from the Global Biodiversity Information Facility](https://github.com/jacobdjpeters/nearcticLianaMaps/blob/main/gbifDataCollection_exampleCode.R)
