# https://hub.docker.com/r/rocker/verse
FROM rocker/verse:3.6.3

# Install packages
COPY apt.txt ${HOME}
RUN apt-get update \
  && apt-get install -y --no-install-recommends $(< apt.txt)
    # lbzip2 \
    # libfftw3-dev \
    # libgdal-dev \
    # libgeos-dev \
    # libgsl0-dev \
    # libgl1-mesa-dev \
    # libglu1-mesa-dev \
    # libhdf4-alt-dev \
    # libhdf5-dev \
    # libjq-dev \
    # liblwgeom-dev \
    # libpq-dev \
    # libproj-dev \
    # libprotobuf-dev \
    # libnetcdf-dev \
    # libsqlite3-dev \
    # libssl-dev \
    # libudunits2-dev \
    # netcdf-bin \
    # postgis \
    # protobuf-compiler \
    # sqlite3 \
    # tk-dev \
    # unixodbc-dev

# https://github.com/rocker-org/geospatial
## Run an install.R script, if it exists.
COPY install.R ${HOME}
RUN if [ -f install.R ]; then R --quiet -f install.R; fi
# RUN rm -r /home/rstudio/kitematic

