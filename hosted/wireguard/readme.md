# VPN

Config files in this directory allow creating network shown on the diagram below.

![Alt text](network.png?raw=true "Network diagram")

## Use cases

I've an RPI hosting some services. I could access them in my LAN, but I also want to access them from the Internet.

I also want this connection to be private, secure and I do not trust my firewall setup and do not want to enable any DMZ/port-forwarding features on my router.

## Solution

RPI has a systemd service that enables wireguard on boot.
Wireguard connects to VPS in the public cloud with connection keep-alive enabled.
iPhone can connect to VPS (wireguard port is open) and it will proxy private services traffic to RPI.
Clients in same the LAN with RPI could connect bypassing VPS directly to RPI if `Endpoint` parameter is set.

## *_A suffix

This config doesn't cover all devices in my network, it's mostly sample/demo/documentation on how to set up it next time I need it. There are multiple PC's, phones, etc - so I use suffixes to differentiate them. This repo only contains configs for `*_A` clients (`PC_A`, `IPHONE_A`).

## How to setup

Generate a public and private keys for each node (they all act as servers and clients). Each node (client/server) should have it's own pair of keys:

```bash
wg genkey > private
wg pubkey < private > public
chmod 400 private
chmod 400 public
```

Select your subnet IP and subnet mask. I've chosen `10.0.42.0/24`, it allows me to have 254 clients (`10.0.42.1 ... 10.0.42.254`) and it's more than I need (I do not own 200+ devices yet).

Then follow the setup in any order, I recommend (from easiest to hardest):

- VPS - easiest to set up, just don't forget to close other ports except for wireguard, even ssh, you would be able to access it via wireguard and private IP.

Note: I suggest configuring firewall on your cloud provider networking settings (AWS security groups, digital ocean firewall), because if you do something stupid - you could still change it without losing access to VPS and having to recreate it. I suggest enabling wireguard auto-start on boot (wh0.conf should be at /etc/wireguard/wg0.conf or it will not work):

```bash
sudo systemctl enable wg-quick@wg0
sudo systemctl start wg-quick@wg0
```

- PC_A - after setting this up, comment out the `DNS` line in your `PC_A` config and test the VPN. How to test it? Just ping your VPS:

```bash
ping  10.0.42.1

PING 10.0.42.1 (10.0.42.1) 56(84) bytes of data.
64 bytes from 10.0.42.1: icmp_seq=1 ttl=64 time=71.1 ms
64 bytes from 10.0.42.1: icmp_seq=2 ttl=64 time=34.6 ms
64 bytes from 10.0.42.1: icmp_seq=3 ttl=64 time=34.5 ms
64 bytes from 10.0.42.1: icmp_seq=4 ttl=64 time=34.5 ms
^C
--- 10.0.42.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3003ms
rtt min/avg/max/mdev = 34.525/43.685/71.126/15.843 ms
```

If this step doesn't work - something is broken and there is no sense in setting up other clients, fix this problem first. You might've forgotten to open `VPS` port, put the wrong IP in your config etc.

If everything works - uncomment DNS line and restart the VPN client on your `PC_A`.

- RPI - nothing interesting, except multiple `AllowedIPs` for `VPS`. Those are for all clients who can't connect to `RPI` directly and will go via `VPS`. I also suggest enabling wireguard auto-start on boot (see `VPS` section on how to do it).
- iPhone_A - I suggest using `qrencode -t png -o client-qr.png -r wg0.conf` to share your iphone config with mobile app.
