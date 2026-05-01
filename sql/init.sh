#!/usr/bin/env bash
# ==============================================================================
# Postgres docker-entrypoint init hook.
#
# The postgres image's entrypoint only processes files at the top
# level of /docker-entrypoint-initdb.d/ — it ignores subdirectories.
# This script bridges that gap by iterating every *.sql file in
# /repo/sql/schema/ and /repo/sql/seed/ in alphabetical order.
#
# Schema files load first (DDL: types, tables, indexes), then seed
# files (per-phase data). Each file is run with ON_ERROR_STOP=1, so
# the first failure aborts container startup.
# ==============================================================================

set -euo pipefail

run_dir() {
    local dir="$1"
    local label="$2"

    if [ ! -d "$dir" ]; then
        echo "init.sh: directory $dir does not exist, skipping $label"
        return 0
    fi

    shopt -s nullglob
    local files=("$dir"/*.sql)
    shopt -u nullglob

    if [ ${#files[@]} -eq 0 ]; then
        echo "init.sh: no .sql files in $dir, skipping $label"
        return 0
    fi

    echo "init.sh: applying $label from $dir"
    for f in "${files[@]}"; do
        echo "init.sh:   $f"
        psql \
            --username "$POSTGRES_USER" \
            --dbname "$POSTGRES_DB" \
            --set=ON_ERROR_STOP=on \
            --file "$f"
    done
}

run_dir /repo/sql/schema "schema"
run_dir /repo/sql/seed   "seed"
