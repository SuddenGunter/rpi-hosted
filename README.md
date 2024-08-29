# rpi-hosted

Backup of things I run on my Raspberry Pi 4 4GB.

## V3 (current version)

I got tired of kubernetes limitations when trying to use a single RPi mostly for IoT stuff.

Went back to docker-compose files.

# TODO VPN:
- https://coredns.io/explugins/records/ + hosted/wireguard

## K3s (v2 / deprecated)

Pi 4 (4GB) running ubuntu server and k3s.

For zigbee I use connbee 2 + zigbee2mqtt (eclipse/mosquitto used as mqtt broker).

Node-RED is used for some basic home automation, I'm not going back to home assistant at least in current setup.

Wireguard is not used, cause external access is not required yet.

## hosted (v1 / deprecated)

Mostly includes stuff from previous Pi deployment and I do not use it on my current production deployment.
Everything in here is configured via docker-compose.
Traefik is used as ingress for all internal web dashboards.
For zigbee I use connbee 2 + deconz and home assistant (via docker). Home assistant via docker is a joke, just don't use it, it has too much limitations and breaks randomly after power outages.
Wireguard tunnel through VPS is used as a cool option for accessing Pi from external network without opening access to Pi on router.