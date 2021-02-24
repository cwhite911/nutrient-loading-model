 WITH hu12_buildings AS (
         SELECT hu12.huc_12,
            hu12.hu_12_name,
            hu12.hu_10_name,
            hu12.dwq_basin,
            bf.bldg_id,
            bf.year_built,
            bf.occup_type,
            st_area(st_setsrid(bf.geom, 6542)) AS total_area,
            bf.htd_sq_ft::numeric / 10.764 AS htd_sq_m,
            st_setsrid(bf.geom, 6542) AS bf_geom,
            hu12.geom AS hu12_geom
           FROM huc12_study_area hu12
             JOIN building_footprints bf ON st_contains(hu12.geom, st_centroid(st_setsrid(bf.geom, 6542)))
        )
 SELECT hu_bld.huc_12,
    hu_bld.hu_12_name,
    hu_bld.year_built,
    hu_bld.hu_10_name,
    hu_bld.dwq_basin,
    count(hu_bld.bldg_id) AS new_buildings,
    sum(count(hu_bld.bldg_id)) OVER (PARTITION BY hu_bld.hu_12_name ORDER BY hu_bld.hu_12_name, hu_bld.year_built ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS total_buildings,
    sum(sum(hu_bld.total_area)) OVER (ORDER BY hu_bld.hu_12_name, hu_bld.year_built) / '1000000'::numeric::double precision AS total_building_sq_km,
    sum(sum(hu_bld.htd_sq_m)) OVER (ORDER BY hu_bld.hu_12_name, hu_bld.year_built) / '1000000'::numeric AS total_heated_sq_km,
    hu_bld.hu12_geom AS geom
   FROM hu12_buildings hu_bld
  GROUP BY hu_bld.huc_12, hu_bld.hu_12_name, hu_bld.year_built, hu_bld.hu_10_name, hu_bld.dwq_basin, hu_bld.hu12_geom
  ORDER BY hu_bld.hu_12_name, hu_bld.year_built;