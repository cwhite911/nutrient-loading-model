# du -sh ~/Documents/QL2_DEMS/10m/*

BASEDIR="/home/coreywhite/Documents/QL2_DEMS/10m/FranklinCoNC"

cd $BASEDIR
# Import rasters
for f in *.asc; do
        r=`basename $f .asc`
        r.import input=$f output="${r}"
done

# for d in /your/first/dir /your/second/dir /your/third/dir; do
# cd ${d}
# # Import rasters
# for f in *.tif; do
#    r=`basename $f .tif`
#    r.in.gdal input=$f output="${r}"
# done
# done
# g.region res=10
# for d in /home/coreywhite/Documents/QL2_DEMS/10m/*; do
#     for i in ${d}/*; do 
#         if [ -d "$i" ]; then
#             for f in ${i}/Rasters/QL2/DEM10/*.asc; do
#                 r=`basename $f .asc`
#                 r.import input=$f output="${r}"
#             done
#         fi
#     done
# done


# Set hard limit for concurrent open files on os
# ulimit -n 15000
# ulimit -s 65536
# MAPS=`g.list type=raster separator=comma pat="D10_*"`
# MAPS1=`g.list type=raster separator=comma pat="D10_37_1*"`
# MAPS2=`g.list type=raster separator=comma pat="D10_37_2*"`

# echo ${#MAPS}
# echo ${#MAPS1}
# echo ${#MAPS2}


# g.region raster=$MAPS1 res=10 -p
# r.patch input=$MAPS1 output=dem_10m_mosaic_1 --overwrite

# g.region raster=$MAPS2 res=10 -p
# r.patch input=$MAPS2 output=dem_10m_mosaic_2 --overwrite

# g.region raster=dem_10m_mosaic_1,dem_10m_mosaic_2 res=10 -p
# r.patch input=dem_10m_mosaic_1,dem_10m_mosaic_2 output=dem_10m_mosaic --overwrite


# r.watershed elevation=dem_10m_mosaic threshold=10000 drainage=direction_10k stream=streams_10k basin=basin_10k accumulation=accum_10k memory=10000 -m --overwrite
# r.thin streams_50k out=streams_50k_thin --o
# r.to.vect streams_50k_thin out=streams_50k_thin type=line
# d.vect streams_10k_thin co=blue

# r.stream.order stream_vect=streams direction=direction_10k strahler=riverorder_strahler
#r.water.outlet input=direction_10k output=basin coordinates=<east,north>


# BASEDIR="/home/coreywhite/Documents/NLCD_Land_Cover_L48_20190424_full_zip/"
# cd $BASEDIR
# # Import rasters
# for f in *.img; do
#         r=`basename $f .img`
#         r.import input=$f output="${r}"  extent=region resolution=region memory=8000
# done

# r.recode input=NLCD_2016_Land_Cover_L48_20190424 output=mancover rules=/home/coreywhite/Documents/GitHub/FallsJordan/nutrient-loading-model/model/features/land_to_mannings.txt

nwalt_landuse_1974|1974|1974
nwalt_landuse_1982|1982|1982
nwalt_landuse_1992|1992|1992
nwalt_landuse_2002|2002|2002
nwalt_landuse_2012|2012|2012
