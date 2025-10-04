#!/bin/bash

IMAGE_TAG="v1.0"
HOSTING_PATH="/todo" # TODO: update
PUID="1000" # TODO: update
PGID="1000" # TODO: update
LAN_NET="192.168.0.0" # TODO: update

CONFIG_PATH="${HOSTING_PATH}/qbit/config"
DOWNLOADS_PATH="${HOSTING_PATH}/qbit/downloads"

docker run -d \
  -v "${CONFIG_PATH}:/config" \
  -v "${DOWNLOADS_PATH}:/downloads" \
  -e "QBT_LEGAL_NOTICE=confirm" \
  -e "PUID=${PUID}" \
  -e "PGID=${PGID}" \
  -e "LAN_NETWORK=${LAN_NET}/24" \
  -e "TZ=Etc/UTC" \
  -e "HEALTH_CHECK_INTERVAL=600" \
  -p 8080:8080 \
  --privileged \
  --cap-add NET_ADMIN \
  --sysctl "net.ipv4.conf.all.rp_filter=2" \
  --sysctl "net.ipv4.conf.all.src_valid_mark=1" \
  --sysctl "net.ipv6.conf.all.disable_ipv6=1" \
  --restart unless-stopped \
  --name qbittorrent-wireguard \
  "ghcr.io/suddengunter/docker-qbittorrent-wireguard:${IMAGE_TAG}"