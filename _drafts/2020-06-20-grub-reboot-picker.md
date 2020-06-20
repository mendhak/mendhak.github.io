---
title: "Grub Reboot Picker - boot into other OSes and BIOS/UEFI from system tray"
description: "Tray application to help you reboot into other operating systems, kernels, UEFI, BIOS, or just reboot"
categories: 
  - ubuntu
  - gnome
  - grub
  - dualboot

---

Grub Reboot Picker is a tray application that helps you reboot into other operating systems or kernels, UEFI, BIOS, or just reboot.  

![screenshot]({{ site.baseurl }}/assets/images/grub-reboot-picker/001.png)

{% include repo_card.html reponame="grub-reboot-picker" %}

### How it works

The appliction basically parses `/etc/default/grub` and lists out the entries in the system tray menu.  When an item is picked, the application uses `grub-reboot` and passes the user selected entry, and then runs the `reboot` command.  

Since the grub file also contains entries for UEFI/BIOS, it's also convenient even if the system is not dual boot.