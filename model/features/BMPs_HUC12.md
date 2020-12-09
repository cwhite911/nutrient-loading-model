# Nutrient Loading Model

### Connect to database

``` r
library(RPostgreSQL)
library(postGIStools)
library(RColorBrewer)

con <- dbConnect(PostgreSQL(), dbname = "WRRI", user = "postgres",
                 host = "postgis",
                 port="5432")
```

## HUC12 Subwatersheds

Get HUC12 in study area

``` r
hu12_df <- get_postgis_query(con, 
    "SELECT *
     FROM huc12_study_area",
geom_name = "geom")
```

Get Study area

``` r
aoi_df <- get_postgis_query(con, 
    "SELECT ST_UNION(fl.geom,jl.geom) as geom 
        FROM jordan_lake_watershed as jl, falls_lake_watershed as fl",
geom_name = "geom")
```

Get Counties

``` r
counties_df <- get_postgis_query(con, 
    "SELECT countyname, geom 
        FROM counties",
geom_name = "geom")
```

``` r
plot(counties_df,  border=c('black'))
plot(hu12_df, border="grey", add=T)
plot(aoi_df,  border=c('blue'), add=T)
```

![](BMPs_HUC12_files/figure-gfm/studyarea-1.png)<!-- -->

## BMPS & SCM

### City of Greensboro

Calculating the total area of BMP & SCM features by type

``` r
greensboro_bmp_area_df <- get_postgis_query(con,
"SELECT featuretyp, bmptype, (SUM(ST_AREA(geom)) / 1e6) as area
FROM sw_waterbodies_bmp_scm_greensboro
GROUP BY featuretyp, bmptype")

ggplot(greensboro_bmp_area_df, aes(y=bmptype, x=featuretyp, fill= area)) + 
  geom_tile() +
  scale_fill_distiller(palette = "YlGnBu") +
  labs(
       title = "BMP & SCM Type Area (km^2)",
       subtitle = "City of Greensboro",
       x = "BMP/SCM Type",
       y = "Feature Type")
```

![](BMPs_HUC12_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

Calculating the total number of BMP & SCM features by type

``` r
greensboro_bmp_count_df <- get_postgis_query(con,
"SELECT featuretyp, bmptype, COUNT(*) as count
FROM sw_waterbodies_bmp_scm_greensboro
GROUP BY featuretyp, bmptype")

ggplot(greensboro_bmp_count_df, aes(y=bmptype, x=featuretyp, fill= count)) + 
  geom_tile() +
  scale_fill_distiller(palette = "YlGnBu") +
  labs(color="Buiding Inclusion",
       title = "BMP & SCM Type Count",
       subtitle = "City of Greensboro",
       x = "BMP/SCM Type",
       y = "Feature Type")
```

![](BMPs_HUC12_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

``` r
query = paste("SELECT bmp.featuretyp, bmp.bmptype, (SUM(ST_AREA(bmp.geom)) / 1e6) as area, sa.geom
FROM sw_waterbodies_bmp_scm_greensboro as bmp
JOIN huc12_study_area as sa ON ST_CONTAINS(sa.geom, ST_CENTROID(bmp.geom))
GROUP BY featuretyp, bmptype, sa.geom")

greensboro_bmp_area_gdf <- st_read(con,query = query)
```

Plot the data

``` r
greensboro_bmp_area_gdf %>%
ggplot() +
    facet_grid(.~featuretyp) +
    geom_sf(aes(fill = area)) +
    scale_fill_viridis_c(option = "plasma")
```

![](BMPs_HUC12_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
greensboro_bmp_area_gdf %>%
  filter(bmptype == 'Dry Waterbody' | bmptype =='Wet Waterbody')  %>%
ggplot() +
    facet_grid(featuretyp~bmptype) +
    geom_sf(aes(fill = area)) +
    scale_fill_viridis_c()
```

![](BMPs_HUC12_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

``` r
class(greensboro_bmp_area_gdf)
```

    ## [1] "sf"         "data.frame"

## Culverts

Calculate the total length of
culverts

``` r
huc12_culverts_df <- get_postgis_query(con, "SELECT sa.huc_12,sa.hu_12_name,sa.hu_10_name, 
    (
        sum(COALESCE(ST_Length(gc.geom),0) + 
            COALESCE(ST_Length(cc.geom),0) +
            COALESCE(ST_Length(rc.geom),0)
           )
    ) AS total_length_m,
    sa.geom
FROM huc12_study_area as sa
LEFT JOIN sw_culverts_greensboro as gc ON ST_CONTAINS(sa.geom, gc.geom)
LEFT JOIN sw_culverts_cary as cc ON ST_CONTAINS(sa.geom, cc.geom)
LEFT JOIN sw_culverts_raleigh as rc ON ST_CONTAINS(sa.geom, rc.geom)

GROUP BY sa.huc_12, sa.hu_12_name,sa.hu_10_name,  sa.geom", geom_name="geom")
```

``` r
spplot(huc12_culverts_df,"total_length_m", main="Culvert Length (m)")
```

![](BMPs_HUC12_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->
