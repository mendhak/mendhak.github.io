---
title:      Bringing TLS 1.3 to older Android devices
description: "Why and how to add TLS 1.3 support even if the older Android devices have stopped receiving updates"
categories:
 - tech
 - android
 - security
 - tls
tags:
 - tech
 - android
 - security
 - tls

header: 
  teaser: /assets/images/tls-13-old-android-devices/000.png

---

Security improvements tend to be a one way street, they are usually implemented in newer versions of operating systems, and by extension, on newer mobile devices.  There is an assumption often made by technologists, that mobile device users are going through a constant upgrade cycle, but the assumption is made from a position of inequality, and grossly misunderstands how devices are used by a huge majority of the world.  (Though in fairness, there is only so much support the technology sector can provide before their own ability to progress is curbed.)

In many parts of the world, using mobile devices with older OSes are a fact of life, where a user will continue using it until it has completely died. Receiving updates are not a prime consideration, what matters is that the device continues to function for its intended purposes. But these circumstances mean that these users do not get access to many security improvements, and can get locked out of various web applications and services that they regularly make use of.  This is because those web services proceed at their own pace, and a security update applied on the server side one day can suddenly render the device incompatible. The most common example of this today is TLS 1.3.  TLS 1.3 is by default available at the OS level in Android 10 onwards



Working on [GPSLogger](https://gpslogger.app/) over the past several years has put me in contact with a large userbase who are completely unlike myself; they are diverse in nature of usage and backgrounds. Among these, GPSLogger is used by several NGOs and charities around the world, as well as people and communities in emerging economies.  Most of these users do not have the latest devices with the latest OS versions, as it is not a primary concern in their usage habits. Instead, mobile devices are seen as a means to run tools to assist their tasks.  

But these same circumstances also mean that the latest security improvements are out of reach for them.  That's because the web applications and services they connect to exist as independent entities and will have their own roadmaps of security, 

![Android OS distribution]({{ site.baseurl }}/assets/images/tls-13-old-android-devices/001.png)