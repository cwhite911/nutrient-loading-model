-- Database: WRRI
-- DROP DATABASE "WRRI";
CREATE DATABASE "WRRI"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

ALTER DATABASE "WRRI"
    SET search_path TO "$user", public, topology;