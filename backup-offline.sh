#!/usr/bin/env bash

set -e

# Load shared config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/config.sh" ]; then
    source "$SCRIPT_DIR/config.sh"
else
    echo "Error: config.sh not found."
    exit 1
fi

BACKUP_DIR="$PWD/world-backups"
SOURCE_DIR="$PWD/data"
TIMESTAMP=$(date +"%y%m%d_%H%M")
ARCHIVE_NAME="${WORLD_NAME}_${TIMESTAMP}.tar"

# Ensure the destination backup directory exists
mkdir --parents "$BACKUP_DIR"

echo -e "Starting Minecraft Bedrock backup...\n"

MANDATORY_BACKUP=(
    "worlds"
    "server.properties"
)

OPTIONAL_FILES=(
    "permissions.json"
    "allowlist.json"
)

OPTIONAL_FOLDERS=(
    "config"
)

# Start with mandatory items
FILES_TO_BACKUP=("${MANDATORY_BACKUP[@]}")

# Dynamically add optional files if they exist
for file in "${OPTIONAL_FILES[@]}"; do
    [[ -e "$SOURCE_DIR/$file" ]] && FILES_TO_BACKUP+=("$file")
done

# Dynamically add optional folders if they exist
for folder in "${OPTIONAL_FOLDERS[@]}"; do
    [[ -d "$SOURCE_DIR/$folder" ]] && FILES_TO_BACKUP+=("$folder")
done

# Run tar backup
tar \
    --create \
    --verbose \
    --file="$BACKUP_DIR/$ARCHIVE_NAME" \
    --directory="$SOURCE_DIR" \
    "${FILES_TO_BACKUP[@]}"

echo -e "\nBackup successfully created:\n  - $BACKUP_DIR/$ARCHIVE_NAME"

