#!/bin/bash

set -e
set -o pipefail
set -o nounset

python << EOF
import sys
import time
import psycopg2
suggest_unrecoverable_after = 30
start = time.time()
while True:
  try:
    psycopg2.connect(
    dbname="${POSTGRES_DB}",
    user="${POSTGRES_USER}",
    password="${POSTGRES_PASSWORD}",
    host="${POSTGRES_HOST}",
    port="${POSTGRES_PORT}",
    )
    break
  except psycopg2.OperationalError as error:
    sys.stderr.write("Waiting for postgres database to be available...\n") 
    if time.time() - start > suggest_unrecoverable_after:
      sys.stderr.write(" This is taking a while. The following exception may indicate an unrecoverable error: '{}'\n".format(error))
    time.sleep(3)
EOF

echo >&2 " Postgres Database is Available..."
exec "$@"