---
title: Wildcard certificates are not always a security risk
description: Using wildcard certificates can be a security mitigation for internal websites and infrastructure.
tags:
  - tls
  - ctl
  - wildcard
  - security


---

The common, prevailing advice given regarding TLS certificates is to avoid using wildcard certificates. That is, when securing a domain, it is considered a best practice to use a certificate for `mydomain.example.com` instead of `*.example.com`.  

The risk is that a compromised wildcard certificate has a large blast radius, and allows attackers to create multiple malicious domains under a 'trusted' banner. 

## Internal infrastructure

Organizations and individuals that host internal infrastructure (services, containers, instances, all kinds of things), have a need to secure traffic to said infrastructure. Although it's possible to manage internal infrastructure with private DNS `mydomain.example.internal` and private certificate authorities, many people will want to avoid its associated overheads.

It's now a very common approach to take the easier route and use public DNS for internal infrastructure, such as `mydomain.example.tech`. Using public DNS allows taking advantage of free automated certificate providers such as [Let's Encrypt](https://letsencrypt.org/getting-started/) and [Amazon ACM](https://aws.amazon.com/certificate-manager/).


### Certificate Transparency Logs can be a risk

Certificate Transparency Logs (CRTs) are an Internet standard for monitoring certificates issued by all major Certificate Authorities (CAs). When CAs issue certificates, they now voluntarily send a log to a public ledger, which can be queried by browsers when a user visits a website, to ensure that the certificate being presented was legitimately issued. 

This public ledger is visible to anyone and can be seen on sites such as [crt.sh](https://crt.sh). Try some searches such as [example.com](https://crt.sh/?q=example.com) and [google.com](https://crt.sh/?q=google.com).

![Example.com](/assets/images/use-wildcard-certificates-for-internal-infrastructure/002.png)

Which means, any certificates issued against internal infrastructure using public DNS should be visible in this log. And it is! The risk here is that an attacker now has an inventory of a company's infrastructure that they would not normally have or easily gain.

A commonly cited example of such exposure was the Transport for New South Wales department with their domain `transport.nsw.gov.au`, and a search on a CRT logs website [reveals a huge number of internal domains](https://crt.sh/?q=transport.nsw.gov.au). 

![The list goes on](/assets/images/use-wildcard-certificates-for-internal-infrastructure/003.png)

Presumably twoards the end of 2020, they seem to have cleaned up their presence (I can only assume due to the attention this CRT received).


## When to use wildcard certificates

Digging through a list like the CRT can reveal not just internal infrastructure, but information _about_ the inner workings in and around it. I consider this risk to be much higher than that of a compromised wildcard certificate. 

My recommendation is to use a wildcard certificate for internal domains, if using public DNS and public CAs. This reduces the internal enumeration risk, while letting development teams retain the convenience of automated domains and certificates.  

