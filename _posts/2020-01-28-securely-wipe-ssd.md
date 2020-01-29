---
title: "Securely wipe an SSD with its built in commands"
description: "Using the built in SECURITY ERASE UNIT command to erase an SSD, in Ubuntu"
categories: 
  - ssd
  - security
  - ubuntu

gallery1:
  - url: /assets/images/securely-wipe-ssd/wipe-ssd-00.png
    image_path: /assets/images/securely-wipe-ssd/wipe-ssd-00.png
  - url: /assets/images/securely-wipe-ssd/wipe-ssd-01.png
    image_path: /assets/images/securely-wipe-ssd/wipe-ssd-01.png
  - url: /assets/images/securely-wipe-ssd/wipe-ssd-02.png
    image_path: /assets/images/securely-wipe-ssd/wipe-ssd-02.png
  - url: /assets/images/securely-wipe-ssd/wipe-ssd-03.png
    image_path: /assets/images/securely-wipe-ssd/wipe-ssd-03.png
  - url: /assets/images/securely-wipe-ssd/wipe-ssd-04.png
    image_path: /assets/images/securely-wipe-ssd/wipe-ssd-04.png
  - url: /assets/images/securely-wipe-ssd/wipe-ssd-05.png
    image_path: /assets/images/securely-wipe-ssd/wipe-ssd-05.png
  - url: /assets/images/securely-wipe-ssd/wipe-ssd-06.png
    image_path: /assets/images/securely-wipe-ssd/wipe-ssd-06.png
  - url: /assets/images/securely-wipe-ssd/wipe-ssd-07.png
    image_path: /assets/images/securely-wipe-ssd/wipe-ssd-07.png
  - url: /assets/images/securely-wipe-ssd/wipe-ssd-08.png
    image_path: /assets/images/securely-wipe-ssd/wipe-ssd-08.png
  - url: /assets/images/securely-wipe-ssd/wipe-ssd-09.png
    image_path: /assets/images/securely-wipe-ssd/wipe-ssd-09.png
  


---

Modern SSDs now come with built in commands that can wipe a disk for you.  This is an action that should normally be performed when you're about to give/sell it away.  

As an overview you'll need to find out the disk's label, unfreeze the disk, set a password, and then issue the erase command. 



## Plug it in

If the disk is already connected to your motherboard, you can leave it there.  If you've already removed it from the case, you can connect it to your machine with a USB-SATA converter.  Preferably, do this over SATA but the option exists to use USB.  

![USB SATA converter]({{ site.baseurl }}/assets/images/securely-wipe-ssd/usb-sata-connected.jpg)

There have been some forum posts about disks being bricked when attempting these operations over USB, however I have wiped about a dozen SSDs without issue.  Your mileage may vary.


## Find out its label

You'll need to know the correct hard drive label to feed into later commands.  The easiest way to do this is to open up the Ubuntu _Disks_ application and look for the hard drive that you've plugged in. 

![get label]({{ site.baseurl }}/assets/images/securely-wipe-ssd/wipe-ssd-00.png)

You can also use the `sudo fdisk -l` command, and look for your disk there. 

![fdisk]({{ site.baseurl }}/assets/images/securely-wipe-ssd/wipe-ssd-01.png)

In this case, the drive is `/dev/sda` - though if you have other SATA SSDs then there may be a mix of sda, sdb, sdc and so on in there.  For reference the drive will just be referenced as `/dev/sdX` from here on.

It is really important to get this step right, as working with the wrong label can wipe your main disk.  
If in doubt, try disconnecting any other drives you have, except the primary OS drive.  
The safest way would be to do this from an Ubuntu Live USB and disconnect all other drives. 
{: .notice--danger}

## Install `hdparm`

The command to use here is `hdparm` - if it isn't already install, just install it using

    sudo apt install hdparm

hdparm allows you to work with ATA disks and ATA disk commands.


## Unfreeze the drive. 

SSDs will sometimes be in a 'frozen' state, which is designed to prevent malicious attacks against your disk, including wiping it.  

You can check if your disk is frozen using 

    sudo hdparm -I /dev/sdX

![frozen disk]({{ site.baseurl }}/assets/images/securely-wipe-ssd/wipe-ssd-02.png)    

