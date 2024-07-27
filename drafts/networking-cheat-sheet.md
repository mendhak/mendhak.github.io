---
title: "My list of useful troubleshooting tools and commands"
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

opengraph:
  image: /assets/images/networking-cheat-sheet/000.png

---

I'm not a networking professional, but I've often had to impersonate one. Here are some of the tools and commands I've found useful.  

### Can I reach a port on a server?

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

### I want to look at a TLS certificate

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

To just view **all** of the certificate's properties

```bash
openssl s_client -connect example.com:443 | openssl x509 -noout -text
```

### Working with bad certificates

A lot can go wrong with certificates, and it's not always coded for or tested for. Certificates could be malformed, self signed, mismatched, expired, revoked.

[BadSSL](https://badssl.com/) has lots of examples to work with. Testing against its examples helps with making client code more robust. I've found the expired, wrong host and self signed to be useful tests. It even has certificates on different TLS versions.  

![BadSSL](/assets/images/networking-cheat-sheet/001.png)

At the other end, a site that's never going to have a certificate is [NeverSSL](https://neverssl.com). This is useful when testing on captive portals or where there's https interception. 

### Testing a website URL

This one's simple, I just want to 'look' at a site URL without browser behaviours getting in the way.  
It has been needed more commonly than I thought, especially when a browser has cached a file or a redirect response.   
I've found that browsers may lie, but curl does not.  

```bash
curl -v http://example.com:8080
```

Test a web server but only look at its response **headers**

```bash
curl -vI http://servername:8080
```

Test a web server but ignore its **certificates**

```bash
curl -kv https://example.com
```

Test a web server using a **proxy**

```bash
curl -v -x http://proxy.internal:3128 http://example.com
```

If everything is using a **proxy**, test a web server but bypass the proxy

```bash
curl -v --noproxy '*' http://example.com
```

When testing **load balancers**, I may need to pass the hostname explicitly. 

```bash
curl -v -H "Host: example.com" http://my-load-balancer.amazonaws.com:8293
```

Sometimes I also need to forcefully **resolve a hostname to a specific IP address**, again while testing out-of-the-balance infrastructure. This is how to get curl to ignore DNS resolution.  

```bash
curl -v --resolve example.com:80:192.168.50.123 http://example.com
```

In rarer cases, I've had to map a hostname and port to a **completely different hostname and port**. 

```bash
curl -v --connect-to example.com:80:differentdomain.net:85 http://example.com 
```


There's a lot more that curl can do, it deserves [its own cheatsheet](https://quickref.me/curl.html).


### Listening and echoing on a port

Sometimes it's not the server that's the problem, but the client. To help with this I need to set up listeners, send a request to the listener, and watch what happens when the request comes in.  

This is commonly used when an actual network engineer tells you they've opened a firewall rule, but they haven't, and you know they haven't, but you don't want to look stupid when you tell them they haven't.  

The simplest listener is using `nc`. (If the port is below 1024, use sudo)

```bash
nc -l 8081
```

Once it's listening, use `nc` to send some text, `echo -n "Hello" | nc localhost 8081` from another terminal.   

To listen on a UDP port, use the `-u` flag.  

```bash
nc -u -l 8081
```

Then similarly, send a UDP packet using `echo -n "Hello" | nc -u localhost 8081` from another terminal.

### Listening and echoing HTTP requests

When I need to work with HTTP itself and troubleshoot message bodies and headers, I use my [http-https-echo utility](https://github.com/mendhak/docker-http-https-echo). It's basically a web server that runs in a container and can be deployed with the rest of the infrastructure.  

```bash
docker run -p 8080:8080 -p 8443:8443 --rm -t mendhak/http-https-echo:33
```

I can then send a request, such as `curl -k -X PUT -H "Arbitrary:Header" -d aaa=bbb https://localhost:8443/hello-world` and see the request echoed back, as well as in the container logs.  

![docker http https echo](/assets/images/docker-http-https-echo/003.png)


### Testing DNS

{% notice "warning" %}
*It’s not DNS  
There’s no way it’s DNS  
It was DNS*
{% endnotice %}


Check if I can use external DNS servers. I can't really use `nc` here since it's a UDP service, but `dig` will work.  

```bash
dig @1.1.1.1 example.com
```

Check if DNS over TLS works, useful for Android's Private DNS feature. This will work from Termux too. 

```bash
nc -v -w5 -z dns.adguard-dns.com 853
```
