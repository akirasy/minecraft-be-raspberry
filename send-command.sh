#!/bin/bash

# Exit immediately if no command argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <minecraft-command>"
  echo "Example: $0 gamerule pvp false"
  exit 1
fi

CONTAINER_NAME="mcberaspberry"
COMMAND="$*"

# Pass the command string into the container's named pipe
docker exec "$CONTAINER_NAME" sh -c "echo \"$COMMAND\" > /tmp/bedrock_stdin"

if [ $? -eq 0 ]; then
  echo "Sent command: $COMMAND"
else
  echo "Failed to send command to $CONTAINER_NAME"
fi