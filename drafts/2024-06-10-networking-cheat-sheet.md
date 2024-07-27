---
title: "My list of useful troubleshooting tools"
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
openssl s_client -connect example.com:443 -showcerts -prexit -state
```


Testing a web server URL

```bash
curl -v http://servername:8080
```

Test a web server but ignore its certificates

```bash
curl -kv http://servername:8080
```

Test a web server but only look at its response headers

```bash
curl -I http://servername:8080
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


Check if I can use external DNS servers. I can't really use `nc` here since it's a UDP service, but `dig` will work.  

```bash
dig @1.1.1.1 example.com
```

Check if DNS over TLS works, useful for Android's Private DNS feature. This will work from Termux too. 

```bash
nc -v -w5 -z dns.adguard-dns.com 853
```
