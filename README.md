[![Launch binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/cwhite911/nutrient-loading-model/main?urlpath=rstudio)

# nutrient-loading-model
Development Envronment for the HUC12 sub watershed nutrient loading model. 

- R version v3.6.3
- PostgreSQL v12.5
- PostGIS v3.0.2

>Note: Use [PGAdmin4](https://www.pgadmin.org/download/) to interact directly with the Postgres database named `WRRI` running on `localhost:5430` with the user `postgres`

# How to use
Install [docker](https://docs.docker.com/get-docker/) to run RStudio in the browser.

## Download Latest Postgres Backup
Copy `wrri_pg_bak` from Google Drive (WRRI_FallsJordan) into the top level of this git repository

## Build and Run the docker services
```docker
docker-compose up -d
```

## Go to RStudio in the browser
```
http://localhost:8787/
```

## Reload new database backup
```
docker-compose restart -d
```

## How To...
### Add or update a R Library 
>A dd or remove R Libraries in `install.R` and then rebuild the docker container to see changes.

### Add or update a linux package 
> Add or remove linux packages in `apt.txt` then rebuild the docker container to see changes.



