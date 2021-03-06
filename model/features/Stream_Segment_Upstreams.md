# Stream Segment Analysis

Investigate the differnce between contributing areas for stream segments
with and without stream buffers.

## Data

  - DEM - 10m or 30m
  - Subwaterheds defined by study or derived through DEM data/maybe
    compare results
  - Land-Use we can either use NWALT or NLCD

## Methods

1.  Calculate stream segments.

Use GRASS GIS r.watershed to get stream flow accumulation,
streams,

[r.stream.segment](https://grass.osgeo.org/grass78/manuals/addons/r.stream.segment.html)

``` r
# Shell GRASS Example
#g.region -p -a raster=elevation
#r.watershed elevation=elevation threshold=10000 drainage=direction_10k stream=streams
#r.stream.order stream_vect=streams direction=direction_10k strahler=riverorder_strahler
#r.stream.segment stream_rast=riverorder_strahler direction=direction_10k \
#  elevation=elevation segments=river_segment sectors=river_sector
```

2.  Calculate the contributing
area.

[r.water.outlet](https://grass.osgeo.org/grass79/manuals/r.water.outlet.html)

``` r
# the watershed outlet position should be placed on a stream (from
# accumulation map):
# r.watershed elev_lid792_1m threshold=5000 accumulation=accum_5K drainage=draindir_5K basin=basin_5K
# r.water.outlet input=direction_10k output=basin coordinates=<east,north>
```

3.  Calculate total area of defined land-use in contributing
area.

<!-- end list -->

``` r
# 1. Set the computational region to the calcuated basin (contributing area)
# 2. Use r.stats to calculate total area of each land-use within basin and save results
# 3. Repeat this step and save results to db
```

4.  Compare land-use in contributing areas from buffered and unbuffered
    stream
segments.

<!-- end list -->

``` r
# Use calcuated data to analysize if a statistical difference exists between land-use distribution in the contributing 
# areas a buffered vs. unbuffered stream segments.
```

## Results
