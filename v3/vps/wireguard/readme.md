# VPN

Config files in this directory allow creating network shown on the diagram below.

![Network diagram](network.png?raw=true "Network diagram")

## Use cases

I've an RPI hosting some services. I could access them in my LAN, but I also want to access them from the Internet.

I also want this connection to be private, secure and I do not trust my firewall setup and do not want to enable any DMZ/port-forwarding features on my router.

## DNS

This wireguard config depends on DNS server running on VPS. See v3/vps/dns on guide how to configure it.

## Solution

RPI has a systemd service that enables wireguard on boot.
Wireguard connects to VPS in the public cloud with connection keep-alive enabled.
iPhone can connect to VPS (wireguard port is open) and it will proxy private services traffic to RPI.

### Deprecated features

My old VPN config in hosted/wireguard allowed clients in same the LAN with RPI connect bypassing VPS directly to RPI if `Endpoint` parameter is set.
Current configuration does not allows it.

## How to setup

Generate a public and private keys for each node (they all act as servers and clients). Each node (client/server) should have it's own pair of keys:

```bash
wg genkey > private
wg pubkey < private > public
chmod 400 private
chmod 400 public
```

Select your subnet IP and subnet mask. Replace __PRIVATE_SUBNET__ with your subnet base like `10.0.42`.

Then follow the setup in any order, I recommend (from easiest to hardest):

- VPS - easiest to set up, just don't forget to close other ports except for wireguard, even ssh, you would be able to access it via wireguard and private IP.

Note: I suggest configuring firewall on your cloud provider networking settings (AWS security groups, digital ocean firewall), because if you do something stupid - you could still change it without losing access to VPS and having to recreate it. I suggest enabling wireguard auto-start on boot (wh0.conf should be at /etc/wireguard/wg0.conf or it will not work):

```bash
sudo systemctl enable wg-quick@wg0
sudo systemctl start wg-quick@wg0
```

- pc - after setting this up, comment out the `DNS` line in your `PC_A` config and test the VPN. How to test it? Just ping your VPS:

```bash
ping  __PRIVATE_SUBNET__.1

PING __PRIVATE_SUBNET__.1 (__PRIVATE_SUBNET__.1) 56(84) bytes of data.
64 bytes from __PRIVATE_SUBNET__.1: icmp_seq=1 ttl=64 time=71.1 ms
64 bytes from __PRIVATE_SUBNET__.1: icmp_seq=2 ttl=64 time=34.6 ms
64 bytes from __PRIVATE_SUBNET__.1: icmp_seq=3 ttl=64 time=34.5 ms
64 bytes from __PRIVATE_SUBNET__.1: icmp_seq=4 ttl=64 time=34.5 ms
^C
--- __PRIVATE_SUBNET__.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3003ms
rtt min/avg/max/mdev = 34.525/43.685/71.126/15.843 ms
```

If this step doesn't work - something is broken and there is no sense in setting up other clients, fix this problem first. You might've forgotten to open `VPS` port, put the wrong IP in your config etc.

If everything works - uncomment DNS line and restart the VPN client on your `pc`.

- RPI - nothing interesting, except multiple `AllowedIPs` for `VPS`. Those are for all clients who can't connect to `RPI` directly and will go via `VPS`. I also suggest enabling wireguard auto-start on boot (see `VPS` section on how to do it).
- iPhone - I suggest using `qrencode -t png -o client-qr.png -r wg0.conf` to share your iphone config with mobile app.

## Forward all traffic

Based on [this guide](https://gist.github.com/nealfennimore/92d571db63404e7ddfba660646ceaf0d).

Before enabling wireguard run this on the server:

```
echo "net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1" > /etc/sysctl.d/wg.conf
sysctl --system
```

Client config [Peer] section - use these for VPS:

```
AllowedIPs = 0.0.0.0/0, ::/0 # Forward all traffic to server
```

Server (VPS) config [Interface] section - add (already configured in my sample VPS config):

```
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; ip6tables -A FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE # Add forwarding when VPN is started
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE; ip6tables -D FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -D POSTROUTING -o eth0 -j MASQUERADE # Remove forwarding when VPN is shutdown
```