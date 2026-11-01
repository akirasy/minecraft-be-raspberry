# Minecraft Bedrock Server on Raspberry Pi (Docker)

A lightweight Docker setup for hosting a **Minecraft Bedrock Dedicated Server** on a **Raspberry Pi** (or ARM64 Linux hosts) using **Box64** for `x86_64` execution.

## Quick Start

### 1. Clone the Repository

Git clone this repository and `cd` into it.

```
git clone https://github.com/akirasy/minecraft-be-raspberry.git
```

### 2. Create the Data Directory

Create a local `./data` directory to store server files and persistent world data

```
mkdir -p ./data
```

### 3. Download the Minecraft Bedrock Server

Download the latest **Minecraft Bedrock Server** zip file directly from the [official Minecraft download page](https://www.minecraft.net/en-us/download/server/bedrock).

### 4. Unpack Server Files

Extract the contents of the downloaded zip file into the `./data` folder:

```
unzip bedrock-server-*.zip -d ./data
```

### 5. Configure Central Settings

All container and world variables are managed centrally in `config.sh`. Review or edit `config.sh`:

```
CONTAINER_NAME="mcberaspberry"
WORLD_NAME="mcberaspberry"
```

> Note: A symbolic link `.env` -> `config.sh` allows Docker Compose to automatically pick up `${CONTAINER_NAME}` alongside your Bash scripts.

### 6. Configure `server.properties` (Important)

Open `./data/server.properties` in a text editor and ensure transport is set to `nethernet`:

```
transport=nethernet
enable-lan-visibility=true
```

> ⚠️ **Note:** Latest releases of the Bedrock Dedicated Server (v1.26.61) strictly require nethernet. NetherNet uses TCP port 19132 for initial signaling handshakes alongside standard UDP ports for gameplay. Ensure TCP 19132 is exposed in Docker.

### 7. Build the Docker Image

```
docker compose build -t mcberaspberry
```

### 8. Run the Container

Start the server in detached mode:

```
docker compose up -d
```

## Interacting with the Server Console

Because the entrypoint routes input through a named pipe, use `send-command.sh` file to run in-game commands (e.g., `op <player>`, `list`, `say Hello`).

### Send in-game commands

```
send-command.sh gamerule pvp false
```

### Watch docker logs

Review to return output of the command given.

```
docker logs -f mcberaspberry
```

### Backing Up the Server

The repository provides two backup scripts depending on whether your server is actively running or stopped. Archives are saved to `./world-backups/`.

#### Live Server Backup (Online)
Use this command when the Docker container is running and players are active:

```
./backup-online.sh
```

#### Direct File Backup (Offline)
Use this command when the server container is stopped:

```
./backup-offline.sh
```

## License

Distributed under the MIT License. See `LICENSE` for more information.
