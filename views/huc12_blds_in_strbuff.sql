 WITH hu12_buildings AS (
         SELECT hu12.huc_12,
            hu12.hu_12_name,
            hu12.huc_10,
            hu12.hu_10_name,
            hu12.dwq_basin,
            hu12.huc_8,
            hu12.dig_8,
            hu12.states,
            hu12.meta_id,
            hu12.fid,
            bf.bldg_id,
            bf.year_built,
            bf.occup_type,
            st_area(bf.geom) AS total_area,
            bf.htd_sq_ft::numeric / 10.764 AS htd_sq_m,
            bf.geom AS bf_geom,
            hu12.geom AS hu12_geom
           FROM huc12_study_area hu12
             JOIN building_footprints bf ON st_contains(hu12.geom, st_centroid(bf.geom))
        )
 SELECT hu_bld.huc_12,
    hu_bld.hu_12_name,
    hu_bld.huc_10,
    hu_bld.hu_10_name,
    hu_bld.dwq_basin,
    hu_bld.huc_8,
    hu_bld.dig_8,
    hu_bld.states,
    hu_bld.meta_id,
    hu_bld.fid,
    hu_bld.year_built,
    count(hu_bld.bldg_id) AS new_buildings,
    sum(count(hu_bld.bldg_id)) OVER (PARTITION BY hu_bld.hu_12_name ORDER BY hu_bld.hu_12_name, hu_bld.year_built ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS total_buildings,
    sum(sum(hu_bld.total_area)) OVER (ORDER BY hu_bld.hu_12_name, hu_bld.year_built) / '1000000'::numeric::double precision AS total_building_sq_km,
    sum(sum(hu_bld.htd_sq_m)) OVER (ORDER BY hu_bld.hu_12_name, hu_bld.year_built) / '1000000'::numeric AS total_heated_sq_km,
    hu_bld.hu12_geom AS geom
   FROM hu12_buildings hu_bld,
    stream_buffers_30m sb
  WHERE st_intersects(hu_bld.bf_geom, sb.geom)
  GROUP BY hu_bld.huc_12, hu_bld.hu_12_name, hu_bld.huc_10, hu_bld.hu_10_name, hu_bld.dwq_basin, hu_bld.huc_8, hu_bld.dig_8, hu_bld.states, hu_bld.meta_id, hu_bld.fid, hu_bld.year_built, hu_bld.hu12_geom
  ORDER BY hu_bld.hu_12_name, hu_bld.year_built;