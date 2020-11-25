[![Launch binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/cwhite911/nutrient-loading-model/main?urlpath=rstudio)

# nutrient-loading-model
Feature generation pipeline for HUC12 sub watershed nutrient loading model. 

# How to use
Install [docker](https://docs.docker.com/get-docker/) to run RStudio in the browser.

## Build the docker image
```docker
docker build -t wrrimodel .
```

## Run the development environment container
```docker
docker run --rm -it --name wrri-model-dev -p 8787:8787 --mount type=bind,source=<absolute path>/nutrient-loading-model/model,target=/home/rstudio/ -e DISABLE_AUTH=true wrrimodel:latest
```

## Go to RStudio in the browser
```
http://localhost:8787/
```

## How To...
### Add or update a R Library 
Add or remove R Libraries in install.R and then rebuild the docker container to see changes.

### Add or update a linux package 
Add or remove linux packages in apt.txt then rebuild the docker container to see changes.
### Add or update a Data Source
Add or update data sources in model/config.yml
