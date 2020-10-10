---
title: "Privacy - running untrusted apps safely using the Shelter app"
description: "How to run untrusted apps in Android without compromising security and privacy"
categories: 
  - android
  - privacy
  - shelter
  - security

gallery1:
  - url: /assets/images/privacy-android-shelter/002.png
    image_path: /assets/images/privacy-android-shelter/002.png
    title: "Empty Contacts"
    alt: "No contacts in the new Work Profile"
  - url: /assets/images/privacy-android-shelter/003.png
    image_path: /assets/images/privacy-android-shelter/003.png
    title: "Empty Files"
    alt: "No files accessible in the new Work Profile"
  - url: /assets/images/privacy-android-shelter/006.png
    image_path: /assets/images/privacy-android-shelter/006.png
    title: "The Work Profile apps"
    alt: "Work Profile apps are under the SHELTER tab"    

gallery2:
  - url: /assets/images/privacy-android-shelter/004.png
    image_path: /assets/images/privacy-android-shelter/004.png
    title: "Briefcase icon"
    alt: "Work Profile apps have a briefcase icon"

gallery3:
  - url: /assets/images/privacy-android-shelter/005.png
    image_path: /assets/images/privacy-android-shelter/005.png
    title: "Shelter app"
    alt: "No contacts in the new Work Profile"
  - url: /assets/images/privacy-android-shelter/003.png
    image_path: /assets/images/privacy-android-shelter/003.png
    title: "Empty Files"
    alt: "No files accessible in the new Work Profile"

gallery4:
  - url: /assets/images/privacy-android-shelter/007.png
    image_path: /assets/images/privacy-android-shelter/007.png
    title: "Initial setup"
    alt: "Initial setup"    


gallery5:
  - url: /assets/images/privacy-android-shelter/008.png
    image_path: /assets/images/privacy-android-shelter/008.png
    title: "Clone to Shelter"
    alt: "Clone to Shelter"
  - url: /assets/images/privacy-android-shelter/009.png
    image_path: /assets/images/privacy-android-shelter/009.png
    title: "Allow Shelter to install APKs"
    alt: "Allow Shelter to install APKs"

gallery6:
  - url: /assets/images/privacy-android-shelter/010.png
    image_path: /assets/images/privacy-android-shelter/010.png
    title: "Freeze app"
    alt: "Freeze app"
  - url: /assets/images/privacy-android-shelter/011.png
    image_path: /assets/images/privacy-android-shelter/011.png
    title: "Freeze app"
    alt: "Freeze app"
---

Sometimes you may need to run an app that you're not comfortable with or don't necessarily trust.  Android comes with a feature that lets you run such apps in _relative_ isolation, without compromising your security or privacy.  

Android [Work Profiles](https://blog.google/products/android-enterprise/work-profile-new-standard-employee-privacy/) create a workspace isolated from the functionality of your regular apps.  Work profiles come with their own contacts, files and accounts.  This means any apps that run in the Work Profile will not have access to your normal contacts, files and accounts.  


![work profiles]({{ site.baseurl }}/assets/images/privacy-android-shelter/001.png)

### Install Shelter

Start by installing the [Shelter App](https://play.google.com/store/apps/details?id=net.typeblog.shelter&hl=en_IE) (also on [F-Droid](https://f-droid.org/packages/net.typeblog.shelter/)).  There are several apps that can help you manage work profiles, but the best one is [Shelter](https://github.com/PeterCxy/Shelter), which is free and open source.

When prompted, choose to _Continue_, and you'll be guided to set up a work profile on Android. Tap the notification when it appears and the Shelter app will appear with two sections, `Main` and `Shelter` with a list of your apps.  The list of apps under the `Shelter` tab will be just a few.

{% include gallery id="gallery4" layout="third" caption="Initial setup" %}


### Explore the Work Profile

Go to your apps list, and notice that the Files and Contacts apps now appear twice, and one of them will have a little briefcase icon against it; this is the Work Profile version of the app.

{% include gallery id="gallery2" layout="third" caption="Work Profile apps have a briefcase icon" %}

Tap the 'sheltered' Files and notice that none of your regular files are visible.  Similarly try the 'sheltered' Contacts app and notice that it's empty, none of your actual contacts are in there. 

{% include gallery id="gallery1" layout="third" caption="None of your regular data visible in the Work Profile" %}


### Installing apps into your Work Profile

The easiest way to install apps that you're not sure of, into Work Profile is to first download it from the Play Store, but don't launch it. 

Open up the Shelter app, then from the `Main` section, tap the chosen app. Choose to `Clone to Shelter` and follow the prompts. Finally be sure to uninstall the app from your main profile. 


{% include gallery id="gallery5" layout="half" caption="Clone to Shelter" %}

Now you can launch your app - either from the Shelter app, or from your apps list, just look for the briefcase icon.  


### Freezing apps

Many apps run background services, even when you close the app.  It's a good practice to _Freeze_ the app - this prevents the app from appearing in your apps list, and from running any background services.  

{% include gallery id="gallery6" layout="half" caption="Freeze app" %}