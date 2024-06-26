---
title: "Privacy - running untrusted apps safely using the Shelter app"
description: "How to run untrusted apps in Android without compromising security and privacy"
tags: 
  - android
  - privacy
  - shelter
  - security

opengraph: 
  image: /assets/images/privacy-android-shelter/001.png

---

Sometimes you may need to run an app that you're not comfortable with or don't necessarily trust.  Android comes with a feature that lets you run such apps in _relative_ isolation, without compromising your security or privacy.  

Android [Work Profiles](https://blog.google/products/android-enterprise/work-profile-new-standard-employee-privacy/) create a workspace isolated from the functionality of your regular apps.  Work profiles come with their own contacts, files and accounts.  This means any apps that run in the Work Profile will not have access to your normal contacts, files and accounts.  

![work profiles](/assets/images/privacy-android-shelter/001.png)

### Install Shelter

Start by installing the [Shelter App](https://play.google.com/store/apps/details?id=net.typeblog.shelter&hl=en_IE) (also on [F-Droid](https://f-droid.org/packages/net.typeblog.shelter/)).  There are several apps that can help you manage work profiles, but the best one is [Shelter](https://github.com/PeterCxy/Shelter), which is free and open source.

When prompted, choose to _Continue_, and you'll be guided to set up a work profile on Android. Tap the notification when it appears and the Shelter app will appear with two sections, `Main` and `Shelter` with a list of your apps.  The list of apps under the `Shelter` tab will be just a few.

{% figure "/assets/images/privacy-android-shelter/007.png", "Initial setup", "third" %}



### Explore the Work Profile

Go to your apps list, and notice that the Files and Contacts apps now appear twice, and one of them will have a little briefcase icon against it; this is the Work Profile version of the app.


{% figure "/assets/images/privacy-android-shelter/004.png", "Work Profile apps have a briefcase icon", "third" %}


Tap the 'sheltered' Files and notice that none of your regular files are visible.  Similarly try the 'sheltered' Contacts app and notice that it's empty, none of your actual contacts are in there. 



{% gallery "None of your regular data visible in the Work Profile" %}
![No contacts in the new Work Profile](/assets/images/privacy-android-shelter/002.png)
![No files accessible in the new Work Profile](/assets/images/privacy-android-shelter/003.png)
![Work Profile apps are under the SHELTER tab](/assets/images/privacy-android-shelter/006.png)
{% endgallery %}



### Installing apps into your Work Profile

The easiest way to install apps that you're not sure of, into Work Profile is to first download it from the Play Store, but don't launch it. 

Open up the Shelter app, then from the `Main` section, tap the chosen app. Choose to `Clone to Shelter` and follow the prompts. Finally be sure to uninstall the app from your main profile. 


{% gallery "Clone to Shelter" %}
![Clone to Shelter](/assets/images/privacy-android-shelter/008.png)
![Allow Shelter to install APKs](/assets/images/privacy-android-shelter/009.png)
{% endgallery %}


Now you can launch your app - either from the Shelter app, or from your apps list, just look for the briefcase icon.  


### Freezing apps

Many apps run background services, even when you close the app.  It's a good practice to _Freeze_ the app - this prevents the app from appearing in your apps list, and from running any background services.  



{% gallery "Freeze app" %}
![Freeze app](/assets/images/privacy-android-shelter/010.png)
![Freeze app](/assets/images/privacy-android-shelter/011.png)
{% endgallery %}



### Separate Google Play Accounts

It's entirely possible to run a separate set of accounts in the Work Profile, just sign in to the other Play Store. You'll want to make sure that it's a separate Google account, as using the same account as your original defeats the purpose of having a separate profile. 

### If you need to remove Work Profiles

Note that uninstalling the Shelter app will not remove your Work Profile.  If you need to clean up, go to system Settings, then Accounts.  
Tap the Work tab, then tap 'Remove work profile'.  This will remove the work profile and any apps you installed into there.  

