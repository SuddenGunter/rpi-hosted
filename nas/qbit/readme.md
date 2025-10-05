# qbittorrent with wireguard

1. Create config folder that your docker container will be able to mount
2. Put your wireguard config into `config/wireguard/wg0.conf`
3. In docker-compose don't forget to change set correct env variables. If you want to have access to torrent UI via VPN you also need to add VPN network into LAN_NETWORK env variable.
4. Access the webUI, The default credentials to log in are:

```
    Username: admin
    Password: adminadmin
```

5. In the qBittorrent web UI, go to Tools -> Options -> Advanced and set Network Interface to wg0
6. Enable VueTorrent UI if needed (see wiki in https://github.com/tenseiken/docker-qbittorrent-wireguard)
7. Configure correct download directories for temp files and finished downloads.

## Wireguard config example (for NAS):

```
[Interface]
Address = 1.1.1.1/32
PrivateKey = abc_private_key

# VPN server
[Peer]
PublicKey = vpn_pub_key
AllowedIPs = 0.0.0.0/0 # Forward all traffic to server
Endpoint = vpnip:port 
```

For server config see v3/vps