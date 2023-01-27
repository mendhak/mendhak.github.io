---
title: "Syncing the login wallpaper with the desktop wallpaper on Ubuntu 20.04"
description: "Getting the login wallpaper to sync with the desktop wallpaper, when using standalone or Variety wallpaper changer"
  
opengraph: 
  image: /assets/images/synchronize-login-wallpaper-ubuntu/003.png

last_modified_at: 2022-04-05

---

In Ubuntu 20.04, the background image that you set for your desktop doesn't appear on the login screen.  There isn't a way to manage the login screen background through the OS settings either.  In this post I will go over two ways of synchronizing the login screen wallpaper to match the one chosen for the desktop.  

{% gallery "Desktop wallpaper, but dull login screen" %}
![](/assets/images/synchronize-login-wallpaper-ubuntu/001.png)
![](/assets/images/synchronize-login-wallpaper-ubuntu/002.png)
{% endgallery %}

## Setup

You'll need a script that can modify the login screen background, as it isn't just a simple image replacement.  You'll also need to allow that script to run without prompting for sudo permissions.   

### Download an image to test with

If you do not have a test wallpaper already, you can use [this one](https://www.flickr.com/photos/mendhak/30454355997/). 

```bash
wget https://live.staticflickr.com/1932/30454355997_f460fcdb22_o_d.jpg -O ~/Pictures/testwallpaper.jpg
```


### Get the Change GDM Background script

Download the [change-gdm-background](https://github.com/thiggy01/change-gdm-background) script which does the actual work, and install its dependency.   

```bash
sudo apt install libglib2.0-dev-bin
git clone https://github.com/thiggy01/change-gdm-background.git
```

Now, as a test, try setting the login screen wallpaper.  When prompted, if you say `y`, you will get logged out and you can see the new login wallpaper.     

```bash
cd change-gdm-background
sudo ./change-gdm-background ~/Pictures/testwallpaper.jpg
```

![login screen wallpaper](/assets/images/synchronize-login-wallpaper-ubuntu/003.png)

{% notice "info" %}
Your original theme isn't lost, you can go back to it using `sudo ./change-gdm-background --restore`
{% endnotice %}

### Allow the script to run without prompting for password

Because the script requires `sudo` to run, it will by default prompt for your password.  This is not useful for automation, so you'll need to allow this specific script to run without prompting.  

Create a custom sudoers file with the right permissions, like so: 

```
sudo touch /etc/sudoers.d/change-gdm-background
sudo chmod 0440 /etc/sudoers.d/change-gdm-background
sudo nano /etc/sudoers.d/change-gdm-background
```

Add this one line in there.  Replace the `myusername` and path to the `change-gdm-background` script with your own.  

```
myusername ALL=(ALL:ALL) NOPASSWD:/home/myusername/Projects/change-gdm-background/change-gdm-background
```


You can try running the script again and this time you shouldn't be prompted for a password. 

## Synchronizing with a cron job

The most versatile way to synchronize the desktop and login screen wallpapers is to use a cron job.  It will work with whichever wallpaper manager software you use, and even if you manage it manually.

Create a bash script that will hold your cron job

```bash
nano syncloginwallpaper.sh
```
Add these lines in it.  Replace the path to the `change-gdm-background` script with yours.   

```bash
currentwpuri=$(gsettings get org.gnome.desktop.background picture-uri | sed "s/'//g")
currentwppath=$(python3 -c "import sys;from urllib.parse import unquote, urlparse; print(unquote(urlparse(sys.argv[1]).path))" "$currentwpuri")
sudo /home/myusername/change-gdm-background/change-gdm-background "$currentwppath"
```

This script is using `gsettings` to get the currently set wallpaper, then a bit of Python to convert the `file:///` path to a local path, and then passing that along to the main change script.  


Finally set up a cron job that runs that script, say, every 5 minutes.  Run `crontab -e`

```bash
crontab -e
```

Add this line, replacing the path to the script. 

```
*/5 * * * * bash /home/myusername/change-gdm-background/syncloginwallpaper.sh
```

Try testing it by changing the wallpaper and waiting a few minutes, then rebooting.  

## Synchronizing with Variety

The simplest way, if you use [Variety wallpaper changer](https://peterlevi.com/variety/), is to have the login screen wallpaper change together with the desktop wallpaper by [adding a custom command](https://github.com/varietywalls/variety/blob/a8abe2bd36e293300bc1d3066726b660a3db9078/data/config/variety.conf#L16-L25).  

To do this, edit the Variety config file:

```
nano ~/.config/variety/variety.conf
```

At the top of the file, add this line which tells Variety to execute a specific bash script when the wallpaper should change.  

```
set_wallpaper_script = /home/username/change-gdm-background/set_both_wallpapers.sh
```

Save, then create the `set_both_wallpapers.sh` script. 

```
nano /home/username/change-gdm-background/set_both_wallpapers.sh
```

Add these lines in:

```bash
#!/bin/bash 

# Set the lock screen wallpaper
echo "n" | sudo /home/username/change-gdm-background/change-gdm-background "$1" 2>&1 > /home/username/change-gdm-background/run.log

# Now let Variety set the desktop wallpaper as usual.
~/.config/variety/scripts/set_wallpaper $@
```

This script takes the wallpaper path passed by Variety, sets the lock screen wallpaper, then calls the regular Variety script to set the desktop wallpaper. 
Try changing the wallpaper via Variety, and then reboot.  The login screen should match.  


## Special note for multi-monitor setups

With multiple monitors, the wallpaper appears zoomed in and lower quality on the login screens.  This is due to [the way GDM3 treats multiple monitors](https://github.com/thiggy01/change-gdm-background/issues/15) as a single one and simply stretches the image across it. 

The workaround for this is to get your login screen to only work on one monitor.  

To do this, first in your own desktop, change the display mode to be Single Display and apply the changes.  

![display settings](/assets/images/synchronize-login-wallpaper-ubuntu/004.png)


This will have modified your `~/.config/monitors.xml` file that you need to pass to GDM3.  To do that, 

```bash
sudo cp ~/.config/monitors.xml `grep gdm /etc/passwd | awk -F ":" '{print $6}'`/.config/
```

Then go back to your display settings and restore your original multi-monitor setup.  

On your next reboot, the login screen will only appear on one monitor, with the wallpaper no longer zoomed in.  