If you see `not    frozen` then you're OK to proceed.  But if you just see `frozen`, you will need to unfreeze the disk. 

The quickest way is to suspend your computer and then reawaken it.  You can do this using

    sudo pm-suspend

and then power it back on.

If that doesn't work, a simple reboot should be enough.  Try the command again and you should see that the disk is no longer frozen. 



## Set a password

You'll now need to set a password to enable security on the disk.  Any password will do, and this password will disappear once the drive has been securely erased.  

    sudo hdparm --user-master u --security-set-pass hunter2 /dev/sdX 

![set password]({{ site.baseurl }}/assets/images/securely-wipe-ssd/wipe-ssd-03.png)    

Test to make sure that the password has indeed been set. 

    sudo hdparm -I /dev/sdX

![frozen disk]({{ site.baseurl }}/assets/images/securely-wipe-ssd/wipe-ssd-04a.png)    

This time you should see, under `Master password`, the `not    enabled` has become `enabled`.  The line `Security level high` also appears at the bottom of the list.  



## Security Erase or Enhanced Security Erase

The hdparm output also shows what kind of erase the drive supports.  

![frozen disk]({{ site.baseurl }}/assets/images/securely-wipe-ssd/wipe-ssd-04b.png)    

The `SECURITY ERASE UNIT` command will rotate the disk's internal encryption key, rendering the data on disk invalid.  
The `ENHANCED SECURITY ERASE UNIT` will rotate the encryption key and also write a manufacturer-determined pattern to the disk as an added measure. 

Take note of how long the estimate is; it can be anywhere from a minute to hundreds of minutes; the time depends on what method the disk uses to erase data.

## Actually erase it

To perform an Enhanced Security Erase, 

    sudo hdparm --user-master u --security-erase-enhanced hunter2 /dev/sdX

To perform a normal Security Erase, 

    sudo hdparm --user-master u --security-erase hunter2 /dev/sdX 

Be sure to wait a few minutes more than the estimate.  

![erase command]({{ site.baseurl }}/assets/images/securely-wipe-ssd/wipe-ssd-05.png)    


## Test that it's erased

Once again, run 

    sudo hdparm -I /dev/sda

Notice that the `Security level high` line no longer appears.  Under `Master password` the status has returned to `not enabled`. This tells us that the disk has been reset.

![disks]({{ site.baseurl }}/assets/images/securely-wipe-ssd/wipe-ssd-06.png)    

Unplug and re-plug the SSD, then open the _Disks_ application. The disk should appear but without any of your previous partitions. 


![disks]({{ site.baseurl }}/assets/images/securely-wipe-ssd/wipe-ssd-07.png)    

You can also verify by reading bytes directly off the disk with the `dd` command. 

    sudo dd if=/dev/sda bs=1M count=5

If you've done an Enhanced Erase you will see the pattern which was set by the manufacturer.  

![enhanced security erase]({{ site.baseurl }}/assets/images/securely-wipe-ssd/wipe-ssd-08.png)    

In the case of a regular erase you will see nothing. 

## Paranoid mode

Although there is an [ATA spec proposal for the erase operations](http://web.archive.org/web/20160813235342/http://t13.org/Documents/UploadedDocuments/docs2004/e04147r0-TechProposalFreezeLockSecureErase.pdf), there is no real standardization in secure erase.  An SSD could report that it has erased the disk but without inspecting the code, there is [no guarantee that it has done so](https://security.stackexchange.com/a/41683).  

The erase should be occurring by [changing the internal encryption key](https://security.stackexchange.com/a/64480) thereby making the data useless; in some cases the disk will perform both the normal erase and the security enhanced erase in the same way.  But manufacturers are not forthcoming about these kinds of details, so a level of suspicion or paranoia here is not unusual.  

To address this paranoia, you can take this a step further by performing a `dd` write to disk anyway.  This command will fill the disk with zeroes. 

    sudo dd if=/dev/zero of=/dev/sdX bs=1M status=progress

Wait until the 'no space left on device' error appears.

![dd fill]({{ site.baseurl }}/assets/images/securely-wipe-ssd/wipe-ssd-09.png)    

And you're done.  

Between all of these steps performed, the disk is now in a state to be sold or given away.



