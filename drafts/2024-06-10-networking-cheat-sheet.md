---
title: "My networking troubleshooting cheatsheet"
description: "My favourite networking troubleshooting commands, like curl, nc, dig, openssl, etc."
tags:
  - networking
  - troubleshooting


---


Inspect a site's certificate

```bash
openssl s_client -connect example.com:443
```

Inspect a site's certificate and print the certificate in text format

```bash
openssl s_client -connect example.com:443 -showcerts
```


Testing a web server URL

```bash
curl -v http://servername:8080
```


Testing a firewall

A corporate firewall or hotel wifi might block certain ports or protocols. 

Portquiz.net is a great site to test this with, it listens on all ports and responds with HTML or text.  

```bash 

# Test the port
nc -v -w5 -z portquiz.net 493

# HTTP request
curl -v http://portquiz.net:493
```



