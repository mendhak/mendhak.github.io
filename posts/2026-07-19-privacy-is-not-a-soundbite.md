---
title: Privacy is not a soundbite
description: \"They're selling your data\" is missing the point of privacy, and things to think about when evaluating privacy
tags:
  - privacy
  - data
  - control


---

An unfortunate aspect regarding the privacy discourse is how it has been subverted into a set of meaningless soundbites that detract from actual privacy issues. A commonly used refrain, often used to gatekeep software and services, is about how "they are selling your data". That's a gross oversimplification of what privacy is, and actively harms the concept of privacy by framing it as a binary. 

It takes just a few seconds of critical thinking to watch it fall apart. 

* If a company were to give your data away for free, would that be acceptable? 
* If they use your data as leverage over other entities, would that be acceptable? 
* If they're selling your data, but you've given them fake data, is that acceptable? 
* How about if you want your data to be sold, but also want to be paid for it? 

These are deliberately rhetorical questions, not meant to be answered, but to illustrate that the evaluation of privacy is not a single question. 

Another often used expression is "If it's free, you are the product". This is what's known as a [thought terminating cliché](https://en.wikipedia.org/wiki/Thought-terminating_clich%C3%A9); it is little more than a pseudo-aphorism, spoken with a smug sense of self satisfaction, and made possible only by having spent zero time thinking about the expression itself. 

Free and open source software, known primarily for respecting user freedom and privacy, exists and is thriving, where users are most certainly not the product. In paid software, there is no magical flag that suddenly makes it privacy friendly for people who pay versus people who don't pay. Paid, commercial software is by its nature and definition, highly privacy invasive, as their aim is revenue generation, and are incentivised to do so by any means necessary. 

This is not limited to a contradicting duality in which they implement both privacy invasive features as well as market themselves as being privacy friendly. I don't exclude the ever present "we don't sell your data" and "we take your privacy seriously" lines usually seen in privacy policies. Where they once had meaning, they are now expected opening lines, the equivalent of T&C small talk.

