---
title: Using threat modelling to choose a password manager
description: Choosing and discarding from among many password managers by using threat modelling
tags:
  - keepass
  - kdbx
  - password
  - manager
  - threat-modelling

opengraph:
  image: /assets/images/threat-modelling-to-pick-password-manager/000.png

---

Common ways of choosing a password manager are to see what everyone else is using, search for what's popular, or just pick something convenient. I do the same, but also want to spend some time evaluating my choices because password managers are the 'keys to the kingdom'. Threat modelling feels like a really good fit in helping evaluate these choices, doing so at a high level can go a long way towards granting assurance and peace of mind.

Most password managers hold secrets in a 'vault' or an encrypted database of sorts. The vault is locked with a password that only I, the user, should know; the password manager is essentially a fancy search interface on top of this vault. What that means is both the vault and its keys are critical — without one, the other is pointless.


## Online password managers

Several popular password managers are web based, for the simple reason that accessing them via the browser is very convenient. The web interface is the password manager and the user uses it to find, edit, and create new entries. The vault sits behind this interface on the provider's servers. It's simple and inexpensive from an implementation point of view, which is why there are so many providers in this space. 

<img class="excalidraw" src="/assets/images/threat-modelling-to-pick-password-manager/001_web_based.png" />


### Trust

Since the entrypoint is in the cloud (someone else's computer), the entrypoint is also its attack surface, which is available to everyone. The provider is responsible for ensuring that its security is maintained, and that means that trust is an important factor. Since they are being entrusted with all the keys, the provider needs to be responsible and reliable, but we don't know what they're doing or running on their servers. The illusion of trust is maintained only as long as there are no disclosed incidents.

LastPass is an example of a provider that has damaged its reputation over the past few years due to its numerous breaches; LastPass proponents would justify it by saying that they are very quick to fix issues, however they miss a crucial point, that the damage will already have been done. It's like buying a stronger padlock after someone's broken into a shed: the tools were stolen and it's too late; you've responded correctly but now you'll always be the person with the weak shed.

To an extent, if the vendor's web application is open sourced, it goes some way towards increasing that provider's trustworthiness. Not everyone can read and audit source code, though with open source development, the actions (both good and bad) take place in the open and there is much less incentive. Historically, sufficiently popular software has been called out for questionable behavior that they might be introducing, as there are then enough eyes on it. It's still not a perfect solution, yet is far better than trusting proprietary code. 

Bitwarden is one such provider that runs an open source stack, and it is sufficiently popular that there are eyes on it. An advantage of doing this is a user can run the [Bitwarden server software](https://github.com/bitwarden/server) themselves if they choose, or simply stay with the Bitwarden cloud version with a relatively higher degree of trust compared to others. [Dashlane](https://github.com/Dashlane) has also partially open sourced their client-side applications, but not the server.

The always-on attack surface remains, and it takes just one incident or one lapse for a compromise, which a user would be powerless against.

### Costs and incentives

The other factor is costs. Since the vendor needs money to keep things running, they need to charge money, which is understandable. It also means that the password management service is only available to the user as long as payments continue. This is a one-way transactional relationship, in that the user is subject to the whims of the provider and its availability, its featureset, and any restrictions they choose to place. 

It is not enough to make money, it is never enough to make money. The providing company will want to make *more* money. To do so, they need to be seen as innovating and adding new features to attract new customers. More features means more moving parts, complexity, and attack surfaces. Any software developer with experience can attest to that. It is a great shame that password manager comparison sites, and people, will often focus on what features a password manager has, or whether it looks and feels nice. If there's one place that there ought to be *fewer* features, and where the look and feel really should not matter, it's a password manager. But I acknowledge that we are people, and we will judge by look and feel, even if it's to our detriment.

Feature development is not the only way to attract customers, the other is advertising. 1Password is a *particularly* egregious example of this and need to be called out for it. A few years ago they ran a relentless advertising and sponsorship campaign. Many tech sites, YouTube channels, bloggers, and online 'personalities' were openly endorsing it. None of them actually know what it is doing behind the scenes, but felt perfectly qualified to tell others to use it. Artefacts of this campaign can still be seen on some blogs, comparison websites, and forums too. There are telltale signs like common promotional phrasing being used (especially around the family plan), or it being the only one with a link on comparison sites. 

What's more, this campaign launched shortly after 1Password went from being a standalone offline password manager, to an online subscription based password manager. That was a pretty good way to highlight the transactional, whimsical nature of this relationship. These combined actions did not fill me with assurance, and after watching them for a while, I started referring to them as the NordVPN of password managers: popular and untrustworthy.

### Mobile and desktop clients

Most online password managers also maintain desktop and mobile clients. A copy of the vault is placed on the device for the local password manager UI to work with. The local password manager would interact with its hosted APIs to get the copy of the vault, as well as to enable various features or interactions that the local application needs to provide. 

<img class="excalidraw" src="/assets/images/threat-modelling-to-pick-password-manager/002_mobile_web_based.png" />

There are now additional attack surfaces available. The local vault which may be the same or yet another implementation of its online counterpart, with unknown security for closed source solutions. And the backend services or APIs that facilitate the application and its features. 

It's not a great idea to have so many attack vectors or to increase them. There's a dichotomy at play here: we want to use password managers to improve our security posture; we choose to compromise our posture for the sake of convenience. 

### Browser extensions 

Password managers provide browser extensions as a convenience tool, to help fill entries on web pages without the user having to manually copy and paste. These extensions act as a tunnel between the browser and the password manager vault. But it also means that they are a means of sending commands and controlling its behavior. A popular attack against extensions is to use hidden fields and have the password manager automatically fill them. Conversely though, without an extension, the risk of being phished exists, as it's still possible to be tricked into pasting passwords into a fake, convincing-looking website. It's probably best to keep paying attention to URLs, but if a browser extension must be used, disable auto-fill.

### Built-in password managers

Browsers now come with their own, built-in password managers. In terms of threat modelling, they are very similar to online password managers. They store the credentials in their local database, and take care of syncing it across different devices and sessions. This is probably the most convenient password manager of all, the user doesn't even have to think about it. It's only slightly better than not having a password manager, the additional risk here is that of lock-in and lock-out. 

Browsers are often gateways to the ecosystems of the vendors that create them: Edge (Microsoft), Chrome (Google), Safari (Apple), and continuing with the theme of convenience, will be the default choice for people encountering the innocuous 'remember your password?' dialog for the first time. Storing credentials in the same ecosystem used for everything else means that the vendors become the custodians of the user's vault _and_ the services they access. The relationship dynamic is hugely disadvantageous to the user. 

The user is permitted to access the vault as long as the user is compliant with the vendor's policies, terms, and not subject to any software bugs or administrative errors. Once a user is locked out, the prevailing assumption in all interactions with the vendor is always that the user is at fault, and the user needs to prove their trustworthiness. It doesn't even have to be an error, simply losing a primary device is enough to make getting back in very difficult. This happens to people regularly, and sadly (from my observations), it does not seem to prompt any initiatives to migrate password managers. Nor do the vendors have any incentive to take any care; they benefit from the lock-in and the difficulty of moving. 

An important point that using the browser itself overlooks: the user wouldn't be storing their ecosystem's password in the browser. They would instead be using a weak password as their ecosystem's main password. Overall, using the browser's built in password save feature is only marginally better than not using a password manager at all. 


## Offline Password Managers

The simplest kind of password manager from a threat modelling perspective is offline. There will be a vault file, and a desktop or CLI application to interact with it. The attack surface attention now shifts to the vault database. 


<img class="excalidraw" src="/assets/images/threat-modelling-to-pick-password-manager/003_offline.png" />

The most well known vault database format is [KDBX](https://keepass.info/help/kb/kdbx_4.html). Because the KDBX format is open and documented, there are numerous applications that work with this vault format. [KeePass2](https://keepass.info/) is the reference implementation by the same creator of KDBX, but there is also [KeePassXC](https://keepassxc.org/). There are mobile and commandline clients for KDBX too. 

KDBX is not the only vault format, a CLI application named [pass](https://www.passwordstore.org/) takes an even simpler approach: it encrypts the credentials with PGP and in doing so builds on years of security experience, all it does is provide a search mechanism over the secrets. 

In either case, the interaction with the password vault takes place offline. There are no always-on attack surfaces, and the attack surface is now limited to the local device (which no password manager can escape). There is reliance on the strength of the vault cryptographic formats, which can be made stronger by choosing very strong passwords, and more key derivations in the case of KDBX family. 

There is no sync mechanism built in, it now becomes the user's responsibility to do the syncing. They can choose to sync to a cloud storage provider (like Dropbox, Google Drive), or peer to peer across devices ([Syncthing](https://syncthing.net/)), or simply backup to a network location. Some KeePass mobile clients can interact directly with cloud storage providers which makes this an easy sell. 

Because the attack surface is now greatly reduced, and the focus is intently on the application and its database format, it's vital that the software and its vault format be open source. To this end, KeePass and the KDBX format can be considered highly trustworthy as they have gone through an [EU audit](https://joinup.ec.europa.eu/collection/eu-fossa-2/project-deliveries). Pass can be considered trustworthy as well, as it uses PGP which is a well known encryption system that's been in use and trusted for decades. 


## Other decision factors

### 2FA codes

Password managers support two-factor authentication (2FA) codes, specifically TOTP codes. These are the usually 6 digit codes generated that are valid for 30-90 seconds, specific to a site and login. This is another aspect to threat modelling that I haven't really gone over. The spirit of 2FA was to make compromises more difficult; a compromised password could still mean there's another code, somewhere else, that the attacker doesn't have access to which is the TOTP. Keeping 2FA codes with passwords means the compromise is easy again. With that in mind, I would not use 2FA codes with online password managers as the risk and its impact is much higher. But with offline password managers, the risk is lower, so it isn't an entirely terrible thing to do. 

The best option is to use a separate application, on a separate device for 2FA needs. Applying similar threat modelling principles, it's easy to see that built-in authenticators, tied to ecosystems, aren't advisable. Authy is tied to phone numbers, and is probably the most convenient choice with low risk as long as you don't lose your phone. Aegis authenticator is not tied to anything and is the equivalent of offline password managers, you're doing the syncing.

### Document storage

Document storage. Since the password vault is meant to be a keeper of secrets, it does follow that secret files also have a place. These can be backup codes, SSH keys, PGP keys, passport scans. Offline password managers can take this a step further by serving as an [SSH agent](https://code.mendhak.com/keepass-and-keeagent-setup/) for secure communication with remote servers as well as git operations to Github.

### Password sharing

Families and workplaces may require password sharing, which is a wholly different use case and will lead to different answers. The reason is, the act of password sharing itself is not a security feature, it's a security compromise, despite what password manager websites may say. Having safeguards for sharing becomes greater in importance, but it also means that the passwords are always going to be uncontrolled and at greater risk. 

If the people involved are technical and trustworthy enough, then sharing via KeePass would still be possible over a network share or file syncing. For others, the simplest in this use case would be to use Bitwarden which has provisions for sharing specific credentials with other people. 

## My choices

I'm most comfortable with the aspects and freedom provided by the offline password managers KeePass and KeePassXC. Syncing files is a solved problem nowadays so it's not a huge hit in terms of convenience and functionality. I'm backing up to several places including Google Drive, a Raspberry Pi, and a UNC share. It also means that I can safely lose or reset devices without worrying about credentials and 2FA codes. In case of a disaster, a copy will be somewhere, at worst mostly recoverable. 

I'm still undecided about 2FA codes, I have them both in KeePass, as well as Authy. I'm still slightly uncomfortable that Authy is tied to a phone number, and perhaps I should have a good look at Aegis.

