---
title:      How to run any Docker container's traffic through Wireguard or OpenVPN
description: Run Docker container traffic through VPN protocols such as OpenVPN or Wireguard. Works for Transmission, Sonarr, etc. 
categories:
 - tech
 - docker
 - vpn
tags:
 - tech
 - docker
 - vpn

---

I prefer running my Torrent (and related tools) in a container, for isolation from my host OS, as well as the ability to route all of its traffic through a VPN.  

Although Docker images exist which bundle various tools with the VPN, it's much cleaner to have a single container that manages the traffic, while leaving us with the freedom to choose which images we want going through the VPN. That means that we can use official or popular images and not worry about compatibility issues which would occur in more bloated images which try to do too much. 

In this example I will use the [gluetun](https://github.com/qdm12/gluetun) image which is a thin Docker container for multiple VPN providers (and supports OpenVPN and WireGuard). Importantly, it comes with a killswitch, so if the VPN connection goes down, none of our containers' traffic should leak.  I'll use Surfshark as the VPN provider, with Wireguard as the protocol.  An OpenVPN example is at the end.    

## Get VPN details

Login to Surfshark, and under manual set up, generate a new key pair.  This is required for setting up Wireguard connections.  Make a note of the private key that gets generated, you will need it shortly.  

![Generate new key pair]({{ site.baseurl }}/assets/images/run-docker-through-vpn-container/001.png)

From the Locations tab, pick a country you want the traffic routed through.  Download the configuration file that comes with it, and open it up.  Make a note of the `Address` field which will also be needed shortly, as well as the country name you chose.  In this example I chose Finland. 

![Address]({{ site.baseurl }}/assets/images/run-docker-through-vpn-container/002.png)

## Set up the VPN container

Create a docker-compose.yml file as below, and substitute the noted values.  The private key goes in `WIREGUARD_PRIVATE_KEY`, the address goes in `WIREGUARD_ADDRESSES`, and the country name goes in `SERVER_COUNTRIES`.  

```yaml
services:
  gluetun:
    image: qmcgaw/gluetun
    cap_add:
      - NET_ADMIN
    environment:
      - VPN_SERVICE_PROVIDER=surfshark
      - VPN_TYPE=wireguard
      - WIREGUARD_PRIVATE_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxx
      - WIREGUARD_ADDRESSES=10.14.0.2/16
      - SERVER_COUNTRIES=Finland

```

Test the setup by running `docker-compose up`.  If the connection is successful, you should see some successful messages and a public IP address.  

![successful connection]({{ site.baseurl }}/assets/images/run-docker-through-vpn-container/003.png)

If you see failure messages, the process will keep restarting itself and retrying. In such a case, stop the container and then try using `SERVER_HOSTNAMES` instead of `SERVER_COUNTRIES`.  For `SERVER_HOSTNAMES`, put the value of the domain value in `Endpoint` in the downloaded file.  That is: 


```yaml
      - SERVER_HOSTNAMES=fi-hel.prod.surfshark.com
```


## Test with curl

Once the Gluetun container is running, you should do a quick test using curl.  The trick here is to use the `network_mode` argument and point at the gluetun container.   

```yaml 
services:
  gluetun:
    image: qmcgaw/gluetun
    cap_add:
      - NET_ADMIN
    environment:
      - VPN_SERVICE_PROVIDER=surfshark
      - VPN_TYPE=wireguard
      - WIREGUARD_PRIVATE_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxx
      - WIREGUARD_ADDRESSES=10.14.0.2/16
      - SERVER_COUNTRIES=Finland
  curl:
    image: curlimages/curl
    network_mode: "service:gluetun"  # <-- the magic
```

Start the gluetun container, 

```
docker-compose up gluetun
```

Once it's up and ready, in a separate terminal, run a test from the curl container. 

```
docker-compose run --rm curl ifconfig.me
```

You should get the IP address of the VPN server rather than your own, and you can try verifying its location in a [Geo IP lookup service](https://www.iplocation.net/ip-lookup). 

To test the killswitch, stop the gluetun container, and try running the curl test again.  The output should hang and time out after a few minutes. 

## Running with Transmission

Transmission is a Torrent client that has a simple, easy-to-use web interface.  It's great for running in a container.  We can now set up [a Docker Transmission image](https://hub.docker.com/r/linuxserver/transmission) to use the VPN container we've set up above.  

One special thing to note — Transmission requires ports 9091 and 51413 to be open.  With this VPN based setup, the port mapping needs to happen on the _VPN container_ and not Transmission itself.  

Modify the docker-compose.yml, like so (with substituted values):  


```yaml
version: "3"
services:
  gluetun:
    image: qmcgaw/gluetun
    cap_add:
      - NET_ADMIN
    environment:
      - VPN_SERVICE_PROVIDER=surfshark
      - VPN_TYPE=wireguard
      - WIREGUARD_PRIVATE_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxx
      - WIREGUARD_ADDRESSES=10.14.0.2/16
      - SERVER_COUNTRIES=Finland
    ports:
      - "0.0.0.0:9091:9091/tcp"   # <-- ports go here, not below
      - 51413:51413/tcp
      - 51413:51413/udp
  transmission:
    image: lscr.io/linuxserver/transmission:latest
    container_name: transmission
    network_mode: "service:gluetun"  # <-- important bit, don't forget
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - TRANSMISSION_WEB_HOME=/flood-for-transmission/ 
    volumes:
      - ${PWD}/transmission-downloads:/downloads
      - ${PWD}/transmission-config:/config
    restart: unless-stopped

```

Now run the whole setup using `docker-compose up -d`.  Wait a while, and browse to http://localhost:9091/.  The Transmission UI should appear after a while.  

To make extra sure that your Transmission traffic is going over the VPN, you can make use of [an IP checking tool by Torguard](https://torguard.net/checkmytorrentipaddress.php).  Simply copy the magnet link and add it to Transmission.  Show the error column in Transmission, where the IP address should appear.  The IP address should also appear on the Torguard page.


![torrent ip test]({{ site.baseurl }}/assets/images/run-docker-through-vpn-container/004.png)

## Running with other containers

In the same manner as above, you can add more containers to the docker-compose setup.  Just keep the two main modifications in mind:

1.  Set `network_mode: "service:gluetun"`  
2.  If you need to expose a port on a container, expose it on the `gluetun` service

When using services that need to talk to each other, such as Sonarr, Radarr, and so on, use `localhost` as the 'server' name in each tool's settings pages, with the right port, so that they can see each other.  The gist is that all of the services are 'local' to the VPN, just running on different ports.  


## OpenVPN

The process for running the traffic through OpenVPN instead of Wireguard is pretty similar to above.  The difference is in the environment variables provided to gluetun.  It only needs `VPN_TYPE=openvpn`, the `OPENVPN_USER` and `OPENVPN_PASSWORD`.  The Wireguard related variables, `WIREGUARD_PRIVATE_KEY` and `WIREGUARD_ADDRESSES` can go.  Example with curl:

```yaml
version: "3"
services:
  gluetun:
    image: qmcgaw/gluetun
    cap_add:
      - NET_ADMIN
    environment:
      - VPN_SERVICE_PROVIDER=surfshark
      - VPN_TYPE=openvpn
      - OPENVPN_USER=xxxxxxxxxxxxxxxxxxxxxxxxxxxx
      - OPENVPN_PASSWORD=xxxxxxxxxxxxxxxxxxxxxxxxxxxx
      - SERVER_COUNTRIES=Finland
  curl:
    image: curlimages/curl
    network_mode: "service:gluetun"      
```



For more details, see [the gluetun wiki](https://github.com/qdm12/gluetun/wiki/Surfshark) which has lots of VPN provider instructions and more details.  

## The country is optional

In the examples above I've chosen a country deliberately, just for the sake of safety and thoroughness. But actually, specifying a country is optional.  The `SERVER_COUNTRIES`, if omitted, will cause the VPN to use your country. 