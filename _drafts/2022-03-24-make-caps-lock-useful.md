---
title: "Repurposing Caps Lock into something useful"
description: "Making the Caps Lock key actually useful through compose keys or video conference mute"

categories: 
  - linux
  - windows
tags: 
  - shortcut
  - keyboard
  - characters
  - linux

header: 
  teaser: /assets/images/make-caps-lock-useful/001.png
---


Does there exist a key more useless, more banal in its existence than Caps Lock?  For most typical computer usage and software development there is no reason to use it, and yet it persists as a [holdover from the typewriter era](https://www.howtogeek.com/683823/why-does-the-caps-lock-key-exist-and-why-was-it-created/).   

There do exist other keys which are less often used, such as Pause, and Scroll Lock, but when measuring by ratio of surface area to uselessness, the Caps Lock key comes ahead.  It is also in close proximity to ASDF and WASD, which only helps to further amplify just what a deadweight it is.  

It is even harmful.  An accidental press of Caps Lock can lead to accidental shouting in social media, incorrect password attempts, and even bad habits forming.  I have even witnessed actual grown adults, functioning members of society, using it in place of a Shift key.  They will press Caps Lock, type the letter, then press Caps Lock again.  I did not enquire as to what series of circumstances, events and abuse led to such a habit being formed.  I could only inform them that the Shift key exists, and merely holding this key down for a moment replicates the entire functionality of Caps Lock — they feigned polite interest.  

I have been searching for better uses of the Caps Lock key and am listing some better uses I've found, as well as some observations regarding this key.   

Of course there are some fields where the Caps Lock key gets used regularly, such as engineering drawing, certain kinds of data entry, and legal.  However for the purposes of self-serving hyperbole, these shall be ignored. 
{: .notice--info}

## Linux, as a Compose Key

Entering special characters on most OSes is a difficult process either involving additional overlays, keyboard modes, or awkward shortcuts.  

By far one of the most intuitive, most human ways I've found of entering special characters is through Compose Keys on Linux.  A Compose Key is a special key that allows you to press multiple keys in a row to get a special character.  The Compose Key can be assigned by the user — and this is where the Caps Lock key is made useful by assigning it as a Compose Key. For example: 

<kbd>Caps</kbd> <kbd>e</kbd> <kbd>'</kbd> = é

<kbd>Caps</kbd> <kbd>L</kbd> <kbd>-</kbd> = £

<kbd>Caps</kbd> <kbd><</kbd> <kbd>=</kbd> = ≤


To enable Compose Keys in Ubuntu 20.04, open [Gnome Tweaks](https://linuxhint.com/gnome_tweak_installation_ubuntu/) keyboard settings, look for the Compose Key option. Caps Lock can be selected here.  

[![Gnome Tweaks Compose Key]({{ site.baseurl }}/assets/images/make-caps-lock-useful/003.png)]({{ site.baseurl }}/assets/images/make-caps-lock-useful/003.png)

There are [Compose Key Cheatsheets available](https://cheatography.com/davechild/cheat-sheets/ubuntu-compose-key-combinations/) which usually list the most common combinations; the [complete list is massive](https://cgit.freedesktop.org/xorg/lib/libX11/plain/nls/en_US.UTF-8/Compose.pre)

Note that the Compose Keys are a _sequence_.  Don't hold down Caps while pressing the other keys like a shortcut.  Simply type the keys one after the other. 
{: .notice--info}

## Chromebook, as a searcher

The Chromebook actually recognizes how unnecessary this key is, and goes ahead and replaces the Caps Lock key entirely.  The button in its place can show the Launcher or start a search.  That's pretty functional. 

[![Chromebook Keyboard]({{ site.baseurl }}/assets/images/make-caps-lock-useful/002.jpg)]({{ site.baseurl }}/assets/images/make-caps-lock-useful/002.jpg)


## PowerToys, as a video conferencing tool

PowerToys is a collection of useful utilities meant for power users on Windows.  One of its utilities is a feature called [Video Conference Mute](https://docs.microsoft.com/en-us/windows/powertoys/video-conference-mute), which lets you quickly mute or unmute yourself regardless of the video conferencing software you're using such as Teams, Zoom or Slack.  The default shortcut for the audio mute is <kbd>Win</kbd>+<kbd>Shift</kbd>+<kbd>A</kbd>.  


It  cannot _directly_ be set to Caps Lock, however PowerToys also comes with a [Keyboard Manager](https://docs.microsoft.com/en-us/windows/powertoys/keyboard-manager) which allows you to assign a key to another key sequence. In Keyboard Manager, set <kbd>Caps</kbd> to <kbd>Win</kbd>+<kbd>Shift</kbd>+<kbd>A</kbd>, and there's your audio mute, with a somewhat useful Caps Lock key. 

## Map it to something else

### Shift and Escape 

An alternative to any of the features above is to simply allow remapping Caps Lock to any number of other more commonly or more useful keys such as <kbd>Esc</kbd>, or <kbd>Shift</kbd>.  Remapping to Escape or Shift is sometimes seen among gamers, speedtypers, and vim users.  

The PowerToys Keyboard Manager mentioned above can do this, and there are also other third party software that allow remapping, such as the popular [AutoHotKey](https://www.autohotkey.com/) and [Uncap](https://github.com/susam/uncap).  

In AutoHotKey this would be done with: 

```
Capslock::
Send, {Escape}
return
```

### Switching keyboard layouts

AutoHotKey adds a lot of versatility, it can also be used to [switch keyboard layouts](https://superuser.com/questions/429930/using-capslock-to-switch-the-keyboard-language-layout-on-windows-7) for multilingual typers.  

In Ubuntu this can be done by remapping the keyboard shortcut for input sources. 

[![Keyboard shortcuts]({{ site.baseurl }}/assets/images/make-caps-lock-useful/004.png)]({{ site.baseurl }}/assets/images/make-caps-lock-useful/004.png)


## Turn it off

A not uncommon approach is to [just turn Caps Lock off](https://www.wikihow.com/Turn-Off-Caps-Lock).  It's a marginal improvement, and helps avoid any Caps Lock associated pain. 

