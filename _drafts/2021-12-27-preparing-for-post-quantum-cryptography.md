---
title: "Quantum computers will break our security, and what is being done about it"
description: "..."

gallery1:
  - url: /assets/images/preparing-for-post-quantum-cryptography/002.png
    image_path: /assets/images/preparing-for-post-quantum-cryptography/002.png
  - url: /assets/images/preparing-for-post-quantum-cryptography/003.png
    image_path: /assets/images/preparing-for-post-quantum-cryptography/003.png

gallery2:
  - url: /assets/images/preparing-for-post-quantum-cryptography/005.png
    image_path: /assets/images/preparing-for-post-quantum-cryptography/005.png
  - url: /assets/images/preparing-for-post-quantum-cryptography/006.png
    image_path: /assets/images/preparing-for-post-quantum-cryptography/006.png    
  - url: /assets/images/preparing-for-post-quantum-cryptography/007.png
    image_path: /assets/images/preparing-for-post-quantum-cryptography/007.png    
---



As a computing end user, I've been vaguely aware of quantum computing emerging on the horizon, but haven't been aware regarding its effect on us. To that end I decided to get a layman's understanding at how quantum computers would affect our security, and what's happening right now in the industry to address these issues.  I'm only vaguely aware that our SSH keys will need changing, and browsers will need to perform TLS differently, but without understanding the why.      

## How it started, Shor's Algorithm

In 1994, mathematician Peter Shor devised a quantum computing algorithm to solve a problem that goes, _"Given an integer N, find its prime factors"_.  It's a simple sentence with large implications.  The significance is that the stated problem is how you'd go about decrypting messages based on our current key exchange algorithms. That is, many key exchange algorithms today work by multiplying two large prime numbers to get a result, and rely on the opposite direction, figuring out which prime numbers were used, being difficult to solve. 

On today's computers (usually referred to as classical machines), for large values, this can take trillions of years, and it is this difficulty which gives us the assurance we need that our key exchanges and authentication steps are safe.  

[![prime factors of an integer]({{ site.baseurl }}/assets/images/preparing-for-post-quantum-cryptography/001.png)]({{ site.baseurl }}/assets/images/preparing-for-post-quantum-cryptography/001.png)


### What this means for SSH and TLS

