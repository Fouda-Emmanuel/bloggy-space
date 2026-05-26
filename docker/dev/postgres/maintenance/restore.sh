#!/usr/bin/env bash

set -e

set -o pipefail

set -o nounset


working_dir="$(dirname ${0})"

source "${working_dir}/_sourced/constants.sh"
source "${working_dir}/_sourced/messages.sh"
source "${working_dir}/_sourced/yes_no.sh"

if [[ -z ${1+x} ]]; then
    message_error "Backup file not specified. Please provide a backup filename as an argument."
    message_newline
    message_info "Usage: restore.sh <backup_filename>"
    message_newline
    exit 1
fi

backup_filename="${BACKUP_DIR_PATH}/${1}"

if [[ ! -f "${backup_filename}" ]]; then
    message_error "No backup found with the specified filename: '${backup_filename}'. Please check the available backups in the '${BACKUP_DIR_PATH}' directory and try again."
    exit 1
fi 

message_welcome "Restoring '${POSTGRES_DB}' database from backup file: '${backup_filename}'..."

if [[ "${POSTGRES_USER}" == 'postgres' ]]; then
    message_error "Restoring as the default 'postgres' user is not supported. Please assign a different 'POSTGRES_USER' and try again."
    exit 1
fi

export PGHOST="${POSTGRES_HOST}"
export PGPORT="${POSTGRES_PORT}"
export PGUSER="${POSTGRES_USER}"
export PGDATABASE="${POSTGRES_DB}"
export PGPASSWORD="${POSTGRES_PASSWORD}"

message_info "Checking PostgreSQL server availability at '${POSTGRES_HOST}:${POSTGRES_PORT}' with user '${POSTGRES_USER}'..."

if ! pg_isready -h "${POSTGRES_HOST}" -p "${POSTGRES_PORT}" -U "${POSTGRES_USER}" > /dev/null 2>&1; then
    message_error "PostgreSQL server unreachable at '${POSTGRES_HOST}:${POSTGRES_PORT}' with user '${POSTGRES_USER}'. Please ensure the server is running and the network connection is available, then try again."
    exit 1
fi
message_success "PostgreSQL server is reachable at '${POSTGRES_HOST}:${POSTGRES_PORT}' with user '${POSTGRES_USER}'."

message_info "Checking Authentication for user '${POSTGRES_USER}'..."

if ! psql -h "${POSTGRES_HOST}" -p "${POSTGRES_PORT}" -U "${POSTGRES_USER}" -c "SELECT 1" > /dev/null 2>&1; then
    message_error "Authentication failed for user '${POSTGRES_USER}' at '${POSTGRES_HOST}:${POSTGRES_PORT}'. Please verify the POSTGRES_USER and POSTGRES_PASSWORD and try again."
    exit 1
fi
message_success "Authentication successful for user '${POSTGRES_USER}' at '${POSTGRES_HOST}:${POSTGRES_PORT}'."


message_info "Checking if database '${POSTGRES_DB}' exists..."

if ! psql -lqt | cut -d \| -f 1 | grep -qw "${POSTGRES_DB}"; then
    message_error "Database '${POSTGRES_DB}' does not exist."
    exit 1
fi
message_success "Database '${POSTGRES_DB}' exists and is ready for restore."

message_info "This operation will permanently drop the existing '${POSTGRES_DB}' database. Are you sure you want to proceed?"

if ! yes_no "Proceed with restore"; then
    message_info "Database restore cancelled."
    exit 0
fi

message_info "Terminating existing database connections..."

psql -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '${POSTGRES_DB}' AND pid <> pg_backend_pid();" postgres
sleep 2

message_info "Dropping existing database..."

dropdb "${PGDATABASE}"

message_info "Creating new database..."

createdb --owner="${POSTGRES_USER}" "${POSTGRES_DB}"

message_info "Restoring new database from backup file..."

gunzip -c "${backup_filename}" | psql -U "${POSTGRES_USER}" -h "${POSTGRES_HOST}" -p "${POSTGRES_PORT}" "${POSTGRES_DB}"

message_success "'${POSTGRES_DB}' database restore completed successfully from backup file: '${backup_filename}'"