---
title: "How quantum computers break our security, and what's being done about it"
description: "Quantum computers will defeat common security algorithms that we use today. I'll cover how they break it, and what the cryptographic community is doing about it, with some of my notes."

categories: 
  - computing
  - security
tags: 
  - quantum
  - computing
  - cryptography
  - general
  - standard
  - simplified
 

gallery1:
  - url: /assets/images/general-understanding-quantum-safe-cryptography/002.png
    image_path: /assets/images/general-understanding-quantum-safe-cryptography/002.png
  - url: /assets/images/general-understanding-quantum-safe-cryptography/003.png
    image_path: /assets/images/general-understanding-quantum-safe-cryptography/003.png

gallery2:
  - url: /assets/images/general-understanding-quantum-safe-cryptography/005.png
    image_path: /assets/images/general-understanding-quantum-safe-cryptography/005.png
  - url: /assets/images/general-understanding-quantum-safe-cryptography/006.png
    image_path: /assets/images/general-understanding-quantum-safe-cryptography/006.png    
  - url: /assets/images/general-understanding-quantum-safe-cryptography/007.png
    image_path: /assets/images/general-understanding-quantum-safe-cryptography/007.png    

gallery3:
  - url: /assets/images/general-understanding-quantum-safe-cryptography/009.jpg
    image_path: /assets/images/general-understanding-quantum-safe-cryptography/009.jpg
  - url: /assets/images/general-understanding-quantum-safe-cryptography/010.jpg
    image_path: /assets/images/general-understanding-quantum-safe-cryptography/010.jpg

header: 
  teaser: /assets/images/general-understanding-quantum-safe-cryptography/012.jpg
---



As a computing end user, I've been vaguely aware of quantum computing on the horizon, but haven't been aware regarding its effect on us. To that end I decided to get a generalist's understanding of how quantum computers would affect our security, and what's happening right now in the industry to address these issues.  I'm only vaguely aware that our SSH keys will need changing, and browsers will need to perform TLS differently, but without understanding the why and the 'behind the scenes' work.      

## How it started, Shor's Algorithm

