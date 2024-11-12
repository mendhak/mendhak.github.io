---
title: New DNS standard could soon lead to useful error messages in browsers
description: Structured DNS Errors is a new standard that should soon lead to helpful and useful error messages in browsers
tags:
  - dns
  - ede
  - sde
  - browsers

opengraph:
  image: /assets/images/structured-dns-errors/001.png  
---


Domains get blocked for a variety of reasons including security, family controls, content filtering, politics, and legal requirements. But when browsers encounter these blocks, they will usually display a somewhat generic and unhelpful error message. As end users it often isn't clear to us why the domain was blocked, and unsurprisingly, encountering a blocked domain can be indistinguishable from an actual connectivity outage. 

Some DNS servers try and be 'helpful' by responding to the domain query with a different address than the actual, and displaying an informational page — this is effectively spoofing, and is pretty dangerous as they will use untrusted certificates for those informational pages. 

## Structured DNS Errors

A [new standard](https://datatracker.ietf.org/doc/draft-ietf-dnsop-structured-dns-error/) is being developed to address this, called **Structured DNS Errors**. When implemented, it will use _another_ feature called [Extended DNS Errors](https://blog.apnic.net/2023/09/28/extended-dns-errors-unlocking-the-full-potential-of-dns-troubleshooting/). 

The Extended DNS Errors feature specifies certain codes to indicate the error, such as 15 for Blocked, 16 for Censorship, 17 for Filtered, 18 for Prohibited. 

Here's an example of a DNS EDE from Cloudflare. 

```
$ dig @1.1.1.1 dnssec-failed.org

; <<>> DiG 9.18.28-0ubuntu0.24.04.1-Ubuntu <<>> @1.1.1.1 dnssec-failed.org
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: SERVFAIL, id: 51089
;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; EDE: 9 (DNSKEY Missing): (no SEP matching the DS found for dnssec-failed.org.)
;; QUESTION SECTION:
;dnssec-failed.org.		IN	A

...

```

Notice the `EDE: 9 (DNSKEY Missing):` line, the [error code](https://developers.cloudflare.com/1.1.1.1/infrastructure/extended-dns-error-codes/) indicates that it did not pass DNSSEC validation.


The new standard, Structured DNS Errors, proposes adding additional information about the block. As the name indicates, it will be structured using JSON, so that the software reading this information can parse it and present it to the human consumers. The software will usually be browsers, at least that is the main target, but could be any application to which the extra information is surfaced. 

We can see this in action using AdGuard DNS who have recently [implemented SDE](https://adguard-dns.io/en/blog/adguard-dns-v2-10.html). 

```
$ dig @dns.adguard-dns.com +ednsopt=15:0000  doubleclick.net

; (4 servers found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 62347
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; EDE: 17 (Filtered): ({"j":"Filtered by AdGuard DNS","o":"AdGuard DNS","c":["mailto:support@adguard-dns.io"]})
;; QUESTION SECTION:
;doubleclick.net.		IN	A

;; ANSWER SECTION:
doubleclick.net.	3600	IN	A	0.0.0.0

...

```

See the `EDE: 17 (Filtered)` line, followed by the JSON. The field names have been kept short to save on bandwidth. They are: 

* `j` - Justification for the block
* `s` - Sub error, probably a troubleshooting code
* `o` - The organization that filtered this query
* `c` - A list of contact details, like email or telephone


A browser receiving this information could now, quite simply, present the information using a built-in page. This takes away a lot of the risk that the workarounds mentioned earlier would involve. There's no forged DNS responses, no spoofed domains, and no need for untrusted certificates. 

AdGuardDNS have also released a [browser extension](https://github.com/AdguardTeam/dns-sde-extension/) that emulates what the blocking behaviour could look like, which I was able to try out. By try out, I mean I modified it to place the extracted information over a meme. 

![AdGuard SDE emulation](/assets/images/structured-dns-errors/001.png)

Here I visited `ad.doubleclick.net` which was blocked, and the extension then queried [a separate endpoint](https://dns.adguard.ch/resolve?name=doubleclick.net&sde=1) to get the additional information. It's worth noting that the emulation behaviour is required for now, since browsers don't yet even look for this information. Once they do I'd imagine no extension would be required at all.  

## Thoughts

The `c` field seems to only allow email, telephone, or SIP; I think it could benefit from also allowing an HTTPS URL pointing at an informational page, but the people authoring the draft [had their concerns](https://github.com/ietf-wg-dnsop/draft-ietf-dnsop-structured-dns-error/pull/51) which makes sense, as it's an attack vector, but makes it not that great for the end users. 

![Contact types for SDE](/assets/images/structured-dns-errors/002.png)

It would be nice if tools such as [Pi-Hole](https://pi-hole.net/) could also take advantage of the feature by passing it on to the browser when it encounters it from an upstream provider. That said, when I queried my Pi-Hole for a blocked domain, it doesn't seem to return the EDE field at all. Maybe this isn't such a simple task. 

![Pi-Hole](/assets/images/structured-dns-errors/003.png)

