#!/usr/bin/env bash

set -e

set -o pipefail

set -o nounset


working_dir="$(dirname ${0})"

source "${working_dir}/_sourced/constants.sh"
source "${working_dir}/_sourced/messages.sh" 

if [[ ! -d "${BACKUP_DIR_PATH}" ]]; then
    message_error "Backup directory does not exist: ${BACKUP_DIR_PATH}"
    exit 1
fi

if [[ -z "$(ls -A "${BACKUP_DIR_PATH}")" ]]; then
    message_info "No backups found yet"
    exit 0
fi

message_welcome "These are the available backups you've created so far:"

echo "Timestamp               Size     Filename"
echo "---------------------   -----    --------"

find "$BACKUP_DIR_PATH" -type f -printf '%T@|%p\n' \
| sort -nr \
| while IFS='|' read -r epoch file; do

    timestamp=$(date -d @"$epoch" "+%Y-%m-%d %H:%M:%S")
    size=$(du -h "$file" | cut -f1)
    filename=$(basename "$file")

    printf "%-21s %-10s %s\n" "$timestamp" "$size" "$filename"

done