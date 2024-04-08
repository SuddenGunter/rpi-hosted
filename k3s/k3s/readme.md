# k3s

Default setup based on official documentation without any customization whatsoever. 
Don't want to write a manual/script in here, just go to k3s website and follow from there.
SQLite used as a storage, cause I only have 1 node.

## Ingress

K3s comes with Traefik, but I did not configure it yet. When I need to access zigbee2mqtt or node-red I just use kubectl port-forward.