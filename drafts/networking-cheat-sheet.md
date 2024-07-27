---
title: "My list of useful troubleshooting tools"
description: "My favourite networking troubleshooting commands, like curl, nc, dig, openssl, etc."
tags:
  - networking
  - troubleshooting
  - bash
  - nc
  - linux
  - ubuntu
  - openssl

extraWideMedia: false

---

I'm not a networking professional, but I've often had to impersonate one. Here are some of the tools and commands I've found useful.  

### Test a port on a server

A corporate firewall or hotel wifi might block certain ports or protocols. [Portquiz.net](http://portquiz.net/) is a great site to test with, it listens on all ports and responds with HTML or text.  

```bash 
nc -v -w5 -z portquiz.net 193
```

Sometimes `nc` isn't available, so I use `telnet` instead. 

```bash
telnet portquiz.net 193
```

But what if telnet isn't available either? One of the neat features in Linux Bash is you can query `/dev/tcp` directly. 

```bash
echo > /dev/tcp/portquiz.net/193 && echo Success
```

In fact it's even possible to [make an HTTP request that way](https://unix.stackexchange.com/a/83927).

### Looking at a site's certificate

Misconfigured certificates can cause weird behaviours in browsers and client tooling, so I often want to inspect them directly. The idea is to look for anything from self signed certificates, to expired certificates, to corporate MITM proxies serving their own certificates.  

To look at the certificate being served, 

```bash
openssl s_client -connect example.com:443
```

Inspect a site's certificate and look at its start and end dates

```bash
openssl s_client -connect example.com:443 | openssl x509 -noout -dates
```

The `x509` subcommand can be used to look at many other properties of a certificate.  

Here is how to view a certificate's SANs (Subject Alternative Names)

```bash
openssl s_client -connect example.com:443 | openssl x509 -noout -ext subjectAltName
```

Or to just view all of the certificate's properties

```bash
openssl s_client -connect example.com:443 | openssl x509 -noout -text
```




### Test a web server URL

This one's simple, I just want to 'look' at a site URL without browser behaviours getting in the way. It happens more commonly than you'd think, especially if a browser has cached a file or a redirect response. 

```bash
curl -v http://example.com:80
```

Test a web server but only look at its response headers

```bash
curl -I http://servername:8080
```

Test a web server but ignore its certificates

```bash
curl -kv https://example.com
```



### Testing DNS

*It’s not DNS  
There’s no way it’s DNS  
It was DNS*


Check if I can use external DNS servers. I can't really use `nc` here since it's a UDP service, but `dig` will work.  

```bash
dig @1.1.1.1 example.com
```

Check if DNS over TLS works, useful for Android's Private DNS feature. This will work from Termux too. 

```bash
nc -v -w5 -z dns.adguard-dns.com 853
```
