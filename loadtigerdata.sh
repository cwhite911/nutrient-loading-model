# Load Tiger Data

TMPDIR="/tmp/geodata"
mkdir -p $TMPDIR
UNZIPTOOL=unzip

WGETTOOL="/usr/bin/wget"
export PGBIN=/usr/lib/postgresql/12/bin
export PGPORT=5432
export PGHOST=localhost
export PGUSER=postgres
export PGPASSWORD=""
export PGDATABASE=WRRI
PSQL=${PGBIN}/psql
SHP2PGSQL=shp2pgsql
cd /tmp/geodata

wget https://www2.census.gov/geo/tiger/TIGER2019/PLACE/tl_2019_37_place.zip --mirror --reject=html
cd /tmp/geodata/www2.census.gov/geo/tiger/TIGER2019/PLACE
rm -f -r ${TMPDIR}/*.*
${PSQL} -c "DROP SCHEMA IF EXISTS tiger_staging CASCADE;"
${PSQL} -c "CREATE SCHEMA tiger_staging;"
for z in tl_2019_37*_place.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;
echo "Starting Tiger Download"
${PSQL} -c "CREATE TABLE tiger_data.NC_place(CONSTRAINT pk_NC_place PRIMARY KEY (plcidfp) ) INHERITS(tiger.place);" 
${SHP2PGSQL} -D -c -s 4269 -g the_geom   -W "latin1" tl_2019_37_place.dbf tiger_staging.nc_place | ${PSQL}
${PSQL} -c "ALTER TABLE tiger_staging.NC_place RENAME geoid TO plcidfp;SELECT loader_load_staged_data(lower('NC_place'), lower('NC_place')); ALTER TABLE tiger_data.NC_place ADD CONSTRAINT uidx_NC_place_gid UNIQUE (gid);"
${PSQL} -c "CREATE INDEX idx_NC_place_soundex_name ON tiger_data.NC_place USING btree (soundex(name));"
${PSQL} -c "CREATE INDEX tiger_data_NC_place_the_geom_gist ON tiger_data.NC_place USING gist(the_geom);"
${PSQL} -c "ALTER TABLE tiger_data.NC_place ADD CONSTRAINT chk_statefp CHECK (statefp = '37');"
cd /tmp/geodata
wget https://www2.census.gov/geo/tiger/TIGER2019/COUSUB/tl_2019_37_cousub.zip --mirror --reject=html
cd /tmp/geodata/www2.census.gov/geo/tiger/TIGER2019/COUSUB
rm -f -r ${TMPDIR}/*.*
${PSQL} -c "DROP SCHEMA IF EXISTS tiger_staging CASCADE;"
${PSQL} -c "CREATE SCHEMA tiger_staging;"
for z in tl_2019_37*_cousub.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;

${PSQL} -c "CREATE TABLE tiger_data.NC_cousub(CONSTRAINT pk_NC_cousub PRIMARY KEY (cosbidfp), CONSTRAINT uidx_NC_cousub_gid UNIQUE (gid)) INHERITS(tiger.cousub);" 
${SHP2PGSQL} -D -c -s 4269 -g the_geom   -W "latin1" tl_2019_37_cousub.dbf tiger_staging.nc_cousub | ${PSQL}
${PSQL} -c "ALTER TABLE tiger_staging.NC_cousub RENAME geoid TO cosbidfp;SELECT loader_load_staged_data(lower('NC_cousub'), lower('NC_cousub')); ALTER TABLE tiger_data.NC_cousub ADD CONSTRAINT chk_statefp CHECK (statefp = '37');"
${PSQL} -c "CREATE INDEX tiger_data_NC_cousub_the_geom_gist ON tiger_data.NC_cousub USING gist(the_geom);"
${PSQL} -c "CREATE INDEX idx_tiger_data_NC_cousub_countyfp ON tiger_data.NC_cousub USING btree(countyfp);"
cd /tmp/geodata
wget https://www2.census.gov/geo/tiger/TIGER2019/TRACT/tl_2019_37_tract.zip --mirror --reject=html
cd /tmp/geodata/www2.census.gov/geo/tiger/TIGER2019/TRACT
rm -f -r ${TMPDIR}/*.*
${PSQL} -c "DROP SCHEMA IF EXISTS tiger_staging CASCADE;"
${PSQL} -c "CREATE SCHEMA tiger_staging;"
for z in tl_2019_37*_tract.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;

${PSQL} -c "CREATE TABLE tiger_data.NC_tract(CONSTRAINT pk_NC_tract PRIMARY KEY (tract_id) ) INHERITS(tiger.tract); " 
${SHP2PGSQL} -D -c -s 4269 -g the_geom   -W "latin1" tl_2019_37_tract.dbf tiger_staging.nc_tract | ${PSQL}
${PSQL} -c "ALTER TABLE tiger_staging.NC_tract RENAME geoid TO tract_id;  SELECT loader_load_staged_data(lower('NC_tract'), lower('NC_tract')); "
	${PSQL} -c "CREATE INDEX tiger_data_NC_tract_the_geom_gist ON tiger_data.NC_tract USING gist(the_geom);"
	${PSQL} -c "VACUUM ANALYZE tiger_data.NC_tract;"
	${PSQL} -c "ALTER TABLE tiger_data.NC_tract ADD CONSTRAINT chk_statefp CHECK (statefp = '37');"
cd /tmp/geodata
cd /tmp/geodata/www2.census.gov/geo/tiger/TIGER2019/FACES/
rm -f -r ${TMPDIR}/*.*
${PSQL} -c "DROP SCHEMA IF EXISTS tiger_staging CASCADE;"
${PSQL} -c "CREATE SCHEMA tiger_staging;"
for z in tl_*_37*_faces*.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;

${PSQL} -c "CREATE TABLE tiger_data.NC_faces(CONSTRAINT pk_NC_faces PRIMARY KEY (gid)) INHERITS(tiger.faces);" 
for z in *faces*.dbf; do
${SHP2PGSQL} -D   -D -s 4269 -g the_geom -W "latin1" $z tiger_staging.NC_faces | ${PSQL}
${PSQL} -c "SELECT loader_load_staged_data(lower('NC_faces'), lower('NC_faces'));"
done

${PSQL} -c "CREATE INDEX tiger_data_NC_faces_the_geom_gist ON tiger_data.NC_faces USING gist(the_geom);"
	${PSQL} -c "CREATE INDEX idx_tiger_data_NC_faces_tfid ON tiger_data.NC_faces USING btree (tfid);"
	${PSQL} -c "CREATE INDEX idx_tiger_data_NC_faces_countyfp ON tiger_data.NC_faces USING btree (countyfp);"
	${PSQL} -c "ALTER TABLE tiger_data.NC_faces ADD CONSTRAINT chk_statefp CHECK (statefp = '37');"
	${PSQL} -c "vacuum analyze tiger_data.NC_faces;"
cd /tmp/geodata
cd /tmp/geodata/www2.census.gov/geo/tiger/TIGER2019/FEATNAMES/
rm -f -r ${TMPDIR}/*.*
${PSQL} -c "DROP SCHEMA IF EXISTS tiger_staging CASCADE;"
${PSQL} -c "CREATE SCHEMA tiger_staging;"
for z in tl_*_37*_featnames*.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;

${PSQL} -c "CREATE TABLE tiger_data.NC_featnames(CONSTRAINT pk_NC_featnames PRIMARY KEY (gid)) INHERITS(tiger.featnames);ALTER TABLE tiger_data.NC_featnames ALTER COLUMN statefp SET DEFAULT '37';" 
for z in *featnames*.dbf; do
${SHP2PGSQL} -D   -D -s 4269 -g the_geom -W "latin1" $z tiger_staging.NC_featnames | ${PSQL}
${PSQL} -c "SELECT loader_load_staged_data(lower('NC_featnames'), lower('NC_featnames'));"
done

${PSQL} -c "CREATE INDEX idx_tiger_data_NC_featnames_snd_name ON tiger_data.NC_featnames USING btree (soundex(name));"
${PSQL} -c "CREATE INDEX idx_tiger_data_NC_featnames_lname ON tiger_data.NC_featnames USING btree (lower(name));"
${PSQL} -c "CREATE INDEX idx_tiger_data_NC_featnames_tlid_statefp ON tiger_data.NC_featnames USING btree (tlid,statefp);"
${PSQL} -c "ALTER TABLE tiger_data.NC_featnames ADD CONSTRAINT chk_statefp CHECK (statefp = '37');"
${PSQL} -c "vacuum analyze tiger_data.NC_featnames;"
cd /tmp/geodata
cd /tmp/geodata/www2.census.gov/geo/tiger/TIGER2019/EDGES/
rm -f -r ${TMPDIR}/*.*
${PSQL} -c "DROP SCHEMA IF EXISTS tiger_staging CASCADE;"
${PSQL} -c "CREATE SCHEMA tiger_staging;"
for z in tl_*_37*_edges*.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;

${PSQL} -c "CREATE TABLE tiger_data.NC_edges(CONSTRAINT pk_NC_edges PRIMARY KEY (gid)) INHERITS(tiger.edges);"
for z in *edges*.dbf; do
${SHP2PGSQL} -D   -D -s 4269 -g the_geom -W "latin1" $z tiger_staging.NC_edges | ${PSQL}
${PSQL} -c "SELECT loader_load_staged_data(lower('NC_edges'), lower('NC_edges'));"
done

${PSQL} -c "ALTER TABLE tiger_data.NC_edges ADD CONSTRAINT chk_statefp CHECK (statefp = '37');"
${PSQL} -c "CREATE INDEX idx_tiger_data_NC_edges_tlid ON tiger_data.NC_edges USING btree (tlid);"
${PSQL} -c "CREATE INDEX idx_tiger_data_NC_edgestfidr ON tiger_data.NC_edges USING btree (tfidr);"
${PSQL} -c "CREATE INDEX idx_tiger_data_NC_edges_tfidl ON tiger_data.NC_edges USING btree (tfidl);"
${PSQL} -c "CREATE INDEX idx_tiger_data_NC_edges_countyfp ON tiger_data.NC_edges USING btree (countyfp);"
${PSQL} -c "CREATE INDEX tiger_data_NC_edges_the_geom_gist ON tiger_data.NC_edges USING gist(the_geom);"
${PSQL} -c "CREATE INDEX idx_tiger_data_NC_edges_zipl ON tiger_data.NC_edges USING btree (zipl);"
${PSQL} -c "CREATE TABLE tiger_data.NC_zip_state_loc(CONSTRAINT pk_NC_zip_state_loc PRIMARY KEY(zip,stusps,place)) INHERITS(tiger.zip_state_loc);"
${PSQL} -c "INSERT INTO tiger_data.NC_zip_state_loc(zip,stusps,statefp,place) SELECT DISTINCT e.zipl, 'NC', '37', p.name FROM tiger_data.NC_edges AS e INNER JOIN tiger_data.NC_faces AS f ON (e.tfidl = f.tfid OR e.tfidr = f.tfid) INNER JOIN tiger_data.NC_place As p ON(f.statefp = p.statefp AND f.placefp = p.placefp ) WHERE e.zipl IS NOT NULL;"
${PSQL} -c "CREATE INDEX idx_tiger_data_NC_zip_state_loc_place ON tiger_data.NC_zip_state_loc USING btree(soundex(place));"
${PSQL} -c "ALTER TABLE tiger_data.NC_zip_state_loc ADD CONSTRAINT chk_statefp CHECK (statefp = '37');"
${PSQL} -c "vacuum analyze tiger_data.NC_edges;"
${PSQL} -c "vacuum analyze tiger_data.NC_zip_state_loc;"
${PSQL} -c "CREATE TABLE tiger_data.NC_zip_lookup_base(CONSTRAINT pk_NC_zip_state_loc_city PRIMARY KEY(zip,state, county, city, statefp)) INHERITS(tiger.zip_lookup_base);"
${PSQL} -c "INSERT INTO tiger_data.NC_zip_lookup_base(zip,state,county,city, statefp) SELECT DISTINCT e.zipl, 'NC', c.name,p.name,'37'  FROM tiger_data.NC_edges AS e INNER JOIN tiger.county As c  ON (e.countyfp = c.countyfp AND e.statefp = c.statefp AND e.statefp = '37') INNER JOIN tiger_data.NC_faces AS f ON (e.tfidl = f.tfid OR e.tfidr = f.tfid) INNER JOIN tiger_data.NC_place As p ON(f.statefp = p.statefp AND f.placefp = p.placefp ) WHERE e.zipl IS NOT NULL;"
${PSQL} -c "ALTER TABLE tiger_data.NC_zip_lookup_base ADD CONSTRAINT chk_statefp CHECK (statefp = '37');"
${PSQL} -c "CREATE INDEX idx_tiger_data_NC_zip_lookup_base_citysnd ON tiger_data.NC_zip_lookup_base USING btree(soundex(city));"
cd /tmp/geodata
cd /tmp/geodata/www2.census.gov/geo/tiger/TIGER2019/ADDR/
rm -f ${TMPDIR}/*.*
${PSQL} -c "DROP SCHEMA IF EXISTS tiger_staging CASCADE;"
${PSQL} -c "CREATE SCHEMA tiger_staging;"
for z in tl_*_37*_addr*.zip ; do $UNZIPTOOL -o -d $TMPDIR $z; done
cd $TMPDIR;

${PSQL} -c "CREATE TABLE tiger_data.NC_addr(CONSTRAINT pk_NC_addr PRIMARY KEY (gid)) INHERITS(tiger.addr);ALTER TABLE tiger_data.NC_addr ALTER COLUMN statefp SET DEFAULT '37';" 
for z in *addr*.dbf; do
${SHP2PGSQL} -D   -D -s 4269 -g the_geom -W "latin1" $z tiger_staging.NC_addr | ${PSQL}
${PSQL} -c "SELECT loader_load_staged_data(lower('NC_addr'), lower('NC_addr'));"
done

${PSQL} -c "ALTER TABLE tiger_data.NC_addr ADD CONSTRAINT chk_statefp CHECK (statefp = '37');"
	${PSQL} -c "CREATE INDEX idx_tiger_data_NC_addr_least_address ON tiger_data.NC_addr USING btree (least_hn(fromhn,tohn) );"
	${PSQL} -c "CREATE INDEX idx_tiger_data_NC_addr_tlid_statefp ON tiger_data.NC_addr USING btree (tlid, statefp);"
	${PSQL} -c "CREATE INDEX idx_tiger_data_NC_addr_zip ON tiger_data.NC_addr USING btree (zip);"
	${PSQL} -c "CREATE TABLE tiger_data.NC_zip_state(CONSTRAINT pk_NC_zip_state PRIMARY KEY(zip,stusps)) INHERITS(tiger.zip_state); "
	${PSQL} -c "INSERT INTO tiger_data.NC_zip_state(zip,stusps,statefp) SELECT DISTINCT zip, 'NC', '37' FROM tiger_data.NC_addr WHERE zip is not null;"
	${PSQL} -c "ALTER TABLE tiger_data.NC_zip_state ADD CONSTRAINT chk_statefp CHECK (statefp = '37');"
	${PSQL} -c "vacuum analyze tiger_data.NC_addr;"