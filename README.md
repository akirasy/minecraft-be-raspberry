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

### 5. Configure `server.properties` (Important)

Open `./data/server.properties` in a text editor and change the transport setting from `nethernet` to `raknet`:

```
# Change this:
# transport=nethernet

# To this:
transport=raknet
```

> ⚠️ **Note:** The default `transport=nethernet` uses TCP signaling handshakes, which breaks connections on mobile clients when only UDP ports are published in Docker. Switching to `raknet` ensures standard UDP connectivity works out of the box.

### 6. Build the Docker Image

```
docker compose build -t mcberaspberry
```

### 7. Run the Container

Start the server in detached mode:

```
docker compose up -d
```

## Interacting with the Server Console

Because the entrypoint routes input through a named pipe, you can safely attach to the container console to run in-game commands (e.g., `op <player>`, `list`, `say Hello`).

### Attaching to the Console

```
docker attach mcberaspberry
```

### Detaching Safely

To exit the console **without stopping the container**, press the detach key sequence:

```
CTRL + P followed by CTRL + Q
```

> ⚠️️ **Warning:** Pressing `CTRL + C` while attached will send a termination signal to the entrypoint script and stop the Minecraft server. Always use `CTRL + P` then `CTRL + Q` to detach.

## License

Distributed under the MIT License. See `LICENSE` for more information.