If the immediate response to all of this dissection is "Well, you know what it means", then that is exactly the problem (and I don't think it has any meaning) - the purpose of soundbites is to say "don't pay attention to the stuff going on over here, just focus on this one thing". They are not automatically understood as proxies to broader underlying concerns.

I don't really blame us for falling into this trap; privacy is a nuanced topic that requires effort, and we inherently seek the path of least resistance. Soundbites are appealing because they are easy to understand, and make us feel like we've grasped a topic. They make companies happy because they've successfully avoided scrutiny; you'll know this is working if you have ever heard justification for other privacy invasive companies with "Well, at least they're not selling my data", which is a reluctance to put any further thought into the matter. 


## Control of data

Privacy is about control of data. It is about whether you control what is happening to your data. It's not just whether a company profits from it, but what it's used for and how it's used. The topic of profiting is an unfortunate bikeshed which dominates conversations, when as individual evaluators, we should be thinking more about what is happening with our data as we use these services. 

In some ways, the topics of privacy and security are similar. It would be ridiculous to hear someone say "Yes we are secure" or "If it's free, you are vulnerable", because security is not a binary flag, and it would be nonsensical to implement security protections only for paying users. Security is a series of measures and controls that can be implemented based on threat evaluations. It takes effort to be secure, and it takes continuous effort to _stay_ secure. Just the same, it takes effort to be private, and it takes continuous effort to maintain privacy.

The GDPR privacy regulation exemplifies this ongoing effort. We groan at the annoying cookie banners and dialogs, but this is the result of a regulation that requires companies to explain to you what they're doing with your data, and to give you a choice about it. The intention is absolutely right, it's the implementation that is overwhelming, fraught with dark patterns, and implemented poorly. 

This is how I try to frame it, at least it works for me: if you are given a choice of what happens to your data, that is a privacy gain. If you are not given a choice, that is a privacy loss. It is not enough to be told that something is private, if a company is telling you something is private or something is for your own good, then you are being marketed to and not necessarily in control. 

In the real world, services can have privacy gains and losses sitting together, it is up to us as users to evaluate them and ensure that we are comfortable with the tradeoffs. There will always be tradeoffs, and we'll be comfortable with some, and not others. 

## My observations

I spent some time thinking of some examples of gains and losses, it's not meant to be an authoritative collection for picking apart, only as an illustrative list. 

Google Maps will include your telemetry as part of its route calculation and traffic congestion overlay, which is useful, though there is no way to opt out of it. This is a privacy loss. 

Google Location Sharing allows you to share your location with specific people; it's opt-in, and can be turned off at any time. They also send you frequent reminders that you have it turned on. This is a privacy gain, and an example of a duality that can coexist within a single service. 

I recently tried to set up an iCloud account, and was blocked from proceeding without handing over my phone number and credit card. This is a privacy loss, and an egregious one, as those details are not necessary for the actual account to exist; it was a bit too invasive for me so I did not proceed.

Windows 11 requires an online account to be set up, which is a privacy loss, and they had begun clamping down on various bypass methods, making it an annoying privacy loss. They are now working on [removing that requirement](https://www.pcgamer.com/software/operating-systems/microsoft-is-working-on-removing-the-online-account-login-requirement-for-new-windows-11-installs-and-also-reducing-unnecessary-copilot-entry-points/), which would be a privacy gain.

On iOS, all browsers are effectively Safari wrappers, which is a disturbing privacy loss, as not only does it remove user choice, it requires the use of a proprietary closed source engine, tightly integrated with the OS, which is forced upon users in their 'best interests'. 

When going shopping these days, it's becoming increasingly difficult to pay with cash, and in some cases impossible. A person may not always want to have their purchases tied to their identity, regardless of reason, and the lack of choice is a privacy loss in the name of efficiency and convenience.

## Security and privacy don't always align

While they can often overlap, and are talked about in similar ways, security is about the protection of data, and the implementation or tradeoffs made to achieve that protection. In an enterprise context, security can involve setting up scanners on employee laptops, firewalls to inspect and log traffic, TLS interception, and DNS filtering. These measures are highly invasive, and are not very different in nature from malware, the only difference is the 'attackers' siphoning the data are within the company. 

It is entirely possible to be secure, and violate users' privacy. As such, the two topics should often be considered separately, and not conflated. 

Passkeys are one such example of a security gain being a privacy loss for average users. In exchange for a tamper proof login, they give up control of their private keys to the ecosystem providers. While technically possible to self-manage keys, the default implementations (which the average user follows) tend towards lock-in. Unhelpfully, the specs are designed with commercial interests prioritized, and in a way that makes it [incompatible with open source](https://www.smokingonabike.com/2025/01/04/passkey-marketing-is-lying-to-you/).


## Open source

Open source software is often tied together with being privacy friendly, as opposed to commercial offerings. The distinguishing factor is the incentive with which the software and services are developed. Open source software is often developed or used by privacy conscious communities, and have a greater chance of implementing privacy-friendly defaults. By virtue of being open, they are automatically more transparent about what the software is doing. Even when the open source offering is commercially backed, the incentive is to build a user base, tending towards transparency and friendly defaults and controls.  

Commercial software is developed with the primary goal of revenue generation. Where a conflict exists between privacy and revenue, revenue will usually win out. Being closed source, by definition, means there cannot be true transparency about what the software or service is doing, which is why it falls to the marketing aspects to convince users that everything is fine, and why those soundbites become so useful, even when they contradict reality. 


## Opt in and opt out

A frequent complaint from users is that they are forced to opt out of various features. The _ability_ to opt out is a privacy gain, as it is about control. The criticism comes from a place of frustration, as it is not a privacy friendly default, which leaves a sour taste for those paying attention. 

Telemetry collection is the most common area of complaint: it is often opt-out. Telemetry collection ties to the commercial incentives mentioned earlier, as the data is needed in order to understand the user base, which features are being used, and where to focus development efforts. If telemetry were to be opt-in, most users would simply not enable it, leaving the company without data needed to make informed decisions. And so, the default remains an opt-out, which is a choice, though not a friendly one.

Another emerging area of user concern is the use of generative AI features. Currently, most software and services do not allow users to opt out of those features at all, although commendably [Firefox has introduced an "AI kill switch"](https://blog.mozilla.org/en/firefox/ai-controls/), allowing you to opt out of specific AI features, or all of them.


## Finishing thoughts

Privacy isn't a slogan or checkbox, or a marketing message. It's a continuous evaluation of control, and knowing what's happening with your data, and making choices about it. It's a set of gains and losses, and tradeoffs you must make. 

The next time you encounter a clichéd soundbite, recognize them for what they are: thought stoppers designed to prevent critical thinking. Instead, it's always worth questioning the underlying assumptions: Do I control this? Can I turn it off? Do I understand why it's needed, and am I comfortable with it? 
