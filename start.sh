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

echo "Starting $CONTAINER_NAME..."

docker run -d \
  --name "$CONTAINER_NAME" \
  -i \
  -t \
  --stop-timeout 30 \
  -e BOX64_DYNAREC_BIGBLOCK=1 \
  -e BOX64_DYNAREC_STRONGMEM=1 \
  -e BOX64_DYNAREC_SAFEFLAGS=0 \
  -e BOX64_DYNAREC_CALLRET=1 \
  -e BOX64_DYNAREC_WAIT=1 \
  -e LD_LIBRARY_PATH=. \
  -p 19132:19132/tcp \
  -p 19132:19132/udp \
  -p 19133:19133/udp \
  -v ./data:/data \
  "$CONTAINER_NAME"

echo "Container $CONTAINER_NAME started successfully!"

