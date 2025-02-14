## Link to publication 

(coming soon)

## Project Abstract

The management of lianas is a promising natural climate solution (NCS) that may help forests remove more carbon dioxide from the atmosphere. The impact of lianas and their removal on tree growth has been studied extensively in the Neotropics, yet we know comparatively little of their spatial distribution in temperate regions, which is necessary to identify where and at what scale this NCS could be implemented. Here we present the first high resolution map of common liana species distribution across the Nearctic region of North America and explore factors influencing their distribution. We predicted and mapped the suitable habitat and distribution of wild grapevines, trumpet creeper, poison ivy, Virginia creeper, Oriental bittersweet, kudzu, wisteria, and English ivy using Google Earth Engine and publicly available data. We implement a unique cascading approach by first classifying their suitable habitat range using primarily climate and position information before predicting their current distribution within that range using higher resolution (30–100 meters) remote sensing data including imagery, vegetation indices, and nighttime lights. We hypothesized that ranges will differ across taxa, with an apparent elevated abundance at the urban-forest interface. We highlight regions that could be targeted for liana management, general patterns of liana distribution at a continental scale, and provides a proof of concept for our species distribution modeling approach. We found that, in the Nearctic region, lianas are most frequent in the eastern United States—which appears to be largely related to increased precipitation. Further, we have identified positive correlations between liana distribution and urbanization and present a 100 meter resolution map to show these relationships. Our final results are shared through an interactive Google Earth Engine web application that is freely available. Viewers can explore these distribution maps, allowing them to investigate the predicted probability for occupancy of these lianas across their suitable ranges. These findings are intended to inform silvicultural treatments for large scale release of forest stands inhibited by disturbance-induced liana superabundance. The extent of liana superabundance in major forest types of North America indicates major opportunities for improving carbon sequestration and resilience of temperate North American forests.

[<img src="blob/main/overlap.png">]

[map](https://github.com/jacobdjpeters/nearcticLianaMaps/blob/main/overlap_SDMs.png)

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
