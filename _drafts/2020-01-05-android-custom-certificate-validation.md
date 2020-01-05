---
title: "Custom TLS certificate validation for Android applications"
description: "Workflow for properly validating custom and self signed TLS certificates in Android applications"
categories: 
  - android
  - security
  - tls
---

How to properly validate TLS certificates from Android applications - without bypassing or compromising validation.

Several features I've had to develop for [GPSLogger](https://gpslogger.app) allow users to communicate with their own private hosts serving custom SSL/TLS certificates.  The most difficult part about developing for such a workflow is actually finding help and documentation.  Android's [own documentation](https://developer.android.com/training/articles/security-ssl) has some advice, but requires that you already _know_ the certificate in advance.  This doesn't always apply as a user will want to apply their own self signed certificates or use a provider that isn't yet trusted in their version of Android. 

StackOverflow posts on this topic will often given awful answers showing you how to _disable_ validation with a little disclaimer tacked on at the end to the effect of "Here's some bad advice, you should totally not do this in production"; nothing more than a wink and a nod silently saying, "You're going to do this anyway just don't tell anyone".  This is extremely dangerous, considering that such code ends up in actual real-world applications susceptible to [man-in-the-middle attacks](https://en.wikipedia.org/wiki/Man-in-the-middle_attack), compromising privacy and security. 

## Validation overview

The proper validation workflow consists of a few parts.  First the user must enter the server name or URL they want to connect to, which is being served by their custom certificate.  User taps the validation link, and the app makes a request to the server.  The certificate is fetched and tested to see if it is recognized by the Android OS already.  If it isn't a known certificate, the details of the certificate are presented for the user to look at.  The user can accept the certificate, at which point it's stored in a keystore. 

![Validation workflow]({{ site.baseurl }}/assets/images/android-custom-certificate-validation/002_workflow.png)

From then on as part of the normal application's running, any requests made are checked against the keystore in order to validate the certificate. 

![Validation workflow]({{ site.baseurl }}/assets/images/android-custom-certificate-validation/003_workflow.png)

As part of the initial setup, the user would see a prompt similar to this:

![Custom validation UI]({{ site.baseurl }}/assets/images/android-custom-certificate-validation/001_validation.gif)

