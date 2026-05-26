#!/usr/bin/env bash

set -e

set -o pipefail

set -o nounset


working_dir="$(dirname ${0})"

source "${working_dir}/_sourced/constants.sh"
source "${working_dir}/_sourced/messages.sh"

message_welcome "Backing up '${POSTGRES_DB}' database..."

if [[ "${POSTGRES_USER}" == 'postgres' ]]; then
    message_error "Backing up as 'postgres' user is not supported. Assign 'POSTGRES_USER' to a different user and try again."
    exit 1
fi

export PGHOST="${POSTGRES_HOST}"
export PGPORT="${POSTGRES_PORT}"
export PGUSER="${POSTGRES_USER}"
export PGDATABASE="${POSTGRES_DB}"
export PGPASSWORD="${POSTGRES_PASSWORD}"

backup_filename="${BACKUP_FILE_PREFIX}_$(date +'%Y_%m_%dT%H_%M_%S').sql.gz"

mkdir -p "${BACKUP_DIR_PATH}"

if ! pg_dump | gzip > "${BACKUP_DIR_PATH}/${backup_filename}"; then
    message_error " Database backup failed. Please check the postgres logs for more details."
    exit 1
fi

message_success "'${POSTGRES_DB}' database backup completed successfully: '${backup_filename}' -> '${BACKUP_DIR_PATH}'"
