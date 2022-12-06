---
title:      Appreciating F-Droid as an app developer
description: "From an app developer's perspective, F-Droid is a much better, well thought out, app store for Android"
categories:
 - android
 - fdroid
tags:
 - android
 - fdroid

---

I used to develop my app solely for the Play Store, until [just 2 years ago](https://github.com/mendhak/gpslogger/issues/849) when I determined that the stress of arbitrary removals had accumulated to an unsustainable level.  

Several months later, I tentatively decided to repackage the app for F-Droid.  It wasn't out of some matter of principle, just one of convenience; I wanted the app to 'live' somewhere and F-Droid was an option that had been suggested to me in the past by several users. At the time I didn't give serious consideration to those suggestions. Now after 2 years of using F-Droid as an app developer, I can compare it against my experience with the Play Store. It's now obvious that I should have given serious consideration to those suggestions. The developer experience has its advantages, is easier, and comes with fewer constraints. 

### No ambiguity

The main issue I faced with app removals on Google Play wasn't so much the removals themselves; after all the Play Store needs to enforce policies. The problem was the manner in which the removals would occur, and the lack of information around it. To add insult to injury, there was a chronic inability to get a hold of someone who could explain what was going on, and in the rare cases where I did get a hold of someone, they would give no information about what or where the problem was.  The elusive agent would robotically keep linking to the same dense policy documents that the original removal email linked to. 

In almost all cases, I had to make guesses regarding the problem, re-submit, and wait for a rejection or success.  In one unique, yet bizarre incident, I received a removal email that did highlight the problem, but the sentence it pointed at was completely innocuous. Support did not help as usual. I made a guess and removed a comma from that sentence, resubmitted, and it went through.  

This is a problem with app stores in general that doesn't affect most app developers, but when it does, only then does the one-sided nature of the relationship with the app store become apparent. My best guess is that these removals are a combination of new errant algorithms and the default assumption by app store employees that the algorithm is indisputably infallible. 

Contrast this with F-Droid: the policies are simple, documented, and in many cases _codified_.  For example, if a closed source library is used, which [F-Droid doesn't allow](https://f-droid.org/docs/Inclusion_Policy/), the F-Droid build will fail, and the reason is visible in the build logs. If the app uses anti-features, the app listing page gets a warning on it indicating as much.  The important thing about something being codified and documented in a simple straightforward manner, is that it removes the stress from interactions with F-Droid.  It's all just there. 

### Reproducible builds

F-Droid increases trust in open source code by implementing [reproducible builds](https://f-droid.org/docs/Reproducible_Builds/). Also known as deterministic builds, it's a way of providing an independently verifiable path from source to binary code. The simple act of participating in F-Droid is enough to increase confidence in an application, if one cares about open source principles. That's something I can appreciate.  

Comparing this with the Play Store, for any given app, no such assurance exists.  

### Managed continuous deployment service

By virtue of the reproducible builds, F-Droid is required to build the application, and it provides convenience methods to do so. The best outcome of this is that I can `git tag` at any point in my branch, and F-Droid picks it up, builds it, and deploys it to the F-Droid repository. F-Droid makes available the source code as well as the build logs for the application, and even provides a site to [monitor the status](https://monitor.f-droid.org/). That's quite useful for  troubleshooting and maintenance.  

A consequence, whether intended or unintended, is that from my perspective F-Droid effectively becomes a managed CI/CD system. The majority of my interaction ends at Github, F-Droid takes care of the rest. 

At the same time, if needed, it's also possible to go deep into the guts of the build: even F-Droid's [build system](https://gitlab.com/fdroid/fdroidserver) is available to run locally. 

I don't think there is any real comparison with the Play Store here, as there's nothing in the way of automation there.  It's somewhat possible, through API calls, to automate a deployment to the Play Store, but the workflow is complex and not very maintainable, or rather, considering the number of workflows, policies, and agreements that often greet the developer during the update process, it's not meant to be maintainable.  

### Reach and analytics

While I did have a larger base of users on Google Play, there's a liberating lack of knowledge around usage numbers or reviews on F-Droid. Shortly after the move from Google Play, the act of deploying to F-Droid felt like it was being released into the void, but over time it's just something I've gotten used to. The only indications I have of usage are adjacent and incidental; although I've still not returned to former levels of involvement with the app, there is still a healthy amount of conversation and issues over Github and emails. 

### Closing thoughts

It's true that the Play Store does come with various conveniences and additional analytics around deployments, errors, and installations.  Its position as the default app store on devices gives it a larger user base.  All of these are not available on F-Droid for good reasons, which I'm willing to give up on for the benefits that deveoping for F-Droid provides.  

