#!/bin/bash

# Create a named pipe for console input
PIPE="/tmp/bedrock_stdin"
mkfifo "$PIPE"

# Handle termination signal from Docker (SIGTERM / SIGINT)
graceful_shutdown() {
  echo "[Entrypoint] Caught termination signal. Gracefully stopping Minecraft..."
  echo "stop" > "$PIPE"
  wait "$SERVER_PID"
  echo "[Entrypoint] Minecraft server stopped cleanly."
  exit 0
}

trap 'graceful_shutdown' SIGTERM SIGINT

# Start Box64 Bedrock server, reading input from the pipe
tail -f "$PIPE" | box64 ./bedrock_server &
SERVER_PID=$!

# Keep pipe open and wait for process
wait "$SERVER_PID"