#!/bin/sh

set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

# Restore Backup
pg_restore -d WRRI /etc/postgresql/wrri_pg_bak

