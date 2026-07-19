---
title: Privacy is not a soundbite
description: \"They're selling your data\" is missing the point of privacy
tags:
  - privacy
  - data
  - control


---

An unfortunate aspect regarding the privacy discourse is how it has been subverted into a series of meaningless soundbites that detract from actual privacy issues. A commonly used expression, often used to gatekeep services, is about how "they are selling your data". That's a gross oversimplification of what privacy is, and actively harms the concept of privacy by framing it as a binary. 

It takes just a few seconds of critical thinking to watch it fall apart. If a company were to give your data away for free, would that be acceptable? If they use your data as leverage over other entities, would that that be acceptable? If they're selling your data, but you've given them fake data, is that acceptable? How about if you want your data to be sold, but also want to be paid for it? These are deliberately rhetorical questions, not meant to be answered, but to illustrate that the evaluation of privacy is not a single question. 

Another often used expression is "If it's free, you are the product". This is what's known as a [thought terminating cliché](https://en.wikipedia.org/wiki/Thought-terminating_clich%C3%A9); it is little more than a pseudo-aphorism, spoken with a smug sense of self satisfaction, and made possible only by having spent zero time thinking about the expression itself. Free and open source software, known primarily for respecting user freedom and privacy, exists and is thriving, where users are most certainly not the product. In paid software, there is no magical flag that suddenly makes it privacy friendly for people who pay versus people who don't pay. Paid, commercial software is by its nature and definition, highly privacy invasive, as their aim is revenue generation, and are incentivised to do so by any means necessary. This is not limited to a contradicting duality in which they implement both privacy invasive features as well as market themselves as being privacy friendly.  

