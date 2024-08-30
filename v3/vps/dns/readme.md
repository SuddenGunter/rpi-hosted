# DNS

VPS DNS configuration is based on [this article](https://www.procustodibus.com/blog/2023/01/wireguard-internal-dns-names/#install-coredns) and [another article](https://ipv6.rs/tutorial/Ubuntu_Server_Latest/CoreDNS/).

1. Download coreDNS binary from Github releases, put it to /use/bin/coredns
2. Write `/etc/coredns/Corefile` and configure your domains to point to RPI private IP:

```
.:53 {
    bind 0.0.0.0 ::
    hosts {
      __PRIVATE_SUBNET__.90 mydomain.test
      __PRIVATE_SUBNET__.90 mydomain.test2
      fallthrough
    }
    forward . 1.1.1.1
    errors  # coredns.io/plugins/errors
}
```
3. Write coreDNS systemd unit:

```
[Unit]
Description=CoreDNS DNS Server
After=network.target
[Service]
Type=simple
ExecStart=/usr/local/bin/coredns -conf /etc/coredns/Corefile
[Install]
WantedBy=multi-user.target
```

4. Enable coreDNS using systemd:

```sh
sudo systemctl daemon-reload
sudo systemctl start coredns
```