By showing that this stated problem has a trivial solution on quantum computers, it means that a sufficiently powerful quantum computer could break the fundamental steps used in SSH and TLS (namely RSA and Elliptic Curve cryptography).  As a specific example, it would take 300 trillion years to break an RSA-2048 encryption key for a classical machine, but [just 10 seconds for a quantum computer](https://www.quintessencelabs.com/blog/breaking-rsa-encryption-update-state-art/).  

As it stands right now, our SSH keys are not quantum safe.  Even though OpenSSH have recently [deprecated RSA](https://levelup.gitconnected.com/demystifying-ssh-rsa-in-openssh-deprecation-notice-22feb1b52acd), and many people will be moving towards the more secure ED25519 key format, neither are safe.  

The same vulnerabilities apply to TLS, where the impact is even larger.  TLS is of course used by browsers and other tools when negotiating traffic to HTTPS URLs.  It's also used by backend systems, such as clients talking to databases, queues and messaging systems.  TLS is a huge part of the software operational backbone for TCP communications.   

All this in turn means, some day in the future, we will need to start using a newer type of SSH key and newer TLS encryption schemes across systems.  Between SSH and TLS, this pretty much covers a huge swathe of infrastructure, and not mitigating can have huge impacts with economic, legal and political consequences.  

## Why worry now

### Quantum computers are weak for now

Quantum computers aren't very powerful today.  They are constrained by a few problems, the first one is called coherence time; it's the duration that the qubits in a quantum computer can stay useful for the purposes of a calculation.  If a calculation on a quantum machine requires more time than the coherence, then the machine won't be able to solve the problem.  The best time achieved as of 2021 has been around 300 to 500 microseconds, which isn't very useful considering the 10 seconds quoted above for breaking RSA-2048.  However there is always research being done to [increase this coherence time to 1 hour and more](https://www.nature.com/articles/s41467-020-20330-w).   

{% include gallery id="gallery1" layout="third" caption="Increasing quantum coherence" %}

The other problem is the number of qubits in the quantum computer.  In the above RSA-2048 breaking example, the quantum computer would need 4099 stable qubits, in addition to the stable coherence time stated. In 2021, IBM has the largest quantum computer at a mere [127 qubits](https://www.newscientist.com/article/2297583-ibm-creates-largest-ever-superconducting-quantum-computer/).  I say 'mere' here as qubits could become subject to a quantum version of Moore's law and this number becomes a footnote.  

These stated numbers are changing frequently though, as universities and organisations are outdoing each other in a slow race. It's tempting to think that quantum computing might stay in the realm of curiosity and not progress much past this coherence and qubit size, and similar sentiments have been held in the past regarding classical computers and the internet as well.     

{% include gallery id="gallery2" layout="third" caption="Breaking qubits barrier" %}

### But the IT industry is slow

From what I've seen, most authoritative and standard bodies are estimating that at some point in the next 15-20 years, quantum computers will become sufficiently powerful to pose a real threat to today's security.  That seems like a generation away, but anyone with experience in the IT sector can attest to the glacial pace at which changes occur across any given systems.  This is even more the case with systems that are entrenched and embedded among large sprawling legacy setups in complex dependencies that build up over time in undocumented ways, but which also serves as crucial points for public infrastructure.  

It's frightening how much of this today's infrastructure is held together by virtual duct-tape with very little knowledge about how they are working.  Now couple that with a great SSH/TLS migration, where any traces of the 'old world' algorithms need to be done away with completely, while keeping those same systems running.  Implementing new SSH and TLS across old and new systems in complex setups is most definitely a non trivial task and would require years to implement.  

That is the reason that standards bodies have already started looking at solutions.  By the time recommendations have been made, and the right security algorithms work their way into the software that we use, a great deal of time will have passed.  

Even then, it will still take a long time to convince businesses and organisations to put in the time and effort to modify all their systems.  It's a bit of speculation, but it might take an actual, high-impact security incident to occur to convince product and business owners to scramble to patch their own systems.  


## Who's working on solutions

There are three major authorities who are looking at this problem. NIST, based in the US.  NCSC, based in the UK. And ETSI, based in the EU but operating worldwide.  

Of these three, NIST and ETSI and working on recommendations and solutions, while [NCSC will be following NIST's outputs](https://www.ncsc.gov.uk/whitepaper/preparing-for-quantum-safe-cryptography). 

What NIST and ETSI are actually doing is bringing together cryptographic experts along with government and business representatives.  Their aim is to provide a set of recommendations.  Some of these will be the algorithms themselves, but a large part of it will also be providing guidance and strategies to businesses and agencies on how to figure out what's affected, and how to migrate those systems.  In other words, the work isn't being done in isolation in an ivory tower.  

Both bodies are documenting their work.  [ETSI's initial whitepaper on quantum safe cryptography](https://www.etsi.org/images/files/ETSIWhitePapers/QuantumSafeWhitepaper.pdf) is quite thorough, although the rest of their information is scattered about and harder to make sense of.  NIST's documentation is [better organized](https://csrc.nist.gov/projects/post-quantum-cryptography) and is easier to follow, even their discussions are happening in the open.  I've only been able to summarize the ongoings in NIST.  

## NIST

NIST started organizing around 2015, in order to achieve general consensus and assure trust in the algorithms that they choose.  They've come up with a set of criteria for the algorithms to be chosen, so that others (universities, organisations, individuals) can make submissions for evaluation and selection.  Criteria such as, making sure the algorithms are publicly disclosed; they shouldn't rely on components that aren't quantum safe; prove there are no back-doors. 

They went through three rounds of submissions, the first one was in 2017 and the latest was in 2020. It's actually possible to [see the submissions](https://csrc.nist.gov/Projects/post-quantum-cryptography/Round-1-Submissions) along with their quirky names. The [third conference held in 2020](https://csrc.nist.gov/events/2021/third-pqc-standardization-conference) holds a huge number of presentations and topics and [even some videos](https://csrc.nist.gov/Projects/post-quantum-cryptography/workshops-and-timeline/round-3-seminars), all of which contained topics and words I could barely understand.  

NIST is expecting to draft some standards between 2022 and 2024.  We should start seeing more concrete news around then.  

### Evaluation

In each round, the submitted algorithms are evaluated in a few ways.  The most important one is of course their resistance to both classical and quantum attacks.  Also evaluated is performance on classical computers, since these implementations will need to run on weak as well as powerful hardware.  And there are smaller factors such as, how easy a drop-in replacement would be, does it have perfect forward secrecy, is it resistant to side channel attacks, is it resistant to misuse.  

In the first round alone, of the 64 submissions, 16 were quickly attacked or broken and had to be rejected.  

### Third round finalists

In the third round, 5 public key algorithms were chosen (Classic McEliece, Kyber, NTRU, and Saber) and 3 were chosen for digital signatures (Dilithium, Falcon, and Rainbow).  

These choices will be narrowed down further.  Kyber, NTRU, Saber are a 'lattice scheme' and so just one of these will be selected.  One of these are most likely to become the most common, general purpose algorithm in the future.  

#### Performance

In terms of performance, Kyber and Saber are the highest ranked.  The results can be seen [here](https://csrc.nist.gov/CSRC/media/Presentations/fpga-benchmarking-of-crystals-kyber-ntru-and-saber/images-media/session-3-gaj-high-speed-hardware.pdf).  

#### VPNs

The two most popular VPN implementations are OpenVPN and WireGuard.  Microsoft Research created a proof of concept using OpenVPN, to make it quantum safe using FrodoKEM.  Frodo isn't a third round finalist although it's expected to be evaluated in a fourth round. Wireguard have added quantum safe cryptography to their implementation, using McEliese and Saber.  

#### What IoT wants

Embedded devices play a role in critical infrastructure, such as power grids, transportation and water.  These devices can stay in place for decades, and work with very limited resources (eg, 4KB RAM, 100 MHz CPU).  For that reason their selection criteria depend greatly on key sizes.  Based on this their preference would is Kyber or Saber for key algorithms, and Dilithium for signatures.  

#### What vehicle manufacturers want

Vehicle to Vehicle communication was brought up as a topic, where the focus is on reliability and speed of verification due to the realtime nature of the operations involved in dense environments.  The preferred algorithms were Dilithium and Falcon.  However the packet sizes involved with Dilithium weren't great when it came to rapid verifications, so they might be leaning towards Falcon.  


#### Classic McEliece

This is an interesting one; originally developed in 1978, it never gained much acceptance, but is now a third round finalist.  It's immune to attacks from Shor's algorithm.  It's faster than RSA.  However one disadvantage is that its public keys are pretty large.  This becomes a barrier for some implementations as key lengths play a role on devices where there is limited storage, memory and CPU power.  




NIST , others are following

How are they deciding things. 

What criteria.  

NIST isn't against implementations that make use of a patent claim.  

There's a forum.  PQC.  

### Links

https://arxiv.org/abs/quant-ph/9508027

https://www.microsoft.com/en-us/research/project/post-quantum-ssh/

https://unix.stackexchange.com/questions/347295/how-can-i-generate-sha3-if-there-is-no-sha3sum-command-in-coreutils

nist: https://nvlpubs.nist.gov/nistpubs/CSWP/NIST.CSWP.05262020-draft.pdf

nist: https://csrc.nist.gov/Projects/Post-Quantum-Cryptography

NCSC following NIST: https://www.ncsc.gov.uk/whitepaper/preparing-for-quantum-safe-cryptography

https://quantumcomputing.stackexchange.com/a/1389

https://techbeacon.com/security/waiting-quantum-computing-why-encryption-has-nothing-worry-about

mailinsg list: https://groups.google.com/a/list.nist.gov/g/pqc-forum

how it'll affect TLS: https://blog.cloudflare.com/towards-post-quantum-cryptography-in-tls/

IOT requirements; https://csrc.nist.gov/Presentations/2021/requirements-for-post-quantum-cryptography-on-embe


SSH new keys.  TLS new algorithms.  

Commercial interests, IOT.  Smaller file sizes, easier cycles.  

Patent encumbered KYBER by CNRS:  https://groups.google.com/a/list.nist.gov/g/pqc-forum/c/2Xv0mrF9lVo

PQC forum: https://groups.google.com/a/list.nist.gov/g/pqc-forum






