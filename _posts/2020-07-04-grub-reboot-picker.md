---
title: "Grub Reboot Picker - boot into other OSes and BIOS/UEFI from system tray"
description: "Tray application to help you reboot into other operating systems, kernels, UEFI, BIOS, or just reboot"
categories: 
  - ubuntu
  - gnome
  - grub
  - dualboot

header: 
  teaser: /assets/images/grub-reboot-picker/001.png

---

Grub Reboot Picker is a tray application that helps you reboot into other operating systems or kernels, UEFI, BIOS, or just reboot.  

[![screenshot]({{ site.baseurl }}/assets/images/grub-reboot-picker/001.png)]({{ site.baseurl }}/assets/images/grub-reboot-picker/001.png)

{% include repo_card.html reponame="grub-reboot-picker" %}

### What it does 

The application autostarts with the OS and sits in the system tray as an application indicator.  Click the icon and a list of options appear, such as UEFI, older kernels, other OSes, and of course Windows. Even if you don't dual boot, it's still convenient to be able to boot into UEFI/BIOS. 

When you click one of the options, the system will reboot and the next time the Grub menu appears, your selection will be preselected.  This allows you to set a small timeout on the Grub menu.  

<i class="fab fa-ubuntu"></i> I've only tested this with Ubuntu 18.04 and 20.04 but it should work on any system which runs grub and Gnome.
{: .notice--info}


### How to install and run it

It's available in my ppa, run these commands:

```
sudo add-apt-repository ppa:mendhak/ppa
sudo apt update
sudo apt install grub-reboot-picker
```

You can then reboot and the reboot icon will appear in the system tray.  
Or you can search for Grub Reboot Picker in the Gnome Activities search.   
Or you can run `grub-reboot-picker` from the command line, or search


### How it works

The appliction basically parses `/etc/default/grub` and lists out the entries in the system tray menu.  When an item is picked, the application uses `grub-reboot` and passes the user selected entry, and then runs the `reboot` command.  

Since the grub file also contains entries for UEFI/BIOS, it's also convenient even if the system is not dual boot.

