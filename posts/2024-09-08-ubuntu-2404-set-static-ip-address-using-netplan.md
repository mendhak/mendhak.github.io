---
title: "Setting a static IP address in Ubuntu 24.04 using `netplan`"
description: "Using the newly introduced netplan in Ubuntu 24.04 to set a static IP address for pihole setup"
tags:
  - networking
  - linux
  - ubuntu
  - netplan
  - pihole
  - static

---

While setting up PiHole on an Ubuntu 24.04 server, I realized that the usual instructions I'd been following for years on Debian systems for setting a static IP address (often involving `/etc/network/interfaces` or `/etc/resolv.conf`) weren't going to work here. It's worth sharing now that I've learned how for myself. Netplan basically acts as a translation layer, it takes configuration files, and creates the right systemd-networkd or Networkmanager configuration.

The first thing I did was to disable the cloud-init networking. 

I created a file, `sudo nano /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg` with the following contents:

```json
network: {config: disabled}
```

Then, edited the existing netplan configuration file, for me this was `sudo nano /etc/netplan/50-cloud-init.yaml`, which originally looked like this:

```yaml
network:
    ethernets:
        enp1s0:
            dhcp4: true
    version: 2
    wifis: {}
```

What it's basically doing is setting the network interface `enp1s0` to use DHCP (and is not static).

I changed it to make it look like this:

```yaml
network:
    ethernets:
        enp1s0:
            dhcp4: false
            dhcp6: false
            addresses:
              - 192.168.50.111/24
            routes:
              - to: default
                via: 192.168.50.1
            nameservers:
                addresses: [1.1.1.1, 8.8.8.8]
    version: 2
    wifis: {}
```

There are a few things happening here: 

- `dhcp4: false` and `dhcp6: false` are disabling DHCP for both IPv4 and IPv6.
- `addresses` is setting the static IP address.
- `routes` is setting the default gateway and pointing at my router, 192.168.50.1
- `nameservers` is setting the DNS servers to use, I've chosen one Cloudflare and one Google DNS. 

To then apply the changes, 

```bash
sudo netplan apply
```

Then check on the status: 

```bash
sudo netplan status enp1s0
```

