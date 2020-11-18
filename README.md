[![Launch binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/cwhite911/wrri-subwatershed-features/main?urlpath=rstudio)

# wrri-subwatershed-features
Feature generation pipeline for HUC12 sub watershed nutrient loading model. 

# How to use

## Build the docker image
```docker
docker build --tag wrrimodel .
```

## Run the development environment container
```docker
docker run --rm -it --name wrri-model-dev -p 8787:8787 --mount type=bind,source=<absolutepath>/model,target=/usr/local/src/model --tag wrrimodel:latest .
```