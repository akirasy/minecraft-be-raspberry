#!/usr/bin/env bash

set -e

# Load shared config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/config.sh" ]; then
    source "$SCRIPT_DIR/config.sh"
fi

send_cmd() {
    "$SCRIPT_DIR/send-command.sh" "$@"
}

cleanup() {
    EXIT_CODE=$?
    echo -e "\n[Cleanup] Resuming world saving..."
    send_cmd save resume > /dev/null 2>&1 || true
    if [ $EXIT_CODE -eq 0 ]; then
        echo "Backup process completed successfully."
    else
        echo "Backup process failed or was interrupted."
    fi
    exit $EXIT_CODE
}
trap cleanup EXIT

echo "=== Starting Minecraft Bedrock Backup Workflow ($CONTAINER_NAME) ==="

echo "Step 1/3: Placing world in save hold..."
send_cmd save hold
sleep 2

echo -e "\nStep 2/3: Querying save state..."
send_cmd save query
sleep 1

echo -e "\nStep 3/3: Creating backup archive..."
"$SCRIPT_DIR/backup-offline.sh"

echo -e "\n=== Workflow Finished Successfully ==="

