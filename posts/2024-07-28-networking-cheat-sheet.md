---
title: "My most useful network troubleshooting commands and tools"
description: "My favourite networking troubleshooting commands, like curl, nc, dig, openssl, etc."
tags:
  - networking
  - troubleshooting
  - bash
  - nc
  - linux
  - ubuntu
  - openssl
  - curl

extraWideMedia: false

opengraph:
  image: /assets/images/networking-cheat-sheet/000.png

---

I'm not a networking professional, but I've often had to impersonate one. Here are some of the tools and commands I've found useful over the years.  

### Reach a port on a server

It's not unusual for corporate firewalls or hotel WiFi to block certain ports/protocols, it might allow web traffic but not VPN or SSH; I want to find out if that's happening. 

In work scenarios, an app on a remote server may be unreachable due to local firewall rules blocking traffic or is genuinely having issues on its side. 

This is where [Portquiz.net](http://portquiz.net/) is helpful for testing - it listens on all ports and responds with HTML, helping identify whether the issue lies in a firewall rule or the new application itself.

To test a remote port, use `nc` (netcat). 

```bash 
nc -v -w5 -z portquiz.net 193
```

Sometimes `nc` isn't available, so I use `telnet` instead. 

```bash
telnet portquiz.net 193
```

But what if telnet isn't available either? One of the neat features in Linux Bash is I can query `/dev/tcp` directly and not need any extra tools. 

```bash
echo > /dev/tcp/portquiz.net/193 && echo Success
```

In fact it's even possible to [make an HTTP request that way](https://unix.stackexchange.com/a/83927).

### Set up a listener on a port

I need this when an actual network engineer tells me they've opened a firewall rule, but they haven't, and I know they haven't, but I don't want to look stupid when I tell them they haven't. 

The simplest listener is using `nc`. (If the port is below 1024, use sudo)

```bash
nc -l 8081
```

Once it's listening, use `nc` to send some text, `echo -n "Hello" | nc servername 8081` from another terminal, and 'Hello' should appear in the first terminal session.     

To listen on a UDP port, use the `-u` flag.  

```bash
nc -u -l 8081
```

Send a UDP packet using `echo -n "Hello" | nc -u servername 8081` from another terminal and watch the first one. It's important to note that UDP is connectionless, sending a packet is a one-way operation and there is no indication of success.  

### Listening and echoing HTTP requests

When I need to work at the HTTP layer, and troubleshoot message bodies and headers, I use my [HTTP Echo utility](/posts/2019-03-01-docker-http-https-echo.md). It's a web server that echoes requests back to the sender. It runs in a container and can be deployed with the rest of the infrastructure being tested.    

```bash
docker run -p 8080:8080 -p 8443:8443 --rm -t mendhak/http-https-echo:33
```

I can then browse to any arbitrary path like [https://localhost:8443/hello-world](https://localhost:8443/hello-world) and see the request echoed back in the browser.   

![Request echoed back in the browser](/assets/images/docker-http-https-echo/002.png)

I can send a request with curl,

```bash
curl -k -X PUT -H "Arbitrary:Header" -d aaa=bbb https://localhost:8443/hello-world` 
```
 
and see the request echoed back too, as well as see the request in the container logs.  



The tool allows for more involved tests, like JWTs, JSON payloads, empty responses, delays, custom content types, mTLS. 

### Inspecting a site's certificates

Misconfigured certificates can cause weird behaviours in browsers and client-side tooling; the browser might throw warnings, or a database client might fail to connect. 
So I often want to inspect the certificates directly. 

The idea is to look for anything 'unusual' which might require extra work. It could be self signed certificates, to expired certificates, to corporate MITM proxies serving their own certificates. The examples here are for port 443 but can be used for any port.  

To look at the certificate being served, 

```bash
openssl s_client -connect example.com:443
```

To get a certificate's start and end dates,

```bash
openssl s_client -connect example.com:443 | openssl x509 -noout -dates
```

The `x509` subcommand can be used to look at many other properties of a certificate.  

Here is how to view a certificate's SANs (Subject Alternative Names). This can produce amusing results on Cloudflare hosted sites where they bundle many sites together.  

```bash
openssl s_client -connect example.com:443 | openssl x509 -noout -ext subjectAltName
```

To view **all** of the certificate's properties,

```bash
openssl s_client -connect example.com:443 | openssl x509 -noout -text
```

### Testing certificate scenarios with BadSSL

A lot can go wrong with certificates, because we make naive assumptions about them. We assume they're always there, always valid, always signed by a trusted CA.  

Of course that's wrong, certificates could be malformed, self signed, not match the hostname, expired, revoked. They could be too large, missing a chain, come with a weak signature or protocol version.  

[BadSSL](https://badssl.com/) is a useful tool in the certificate space. It has lots of certificate scenarios to work against. Testing against its examples helps with making client code more robust. I've found the expired, wrong host, and self signed to be useful tests. It even has certificates on different TLS versions, key exchanges, and HSTS upgrade testing.  

![BadSSL](/assets/images/networking-cheat-sheet/001.png)

At the other end, a site that's never going to have a certificate is [NeverSSL](https://neverssl.com). This is useful when testing on captive portals or where there's https interception in a network, or https redirection by a browser.   


### Testing DNS

{% notice "warning" %}
*It’s not DNS,  
There’s no way it’s DNS,  
It was DNS.*
{% endnotice %}

A basic DNS lookup can be done with `dig`.

```bash
dig example.com
```

To see more details, use the trace argument.  

```bash
dig +trace example.com
```

To get the Start of Authority (SOA) of a domain,

```bash
dig example.com SOA
```

I can also get MX records or TXT records, which is a common way to figure out what services that domain is using.  

```bash
dig example.com MX
dig example.com TXT
```

To check if I can use external DNS servers from my network, I can't really use `nc` here since it's a UDP service, but `dig` can be pointed at other DNS servers.  

```bash
dig @1.1.1.1 example.com
```

To check if DNS-over-TLS (DoT) is reachable, useful for Android's Private DNS feature. This will work from Termux too. 

```bash
nc -v -w5 -z dns.adguard-dns.com 853
```

To find out what DNS servers are being used on a local computer, it's normally as simple as looking at the resolv.conf file. 

```bash
cat /etc/resolv.conf
```

But in many more modern systems, it's not that simple. In Ubuntu 22.04, it's `resolvectl`. 

```bash
resolvectl status
```

### Testing a website URL

This one's the simplest, I just want to 'look' at a site URL without browser behaviours getting in the way.  

It has been needed more commonly than I thought, especially when a browser has cached a file or a redirect response. I've found that browsers may lie, but curl does not.  

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

Side note, it's also possible to request a web page through openssl. If you've noticed it hang after running a command (where you normally press Ctrl+C), it's waiting for you to send some input.    
Try this out, use openssl to connect to exapmle.com. Then enter the bottom three lines shown, then press enter twice. 

```bash
$ openssl s_client -connect example.com:443
...

GET / HTTP/1.1
Host: example.com
Connection: Close


```

Or together in one line, 

```bash
echo -e "GET / HTTP/1.1\r\nHost: example.com\r\nConnection: Close\r\n\r\n" | openssl 2>&1 s_client -quiet -state -connect example.com:443
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

### Find out what's listening on a port

When port conflicts occur, I need to find out what's listening on a port. 

```bash
sudo netstat -plunt
```
The response will contain the PID of the process listening on the port.  
On Windows, use `netstat -bona`.  