Through the 1980s, quantum computers were simply a topic of study,  until 1994 when mathematician Peter Shor devised a quantum computing [algorithm](https://www.jstor.org/stable/2653075) basically along the lines of, _"Given an integer N, find its prime factors"_.  It's a simple sentence with large implications. 

The significance is that the stated problem is how you'd go about decrypting messages based on our current key exchange algorithms. That is, many key exchange algorithms today work by multiplying two large prime numbers to get a result, and rely on the opposite direction, figuring out which prime numbers were used, being difficult to solve. 

On today's computers (usually referred to as classical machines), for large values, this would take trillions of years, and it is this difficulty which gives us the assurance we need that our key exchanges and authentication steps are safe.  That assurance goes away with quantum computers.  

[![prime factors of an integer]({{ site.baseurl }}/assets/images/general-understanding-quantum-safe-cryptography/001.png)]({{ site.baseurl }}/assets/images/general-understanding-quantum-safe-cryptography/001.png)



### What this means for SSH and TLS

By showing that this stated problem has a trivial solution on quantum computers, it means that a sufficiently powerful quantum computer could break the fundamental steps used in SSH and TLS (namely RSA and Elliptic Curve cryptography).  As a specific example, it would take 300 trillion years to break an RSA-2048 encryption key for a classical machine, but [just 10 seconds for a quantum computer](https://www.quintessencelabs.com/blog/breaking-rsa-encryption-update-state-art/).  

As it stands right now, our SSH keys are not quantum safe.  Even though OpenSSH have recently [deprecated RSA](https://levelup.gitconnected.com/demystifying-ssh-rsa-in-openssh-deprecation-notice-22feb1b52acd), and many people will be moving towards the more secure ED25519 key format, neither are safe from an attacker with access to quantum computing resources.  

The same vulnerabilities apply to TLS, where the impact is even larger.  TLS is of course used by browsers and other tools when negotiating traffic to HTTPS URLs.  It's also used by backend systems, such as clients talking to databases, queues and messaging systems.  TLS is a huge part of the software operational backbone for TCP communications.   

All this in turn means, some day in the future, we will need to start using a newer type of SSH key and newer TLS encryption schemes across systems.  Between SSH and TLS, this pretty much covers a huge swathe of infrastructure, and not mitigating can have huge impacts with economic, legal and political consequences.  


## Why worry now

### Quantum computers are weak today

Quantum computers aren't very powerful today and are constrained by a few problems.  

The first one is called _coherence time_; it's the duration that the qubits in a quantum computer can stay useful for the purposes of a calculation.  If a calculation on a quantum machine requires more time than the coherence time, then the machine won't be able to solve the problem.  The best time achieved as of 2021 has been around 300 to 500 microseconds, which isn't very useful considering the 10 seconds quoted above for breaking RSA-2048.  However there is always research being done to [increase this coherence time to 1 hour and more](https://www.nature.com/articles/s41467-020-20330-w).   

{% include gallery id="gallery1" layout="third" caption="Increasing quantum coherence" %}

The other problem is the _number of qubits_ in the quantum computer.  In the RSA-2048 breaking example above, the quantum computer would also need 4099 stable qubits. As of 2021, IBM has the largest quantum computer at [127 qubits](https://www.newscientist.com/article/2297583-ibm-creates-largest-ever-superconducting-quantum-computer/) and are predicting [1121 qubits in 2023](https://research.ibm.com/blog/ibm-quantum-roadmap).  

If you're wondering where the 4099 number came from for an RSA-2048 bit key, it's based on having [2n+3 qubits rquired for an efficient implementation of Shor's algorithm](https://arxiv.org/pdf/quant-ph/0205095.pdf).  It's possible to have a different number of qubits, the time taken will just be different.  There might also exist other efficient algorithms that require fewer qubits.   
{: .notice--info}

These stated numbers are changing frequently though, as universities and organisations are continuously outdoing each other. It's tempting to think that quantum computing might stay in the realm of curiosity, research and academia, without making progress past current coherence and qubit limitations, but this is no [longer](https://techmonitor.ai/technology/ibm-eagle-chip-quantum-computing) a [commonly](https://ai.googleblog.com/2018/03/a-preview-of-bristlecone-googles-new.html) held [viewpoint](https://en.wikipedia.org/wiki/Quantum_supremacy).       

{% include gallery id="gallery2" layout="third" caption="Breaking qubits barrier" %}

It's not important to know what qubits are for this post, it's simpler to think of them as the same as bits in classical computers, but with multiple possible values at the same time. 
{: .notice--info}

### But the IT industry is slow

Most authoritative and standard bodies are estimating that at some point in the next 15-20 years, quantum computers will become sufficiently powerful to pose a real threat to today's security.  That seems like a generation away, but anyone with experience in the IT sector can attest to the glacial pace at which changes occur across any given systems.  This is even more the case with systems that are entrenched and embedded among large sprawling legacy setups in complex dependencies that build up over time in undocumented ways, but which also serves as crucial points for public infrastructure.  

It's pretty frightening how much of this today's infrastructure is held together by virtual duct tape with very little knowledge about how they are working.  Now couple that with a great SSH/TLS migration, where any traces of the 'old world' algorithms need to be done away with, while keeping those same systems running.  Implementing new SSH and TLS across old and new systems in complex setups is most definitely a non trivial task and would require years to implement.  

That is the reason that standards bodies have already started looking at solutions.  By the time recommendations have been made, and the right security algorithms work their way into the software that we use, a great deal of time will have passed.  

Even then, it will still take a long time to convince businesses and organisations to put in the time and effort to modify all their systems.  It's a bit of speculation, but it might take an actual, high-impact security incident to occur to convince product and business owners to scramble to patch their own systems.  


## Who's working on solutions

There are three major authorities who are looking at this problem. NIST, based in the US.  NCSC, based in the UK. And ETSI, based in the EU but operating worldwide.  

Of these three, NIST (US) and ETSI (EU) and working on recommendations and solutions, while [NCSC (UK) will be following NIST's lead](https://www.ncsc.gov.uk/whitepaper/preparing-for-quantum-safe-cryptography). 

What NIST and ETSI are actually doing is bringing together cryptographic experts along with government and business representatives.  Their aim is to provide a set of recommendations for post quantum cryptography (PQC).  Some of these will be the algorithms themselves, but a large part of it will also be providing guidance and strategies to businesses and agencies on how to figure out what's affected, and how to migrate those systems.  In other words, the work isn't being done in isolation in an ivory tower, and it's not just about the algorithms.  

Both bodies are documenting their work.  [ETSI's initial whitepaper on quantum safe cryptography](https://www.etsi.org/images/files/ETSIWhitePapers/QuantumSafeWhitepaper.pdf) is quite thorough, although the rest of their information is scattered about, poorly organised, and harder to make sense of.  NIST's documentation is [better organised](https://csrc.nist.gov/projects/post-quantum-cryptography) and is easier to follow, even their discussions are happening in the open.  I've only been able to summarize the ongoings in the NIST sphere.  

## NIST

NIST started organising around this topic in 2015, their aim was to achieve general consensus and assure trust in the algorithms that they would be choosing.  They've come up with a set of criteria for the algorithms to be chosen, so that others (universities, organisations, individuals) can make submissions for evaluation and selection.  Some of the criteria are making sure the algorithms are publicly disclosed; they shouldn't rely on components that aren't quantum safe; proving there are no back-doors. 

### Submissions

There have been three rounds of submissions, the first one was in 2017 and the latest in 2020. It's actually possible to [see the submissions](https://csrc.nist.gov/Projects/post-quantum-cryptography/Round-1-Submissions) along with their quirky names and reference code in the zip files. The [third conference held in 2020](https://csrc.nist.gov/events/2021/third-pqc-standardization-conference) holds several presentation topics and [even some videos](https://csrc.nist.gov/Projects/post-quantum-cryptography/workshops-and-timeline/round-3-seminars).  

NIST is expecting to draft some standards between 2022 and 2024.  We should start seeing more concrete news and recommendations around then.  


### Discussions

There's a [mailing list, the pqc-forum](https://groups.google.com/a/list.nist.gov/g/pqc-forum) where you can see all the discussions happening out in the open! It's pretty fascinating watching cryptographics experts having technical discussions across multiple scopes both broad and niche, even if a lot of it goes over my head. The discussions are usually technical in nature, and there are some announcements, updates, and the occasional argument.  

### Evaluation

In each round, the submitted algorithms are evaluated in a few ways.  The most important one is of course their resistance to both classical and quantum attacks.  Also evaluated is performance on classical computers, since these implementations will need to run on weak as well as powerful hardware.  And there are smaller factors such as, how easy a drop-in replacement would be, does it have perfect forward secrecy, is it resistant to side channel attacks, is it resistant to misuse.  

In the first round alone, of the 64 submissions, 16 were quickly attacked or broken and had to be rejected.  

## The Round 3 Finalists

For the third round of NIST's selection, 4 public key algorithms were chosen (Classic McEliece, Crystals-Kyber, NTRU, and Saber) and 3 were chosen for digital signatures (Crystals-Dilithium, Falcon, and Rainbow).  

These choices will be narrowed down further over the next year.  Among the public key algorithms, Kyber, NTRU, and Saber are 'lattice scheme' algorithms, and NIST intends to pick just one.  Among the digital signatures, Dilithium and Falcon are also lattice schemes, again just one will be picked.  NIST expects that lattice scheme algorithms will become the general purpose algorithm in the future, and eventually names we'll become somewhat familiar with on a regular basis.  

### Performance

In terms of performance, Kyber and Saber are the highest ranked.  The results can be seen [here](https://csrc.nist.gov/CSRC/media/Presentations/fpga-benchmarking-of-crystals-kyber-ntru-and-saber/images-media/session-3-gaj-high-speed-hardware.pdf).  High performance algorithms are more likely to be used in protocols where speed is a concern, such as HTTPS/TLS.  

### VPNs

The two most popular VPN implementations are OpenVPN and WireGuard.  Microsoft Research have created a proof of concept using OpenVPN, to make it quantum safe using FrodoKEM.  Although FrodoKEM isn't a third round finalist although it's expected to be evaluated in a fourth round. Wireguard have added quantum safe cryptography to their implementation, using McEliese and Saber.  

### IoT and embedded devices

Embedded devices play a role in critical infrastructure, such as power grids, transportation and water.  These devices can stay in place for decades, and work with very limited resources (for example, 4KB RAM and 100 MHz CPUs).  For that reason their selection criteria depend greatly on key sizes. And because there are devices today which will be around in 20 years, embedded device and IoT engineers need to get started with implementations as soon as possible. [Their preference](https://csrc.nist.gov/Presentations/2021/requirements-for-post-quantum-cryptography-on-embe) would be Kyber or Saber for key algorithms, and Falcon for signatures.  

### What vehicle manufacturers want

In [Vehicle to Vehicle communication](https://csrc.nist.gov/CSRC/media/Presentations/suitability-of-3rd-round-signature-candidates-for/images-media/session-5-bindel-suitability-vehicle.pdf), vehicles broadcast Basic Safety Messages (BSMs) 10 times per second to their surroundings, containing information like speed, direction and brake status.  Vehicles are expected to receive and process each other's BSMs rapidly, and so the focus is on reliability and speed of verification due to the realtime nature of the decisions involved in dense environments. The preferred algorithms were Dilithium and Falcon.  However the packet sizes involved with Dilithium weren't great when it came to rapid verifications, so they might be leaning towards Falcon.  

{% include gallery id="gallery3" caption="Vehicle to Vehicle" %}

### The Crystals, Kyber and Dilithium

These interesting names are references to Star Wars and Star Trek respectively.  

A Kyber crystal, from Star Wars, is used as the living crystal inside lightsabers. Incidentally, Saber is another chosen algorithm (not from the same Crystals group), and one of their implementations is named LightSABER. 

Dilithium is used in spaceships in the Star Trek universe for matter-antimatter reactors.  Although they appear to be from the same family, their formulations and implementations seem to be by different authors.  Both reference implemenations for [Kyber](https://github.com/pq-crystals/kyber) and [Dilithium](https://github.com/pq-crystals/dilithium) are on Github.  

### Classic McEliece

This is an interesting one; originally developed in 1978, it never gained much acceptance, but is now a third round finalist.  It's immune to attacks from Shor's algorithm.  It's faster than RSA.  However one disadvantage is that its public keys are pretty large, a typical implementation would be about 512kb.  This becomes a barrier for some implementations as key lengths play a role on devices where there is limited storage, memory and CPU power, such as the IoT case above.  It might not be a great choice for TLS either, since the large key would require multiple packets to transmit. 

### There's always a patent troll

Because it's now a given that we can't have nice things, the problem of patents has reared its head.  A 'research organisation' from France, known as CNRS, appear to be claiming that [their patent](https://patents.google.com/patent/US9094189B2/en) covers the Kyber and Saber algorithms.  They've also made their position quite clear [on their website regarding the royalty rates they are expecting](http://web.archive.org/web/20211023161655/https://www.cnrsinnovation.com/?lang=en).  

The problem becomes, if NIST goes ahead and picks Kyber or Saber, and CNRS starts demanding royalties, then there will be great barriers towards adoption of the chosen algorithms.  If they litigate and win (court systems tend to favor patent holders), then the standard becomes patent encumbered.  In the worst case then, one of the next generation's most important security updates gets held hostage due to greed.  

A thread on the pqc-forums covers why [the CNRS patent may not be applicable](https://groups.google.com/a/list.nist.gov/g/pqc-forum/c/2Xv0mrF9lVo) from a scientific perspective, though it's unclear whether that also applies from a legal perspective.     

There's also [another thread](https://groups.google.com/a/list.nist.gov/g/pqc-forum/c/nbIZhtICKWU/m/ML7aYY71AgAJ) discussing the same patent in the context of patent buyouts and dealing with patent risks in general.  Both threads make for interesting reads.  


## What's happening in the software industry

### Open Quantum Safe

This is the part that's closer to us as developers and end users.  Microsoft, IBM, and AWS are working with universities on the [Open Quantum Safe](https://openquantumsafe.org/) project.  The project has created a library called [`liboqs`](https://github.com/open-quantum-safe/liboqs) containing quantum resistant algorithms, which will be made available for use to other software projects.  The project is also prototyping integration into most commonly used protocols such as TLS, SSH, and certificates.  Importantly they also have a [fork of OpenSSL](https://github.com/open-quantum-safe/openssl) with some quantum safe algorithms implemented.  They've got demo integrations with Apache httpd, nginx, curl and [Chromium browser](https://github.com/open-quantum-safe/oqs-demos/releases/).  There are [Docker images too!](https://hub.docker.com/u/openquantumsafe)

[![Open Quantum Safe]({{ site.baseurl }}/assets/images/general-understanding-quantum-safe-cryptography/008.jpg)]({{ site.baseurl }}/assets/images/general-understanding-quantum-safe-cryptography/008.jpg)

### Cloudflare

Cloudflare are also working on their [CIRCL](https://github.com/cloudflare/circl) library which is a collection of implementations, including post quantum cryptographic ones, specifically SIKE, CSIDH, Kyber and Dilithium. 

There's also an in-depth [blog post](https://blog.cloudflare.com/towards-post-quantum-cryptography-in-tls/) where they cover their efforts towards PQC. One of these efforts was a [TLS Post-Quantum experiment with Google](https://blog.cloudflare.com/the-tls-post-quantum-experiment/) to evaluate the performance and feasibility of some new ciphers.  

### Microsoft

Microsoft Research are covering [their efforts](https://www.microsoft.com/en-us/research/project/post-quantum-cryptography/) through multiple PQC algorithms named FrodoKEM, SIKE, Picnic, and qTESLA.  They're also working on integrations for OpenVPN, TLS/OpenSSL and OpenSSH.  



## Final thoughts and how to keep up with PQC news

So there's more to come over the next few years.  Final choices and recommendations, hopefully some resolution to the potential patent headaches, and some actual implementations.  What is clear though, is that doing nothing isn't an option, and that's a pretty Shor bet.  

Keeping up with ongoing PQC updates doesn't seem to be easy.  One way would be to join their [mailing list](https://csrc.nist.gov/Projects/post-quantum-cryptography/Email-List) at the risk of getting too much indecipherable 'noise'.  The other would be to 'watch' the [NIST PQC News page](https://csrc.nist.gov/Projects/post-quantum-cryptography/news).  That page doesn't seem to have an RSS feed, although there are a few [topic based RSS feeds](https://www.nist.gov/pao/nist-rss-feeds), again with the risk of too much 'other noise'.  