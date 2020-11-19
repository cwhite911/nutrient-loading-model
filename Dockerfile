# https://hub.docker.com/r/rocker/verse
FROM rocker/verse:3.6.3

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    lbzip2 \
    libfftw3-dev \
    libgdal-dev \
    libgeos-dev \
    libgsl0-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libhdf4-alt-dev \
    libhdf5-dev \
    libjq-dev \
    liblwgeom-dev \
    libpq-dev \
    libproj-dev \
    libprotobuf-dev \
    libnetcdf-dev \
    libsqlite3-dev \
    libssl-dev \
    libudunits2-dev \
    netcdf-bin \
    postgis \
    protobuf-compiler \
    sqlite3 \
    tk-dev \
    unixodbc-dev

# Installing rstan independently becasue it was throwing an error using install2.r
RUN R -e "install.packages('rstan', repos = 'https://cloud.r-project.org/', dependencies = TRUE)"

# https://github.com/rocker-org/geospatial
RUN install2.r --error \
    reshape2 \
    dplyr \
    lme4 \
    ggplot2 \
    ggpubr \
    xlsx \
    rstudioapi \
    loo \
    MASS \
    matrixStats \
    pacman \
    cowplot \
    hexbin \
    rcompanion \
    RColorBrewer \
    RandomFields \
    RNetCDF \
    classInt \
    deldir \
    gstat \
    hdf5r \
    lidR \
    mapdata \
    maptools \
    mapview \
    ncdf4 \
    proj4 \
    raster \
    rgdal \
    rgeos \
    rlas \
    sf \
    sp \
    spacetime \
    spatstat \
    spdep \
    geoR \
    geosphere \
    ## from bioconductor
    && R -e "BiocManager::install('rhdf5', update=FALSE, ask=FALSE)"

RUN rm -r /home/rstudio/kitematic


