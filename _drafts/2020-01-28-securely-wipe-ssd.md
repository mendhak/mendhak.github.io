How to secure erase SSD


## Find out its label

Check Disk management
Check sudo fdisk -l

In this case, the drive is `/dev/sda`


## Unfreeze the drive. 

Check if drive is frozen. 

sudo hdparm -I /dev/sda

If it's frozen, unfreeze it.  Set the computer to sleep, 

sudo pm-suspend

then power it back on.

If that doesn't work, disconnect and reconnect the drive. Or just reboot.

At some point you should see not frozen in the hdparm command.



## Set a password

Setting password is required 

sudo hdparm --user-master u --security-set-pass hunter2 /dev/sda 

Test that it's set

sudo hdparm -I /dev/sda

'security level high'

and master password shows 'enabled'



## Actually erase it

If Enhanced Security Erase supported:

sudo hdparm --user-master u --security-erase-enhanced hunter2 /dev/sda 

Else

sudo hdparm --user-master u --security-erase hunter2 /dev/sda 

Wait a few minutes more than the estimate.  


## Test that it's erased


Rerun sudo hdparm -I /dev/sda

Notice the security high message is gone.  master password 'not enabled' is back. 

Unplug and re-plug the SSD.  Check disks management. 


Read bytes from the disk

sudo dd if=/dev/sda bs=1M count=5

In the case of Enhanced Erase you will see a pattern which was set by the manufacturer.  In the case of normal erase you will see nothing. 

## Paranoid mode

There is no real standardization in secure erase.  An SSD could report that it has erased the disk but without inspecting the code, there is no guarantee that it has done so.  

https://security.stackexchange.com/a/41683

https://security.stackexchange.com/a/64480


The erase should be occurring by changing the internal encryption key thereby making the remaining data useless.  But manufacturers are not forthcoming about these kinds of details so you can take it a step further.  Perform a dd write anyway. 

sudo dd if=/dev/zero of=/dev/sda bs=1M status=progress

Wait until 'no space left on device' error.




