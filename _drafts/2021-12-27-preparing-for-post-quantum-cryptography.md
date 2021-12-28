---
title: "Making sense of ongoing work happening towards post quantum cryptography"
description: "..."

---



As a computing end user, I've been vaguely aware of quantum computing emerging on the horizon, but haven't been aware regarding its effect on us. To that end I decided to get a layman's understanding at how quantum computers would affect our security, and what's happening right now in the industry to address these issues.  I'm only vaguely aware that our SSH keys will need changing, and browsers will need to perform TLS differently, but without understanding the why.      

## How it started, Shor's Algorithm

In 1994, mathematician Peter Shor devised a quantum computing algorithm to solve a problem that goes, _"Given an integer N, find its prime factors"_.  The significance is that the stated problem is how you'd go about decrypting messages based on our current key exchange algorithms. That is, many key exchange algorithms today work in the opposite direction, by multiplying two large numbers, and rely on the opposite direction being difficult to solve. On today's computers (usually referred to as classical machines), for large values, this can take trillions of years, and it is this difficulty which gives us the assurance we need that our key exchanges and authentication steps are safe.  




### What this means for SSH and TLS

By showing that this stated problem has a trivial solution on quantum computers, it means that a sufficiently powerful quantum computer could break the fundamental steps used in SSH and TLS (namely RSA and Elliptic Curve cryptography).  As a specific example, it would take 300 trillion years to break an RSA-2048 encryption key for a classical machine, but [just 10 seconds for a quantum computer](https://www.quintessencelabs.com/blog/breaking-rsa-encryption-update-state-art/).  

As it stands right now, our SSH keys are not quantum safe.  Even though OpenSSH have recently [deprecated RSA](https://levelup.gitconnected.com/demystifying-ssh-rsa-in-openssh-deprecation-notice-22feb1b52acd), and many people will be moving towards the more secure ED25519 key format, neither are safe.  

The same vulnerabilities apply to TLS used by browsers and other tools when negotiating traffic to HTTPS URLs.  Not just browers but by backend systems too such as clients talking to databases, queues and messaging systems.  TLS is a huge part of the software operational backbone.  

All this in turn means, some day in the future, we will need to start using a newer type of SSH key and newer TLS encryption schemes across systems.  Between SSH and TLS, this pretty much covers a huge swathe of infrastructure that our economy and way of life depends on.  

## Why worry now?

### Quantum computers are weak today

Quantum computers aren't very powerful today.  They are constrained by a few problems, the first one is called coherence time; it's the duration that the qubits in a quantum computer can stay useful for the purposes of a calculation.  The best time achieved as of 2021 has been around 300 to 500 microseconds, which isn't very useful considering the 10 seconds quoted above for braeking RSA-2048.  However there is always research being done to [increase this coherence time to 1 hour and more](https://www.nature.com/articles/s41467-020-20330-w).   

The other problem is the number of qubits in the quantum computer.  In the above RSA-2048 breaking example, the quantum computer would need 4099 stable qubits, in addition to the stable coherence time stated. In 2021, IBM has the largest quantum computer at a mere [127 qubits](https://www.newscientist.com/article/2297583-ibm-creates-largest-ever-superconducting-quantum-computer/).  I say 'mere' here as qubits could become subject to a quantum version of Moore's law and this number becomes a footnote.  

These stated numbers are changing frequently though, as universities and organisations are outdoing each other in a slow arms race.  It's still tempting to think that quantum computing might stay in the realm of curiosity and not progress much past this coherence and qubit size, similar sentiments have been held in the past regarding classical computers and the internet as well.    

### But the IT industry is slow

From what I've seen, most authorities are estimating that at some point in the next 20 years, quantum computers will become sufficiently powerful to pose a real threat to today's signature and key exchange algorithms.  Anyone with experience in the IT sector can attest to the glacial pace at which changes occur across any given systems.  This is even more the case with systems that are entrenched and embedded among large sprawling legacy setups in complex dependencies that build up over time in undocumented ways, but which also serves as crucial points for public infrastructure.  

It's scary how much of this today's infrastructure is held together by virtual duct-tape with very little knowledge about how they are working.  Now couple that with a great SSH/TLS migration, where any traces of the 'old world' algorithms need to be done away with completely.  Implementing new SSH and TLS across old and new systems in complex setups is most definitely a non trivial task and would require years to implement.  

That is the reason for starting looking at replacements now.  By the time decisions have been made and the right security algorithms make it into the software that we use, a great deal of time will have passed.  


### Who's deciding

NIST , others are following


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






