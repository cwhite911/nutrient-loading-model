[![Launch binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/cwhite911/nutrient-loading-model/main?urlpath=rstudio)

# nutrient-loading-model
Feature generation pipeline for HUC12 sub watershed nutrient loading model. 

# How to use

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