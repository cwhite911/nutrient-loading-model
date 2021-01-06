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
  scale_fill_distiller(palette = "YlGnBu", trans='log2', direction=1) +
  labs(
       title = "BMP & SCM Type Area (km^2)",
       subtitle = "City of Greensboro",
       x = "BMP/SCM Type",
       y = "Feature Type") +
  geom_text(aes(label=sprintf("%0.4f", area)),color="white", face="bold", size=rel(3.5)) 
```

    ## Warning: Ignoring unknown parameters: face

![](BMPs_HUC12_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

Calculating the total number of BMP & SCM features by type

``` r
greensboro_bmp_count_df <- get_postgis_query(con,
"SELECT featuretyp, bmptype, COUNT(*) as count
FROM sw_waterbodies_bmp_scm_greensboro
GROUP BY featuretyp, bmptype")

ggplot(greensboro_bmp_count_df, aes(y=bmptype, x=featuretyp, fill= count)) + 
  geom_tile() +
  scale_fill_distiller(palette = "YlGnBu", trans='log2', direction=1) +
  labs(color="Buiding Inclusion",
       title = "BMP & SCM Type Count",
       subtitle = "City of Greensboro",
       x = "BMP/SCM Type",
       y = "Feature Type") +
  geom_text(aes(label= count),color="white", face="bold", size=rel(3.5))
```

    ## Warning: Ignoring unknown parameters: face

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
    scale_fill_viridis_c(option = "YlGnBu",trans='log2')
```

    ## Warning in viridisLite::viridis(n, alpha, begin, end, direction, option): Option
    ## 'YlGnBu' does not exist. Defaulting to 'viridis'.

![](BMPs_HUC12_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
greensboro_bmp_area_gdf %>%
  filter(bmptype == 'Dry Waterbody' | bmptype =='Wet Waterbody')  %>%
ggplot() +
    facet_grid(featuretyp~bmptype) +
    geom_sf(aes(fill = area)) +
    scale_fill_viridis_c(trans='log2')
```

![](BMPs_HUC12_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

``` r
query = paste('SELECT  
    bmp.assetid,
    bmp.featuretyp,
    bmp.bmptype,
    bmp.installdat,
    (SUM(ST_AREA(bmp.geom)) / 1e6) as area,
    cast(avg(cast(bf.year_built as integer)) as integer) as "year",
    sa.geom
FROM sw_waterbodies_bmp_scm_greensboro as bmp
JOIN building_footprints as bf on ST_INTERSECTS(ST_Buffer(bmp.geom, 500), bf.geom)
JOIN huc12_study_area as sa on ST_INTERSECTS(bmp.geom, sa.geom)
GROUP BY 
        bmp.assetid,
        bmp.featuretyp,
        bmp.bmptype,
        bmp.installdat, 
        sa.geom
ORDER BY installdat'
)

greensboro_bmp_year_area_gdf <- st_read(con,query = query)
```

``` r
head(greensboro_bmp_year_area_gdf, 5)
```

    ## Simple feature collection with 5 features and 6 fields
    ## geometry type:  MULTIPOLYGON
    ## dimension:      XY
    ## bbox:           xmin: 522271.4 ymin: 248417.2 xmax: 562886.8 ymax: 274726.2
    ## CRS:            EPSG:6542
    ##    assetid featuretyp       bmptype installdat        area year
    ## 1 WTB10709        BMP Wet Waterbody 1999-01-01 0.007281379 1980
    ## 2 WTB11067        BMP Dry Waterbody 1999-12-12 0.060120249 1992
    ## 3 WTB11192        BMP Wet Waterbody 2005-12-01 0.027001278 1977
    ## 4 WTB11193        BMP Wet Waterbody 2005-12-01 0.003592784 1975
    ## 5 WTB10835        BMP       Biocell 2007-01-15 0.064898720 1991
    ##                             geom
    ## 1 MULTIPOLYGON (((550696.9 27...
    ## 2 MULTIPOLYGON (((532062.9 27...
    ## 3 MULTIPOLYGON (((562876.5 25...
    ## 4 MULTIPOLYGON (((562876.5 25...
    ## 5 MULTIPOLYGON (((532062.9 27...

``` r
ggplot(greensboro_bmp_year_area_gdf, aes(y=area, x=year, group= bmptype)) + 
  geom_line() +
  #scale_fill_distiller(palette = "YlGnBu", direction=1) +
  labs(color="Buiding Inclusion",
       title = "BMP & SCM Type Count by Year",
       subtitle = "City of Greensboro",
       x = "BMP/SCM Type",
       y = "Feature Type") #+
```

![](BMPs_HUC12_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

``` r
  #geom_text(aes(label= area),color="white", face="bold", size=rel(3.5))
```

``` r
#head(all_bf_gdf)
counties_sf <- st_read(con, query= paste(
    "SELECT sa.geom 
        FROM counties, huc12_study_area as sa WHERE countyname = 'Guilford' and ST_INTERSECTS(counties.geom, sa.geom)"))

greensboro_bmp_year_area_gdf %>%
ggplot() +
   # facet_grid(year_built~.,rows = vars(5)) +
    geom_sf(data=counties_sf) +
    facet_wrap(year~., ncol = 10) +
    geom_sf(aes(fill = area)) +
    scale_fill_viridis_c(name="Total BMP/SCM Area (Sq Km)",trans='log2') + 
    theme_map() +
    labs( title = "Total BMP/SCM Area (Sq Km) per HUC12",
       subtitle = "1970 - 2014")
```

<img src="BMPs_HUC12_files/figure-gfm/unnamed-chunk-8-1.png" style="display: block; margin: auto;" />

``` r
head(greensboro_bmp_year_area_gdf)
```

    ## Simple feature collection with 6 features and 6 fields
    ## geometry type:  MULTIPOLYGON
    ## dimension:      XY
    ## bbox:           xmin: 522271.4 ymin: 248417.2 xmax: 562886.8 ymax: 275682
    ## CRS:            EPSG:6542
    ##    assetid featuretyp       bmptype installdat        area year
    ## 1 WTB10709        BMP Wet Waterbody 1999-01-01 0.007281379 1980
    ## 2 WTB11067        BMP Dry Waterbody 1999-12-12 0.060120249 1992
    ## 3 WTB11192        BMP Wet Waterbody 2005-12-01 0.027001278 1977
    ## 4 WTB11193        BMP Wet Waterbody 2005-12-01 0.003592784 1975
    ## 5 WTB10835        BMP       Biocell 2007-01-15 0.064898720 1991
    ## 6 WTB11063        BMP       Biocell 2013-12-12 0.004832969 1969
    ##                             geom
    ## 1 MULTIPOLYGON (((550696.9 27...
    ## 2 MULTIPOLYGON (((532062.9 27...
    ## 3 MULTIPOLYGON (((562876.5 25...
    ## 4 MULTIPOLYGON (((562876.5 25...
    ## 5 MULTIPOLYGON (((532062.9 27...
    ## 6 MULTIPOLYGON (((543730.6 27...

## BMP Inlets

``` r
query = paste('SELECT 
    inlet.assetid as inlet_assetid,
    bmp.objectid,
    bmp.installdat,
    bmp.bmptype,
    bmp.featuretyp,
    bmp.outletdiam,
    inlet.geom
FROM sw_inlets_greensboro as inlet, sw_waterbodies_bmp_scm_greensboro as bmp
WHERE ST_Intersects(inlet.geom, bmp.geom)')

bmp_inlets_gdf <- st_read(con,query = query)

query = paste('SELECT 
    bmp.*
FROM sw_inlets_greensboro as inlet, sw_waterbodies_bmp_scm_greensboro as bmp
WHERE ST_Intersects(inlet.geom, bmp.geom)')

bmps_gdf <- st_read(con,query = query)
```

``` r
bmp_inlets_gdf %>%
ggplot() +
    geom_sf() +
    geom_sf(data=bmps_gdf, aes(fill=bmptype))
```

![](BMPs_HUC12_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

``` r
    #scale_fill_viridis_c(option = "plasma")
```

## Culverts

Calculate the total length of
culverts

``` r
huc12_culverts_df <- st_read(con, query=paste("SELECT sa.huc_12,sa.hu_12_name,sa.hu_10_name, 
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

GROUP BY sa.huc_12, sa.hu_12_name,sa.hu_10_name,  sa.geom"))
```

``` r
#spplot(huc12_culverts_df,"total_length_m", main="Culvert Length (m)")

huc12_culverts_df %>%
ggplot() +
    #facet_grid(.~featuretyp) +
    geom_sf(aes(fill = total_length_m)) +
    scale_fill_viridis_c(option = "YlGnBu",trans='log2') +
    labs(color="Length (m)",
       title = "Culvert Length (m)") 
```

    ## Warning in viridisLite::viridis(n, alpha, begin, end, direction, option): Option
    ## 'YlGnBu' does not exist. Defaulting to 'viridis'.

    ## Warning: Transformation introduced infinite values in discrete y-axis

![](BMPs_HUC12_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

``` r
#Import libraries
library(spatstat)
```

    ## Loading required package: spatstat.data

    ## Loading required package: nlme

    ## 
    ## Attaching package: 'nlme'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     collapse

    ## Loading required package: rpart

    ## 
    ## spatstat 1.63-3       (nickname: 'Wet paint') 
    ## For an introduction to spatstat, type 'beginner'

    ## 
    ## Note: spatstat version 1.63-3 is out of date by more than 10 months; we recommend upgrading to the latest version.

    ## 
    ## Attaching package: 'spatstat'

    ## The following objects are masked from 'package:ggpubr':
    ## 
    ##     border, rotate

    ## The following object is masked from 'package:MASS':
    ## 
    ##     area

``` r
#library(rgdal)

#huc12_culverts_df <- get_postgis_query(con, 
#geom_name = "geom")
#Convert roads spatial lines data frame to psp object
#psp_culvert_ms <- st_cast(huc12_culverts_df,"MULTILINESTRING")
#psp_culvert_ls <- st_cast(psp_culvert_ms,"LINESTRING")
#class(psp_culvert_ls)
#psp_culvert <- as.psp(huc12_culverts_df)
#Apply kernel density, however this is where I am unsure of the arguments
#culvert_density <- spatstat::density.psp(psp_culvert, sigma = 0.01, eps = 500) 
```
