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

opengraph: 
  image: /assets/images/tls-13-old-android-devices/000.png

---

Security improvements tend to be a one way street, they are usually implemented in newer versions of operating systems, and by extension, on newer mobile devices.  There is an assumption often made by technologists, that mobile device users are going through a constant upgrade cycle, but the assumption is made from a position of inequality, and grossly misunderstands how devices are used by a huge majority of the world.  (Though in fairness, there is only so much support the technology sector can provide before their own ability to progress is curbed.)

In many parts of the world, using mobile devices with older OSes are a fact of life, where a user will continue using it until it has completely died. Receiving updates are not a prime consideration, what matters is that the device continues to function for its intended purposes. But these circumstances mean that these users do not get access to many security improvements, and can get locked out of various web applications and services that they regularly make use of.  This is because those web services proceed at their own pace, and a security update applied on the server side one day can suddenly render the device incompatible. The most common example of this today is TLS 1.3.  TLS 1.3 is by default available at the OS level in Android 10 onwards

## The problem

Working on [GPSLogger](https://gpslogger.app/) over the past several years has put me in contact with a large userbase who are completely unlike myself; they are diverse in nature of usage and backgrounds. Among these, GPSLogger is used by several NGOs and charities around the world, as well as people and communities in emerging economies.  Most of these users do not have the latest devices with the latest OS versions, as it is not a primary concern in their usage habits. Instead, mobile devices are seen as a means to run tools to assist their tasks.  

But these same circumstances also mean that the latest security improvements are out of reach for them.  That's because the web applications and services they connect to exist as independent entities and will have their own roadmaps of security, independent of devices that access them.

![Android OS distribution]({{ site.baseurl }}/assets/images/tls-13-old-android-devices/001.png)

A good example of this is the OpenStreetMap trace upload feature.  Recently, I had started receiving reports regarding older Android devices being unable to upload traces to OpenStreetMap, and that this feature had stopped working.  After some investigation, it turned out that OpenStreetMap had moved to TLS 1.2 and TLS 1.3, and this could be confirmed by trying to connect using TLS 1.1. 


```bash
$ openssl s_client -tls1_1 -connect openstreetmap.org:443
CONNECTED(00000003)
4047835B3E7F0000:error:0A0000BF:SSL routines:tls_setup_handshake:no protocols available:../ssl/statem/statem_lib.c:104:
---
no peer certificate available
```

## Solutions

### Provider Installer, Google Play Services

Several versions of Android already come with TLS versions _available_, just not _enabled_ by default.  Enabling them for an application requires using something called the  [ProviderInstaller](https://developers.google.com/android/reference/com/google/android/gms/security/ProviderInstaller), which is invoked using `ProviderInstaller.installIfNeeded(context)`.  Simple, but just one problem — the library is closed source and isn't eligible for use on F-Droid.


### Conscrypt Provider, Open Source

[Conscrypt](https://github.com/google/conscrypt) is an open source library by Google that acts as a Java Security Provider (JSP).  Unsurprisingly, I couldn't find any good documentation on JSPs, how they work, or why they're needed, but it was enough to understand that JSPs can be plugged into your application and the Java Runtime will make use of them.  The great part about Conscrypt is that it can work on Android devices as old as version 2.2!  

The library is available on maven, and once the library has been added to the application, using it is very simple, 

```java
Security.insertProviderAt(Conscrypt.newProvider(), 1);
```

But there was a problem right away; it's huge!  Adding the library to GPSLogger added about 6 MB to the APK size effectively doubling it.  This became a difficult decision point — not every user of GPSLogger needed this functionality, just some users connecting to services that happen to use later TLS versions.  If possible, it would be nice if not every user had to suffer from the APK bloat to benefit a few.

### F-Droid post

I eventually found [this blog post from F-Droid](https://f-droid.org/2020/05/29/android-updates-and-tls-connections.html) which talked about this very issue and how it could be solved, the answers were all there!  Being lazy, I chose the simplest solution:  create a separate application that includes the library, let users install that application if needed, and only include the security provider if that application exists on the user's device.

## Conscrypt Provider App

So I've created an app called [Conscrypt Provider](https://github.com/mendhak/Conscrypt-Provider) and [published it on F-Droid](https://f-droid.org/packages/com.mendhak.conscryptprovider/).  Its [actual code](https://github.com/mendhak/Conscrypt-Provider/blob/master/app/src/main/java/com/mendhak/conscryptprovider/ConscryptProvider.kt) is dead simple, literally the `Security.insertProviderAt` one-liner above.  

The actual work happens in the _calling_ application, this case GPSLogger. I have to include the Conscrypt Provider application, then load its main class, then call the `install` method.  

```java
Context targetContext = context.createPackageContext("com.mendhak.conscryptprovider",
            Context.CONTEXT_INCLUDE_CODE | Context.CONTEXT_IGNORE_SECURITY);
ClassLoader classLoader = targetContext.getClassLoader();
Class installClass = classLoader.loadClass("com.mendhak.conscryptprovider.ConscryptProvider");
Method installMethod = installClass.getMethod("install", new Class[]{});
installMethod.invoke(null);
Log.i("Conscrypt Provider installed");
```    

As the F-Droid post explains, to avoid spoofing, a decent mitigation is to check the application's signature.  In my case, I am checking both my certificate as well as the F-Droid certificate signature.  

```java
try {
    //Get signature to compare - either Github or F-Droid versions
    //~/Android/Sdk/build-tools/33.0.0/apksigner verify --print-certs -v ~/Downloads/com.mendhak.conscryptprovider_3.apk
    String signature = getPackageSignature("com.mendhak.conscryptprovider", context);
    if (
            signature.equalsIgnoreCase("C7:90:8D:17:33:76:1D:F3:CD:EB:56:67:16:C8:00:B5:AF:C5:57:DB")
            || signature.equalsIgnoreCase("9D:E1:4D:DA:20:F0:5A:58:01:BE:23:CC:53:34:14:11:48:76:B7:5E")
    ) {
        signatureMatch = true;
    }
    else {
        Log.e("com.mendhak.conscryptprovider found, but with an invalid signature. Ignoring.");
        return;
    }

    //https://gist.github.com/ByteHamster/f488f9993eeb6679c2b5f0180615d518
    Context targetContext = context.createPackageContext("com.mendhak.conscryptprovider",
            Context.CONTEXT_INCLUDE_CODE | Context.CONTEXT_IGNORE_SECURITY);
    ClassLoader classLoader = targetContext.getClassLoader();
    Class installClass = classLoader.loadClass("com.mendhak.conscryptprovider.ConscryptProvider");
    Method installMethod = installClass.getMethod("install", new Class[]{});
    installMethod.invoke(null);
    installed = true;
    Log.i("Conscrypt Provider installed");
} catch (Exception e) {
    Log.e("Could not install Conscrypt Provider", e);
}

```

The code for `getPackageSignature` is in the Github repo.  

With these ingredients in place, I'm now able to provide TLS 1.3 to older devices while keeping the main application as lean as possible.  

## Surfacing the option to users


A chicken and egg situation still exists.  I don't want to nag every user to install the provider app, but only to users that will need it.  How then, do I figure out whether a user needs it?  

A very crude approach is to check the Android version and simply offer the extra app to install, but as mentioned earlier, it's just unnecessary for most users if they're not using a service that requires TLS 1.3.  

A slightly sophisticated approach would require users running into an SSL socket or handshake exception, figuring out whether it's related to TLS versions, and then offering them the option to install the app.  I haven't found a reliable way to determine this. 

Even then, it's still not foolproof, because the exception could occur while the application is running unattended.   

I've left this as a thought exercise to mull over but for now, just having an option in the settings screen is 'good enough'.  