If the immediate response to all of this dissection is "Well, you know what I mean", then that is exactly the problem (and I don't think it has any meaning) - the purpose of soundbites is to say "don't pay attention to the stuff going on over here, just focus on this one thing". I don't really blame ourselves for falling for this kind of thinking; privacy is a nuanced topic that requires effort, and we inherently seek the path of least resistance. Soundbites are appealing because they are easy to understand, and make us feel like we've grasped a topic. They make companies happy because they've successfully avoided scrutiny; you'll know this is working if you have ever heard justification for other privacy invasive companies with "Well, at least they're not selling my data", which is a reluctance to put any further thought into the matter. 

## Control of data

Privacy is about control of data. It is about whether you control what is happening to your data. It's not just whether a company profits from it, but what it's used for and how it's used. The topic of profiting is an unfortunate bikeshed which dominates conversations, when as individual evaluators, we should be thinking more about what is happening with our data as we use these services. 

In some ways, the topics of privacy and security are similar. It would be ridiculous to hear someone say "Yes we are secure" or "If it's free, you are vulnerable", because security is not a binary flag. It is a series of measures and controls that can be implemented, or not implemented. It takes effort to be secure, and it takes continuous effort to _stay_ secure. Just the same, it takes effort to be private, and it takes continuous effort to maintain privacy.

A well known example of how this effort manifests is the GDPR privacy regulation; we groan at the annoying cookie banners and dialogs, yet this is the result of a regulation that requires companies to explain to you what they're doing with your data, and to give you a choice about it. The intention is absolutely right, it's the implementation that is annoying and at times overwhelming.

This is how I try to frame it, at least it works for me: if you are given a choice of what happens to your data, that is a privacy gain. If you are not given a choice, that is a privacy loss. It is not enough to be told that something is private, if a company is telling you something is private or something is for your own good, then you are being marketed to and not necessarily in control. 

In the real world, services can have privacy gains and losses sitting together, it is up to us as users to evaluate them and ensure that we are comfortable with the tradeoffs. 

## My contrived observations

I spent some time thinking of some examples of gains and losses, it's not meant to be an authoritative collection for picking apart, only as an illustrative list. 

Google Maps will include your telemetry as part of its route calculation and traffic congestion overlay, which is useful, though there is no way to opt out of it. This is a privacy loss. 

Google Location Sharing allows you to share your location with specific people; it's opt-in, and can be turned off at any time. They also send you frequent reminders that you have it turned on. This is a privacy gain, and an example of a duality that can coexist within a single service. 

I recently tried to set up an iCloud account, and was blocked from proceeding without handing over my phone number and credit card. This is a privacy loss, and an egregious one, as those details are not necessary for the actual account to exist; it was a bit too invasive for me so I did not proceed.

Windows 11 requires an online account to be set up, which is a privacy loss, and they had begun clamping down on various bypass methods, making it an annoying privacy loss. They are now working on [removing that requirement](https://www.pcgamer.com/software/operating-systems/microsoft-is-working-on-removing-the-online-account-login-requirement-for-new-windows-11-installs-and-also-reducing-unnecessary-copilot-entry-points/), which would be a privacy gain.

On iOS, all browsers are effectively Safari wrappers, which is a disturbing privacy loss, as not only does it remove user choice, it requires the use of a proprietary closed source engine that is forced upon users in their 'best interests'. 

Going shopping these days, it's becoming increasingly difficult to pay with cash, and in some cases impossible. A customer may not always want to have their purchases tied to their identity, regardless of reason, and the lack of choice is a privacy loss.

## Security and privacy don't always align

While they can often overlap, security is about the protection of data, and the implementation or tradeoffs made to achieve that protection. In an enterprise context, security can involve setting up scanners on employee laptops, firewalls to inspect and log traffic, TLS interception, and DNS filtering. These measures are not very different from malware, the only difference is the audience is within the company. 

It is entirely possible to be secure, and violate users' privacy. As such the two topics should often be considered separately, and not conflated. 

## Looking at the wider context

The much vaunted passkeys are an interesting instance a privacy loss/security gain for the average user that accepts the defaults: In exchange for a 'tamper proof' login, they are giving up control of their private keys to their ecosystem provider, which is a dangerous privacy loss, as the user is at the whims of a business that could shut off access at any time, and without recourse. Although passkeys do allow for the option of managing your own keys, it is an option employed by a minority of users who will already have been using password managers, and are therefore not the primary target audience for passkeys. Someone less cynical than me should be able to easily observe that the passkey system (for the average user) is little more than a thinly veiled ecosystem lock-in. 

The reason for mentioning passkeys is that you often need to look at the wider context as well. The 'guardians' of the passkey spec have designed it specifically for commercial interests in a manner that is [incompatible with open source](https://www.smokingonabike.com/2025/01/04/passkey-marketing-is-lying-to-you/). The companies that [pushed for passkeys](https://fidoalliance.org/apple-google-and-microsoft-commit-to-expanded-support-for-fido-standard-to-accelerate-availability-of-passwordless-sign-ins/) all run closed, proprietary ecosystems, and are well known for their aggressive anti-competitive practices, platform abuse, and compliance with government data turnover requests. In our current 'climate', it is no longer a tinfoil hat conspiracy to assume that this will not end well, and is not in users' best interests when it comes to privacy. 


## Open source

Open source software is often tied together with being privacy friendly as opposed to commercial offerings. The distinguishing factor is the incentive with which the software is developed. Open source software is often developed by people who are privacy conscious, and therefore have a greater chance of implementing privacy friendly defaults, and by virtue of being open, are automatically more transparent about what the software is doing. 

Commercial software is developed with the primary goal of revenue generation. Where there exists a conflict between privacy and revenue, revenue will usually win out. Being closed source, by definition, there cannot be true transparency about what the software or service is doing, which is why it falls to the marketing aspects to convince users that everything is fine. It includes those soundbites mentioned earlier.

The strength of marketing's effectiveness lies in its ability to shape perceptions, and its effectiveness has been proven by the widespread acceptance of marketing messages and soundbites, even when they contradict observable reality.

## Opt in and opt out

A frequent complaint from users is that they are forced to opt out of various features. The _ability_ to opt out is a privacy gain, as it is about control. The complaint comes from a place of frustration, as it is not a privacy friendly default, which leaves a sour taste for those paying attention. 



