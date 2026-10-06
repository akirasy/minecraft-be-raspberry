FROM debian:stable-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    box64 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

WORKDIR /data

EXPOSE 19132/udp
EXPOSE 19133/udp

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]